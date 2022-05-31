import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // Sample data for preview
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let context = result.container.viewContext
        for index in 0 ..< 12 {
            let bill = Double(10 * (index + 1))

            let tip = Tips(context: context)
            tip.TipName = "TipTest \(index + 1)"
            tip.Bill = bill + ((Double(index) + 1) * 10)
            tip.Tip = (bill * (10 + (Double(index) + 0.5))) / 100
            tip.Timestamp = Date()

            context.perform {
                try! context.save()
            }
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Entity creation
        let tipEntity = NSEntityDescription()
        tipEntity.name = "Tips"
        tipEntity.managedObjectClassName = "Tips"

        // Name attribute
        let nameAttr = NSAttributeDescription()
        nameAttr.name = "TipName"
        nameAttr.type = .string
        tipEntity.properties.append(nameAttr)

        // Bill attribute
        let billAttr = NSAttributeDescription()
        billAttr.name = "Bill"
        billAttr.type = .double
        tipEntity.properties.append(billAttr)

        // Tip attribute
        let tipAttr = NSAttributeDescription()
        tipAttr.name = "Tip"
        tipAttr.type = .double
        tipEntity.properties.append(tipAttr)

        // Timestamp attribute
        let timestampAttr = NSAttributeDescription()
        timestampAttr.name = "Timestamp"
        timestampAttr.type = .date
        tipEntity.properties.append(timestampAttr)

        // Model creation
        let tipModel = NSManagedObjectModel()
        tipModel.entities = [tipEntity]

        let container = NSPersistentContainer(name: "TipsModel", managedObjectModel: tipModel)

        // Load data inside memory
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                // Handling errors
                fatalError("failed with: \(error.localizedDescription)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        container.viewContext.automaticallyMergesChangesFromParent = true
        self.container = container
    }
}
