import SwiftUI

struct TipListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Tips.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Tips.Timestamp, ascending: false)]) private var items: FetchedResults<Tips>

    // Manage app settings
    @ObservedObject var appSettings = AppSettings()

    // Show modals and alerts
    @State private var isAdding = false
    @State private var isEditing = false
    @State private var isDeleting = false

    // Sheet state
    @State private var showIntro = true
    @State private var showHelp = false

    var body: some View {
        NavigationView {
            ZStack {
                // Main background
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.teal, .green],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea()

                // Main content view
                VStack(alignment: .center) {
                    Spacer()

                    if items.isEmpty {
                        Image("Tippy_Sad")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 256, height: 256, alignment: .center)
                        Text("Your tip list is empty. 😢")
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 24) {
                                ForEach(items, id: \.self) { item in
                                    NavigationLink {
                                        DetailView(itemInfo: item) {
                                            deleteTip(item)
                                        }
                                    } label: {
                                        ItemRow(item: item)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)

                        Spacer()
                    }

                    // Open tip form
                    Button("Add a tip") {
                        isAdding = true
                    }
                    .controlSize(.large)
                    .font(.title2)
                    .buttonStyle(BorderedProminentButtonStyle())
                    .sheet(isPresented: $isAdding) {
                        FormView(formState: $isAdding, isEditing: false, editedItem: nil) { name, billTotal, tipPrice in
                            addTip(name: name, bill: billTotal, tip: tipPrice)
                            isAdding = false
                        }
                    }

                    Spacer()

                    // TODO: Cleanup this code before submitting! (or, don't)
                    Button("Show intro") {
                        appSettings.displayIntro.toggle()
                    }
                    .foregroundColor(.white)
                }
                .sheet(isPresented: $appSettings.displayIntro) {
                    appSettings.displayIntro = false
                } content: {
                    IntroView()
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showHelp.toggle()
                        } label: {
                            Label("Help", systemImage: "questionmark.circle.fill")
                        }
                        .foregroundColor(.white)
                        .alert("How to use Tippy", isPresented: $showHelp) {
                            Button("OK, got it!") {}
                        } message: {
                            Text("To add a tip click \"Add a tip\" button and enter a tip name, total bill, and a tip percent to calculate a tip and total price.\n\nTo view more details, tap any listed tip available.")
                        }
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }

    // Add a data
    private func addTip(name: String, bill: Double, tip: Double) {
        withAnimation {
            // Create new context
            let newContext = Tips(context: viewContext)

            // Get input value and save to the new context
            newContext.TipName = name
            newContext.Bill = bill
            newContext.Tip = tip
            newContext.Timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                fatalError()
            }
        }
    }

    // Update a data
    private func updateTip(tipItem: Tips, name: String, bill: Double, tip: Double) {
        viewContext.performAndWait {
            tipItem.TipName = name
            tipItem.Bill = bill
            tipItem.Tip = tip

            try? viewContext.save()
        }
    }

    // Delete a data
    private func deleteTip(_ item: Tips) {
        withAnimation {
            viewContext.performAndWait {
                viewContext.delete(item)
                try? viewContext.save()
            }
        }
    }
}
