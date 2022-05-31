import SwiftUI

// This view displays an individual item on CoreData
struct ItemRow: View {

    // Get Tips model
    @ObservedObject var item: Tips

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.TipName ?? "Unidentified")
                    .font(.title)
                Text(item.Timestamp != nil ? "\(item.Timestamp!, formatter: AppFormatter.formattedDate(dateStyle: .medium, timeStyle: .short))" : "\(Date(), formatter: AppFormatter.formattedDate(dateStyle: .medium, timeStyle: .short))")
                    .font(.caption)
            }
            .padding()

            Spacer()

            Text(AppFormatter.formattedNumber(value: item.Bill + item.Tip))
                .padding()
        }
        .background(Color.accentColor)
        .foregroundColor(.white)
        .cornerRadius(12)
    }
}
