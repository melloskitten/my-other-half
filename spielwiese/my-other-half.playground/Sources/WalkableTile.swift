import Cocoa
import SpriteKit
import PlaygroundSupport



class WalkableTile: Tile {
    
    // TODO: Missing tile reference.
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
