import Cocoa
import SpriteKit
import PlaygroundSupport


/// Represents direction of movement of a character.
enum Direction {
    case left
    case right
    case down
    case up
    
    
    /// Gets opposite direction for a given direction.
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
    
    /// Gets synchronised direction for a given direction.
    func synchronised() -> Direction {
        return self
    }
}
