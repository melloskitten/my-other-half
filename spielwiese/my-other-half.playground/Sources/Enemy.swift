import Cocoa
import SpriteKit
import PlaygroundSupport


/// Class representing enemy characters.
public class Enemy: Character {
    
    /// represents the tile positions where the enemy character
    /// patrolls on. If there are none, he will simply
    /// stay in the same location where he started out.
    var walkingRoute = [TilePosition]()
    
    /// Current index that we're accessing in the walkingRoute
    /// array. Needs to be reset when 
    var currentWalkTileIndex = 0
    
    /// Denotes whether we're currently going from first
    /// to last element in the walkingRoute array or
    /// reversed (so from last element to first element.)
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
