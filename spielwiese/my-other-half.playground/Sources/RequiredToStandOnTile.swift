import Cocoa
import SpriteKit
import PlaygroundSupport

// This class represents a tile that the player and partner have to
// stand on in order to end the level.
class RequiredToStandOnTile: Tile {
    
    init(_ tilePosition: TilePosition) {
        let texture = SKTexture(imageNamed: REQUIRED_TILE)
        super.init(walkable: true,
                   texture: texture,
                   color: .systemPurple,
                   size: DEFAULT_TILE_SIZE,
                   tilePosition: tilePosition)
        
        // Sets the physics body collision.
        self.physicsBody = SKPhysicsBody(rectangleOf: DEFAULT_CHARACTER_SIZE)
        self.physicsBody?.contactTestBitMask = SWITCH_CATEGORY
        self.physicsBody?.categoryBitMask = SWITCH_CATEGORY
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.isDynamic = true
        self.physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
