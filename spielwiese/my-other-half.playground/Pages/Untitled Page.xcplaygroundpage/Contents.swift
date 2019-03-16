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

enum PartnerMode {
    case synchronised
    case opposite
}

// CONSTANTS:
let ENEMY_CATEGORY: UInt32 = 1
let SWITCH_CATEGORY: UInt32 = 4
let BLOCKED_TILE_CATEGORY: UInt32 = 2
let SWITCH_AND_ENEMY_CATEGORY: UInt32 = 5
let SWITCH_ENEMY_BLOCKABLE_TILE_CATEGORY: UInt32 = 7
let DEFAULT_TILE_SIZE = CGSize(width: 50, height: 50)
let DEFAULT_CHARACTER_SIZE = CGSize(width: 30, height: 40)
let WALK_ANIMATION_DURATION = 0.15

class Tile: SKSpriteNode {
    var walkable: Bool
    var tilePosition: TilePosition
    
    // TODO: Contemplate whether this is a good name?
    var objects: [SKSpriteNode]
    
    init(walkable: Bool, texture: SKTexture?, color: NSColor, size: CGSize,
         tilePosition: TilePosition) {
        self.walkable = walkable
        self.objects = []
        self.tilePosition = tilePosition
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
    init(_ tilePosition: TilePosition) {
        super.init(walkable: true,
                   texture: nil,
                   color: .green,
                   size: DEFAULT_TILE_SIZE,
                   tilePosition: tilePosition)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BlockedTile: Tile {
    
    // TODO: Missing tile reference.
    init(_ tilePosition: TilePosition) {
        super.init(walkable: false,
                   texture: nil,
                   color: .darkGray,
                   size: DEFAULT_TILE_SIZE,
                   tilePosition: tilePosition)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: DEFAULT_CHARACTER_SIZE)
        self.physicsBody?.contactTestBitMask = BLOCKED_TILE_CATEGORY
        self.physicsBody?.categoryBitMask = BLOCKED_TILE_CATEGORY
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.isDynamic = true
        self.physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RequiredToStandOnTile: Tile {
    
    // TODO: Missing tile reference.
    init(_ tilePosition: TilePosition) {
        super.init(walkable: true,
                   texture: nil,
                   color: .systemPurple,
                   size: DEFAULT_TILE_SIZE,
                   tilePosition: tilePosition)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SwitchPartnerModeTile: Tile {
    
    var partnerMode: PartnerMode?
    
    init(_ tilePosition: TilePosition, _ partnerMode: PartnerMode) {
        self.partnerMode = partnerMode
        
        // TODO: Switch between tiles for the two modes.
        let color: NSColor = partnerMode == .opposite ? .systemBlue : .systemRed

        super.init(walkable: true,
                   texture: nil,
                   color: color,
                   size: DEFAULT_TILE_SIZE,
                   tilePosition: tilePosition)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: DEFAULT_CHARACTER_SIZE)
        self.physicsBody?.contactTestBitMask = SWITCH_CATEGORY
        self.physicsBody?.categoryBitMask = SWITCH_CATEGORY
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.isDynamic = true
        self.physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// This tile flips a set of tiles from walkable to unwalkable and vice versa.
class SwitchTile: Tile {
    
    var switchedTiles: [Tile]
    
    init(_ tilePosition: TilePosition, _ switchedTiles: [Tile]? = nil) {
        if let existingTiles = switchedTiles {
            self.switchedTiles = existingTiles
        } else {
            self.switchedTiles = [Tile]()
        }
        
        super.init(walkable: true,
                   texture: nil,
                   color: .systemYellow,
                   size: DEFAULT_TILE_SIZE,
                   tilePosition: tilePosition)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: DEFAULT_CHARACTER_SIZE)
        self.physicsBody?.contactTestBitMask = SWITCH_CATEGORY
        self.physicsBody?.categoryBitMask = SWITCH_CATEGORY
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.isDynamic = true
        self.physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


enum TileType {
    case walkable
    case blocked
    case special
    case requiredToStandOn
    case switchToSyncMode
    case switchToOppositeMode
    case switchTile
}

class Level {
    
    var tiles = [[Tile]]()
    var scene: SKScene
    var requiresStandOnField = false
    
    /// https://stackoverflow.com/a/46251224/7217195
    init(size: LevelSize, scene: SKScene) {
        self.scene = scene
        
        for x in 0...size.width-1 {
            tiles.append( [] )
            
            for y in 0...size.height-1 {
                let walkableTile = WalkableTile(.init(x: x, y: y))
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
    
    func setTile(type: TileType, on position: TilePosition) {
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

class Character: SKSpriteNode {
    
    var initialTilePosition: TilePosition?
    var tilePosition: TilePosition?
    
    required init(characterType: CharacterType? = nil) {
        // let texture: SKTexture?
        let color: NSColor
        
        switch characterType {
        case .alice?:
            color = .white
        case .bob?:
            color = .blue
        case .charlie?:
            color = .orange
        default:
            color = .black
        }
        
        super.init(texture: nil, color: color, size: DEFAULT_CHARACTER_SIZE)
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

class Player: Character {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(characterType: CharacterType?) {
        super.init(characterType: characterType)
        self.physicsBody?.contactTestBitMask = SWITCH_ENEMY_BLOCKABLE_TILE_CATEGORY
    }
}

class Partner: Character {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(characterType: CharacterType?) {
        super.init(characterType: characterType)
        self.physicsBody?.contactTestBitMask = SWITCH_ENEMY_BLOCKABLE_TILE_CATEGORY
    }
}

class Enemy: Character {
    
    var walkingRoute = [TilePosition]()
    var currentWalkTileIndex = 0
    /// Denotes whether we're currently going from first to last element in the
    /// walkingRoute array or reversed (so from last element to first element.)
    var reversed = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(characterType: CharacterType?) {
        super.init(characterType: characterType)
        self.physicsBody?.contactTestBitMask = ENEMY_CATEGORY
        self.physicsBody?.categoryBitMask = ENEMY_CATEGORY
    }
    
    func addWalkingRoute(_ walkingRouteTilePositions: [TilePosition]) {
        walkingRoute = walkingRouteTilePositions
    }
}

enum CharacterType {
    case alice
    case bob
    case charlie
}

struct TilePosition: Hashable {
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
let RETRY_KEY: UInt16 = 15

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var level: Level?
    var player: Player?
    var partner: Partner?
    var partnerMode: PartnerMode = .opposite
    var enemies = [Enemy]()
    
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if let _ = contact.bodyA.node as? BlockedTile, let character = contact.bodyB.node as? Character {
            if character is Player || character is Partner {
                endGame(withSuccess: false)
                return
            }
        }
        
        if let switchPartnerModeTile = contact.bodyA.node as? SwitchPartnerModeTile  {
            partnerMode = switchPartnerModeTile.partnerMode!
            return
        }
        
        if let switchTile = contact.bodyA.node as? SwitchTile, let level = level {
            switchTile.switchedTiles = level.toggleTiles(switchTile.switchedTiles)
        }
        
        if (contact.bodyA.node is Player || contact.bodyA.node is Partner)
            && (contact.bodyB.node is Enemy) {
            endGame(withSuccess: false)
        }
        
        if (contact.bodyA.node is Player && contact.bodyB.node is Partner)
            || (contact.bodyA.node is Partner && contact.bodyB.node is Player) {
            
            // If the level needs a required field to finish on, make sure to check
            // that as well as its needed for the ending of the level.
            
            if ((level?.requiresStandOnField)!) {
                if let player = contact.bodyA.node as? Character {
                    if let tile = level?.getTile(at: player.tilePosition!) {
                        if tile is RequiredToStandOnTile {
                            endGame(withSuccess: true)
                            return
                        }
                    }
                }
                // TODO: Handle here a nice error message that you're not
                // standing on the correct tile!!!
                return
            }
            endGame(withSuccess: true)
        }

    }

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
            
            // Move to mouse based input for this at some later point
            // in time.
            case RETRY_KEY:
                retryGame()
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
            
            // Check if the partner and playerCharacter are next to each other,
            // because this also ends the game.
            moveEnemies()

        }
        
    }
    
    private func retryGame() {
        // TODO: Maybe some nice loading animation would be good.
        
        // Reposition the player, partner and enemies.
        if let player = player, let partner = partner {
            level?.updatePosition(for: player, on: (player.initialTilePosition)!)
            level?.updatePosition(for: partner, on: (partner.initialTilePosition)!)
            
            enemies.forEach { (enemy) in
                level?.updatePosition(for: enemy, on: enemy.initialTilePosition!)
            }
            
            PlaygroundPage.current.liveView = self.view
        }
    }
    
    private func endGame(withSuccess: Bool) {
        
        let finishScreen = NSView(frame: NSRect(x: 0, y: 0, width: 500, height: 500))
        let finishText = NSTextField(frame: NSRect(x: 150, y: 250, width: 200, height: 200))
        finishText.isBezeled = false
        finishText.isEditable = false
        switch withSuccess {
        case true:
            finishText.stringValue = "You found your love! Congrats!"
            finishScreen.addSubview(finishText)
        case false:
            finishText.stringValue = "You got sidetracked by whatever. Try harder next time, your love is waiting for you!!!"
            finishScreen.addSubview(finishText)
        }
        
        PlaygroundPage.current.liveView = finishScreen
    }
    
    
    private func moveEnemies() {
        enemies.forEach { (enemy) in

            // Only animate enemies that actually have wakling routes.
            if enemy.walkingRoute.count > 1 {
                let currentIndex = enemy.currentWalkTileIndex

                // Not reversed means that we are traversing through the
                // walking route tile array from the first to the last entry.
                if !enemy.reversed {
                    
                    // If reached end of the walking route array, reverse and
                    // start from end.
                    if currentIndex == enemy.walkingRoute.count - 1 {
                        enemy.currentWalkTileIndex -= 1
                        enemy.reversed = true
                        
                        if isWalkablePosition(at: enemy.walkingRoute[enemy.currentWalkTileIndex]) {
                            moveCharacter(enemy, to: enemy.walkingRoute[enemy.currentWalkTileIndex])
                        }
                        
                    } else {
                        enemy.currentWalkTileIndex += 1

                        if isWalkablePosition(at: enemy.walkingRoute[enemy.currentWalkTileIndex]) {
                            moveCharacter(enemy, to: enemy.walkingRoute[enemy.currentWalkTileIndex])
                        }
                    }
                    
                // Reversed means that we are traversing through the
                // walking route tile array from the last to the first entry.
                } else {
                    // If reached front again, start going through
                    // array normally again.
                    if currentIndex == 0 {
                        enemy.currentWalkTileIndex += 1
                        enemy.reversed = false
                        
                        if isWalkablePosition(at: enemy.walkingRoute[enemy.currentWalkTileIndex]) {
                            moveCharacter(enemy, to: enemy.walkingRoute[enemy.currentWalkTileIndex])
                        }
                        
                    } else {
                        
                        enemy.currentWalkTileIndex -= 1
                        
                        if isWalkablePosition(at: enemy.walkingRoute[enemy.currentWalkTileIndex]) {
                            moveCharacter(enemy, to: enemy.walkingRoute[enemy.currentWalkTileIndex])
                        }
                    }
                }
            }
        }
    }
    
    private func moveCharacter(_ character: Character, to tilePosition: TilePosition) {
        if isWalkablePosition(at: tilePosition) {
            let tile = level?.getTile(at: tilePosition)
            let moveAction = SKAction.move(to: (tile?.position)!,
                                           duration: WALK_ANIMATION_DURATION)
            character.run(moveAction)
        }
    }
    
    private func moveCharacter(_ character: Character, inDirection direction: Direction) {
        
        // Initialise the action and potential tile position to check later.
        var moveAction = SKAction()
        var tempTilePos: TilePosition
        
        if let charPos = character.tilePosition {
            
            switch direction {
            case .left:
                tempTilePos = TilePosition(x: charPos.x-1, y: charPos.y)
                let moveVector = CGVector(dx: -DEFAULT_TILE_SIZE.width, dy: 0)
                moveAction = SKAction.move(by: moveVector, duration: WALK_ANIMATION_DURATION)
            
            case .right:
                tempTilePos = TilePosition(x: charPos.x+1, y: charPos.y)
                let moveVector = CGVector(dx: DEFAULT_TILE_SIZE.width, dy: 0)
                moveAction = SKAction.move(by: moveVector, duration: WALK_ANIMATION_DURATION)
                
            case .down:
                tempTilePos = TilePosition(x: charPos.x, y: charPos.y-1)
                let moveVector = CGVector(dx: 0, dy: -DEFAULT_TILE_SIZE.height)
                moveAction = SKAction.move(by: moveVector, duration: WALK_ANIMATION_DURATION)
                
            case .up:
                tempTilePos = TilePosition(x: charPos.x, y: charPos.y+1)
                let moveVector = CGVector(dx: 0, dy: DEFAULT_TILE_SIZE.height)
                moveAction = SKAction.move(by: moveVector, duration: WALK_ANIMATION_DURATION)
            }

            if isWalkablePosition(at: tempTilePos) {
                character.tilePosition = tempTilePos
                character.run(moveAction)
            }
        }
    }

    
    func isWalkablePosition(at tilePosition: TilePosition) -> Bool {
        if let tile = level?.getTile(at: tilePosition) {
            return tile.walkable
        }
        return false
    }
    
    func setCharacter(_ character: Character, on tilePosition: TilePosition) {
        level?.setCharacter(character, on: tilePosition)
        
        switch character {
        case is Player:
            player = character as? Player
        case is Partner:
            partner = character as? Partner
        case is Enemy:
            enemies.append((character as? Enemy)!)
        default:
            print("Unknown character could not be set.")
        }
    }
    
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
view.showsFPS = true

let size = LevelSize(width: 5, height: 7)
let level = Level(size: size, scene: scene)
level.setTile(type: .blocked, on: TilePosition(x: 4, y: 4))
level.setTile(type: .blocked, on: TilePosition(x: 3, y: 2))
level.setTile(type: .requiredToStandOn, on: TilePosition(x: 3, y: 5))
// level.setTile(type: .switchToSyncMode, on: .init(x: 0, y: 3))
// level.setTile(type: .blocked, on: .init(x: 1, y: 4))
// level.setTile(type: .switchToSyncMode, on: .init(x: 2, y: 2))

/*let switchedTiles: [TilePosition: TileType] = [ .init(x: 3, y: 5): .blocked,
                                                .init(x: 4, y: 3):  .walkable]
level.setSwitchTile(on: .init(x: 2, y: 5), switchedTiles: switchedTiles)*/

let player = Player(characterType: .alice)
let partner = Partner(characterType: .bob)
let enemy = Enemy(characterType: .charlie)
let standingEnemy = Enemy(characterType: .charlie)


let e1 = TilePosition(x: 2, y: 2)
let e2 = TilePosition(x: 2, y: 3)
let e3 = TilePosition(x: 2, y: 4)

let walkingRoute = [e1, e2, e3]

enemy.addWalkingRoute(walkingRoute)

scene.level = level
scene.setCharacter(player, on: TilePosition(x: 0, y: 0))
scene.setCharacter(partner, on: TilePosition(x: 4, y: 5))
scene.setCharacter(enemy, on: e1)
scene.setCharacter(standingEnemy, on: TilePosition(x: 4, y: 0))

PlaygroundPage.current.liveView = view




