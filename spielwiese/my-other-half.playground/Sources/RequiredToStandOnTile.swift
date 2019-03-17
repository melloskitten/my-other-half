import Cocoa
import SpriteKit
import PlaygroundSupport



class RequiredToStandOnTile: Tile {
    
    // TODO: Missing tile reference.
    init(_ tilePosition: TilePosition) {
        
        let texture = SKTexture(imageNamed: REQUIRED_TILE)
        
        super.init(walkable: true,
                   texture: texture,
                   color: .systemPurple,
                   size: DEFAULT_TILE_SIZE,
                   tilePosition: tilePosition)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
