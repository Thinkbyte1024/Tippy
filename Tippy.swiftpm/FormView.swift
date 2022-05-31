import Combine
import SwiftUI

struct FormView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Alerts
    @State private var emptyInputState = false
    @State private var alertMessage = ""

    // List of form alert message
    private enum alertCase: String {
        case nameEmpty = "Name should not be empty"
        case billEmpty = "Total bill should not be zero or empty"
        case emptyBillAndName = "Please fill the name and bill total"
    }

    // Data
    @State var tipPrice: Double = 0.0
    @State var totalPrice: Double = 0.0

    // Inputs
    @State var nameInput = ""
    @State var billInput = ""
    @State var tipInput = 5.0

    // Editing variables
    @Binding var formState: Bool
    var isEditing: Bool
    var editedItem: Tips?

    // Handling data on submit
    let onComplete: (String, Double, Double) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section("Name") {
                    TextField("Some restaurant name or etc...", text: $nameInput)
                }

                Section("Tip Info") {
                    TextField("Total bill", text: $billInput)
                        .keyboardType(.decimalPad)
                        .onChange(of: billInput) { newValue in
                            let convertedInput = Double(newValue)

                            if let input = convertedInput {
                                tipPrice = (input * tipInput) / 100
                                totalPrice = input + tipPrice
                            }
                        }
                        .onReceive(Just(billInput)) { value in
                            let filter = value.filter { "0123456789,.".contains($0) }
                            if filter != value {
                                billInput = filter
                            }
                        }
                    VStack {
                        Slider(value: $tipInput, in: 1 ... 100, step: 0.5) {
                            Text("Tip")
                        } minimumValueLabel: {
                            Text("0%")
                        } maximumValueLabel: {
                            Text("100%")
                        }
                        .onChange(of: tipInput) { newValue in
                            let convertedInput = Double(self.billInput)

                            if let input = convertedInput {
                                tipPrice = (input * newValue) / 100
                                totalPrice = input + tipPrice
                            }
                        }
                        Text("Tip \(tipInput.formatted(.number))%")
                    }
                }

                Section {
                    HStack {
                        Text("Tip Price")
                        Spacer()
                        Text(AppFormatter.formattedNumber(value: tipPrice))
                    }
                    HStack {
                        Text("Total Price")
                        Spacer()
                        Text(AppFormatter.formattedNumber(value: totalPrice))
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit \(editedItem?.TipName ?? "Unindentified")" : "Add a tip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        formState = false
                    } label: {
                        HStack {
                            Text("Go back")
                        }
                    }
                }
            }
        }

        HStack {
            Button(isEditing ? "Save changes" : "Save result") {

                // Handling fail-safe if some user input is empty
                if (billInput.isEmpty || billInput == "0") && nameInput.isEmpty {
                    emptyInputState = true
                    alertMessage = alertCase.emptyBillAndName.rawValue
                } else if nameInput.isEmpty {
                    emptyInputState = true
                    alertMessage = alertCase.nameEmpty.rawValue
                } else if billInput.isEmpty || billInput == "0" {
                    emptyInputState = true
                    alertMessage = alertCase.billEmpty.rawValue
                } else {
                    onComplete(nameInput, Double(billInput)!, tipPrice)
                }
            }
            .alert(alertMessage, isPresented: $emptyInputState, actions: {
                Button("OK") {
                    self.emptyInputState = false
                }
            })
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Button("Reset input", role: .destructive) {
                nameInput = isEditing ? editedItem!.TipName ?? "Unidentified" : ""
                billInput = isEditing ? String(editedItem!.Bill) : ""
                tipInput = isEditing ? (editedItem!.Tip / editedItem!.Bill) * 100 : 5.0
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }

        Spacer()
    }
}
