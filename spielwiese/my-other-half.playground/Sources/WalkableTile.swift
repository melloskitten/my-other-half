import Cocoa
import SpriteKit
import PlaygroundSupport

/// This represents a level tile such as a normal sand tile
/// which can be walked on by the characters.
class WalkableTile: Tile {
    
    init(_ tilePosition: TilePosition) {
        
        let texture = SKTexture(imageNamed: WALKABLE_TEXTURES.randomElement()!)
        super.init(walkable: true,
                   texture: texture,
                   color: .green,
                   size: DEFAULT_TILE_SIZE,
                   tilePosition: tilePosition)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
