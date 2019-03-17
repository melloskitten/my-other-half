import Cocoa
import SpriteKit
import PlaygroundSupport

class BlockedTile: Tile {
    
    // TODO: Missing tile reference.
    init(_ tilePosition: TilePosition) {
        
        let texture = SKTexture(imageNamed: BLOCKED_TEXTURES.randomElement()!)
        super.init(walkable: false,
                   texture: texture,
                   color: .darkGray,
                   size: DEFAULT_TILE_SIZE,
                   tilePosition: tilePosition)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: DEFAULT_CHARACTER_SIZE)
        self.physicsBody?.contactTestBitMask = BLOCKED_TILE_CATEGORY
        self.physicsBody?.categoryBitMask = BLOCKED_TILE_CATEGORY
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.isDynamic = true
        self.physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
