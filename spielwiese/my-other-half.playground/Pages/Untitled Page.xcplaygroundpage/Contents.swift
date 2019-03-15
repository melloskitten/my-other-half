import Cocoa
import SpriteKit
import PlaygroundSupport

/// This is just for debugging purposes.
/// TODO: Remove me when adding textures.
/// https://stackoverflow.com/a/52708360/7217195
extension SKSpriteNode {
    func drawBorder(color: NSColor, width: CGFloat) {
        let shapeNode = SKShapeNode(rect: frame)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = color
        shapeNode.lineWidth = width
        addChild(shapeNode)
    }
}

// CONSTANTS:
let DEFAULT_TILE_SIZE = CGSize(width: 50, height: 50)
let DEFAULT_CHARACTER_SIZE = CGSize(width: 30, height: 40)

class Tile: SKSpriteNode {
    var walkable: Bool
    
    // TODO: Contemplate whether this is a good name?
    var objects: [SKSpriteNode]
    
    init(walkable: Bool, texture: SKTexture?, color: NSColor, size: CGSize) {
        self.walkable = walkable
        self.objects = []
        super.init(texture: texture, color: color, size: size)
        drawBorder(color: .darkGray, width: 1.0)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Convenience method for setting the position of the lower left hand
    /// corner of the sprite, as opposed to the center.
    func setPosition(to: CGPoint) {
        let widthOffset = self.frame.width / 2
        let heightOffset = self.frame.height / 2
        self.position = CGPoint(x: to.x + widthOffset,
                                y: to.y + heightOffset)
    }
}

class WalkableTile: Tile {
    
    // TODO: Missing tile reference.
    init() {
        super.init(walkable: true,
                   texture: nil,
                   color: .green,
                   size: DEFAULT_TILE_SIZE)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BlockedTile: Tile {
    
    // TODO: Missing tile reference.
    init() {
        super.init(walkable: false,
                   texture: nil,
                   color: .darkGray,
                   size: DEFAULT_TILE_SIZE)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum TileType {
    case walkable
    case blocked
    case special
}

class Level {
    
    var tiles = [[Tile]]()
    var scene: SKScene
    
    /// https://stackoverflow.com/a/46251224/7217195
    init(size: LevelSize, scene: SKScene) {
        self.scene = scene
        
        for x in 0...size.width-1 {
            tiles.append( [] )
            
            for y in 0...size.height-1 {
                let walkableTile = WalkableTile()
                let tilePosition = getPosition(x, y)
                walkableTile.setPosition(to: tilePosition)
                tiles[x].append(walkableTile)
                scene.addChild(walkableTile)
            }
        }
    }
    
    func setTile(type: TileType, position: TilePosition) {
        var tile: Tile
        
        switch type {
        case .walkable:
            tile = WalkableTile()
        case .blocked:
            tile = BlockedTile()
        default:
            print("\(type) not supported yet, rendering WalkableTile instead.")
            tile = WalkableTile()
        }
        
        // Remove previous tile from scene.
        tiles[position.x][position.y].removeFromParent()
        
        // Adjust position of new tile and add to scene.
        tile.setPosition(to: getPosition(position))
        tiles[position.x][position.y] = tile
        
        // TODO: Perhaps move this adjustment to another class?
        scene.addChild(tile)
    }
    
    func getTile(at tilePosition: TilePosition) -> Tile {
        return tiles[tilePosition.x][tilePosition.y]
    }
    
    func setCharacter(_ character: Character, on tilePosition: TilePosition) {
        let tile = getTile(at: tilePosition)
        character.position = tile.position
        scene.addChild(character)
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

class Character: SKSpriteNode {
    
    required init(characterType: CharacterType? = nil) {
        // let texture: SKTexture?
        let color: NSColor
        
        switch characterType {
        case .alice?:
            color = .white
        case .bob?:
            color = .blue
        default:
            color = .black
        }
        
        super.init(texture: nil, color: color, size: DEFAULT_CHARACTER_SIZE)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Player: Character {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(characterType: CharacterType?) {
        super.init(characterType: characterType)
    }
}

class Partner: Character {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(characterType: CharacterType?) {
        super.init(characterType: characterType)
    }
}

enum CharacterType {
    case alice
    case bob
}

struct TilePosition {
    var x: Int
    var y: Int
}

struct LevelSize {
    var width: Int
    var height: Int
}

let LEFT_ARROW_KEY: UInt16 = 123
let RIGHT_ARROW_KEY: UInt16 = 124
let DOWN_ARROW_KEY: UInt16 = 125
let UP_ARROW_KEY: UInt16 = 126

class GameScene: SKScene {
    
    var level: Level?
    var player: Player?
    var partner: Partner?
    var partnerMode: PartnerMode = .opposite

    override func keyDown(with event: NSEvent) {
        
        var direction: Direction? = nil
        
        if player != nil {
            switch event.keyCode {
            case LEFT_ARROW_KEY:
                direction = .left
            case RIGHT_ARROW_KEY:
                direction = .right
            case DOWN_ARROW_KEY:
                direction = .down
            case UP_ARROW_KEY:
                direction = .up
            default:
                break
            }
            
            if direction != nil {
                moveSceneCharacters(inPlayerDirection: direction!)
            }
        }
    }
    
    private func moveSceneCharacters(inPlayerDirection playerDirection: Direction) {
        
        if let player = player, let partner = partner {
            
            // Move the player first.
            moveCharacter(player, inDirection: playerDirection)
            
            var partnerDirection: Direction
            // Move partner depending on mode.
            switch partnerMode {
            case .opposite:
                partnerDirection = playerDirection.opposite()
            case .synchronised:
                partnerDirection = playerDirection.synchronised()
            }
            
            moveCharacter(partner, inDirection: partnerDirection)
        }
        
    }
    
    private func moveCharacter(_ character: Character, inDirection direction: Direction) {
        
        var moveAction = SKAction()
        
        switch direction {
        case .left:
            let moveVector = CGVector(dx: -DEFAULT_TILE_SIZE.width, dy: 0)
            moveAction = SKAction.move(by: moveVector, duration: 0.1)
        
        case .right:
            let moveVector = CGVector(dx: DEFAULT_TILE_SIZE.width, dy: 0)
            moveAction = SKAction.move(by: moveVector, duration: 0.1)
            
        case .down:
            let moveVector = CGVector(dx: 0, dy: -DEFAULT_TILE_SIZE.height)
            moveAction = SKAction.move(by: moveVector, duration: 0.1)
            
        case .up:
            let moveVector = CGVector(dx: 0, dy: DEFAULT_TILE_SIZE.height)
            moveAction = SKAction.move(by: moveVector, duration: 0.1)
        }
        
        character.run(moveAction)
    }
    
}

enum PartnerMode {
    case synchronised
    case opposite
}

enum Direction {
    case left
    case right
    case down
    case up
    
    func opposite() -> Direction {
        switch self {
        case .left:
            return .right
        case .right:
            return .left
        case .down:
            return .up
        case .up:
            return .down
        }
    }
    
    func synchronised() -> Direction {
        return self
    }
}

let view = SKView(frame: NSRect(x: 0, y: 0, width: 500, height: 500))
let scene = GameScene(size: CGSize(width: 500, height: 500))
view.presentScene(scene)

let size = LevelSize(width: 5, height: 6)
let level = Level(size: size, scene: scene)
level.setTile(type: .blocked, position: TilePosition(x: 4, y: 4))
level.setTile(type: .blocked, position: TilePosition(x: 3, y: 2))

let player = Player(characterType: .alice)
let partner = Partner(characterType: .bob)

level.setCharacter(player, on: TilePosition(x: 0, y: 0))
level.setCharacter(partner, on: TilePosition(x: 4, y: 5))

scene.level = level
scene.player = player
scene.partner = partner

PlaygroundPage.current.liveView = view




