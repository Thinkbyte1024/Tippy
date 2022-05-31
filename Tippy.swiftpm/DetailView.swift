import SwiftUI

struct DetailView: View {

    // Environment variables
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var itemInfo: Tips

    let onRequestDelete: () -> Void

    @State private var deleteAlert = false
    @State private var editForm = false

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    Text(itemInfo.TipName ?? "Unidentified")
                        .font(.title)
                    Text("Total \(AppFormatter.formattedNumber(value: itemInfo.Bill + itemInfo.Tip))")
                        .font(.subheadline)
                }
                .padding()
            }

            Section {
                HStack {
                    Label("Created on", systemImage: "clock")
                        .foregroundColor(.black)

                    Spacer()

                    Text(itemInfo.Timestamp != nil ? "\(itemInfo.Timestamp!, formatter: AppFormatter.formattedDate(dateStyle: .medium, timeStyle: .short))" : "")
                }
            }

            Section {
                HStack {
                    Label("Bill total", systemImage: "banknote")
                        .foregroundColor(.black)

                    Spacer()

                    Text(AppFormatter.formattedNumber(value: itemInfo.Bill))
                }

                HStack {
                    Label("Tip", systemImage: "centsign.circle")
                        .foregroundColor(.black)

                    Spacer()

                    Text(AppFormatter.formattedNumber(value: itemInfo.Tip))
                }
            }

            Section {
                Button("Edit") {
                    editForm.toggle()
                }
                .sheet(isPresented: $editForm) {
                    FormView(
                        tipPrice: itemInfo.Tip,
                        totalPrice: itemInfo.Bill + itemInfo.Tip,
                        nameInput: itemInfo.TipName ?? "Unidentified",
                        billInput: String(itemInfo.Bill),
                        tipInput: (itemInfo.Tip / itemInfo.Bill) * 100,
                        formState: $editForm,
                        isEditing: true,
                        editedItem: itemInfo
                    ) { name, bill, tip in
                        withAnimation {
                            viewContext.performAndWait {
                                itemInfo.TipName = name
                                itemInfo.Bill = bill
                                itemInfo.Tip = tip

                                try? viewContext.save()
                            }
                        }
                        editForm = false
                    }
                }
                Button("Delete", role: .destructive) {
                    deleteAlert.toggle()
                }
                .alert("Delete \(itemInfo.TipName ?? "Unidentified")?", isPresented: $deleteAlert) {
                    Button("Yes") {
                        viewContext.delete(itemInfo)
                        do {
                            try viewContext.save()
                            dismiss()
                        } catch {
                            print("error")
                        }
                    }
                    Button("No") {}
                } message: {
                    Text("Are you sure you want to delete this tip?")
                }
            }
        }
        .navigationTitle("Tip detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
