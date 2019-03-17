import Cocoa
import SpriteKit
import PlaygroundSupport


// This tile flips a set of tiles from walkable to unwalkable and vice versa.
class SwitchTile: Tile {
    
    var switchedTiles: [Tile]
    
    init(_ tilePosition: TilePosition, _ switchedTiles: [Tile]? = nil) {
        if let existingTiles = switchedTiles {
            self.switchedTiles = existingTiles
        } else {
            self.switchedTiles = [Tile]()
        }
        
        let texture = SKTexture(imageNamed: SWITCH)
        
        super.init(walkable: true,
                   texture: texture,
                   color: .systemYellow,
                   size: DEFAULT_TILE_SIZE,
                   tilePosition: tilePosition)
        
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
