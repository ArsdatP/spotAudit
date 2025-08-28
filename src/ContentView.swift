import SwiftUI
import UIKit




struct ContentView: View {
    
    @StateObject private var viewModel = TillViewModel()
    @FocusState private var focusedField: FocusableField?
    
    var allFocusableFields: [FocusableField] {
        var fields: [FocusableField] = [.galaxyID, .node]
        fields += viewModel.denominations.map { .denomination($0.id) }
        return fields
    }

    func moveFocus(offset: Int) {
        guard let current = focusedField,
              let currentIndex = allFocusableFields.firstIndex(of: current) else { return }

        let newIndex = currentIndex + offset
        if allFocusableFields.indices.contains(newIndex) {
            focusedField = allFocusableFields[newIndex]
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Spot Audit")) {
                    TextField("Galaxy ID", text: $viewModel.galaxyID)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .galaxyID)
                    
                    TextField("Coordinator Name", text: $viewModel.cName)
                        .focused($focusedField, equals: .cName)


                    TextField("Node", text: $viewModel.node)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .node)
                }

                Section(header: Text("Coins / Bills")) {
                    ForEach($viewModel.denominations) { $denom in
                        HStack {
                            Text(denom.name)
                            Spacer()
                            TextField("0", text: $denom.countText)
                                .keyboardType(.numberPad)
                                .focused($focusedField, equals: .denomination(denom.id))
                                .frame(width: 120)
                                .multilineTextAlignment(.trailing)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            focusedField = .denomination(denom.id)
                        
                        }
                    }
                }

                Section {
                    Text("Total: $\(viewModel.total, specifier: "%.2f")")
                        .font(.headline)
                }

                Section {
                    Button("Send Spot Audit Email") {
                        sendEmail(body: viewModel.emailBody())
                    }
                }
            }
            .navigationTitle("Spot Audit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button(action: {
                        moveFocus(offset: -1)
                    }) {
                        Image(systemName: "chevron.up")
                    }
                    
                    .disabled(focusedField == allFocusableFields.first)

                    Button(action: {
                        moveFocus(offset: 1)
                    }) {
                        Image(systemName: "chevron.down")
                    }
                    .disabled(focusedField == allFocusableFields.last)

                    Spacer()

                    Button("Done") {
                        focusedField = nil
                    }
                }
            }

        }
    }

    func sendEmail(body: String) {
        let activityVC = UIActivityViewController(activityItems: [body], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(activityVC, animated: true)
        }
    }
}

enum FocusableField: Hashable {
    case cName, galaxyID, node, denomination(UUID)
    
    
    
}



