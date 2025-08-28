import Foundation

struct Denomination: Identifiable {
    let id = UUID()
    let name: String
    let value: Double
    var countText: String = ""

    var count: Int {
        Int(countText) ?? 0
    }

    var total: Double {
        Double(count) * value
    }
}

class TillViewModel: ObservableObject {
    @Published var galaxyID: String = ""
    @Published var node: String = ""
    @Published var cName: String = ""
    
    @Published var denominations: [Denomination] = [
        Denomination(name: "Pennies", value: 0.01),
        Denomination(name: "Nickels", value: 0.05),
        Denomination(name: "Dimes", value: 0.10),
        Denomination(name: "Quarters", value: 0.25),
        Denomination(name: "Half-dollar", value: 0.50),
        Denomination(name: "Dollar Coin", value: 1.00),
        Denomination(name: "$1 Bills", value: 1.00),
        Denomination(name: "$5 Bills", value: 5.00),
        Denomination(name: "$10 Bills", value: 10.00),
        Denomination(name: "$20 Bills", value: 20.00),
        Denomination(name: "$50 Bills", value: 50.00),
        Denomination(name: "$100 Bills", value: 100.00)
    ]

    var total: Double {
        denominations.reduce(0) { $0 + $1.total }
    }

    func emailBody() -> String {
        var body = "Spot Audit Summary\n\n"
        body += "Galaxy ID: \(galaxyID) \n"
        body += "Coordinator:  \(cName) \n"
        body += "Node: \(node)\n\n"

        for d in denominations {
            body += String(format: "%-12@: %3d × $%5.2f = $%7.2f\n",
                           d.name as NSString,
                           d.count,
                           d.value,
                           d.total)
        }

        body += "\n-----------------------------\n"
        body += String(format: "Total: $%.2f", total)
        return body
    }
}
