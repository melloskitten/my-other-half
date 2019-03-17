import Foundation
import SpriteKit

public class Setup {
    
    /// Creates the standard bg and setup for a regular game scene.
    public static func getStandardBGViewAndScene() -> SKView {
        let view = SKView(frame: NSRect(x: 0,
                                        y: 0,
                                        width: OpenConstants.GAME_SCENE_SIZE.width,
                                        height: OpenConstants.GAME_SCENE_SIZE.height))
        
        let scene = GameScene(size: OpenConstants.GAME_SCENE_SIZE)
        let backgroundImage = SKSpriteNode(imageNamed: "bg.png")
        backgroundImage.texture?.filteringMode = .nearest
        backgroundImage.zPosition = -10000
        backgroundImage.position = CGPoint(x: backgroundImage.frame.width/2 , y: backgroundImage.frame.height/2)
        scene.addChild(backgroundImage)
        
        let color = NSColor(red:0.98, green:0.86, blue:0.81, alpha:1.0)
        let frame = SKSpriteNode(color: color, size: CGSize(width: 7*OpenConstants.DEFAULT_TILE_SIZE.width + 20, height: 7*OpenConstants.DEFAULT_TILE_SIZE.width + 20))
        frame.position = CGPoint(x: 334 + 19, y: frame.size.height/2 + 50)
        scene.addChild(frame)
        view.presentScene(scene)
        return view
    }
    
    /// Returns the SKView for the intro scene with the logo.
    public static func introScene() -> SKView {
        let introView = SKView(frame: NSRect(x: 0, y: 0, width: OpenConstants.INTRO_SCREEN_SIZE.width, height: OpenConstants.INTRO_SCREEN_SIZE.height))
        let scene = SKScene(size: OpenConstants.INTRO_SCREEN_SIZE)
        scene.backgroundColor = .red
        let node = SKSpriteNode(imageNamed: "bg-logo.png")
        node.texture?.filteringMode = .nearest
        node.position = CGPoint(x: node.frame.width/2 , y: node.frame.height/2)
        scene.addChild(node)
        introView.presentScene(scene)
        return introView
    }
    
    
}
