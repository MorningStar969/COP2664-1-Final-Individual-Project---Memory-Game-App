import Foundation

enum Difficulty: String, CaseIterable, Identifiable {
    case easy
    case medium
    case hard
    
    var id: String { self.rawValue }
    
    var pairCount: Int {
        switch self {
        case .easy:
            return 6
        case .medium:
            return 12
        case .hard:
            return 18
        }
    }
} // The Difficulty enum defines three cases: easy, medium, and hard. Each case has an associated pairCount property that specifies the number of pairs of cards for that difficulty level.
