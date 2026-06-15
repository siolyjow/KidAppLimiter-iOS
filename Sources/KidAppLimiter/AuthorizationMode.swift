import FamilyControls
import Foundation

enum AuthorizationMode: String, CaseIterable, Codable, Identifiable {
    case child
    case individual

    var id: String { rawValue }

    var member: FamilyControlsMember {
        switch self {
        case .child:
            return .child
        case .individual:
            return .individual
        }
    }

    var title: String {
        switch self {
        case .child:
            return "儿童账号"
        case .individual:
            return "个人测试"
        }
    }
}

