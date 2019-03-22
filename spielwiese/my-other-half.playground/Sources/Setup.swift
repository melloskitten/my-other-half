import Foundation
import SpriteKit

/// Class that sets up all the levels and returns corresponding
/// SKView object that can be input into the scene.
public class Setup {
    
    /// Creates the standard bg and setup for a regular game scene.
    public static func getStandardBGViewAndScene() -> SKView {
        let view = SKView(frame: NSRect(x: 0,
                                        y: 0,
                                        width: OpenConstants.GAME_SCENE_SIZE.width,
                                        height: OpenConstants.GAME_SCENE_SIZE.height))
        
        let scene = GameScene(size: OpenConstants.GAME_SCENE_SIZE)
        
        // Add the standard background image.
        let backgroundImage = SKSpriteNode(imageNamed: "bg.png")
        backgroundImage.texture?.filteringMode = .nearest
        backgroundImage.zPosition = -10000
        backgroundImage.position = CGPoint(x: backgroundImage.frame.width/2 ,
                                           y: backgroundImage.frame.height/2)
        scene.addChild(backgroundImage)
        
        // Add the background for the tiles to walk on.
        let color = NSColor(red:0.98, green:0.86, blue:0.81, alpha:1.0)
        let frame = SKSpriteNode(color: color, size: CGSize(width: 7*OpenConstants.DEFAULT_TILE_SIZE.width + 20,
                                                            height: 7*OpenConstants.DEFAULT_TILE_SIZE.width + 20))
        frame.position = CGPoint(x: 334 + 19,
                                 y: frame.size.height/2 + 50)
        scene.addChild(frame)
        view.presentScene(scene)
        return view
    }
    
    /// Returns the SKView for the intro scene with the logo.
    public static func introScene() -> SKView {
        let introView = SKView(frame: NSRect(x: 0,
                                             y: 0,
                                             width: OpenConstants.INTRO_SCREEN_SIZE.width,
                                             height: OpenConstants.INTRO_SCREEN_SIZE.height))
        
        let scene = SKScene(size: OpenConstants.INTRO_SCREEN_SIZE)
        let node = SKSpriteNode(imageNamed: "bg-logo.png")
        node.texture?.filteringMode = .nearest
        node.position = CGPoint(x: node.frame.width/2 , y: node.frame.height/2)
        scene.addChild(node)
        introView.presentScene(scene)
        return introView
    }
    
    public static func firstLevel(_ character: CharacterType) -> SKView {
        let view = Setup.getStandardBGViewAndScene()
        if let scene = view.scene as? GameScene {
            let size = LevelSize(width: 7, height: 7)
            let level = Level(size: size, scene: scene)
            level.setTile(type: .blocked, on: TilePosition(x: 4, y: 4))
            level.setTile(type: .blocked, on: TilePosition(x: 3, y: 2))
            level.setTile(type: .blocked, on: TilePosition(x: 2, y: 6))
            
            let player = Player(characterType: .son)
            let partner = Partner(characterType: character)
            let enemy = Enemy(characterType: .crabbo)
            let standingEnemy = Enemy(characterType: .crabbolino)

            let e1 = TilePosition(x: 2, y: 2)
            let e2 = TilePosition(x: 2, y: 3)
            let e3 = TilePosition(x: 2, y: 4)
            let e4 = TilePosition(x: 2, y: 5)
            let walkingRoute = [e1, e2, e3, e4]
            
            enemy.addWalkingRoute(walkingRoute)
            
            scene.setLevel(level)
            scene.setCharacter(player, on: TilePosition(x: 0, y: 0))
            scene.setCharacter(partner, on: TilePosition(x: 6, y: 6))
            scene.setCharacter(enemy, on: e1)
            scene.setCharacter(standingEnemy, on: TilePosition(x: 4, y: 0))
        }
        
        return view
    }
    
    public static func secondLevel(_ partnerA: CharacterType, _ partnerB: CharacterType) -> SKView {
        
        let view = Setup.getStandardBGViewAndScene()
        if let scene = view.scene as? GameScene {

            let size = LevelSize(width: 7, height: 7)
            let level = Level(size: size, scene: scene)

            level.setTile(type: .requiredToStandOn, on: TilePosition(x: 3, y: 5))
            level.setTile(type: .switchToSyncMode, on: .init(x: 3, y: 3))
            level.setTile(type: .switchToOppositeMode, on: .init(x: 6, y: 1))
            level.setTile(type: .blocked, on: TilePosition(x: 3, y: 4))
            
            let player = Player(characterType: partnerA)
            let partner = Partner(characterType: partnerB)
            let enemy = Enemy(characterType: .crabbo)
            let standingEnemy = Enemy(characterType: .crabbolino)
            
            let e1 = TilePosition(x: 2, y: 2)
            let e2 = TilePosition(x: 2, y: 3)
            let e3 = TilePosition(x: 2, y: 4)
            let e4 = TilePosition(x: 2, y: 5)
            let walkingRoute = [e1, e2, e3, e4]
            
            let e5 = TilePosition(x: 4, y: 5)
            let e6 = TilePosition(x: 5, y: 5)
            let newWalkingRoute = [e5, e6]
            
            let filipsEnemy = Enemy(characterType: .crabbo)
            filipsEnemy.addWalkingRoute(newWalkingRoute)
            enemy.addWalkingRoute(walkingRoute)
            
            scene.setLevel(level)
            scene.setCharacter(player, on: TilePosition(x: 0, y: 0))
            scene.setCharacter(partner, on: TilePosition(x: 6, y: 6))
            scene.setCharacter(enemy, on: e1)
            scene.setCharacter(standingEnemy, on: TilePosition(x: 4, y: 0))
            scene.setCharacter(filipsEnemy, on: e5)
        }
        
        return view
    }
    
}
