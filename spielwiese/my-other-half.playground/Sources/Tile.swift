import Cocoa
import SpriteKit
import PlaygroundSupport


class Tile: SKSpriteNode {
    var walkable: Bool
    var tilePosition: TilePosition
    
    // TODO: Contemplate whether this is a good name?
    var objects: [SKSpriteNode]
    
    init(walkable: Bool, texture: SKTexture?, color: NSColor, size: CGSize,
         tilePosition: TilePosition) {
        self.walkable = walkable
        self.objects = []
        self.tilePosition = tilePosition
        super.init(texture: texture, color: color, size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Convenience method for setting the position of the lower left hand
    /// corner of the sprite, as opposed to the center.
    func setPosition(to: CGPoint) {
        let widthOffset = X_OFFSET + self.frame.width / 2
        let heightOffset = Y_OFFSET + self.frame.height / 2
        self.position = CGPoint(x: to.x + widthOffset,
                                y: to.y + heightOffset)
    }
}
