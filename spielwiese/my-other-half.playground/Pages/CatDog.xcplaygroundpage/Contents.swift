import PlaygroundSupport
import SpriteKit


/*:
 
 ## Catto and Doggo
 
 ![A picture of Doggo and Catto.](catto_and_doggo.png)

 Always remember: __love knows no boundaries__. ❤️🧡💛💚💙💜
 
 Catto and Doggo might come from a completely different background, species, even, but that does not mean that they can't love each other! As long as you and your loved one accept each other as you are, you can go through thick and thin, no matter what!
 
 ## How To
 - ‼️ This time, you can make your creativity flow! Build your own level and try it out. Feel free to play the already existing level or modify it, just look at the code below for more ideas and explanations.
 - ‼️ Remember: The game field has a 7 x 7 grid that that starts counting at 0 in the lower left hand corner, while the x axis increases from left to right and the y axis increases from down to up. This means, if you want to address the lower left field, you would use `TilePosition(x: 0, y: 0)` and if you would like to address the field in the top right hand corner, you would use `TilePosition(x: 6, y: 6)`.

 ## Level Generator
 Check out the comments below and see where you can add new tiles and change characters.
 - If you want to see a grid around the tiles, please change `buildMode = false` to `buildMode = true`
 */

let buildMode = false

/*:
 
 - For all other options, please check out the comments in the method `personalLevel()` below.
 */

public func personalLevel() -> SKView {
    
    let view = Setup.getStandardBGViewAndScene()
    if let scene = view.scene as? GameScene {
        let size = LevelSize(width: 7, height: 7)
        let level = Level(size: size, scene: scene, buildMode: buildMode)
        
        // You can set blocked tiles in the following way:
        // This sets a tile such as a bush, puddle, or rock on on position 4,4.
        level.setTile(type: .blocked, on: .init(x: 4, y: 4))

        // You can set switching tiles in the following way:
        // This is a tile that lets your characters walk in sync.
        level.setTile(type: .switchToSyncMode, on: .init(x: 0, y: 3))
        
        // This is a tile that lets your characters walk in the opposite way.
        level.setTile(type: .switchToOppositeMode, on: .init(x: 0, y: 6))
        
        // Then, make sure to integrate the level into your scene.
        scene.setLevel(level)
        
        // Here you can define your player.
        // You have to place your player on a field.
        let player = Player(characterType: .catto)
        scene.setCharacter(player, on: TilePosition(x: 0, y: 0))
        
        // Here you can define your partner.
        // You have to place your partner on another field.
        let partner = Partner(characterType: .doggo)
        scene.setCharacter(partner, on: TilePosition(x: 6, y: 6))
        
        // Here you can set up enemies. This is an enemy that stands only
        // on one tile.
        let standingEnemy = Enemy(characterType: .crabbo)
        scene.setCharacter(standingEnemy, on: TilePosition(x: 4, y: 0))
        
        // This is an enemy that walks a route.
        let walkingEnemy = Enemy(characterType: .crabbolino)
        
        // Define his walking route.
        let e1 = TilePosition(x: 2, y: 2)
        let e2 = TilePosition(x: 2, y: 3)
        let walkingRoute = [e1, e2]

        // Add it to the walking route of the enemy and put it on the first
        // tile of its walking route.
        walkingEnemy.addWalkingRoute(walkingRoute)
        scene.setCharacter(walkingEnemy, on: e1)
    }
    
    return view
}



PlaygroundPage.current.liveView = personalLevel()
