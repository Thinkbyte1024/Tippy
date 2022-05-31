import CoreData
import SwiftUI


    // MARK: Tips model

@objc(Tips)
class Tips: NSManagedObject {
    @NSManaged public var TipName: String?
    @NSManaged public var Bill: Double
    @NSManaged public var Tip: Double
    @NSManaged public var Timestamp: Date?
}

extension Tips {
    public var wrappedTipName: String {
        get { TipName ?? "Unidentified" }
        set { TipName = newValue }
    }

    public var wrappedBill: String {
        get { String(Bill) }
        set { Bill = Double(newValue)! }
    }

    public var tipPercent: Double {
        get { (Tip / Bill) * 100 }
    }
}

extension Tips: Identifiable {
    
}
