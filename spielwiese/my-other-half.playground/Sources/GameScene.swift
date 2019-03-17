import Foundation

import Cocoa
import SpriteKit
import PlaygroundSupport

public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var level: Level?
    var player: Player?
    var partner: Partner?
    var partnerMode: PartnerMode = .opposite
    var enemies = [Enemy]()
    var finishScreen: SKSpriteNode?
    
    public override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
    }
    
    public func setLevel(_ level: Level) {
        self.level = level
    }
    
    public func turnOnBuildMode() {
        if let level = level {
            level.tiles.forEach { (tiles) in
                tiles.forEach({ (tile) in
                    tile.drawBorder(color: .gray, width: 2.0)
                })
            }
        }
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
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
            if let character = contact.bodyA.node as? Character,
                let enemy = contact.bodyB.node as? Enemy {
                if character.tilePosition == enemy.tilePosition {
                    endGame(withSuccess: false)
                }
            }

        }
        
        if (contact.bodyA.node is Player &&
            contact.bodyB.node is RequiredToStandOnTile) || ((contact.bodyB.node is Player &&
                contact.bodyA.node is RequiredToStandOnTile)) {
            // Check if the partner is in the same position
            if partner?.tilePosition == player?.tilePosition {
                endGame(withSuccess: true)
                return
            }
        } else {
            
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
        
    }
    
    public override func keyDown(with event: NSEvent) {
        
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
        
        // Remove any potential finishScreen.
        finishScreen?.removeFromParent()
        
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
        
        switch withSuccess {
        case true:
            finishScreen = SKSpriteNode(imageNamed: SUCCESS_SCREEN)
            
        case false:
            finishScreen = SKSpriteNode(imageNamed: FAILURE_SCREEN)
        }
        
        finishScreen?.position = CGPoint(x: 350, y: 400)
        finishScreen?.zPosition = 100000000
        self.addChild(finishScreen!)
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
            character.tilePosition = tilePosition
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
    
    public func setCharacter(_ character: Character, on tilePosition: TilePosition) {
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
