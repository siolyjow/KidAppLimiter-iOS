import Foundation

struct SelectionSummary: Equatable {
    var apps: Int
    var categories: Int
    var websites: Int

    static let empty = SelectionSummary(apps: 0, categories: 0, websites: 0)

    var total: Int {
        apps + categories + websites
    }

    var text: String {
        if total == 0 {
            return "还没有选择"
        }

        var parts: [String] = []
        if apps > 0 {
            parts.append("\(apps) 个 App")
        }
        if categories > 0 {
            parts.append("\(categories) 个类别")
        }
        if websites > 0 {
            parts.append("\(websites) 个网站")
        }
        return parts.joined(separator: "、")
    }
}

