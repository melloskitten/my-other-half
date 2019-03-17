import Cocoa
import SpriteKit
import PlaygroundSupport

public class Enemy: Character {
    
    var walkingRoute = [TilePosition]()
    var currentWalkTileIndex = 0
    /// Denotes whether we're currently going from first to last element in the
    /// walkingRoute array or reversed (so from last element to first element.)
    var reversed = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init(characterType: CharacterType?) {
        super.init(characterType: characterType)
        self.physicsBody?.contactTestBitMask = ENEMY_CATEGORY
        self.physicsBody?.categoryBitMask = ENEMY_CATEGORY
    }
    
    public func addWalkingRoute(_ walkingRouteTilePositions: [TilePosition]) {
        walkingRoute = walkingRouteTilePositions
    }
}
