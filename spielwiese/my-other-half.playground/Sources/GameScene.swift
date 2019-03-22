import Foundation
import Cocoa
import SpriteKit
import PlaygroundSupport

/// This class contains the level, player and partner object
/// and manages the lifecycle of the game.
public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /// Level including tiles for this game.
    var level: Level?
    
    /// Your player character.
    var player: Player?
    
    /// Your partner character.
    var partner: Partner?
    
    /// The mode in which your partner is moving.
    /// Always initialised to .opposite in the beginning.
    var partnerMode: PartnerMode = .opposite
    
    /// Holds all enemies for the current scene.
    /// Needed for moving the enemies around based on each
    /// of the player's steps.
    var enemies = [Enemy]()
    
    /// Finishing screen, both for success and failure.
    var finishScreen: SKSpriteNode?
    
    public override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
    }
    
    
    /// Set the level for the current game session.
    ///
    /// - Parameter level: your newly created level.
    public func setLevel(_ level: Level) {
        self.level = level
    }
    
    
    /// Enables or disables the buildmode for the current game scene.
    /// in build mode, all tiles have a border around them to
    /// easily distinguish them.
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
        
        // In case you're standing on a blocked tile by accident,
        // end the game. This should usually not happen unless you
        // add switch tiles into the game.
        if let _ = contact.bodyA.node as? BlockedTile, let character = contact.bodyB.node as? Character {
            if character is Player || character is Partner {
                endGame(withSuccess: false)
                return
            }
        }
        
        // If you or your partner walk onto a switch partner
        // tile, reset the partnermode.
        if let switchPartnerModeTile = contact.bodyA.node as? SwitchPartnerModeTile {
            if (contact.bodyB.node is Partner || contact.bodyB.node is Player) {
                partnerMode = switchPartnerModeTile.partnerMode!
                return
            }
        }
        
        // Check whether partner or player object ran into an
        // enemy.
        if (contact.bodyA.node is Player || contact.bodyA.node is Partner)
            && (contact.bodyB.node is Enemy) {
            if let character = contact.bodyA.node as? Character,
                let enemy = contact.bodyB.node as? Enemy {
                if character.tilePosition == enemy.tilePosition {
                    endGame(withSuccess: false)
                }
            }

        }
        
        // Check if player and partner are located on the same
        // tile and if its in the required to stand on tile.
        if (contact.bodyA.node is Player &&
            contact.bodyB.node is RequiredToStandOnTile) || ((contact.bodyB.node is Player &&
                contact.bodyA.node is RequiredToStandOnTile)) {
            // Check if the partner is in the same position.
            if partner?.tilePosition == player?.tilePosition {
                endGame(withSuccess: true)
                return
            }
        } else {
            
            if (contact.bodyA.node is Player && contact.bodyB.node is Partner)
                || (contact.bodyA.node is Partner && contact.bodyB.node is Player) {
                
                // If the level needs a required field
                // to finish on, make sure to check that
                // as well as its needed for the
                // ending of the level.
                
                if ((level?.requiresStandOnField)!) {
                    if let player = contact.bodyA.node as? Character {
                        if let tile = level?.getTile(at: player.tilePosition!) {
                            if tile is RequiredToStandOnTile {
                                endGame(withSuccess: true)
                                return
                            }
                        }
                    }
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
            case RETRY_KEY:
                retryGame()
            default:
                break
            }
            
            // Only move the character if you're not in
            // the finish screen,
            if direction != nil &&
                finishScreen == nil {
                moveSceneCharacters(inPlayerDirection: direction!)
            }
        }
    }
    
    private func moveSceneCharacters(inPlayerDirection playerDirection: Direction) {
        
        if let player = player, let partner = partner {
            
            // Move the player first.
            moveCharacter(player, inDirection: playerDirection)
            
            // Move partner depending on mode.
            var partnerDirection: Direction
        
            switch partnerMode {
            case .opposite:
                partnerDirection = playerDirection.opposite()
            case .synchronised:
                partnerDirection = playerDirection.synchronised()
            }
            
            moveCharacter(partner, inDirection: partnerDirection)

            // Move all enemies in the scene.
            moveEnemies()
            
        }
        
    }
    
    private func retryGame() {
        // Remove any potential finishScreen.
        finishScreen?.removeFromParent()
        finishScreen = nil
    
        // Reposition the player, partner and enemies.
        if let player = player, let partner = partner {
            level?.updatePosition(for: player, on: (player.initialTilePosition)!)
            level?.updatePosition(for: partner, on: (partner.initialTilePosition)!)
            partnerMode = .opposite
            
            // Reposition the enemies into their
            // initial positions. Reset the
            // current walk tile index as well as the
            // reversed mode.
            
            enemies.forEach { (enemy) in
                level?.updatePosition(for: enemy, on: enemy.initialTilePosition!)
                enemy.currentWalkTileIndex = 0
                enemy.reversed = false
            }
            
            PlaygroundPage.current.liveView = self.view
        }
        
    }
    
    /// Ends the game and shows the appropriate finishing screen.
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
    
    /// Automatically moves all enemies for each turn.
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
    
    
    /// Move a character onto the specific tile position.
    ///
    /// - Parameters:
    ///   - character: character to move.
    ///   - tilePosition: tilePosition to set it to.
    private func moveCharacter(_ character: Character, to tilePosition: TilePosition) {
        if isWalkablePosition(at: tilePosition) {
            let tile = level?.getTile(at: tilePosition)
            let moveAction = SKAction.move(to: (tile?.position)!,
                                           duration: WALK_ANIMATION_DURATION)
            character.tilePosition = tilePosition
            character.run(moveAction)
        }
    }
    
    /// Move a character in a specific direction.
    ///
    /// - Parameters:
    ///   - character: character to move.
    ///   - direction: the direction in which to move.
    private func moveCharacter(_ character: Character, inDirection direction: Direction) {
        
        // Initialize the action and potential tile position to check later.
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
    
    
    /// Checks whether the given tilePosition can be walked on.
    func isWalkablePosition(at tilePosition: TilePosition) -> Bool {
        if let tile = level?.getTile(at: tilePosition) {
            return tile.walkable
        }
        return false
    }
    
    
    /// Sets a character on a particular tilePosition.
    ///
    /// - Parameters:
    ///   - character: the character to set.
    ///   - tilePosition: the tilePosition on which to set the character.
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
