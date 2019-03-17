import Cocoa
import SpriteKit
import PlaygroundSupport

public struct TilePosition: Hashable {
    public var x: Int
    public var y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}
