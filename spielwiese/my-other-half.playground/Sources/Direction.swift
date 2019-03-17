import Cocoa
import SpriteKit
import PlaygroundSupport

enum Direction {
    case left
    case right
    case down
    case up
    
    func opposite() -> Direction {
        switch self {
        case .left:
            return .right
        case .right:
            return .left
        case .down:
            return .up
        case .up:
            return .down
        }
    }
    
    func synchronised() -> Direction {
        return self
    }
}
