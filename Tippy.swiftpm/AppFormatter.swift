import SwiftUI


    // MARK: Formatters

final class AppFormatter {
    static func formattedDate(dateStyle: DateFormatter.Style? = .medium, timeStyle: DateFormatter.Style? = .medium) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle!
        formatter.timeStyle = timeStyle!
        formatter.doesRelativeDateFormatting = true
        return formatter
    }

    static func formattedNumber(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")

        return formatter.string(from: NSNumber(value: value)) ?? formatter.string(from: NSNumber(value: 0))!
    }
}
