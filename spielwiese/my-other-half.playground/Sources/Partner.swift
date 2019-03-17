import Cocoa
import SpriteKit
import PlaygroundSupport

public class Partner: Character {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init(characterType: CharacterType?) {
        super.init(characterType: characterType)
        self.physicsBody?.contactTestBitMask = SWITCH_ENEMY_BLOCKABLE_TILE_CATEGORY
    }
}
