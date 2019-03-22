import Cocoa
import SpriteKit
import PlaygroundSupport

// Tile that can switch the partnermode of a player or
// enemy.
class SwitchPartnerModeTile: Tile {
    
    var partnerMode: PartnerMode?
    
    init(_ tilePosition: TilePosition, _ partnerMode: PartnerMode) {
        self.partnerMode = partnerMode
        let textureName = partnerMode == .opposite ? SWITCH_OPP : SWITCH_SYM
        let texture = SKTexture(imageNamed: textureName)
        
        super.init(walkable: true,
                   texture: texture,
                   color: .orange,
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
