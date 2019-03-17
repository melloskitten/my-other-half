import Cocoa
import SpriteKit
import PlaygroundSupport

public enum TileType {
    case walkable
    case blocked
    case special
    case requiredToStandOn
    case switchToSyncMode
    case switchToOppositeMode
    case switchTile
}
