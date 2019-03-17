import Cocoa
import SpriteKit
import PlaygroundSupport

public class Character: SKSpriteNode {
    
    var initialTilePosition: TilePosition?
    var tilePosition: TilePosition?
    
    public required init(characterType: CharacterType? = nil) {
        var imagePath: String = ""
        
        switch characterType {
        case .mom?:
            imagePath = MOM
        case .dad?:
            imagePath = DAD
        case .son?:
            imagePath = SON
        case .groomBob?:
            imagePath = GROOM_BOB
        case .brideAlice?:
            imagePath = BRIDE_ALICE
        case .brideCarla?:
            imagePath = BRIDE_CARLA
        case .brideDalia?:
            imagePath = BRIDE_DALIA
        case .catto?:
            imagePath = CATTO
        case .doggo?:
            imagePath = DOGGO
        case .crabbo?:
            imagePath = CRABBO
        case .crabbolino?:
            imagePath = CRABBOLINO
        default:
            break
        }
        
        let texture = SKTexture(imageNamed: imagePath)
        
        super.init(texture: texture, color: .black, size: DEFAULT_CHARACTER_SIZE)
        // TODO: Does this really belong in this class?
        self.physicsBody = SKPhysicsBody(rectangleOf: DEFAULT_CHARACTER_SIZE)
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.contactTestBitMask = ENEMY_CATEGORY
        self.physicsBody!.isDynamic = true
        self.physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
