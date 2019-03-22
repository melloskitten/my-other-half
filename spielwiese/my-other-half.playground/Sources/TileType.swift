import Cocoa
import SpriteKit
import PlaygroundSupport

/// Enums representing the different types of tiles.
public enum TileType {
    case walkable
    case blocked
    case requiredToStandOn
    case switchToSyncMode
    case switchToOppositeMode
}
