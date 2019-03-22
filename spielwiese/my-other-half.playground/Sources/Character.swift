import Cocoa
import SpriteKit
import PlaygroundSupport

/// Base class for all characters in this game, including the player, enemy and partner character.
public class Character: SKSpriteNode {
    
    /// Tile position at which the character starts out.
    /// needed for restarting the level.
    var initialTilePosition: TilePosition?
    
    /// Current tile position of the character.
    var tilePosition: TilePosition?
    
    
    /// Initializes a character based on the given character type.
    ///
    /// - Parameter characterType: the type of character you would like
    /// to put in the game.
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
        
        // Load the texture that corresponds to the given character
        // type.
        let texture = SKTexture(imageNamed: imagePath)
        
        super.init(texture: texture, color: .black, size: DEFAULT_CHARACTER_SIZE)

        // Set physics body collisions.
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
