import Cocoa
import SpriteKit
import PlaygroundSupport

public class Level {
    
    var tiles = [[Tile]]()
    var scene: SKScene
    var requiresStandOnField = false
    
    /// https://stackoverflow.com/a/46251224/7217195
    public init(size: LevelSize, scene: SKScene,
                buildMode: Bool = false) {
        self.scene = scene
        
        for x in 0...size.width-1 {
            tiles.append( [] )
            
            for y in 0...size.height-1 {
                let walkableTile = WalkableTile(.init(x: x, y: y))
                if buildMode {
                    walkableTile.drawBorder(color: NSColor(red:0.98, green:0.86, blue:0.81, alpha:1.0), width: 1.0)
                }
                let tilePosition = getPosition(x, y)
                walkableTile.setPosition(to: tilePosition)
                tiles[x].append(walkableTile)
                scene.addChild(walkableTile)
            }
        }
    }
    
    func toggleTiles(_ toggleTiles: [Tile]) -> [Tile] {
        var temp = [Tile]()
        for tile in toggleTiles {
            let oldTilePosition = tile.tilePosition
            switch tile {
            case is BlockedTile:
                let tile = setAndReturnTile(type: .walkable, on: oldTilePosition)
                temp.append(tile)
            case is WalkableTile:
                let tile = setAndReturnTile(type: .blocked, on: oldTilePosition)
                temp.append(tile)
            default:
                let tile = setAndReturnTile(type: .walkable, on: oldTilePosition)
                temp.append(tile)
            }
        }
        return temp
    }
    
    public func setTile(type: TileType, on position: TilePosition) {
        _ = setAndReturnTile(type: type, on: position)
    }
    
    private func setAndReturnTile(type: TileType, on position: TilePosition) -> Tile {
        var tile: Tile
        
        switch type {
        case .walkable:
            tile = WalkableTile(position)
        case .blocked:
            tile = BlockedTile(position)
        case .requiredToStandOn:
            tile = RequiredToStandOnTile(position)
            requiresStandOnField = true
        case .switchToOppositeMode:
            tile = SwitchPartnerModeTile(position, .opposite)
        case .switchToSyncMode:
            tile = SwitchPartnerModeTile(position, .synchronised)
        case .switchTile:
            tile = SwitchTile(position)
        default:
            print("\(type) not supported yet, rendering WalkableTile instead.")
            tile = WalkableTile(position)
        }
        
        // Remove previous tile from scene.
        tiles[position.x][position.y].removeFromParent()
        
        // Adjust position of new tile and add to scene.
        tile.setPosition(to: getPosition(position))
        tiles[position.x][position.y] = tile
        
        // TODO: Perhaps move this adjustment to another class?
        scene.addChild(tile)
        return tile
    }
    
    func setSwitchTile(on position: TilePosition,
                       switchedTiles: [TilePosition: TileType] ) {
        setTile(type: .switchTile, on: position)
        let tile = getTile(at: position) as? SwitchTile
        
        for (tilePosition, tileType) in switchedTiles {
            setTile(type: tileType, on: tilePosition)
            let switchedTile = getTile(at: tilePosition)
            tile?.switchedTiles.append(switchedTile!)
        }
        
    }
    
    
    func getTile(at tilePosition: TilePosition) -> Tile? {
        if tilePosition.x < 0 || tilePosition.y < 0
            || tilePosition.x >= tiles.count || tilePosition.y >= tiles[0].count {
            return nil
        }
        return tiles[tilePosition.x][tilePosition.y]
    }
    
    internal func setCharacter(_ character: Character, on tilePosition: TilePosition) {
        if let tile = getTile(at: tilePosition) {
            character.position = tile.position
            character.initialTilePosition = tilePosition
            character.tilePosition = tilePosition
            character.zPosition = 10000
            scene.addChild(character)
        }
        
        // TODO: Maybe some error handling?
    }
    
    func updatePosition(for character: Character, on tilePosition: TilePosition) {
        if let tile = getTile(at: tilePosition) {
            character.position = tile.position
            character.tilePosition = tilePosition
        }
    }
    
    
    private func getPosition(_ forTilePosition: TilePosition) -> CGPoint {
        let positionX = forTilePosition.x * Int(DEFAULT_TILE_SIZE.width)
        let positionY = forTilePosition.y * Int(DEFAULT_TILE_SIZE.height)
        return CGPoint(x: positionX, y: positionY)
    }
    
    private func getPosition(_ forTilePositionX: Int, _ forTilePositionY: Int) -> CGPoint {
        return getPosition(TilePosition(x: forTilePositionX, y: forTilePositionY))
    }
    
}
