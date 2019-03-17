import PlaygroundSupport
// TODO: Remove me!
import SpriteKit

//: ## Jack and his Parents

//:  ![A picture of mom, dad and their son Jack.](mom_dad_child.png)

/*:
 
 This is Jack and his Mom and Dad. If you execute the playground, you can see they're enjoying a day at the beach. The main goal of this game is the following: Make Jack, which is located in the left lower half of the screen, meet his Dad, which is located on the top right hand corner of the screen. _Try to bring the two together_.
 
 ## How To

 - The love between Jack and his Dad are big - but sometimes, the urge to do the opposite of what your parents expect of you is equally big. Jack and his dad are doing _exactly  opposite moves_. This means if Jack walks to the right ➡️, Dad will walk to the left ⬅️, if Jack walks down ⬇️, Dad will walk up ⬆️.
 - Just like with every relationship, there are obstacles that can obstruct your path and make your life harder. And sometimes you're not going to jump in that lovely puddle because Dad told you not to! You cannot walk on bushes, puddles and rocks! 🌳 🌊
 - Take care of the crabs! 🦀 Crabbo and Crabbolino, two little crabs, are ready to pinch your toes if you walk on them! Sometimes they just sit in one place, and sometimes they walk back and forth in a specific pattern. Understand the pattern and it will be no problem to evade them.
 - ‼️ You can __restart the level__ at any time by pressing the R button on your keyboard.
 

## Mom, where are you?

 - Do you want to let Jack find his mom, too? Just change the method below from `.dad` to `.mom` 

 ## Hint
 
 A possible solution for the level is:
- 3 x ⬆️
 - 1 x ➡️
 - 1 x ⬅️
 - 1 x ➡️
 - 1 x ⬅️
 - 3 x ➡️
 
 */




public func firstLevel(_ character: CharacterType) -> SKView {

    let view = Setup.getStandardBGViewAndScene()
    if let scene = view.scene as? GameScene {
        // TODO: Create proper level here!
        let size = LevelSize(width: 7, height: 7)
        let level = Level(size: size, scene: scene)
        level.setTile(type: .blocked, on: TilePosition(x: 4, y: 4))
        level.setTile(type: .blocked, on: TilePosition(x: 3, y: 2))
        level.setTile(type: .blocked, on: TilePosition(x: 2, y: 6))
        // level.setTile(type: .requiredToStandOn, on: TilePosition(x: 3, y: 5))
        // level.setTile(type: .switchToSyncMode, on: .init(x: 0, y: 3))
        // level.setTile(type: .blocked, on: .init(x: 1, y: 4))
        // level.setTile(type: .switchToSyncMode, on: .init(x: 2, y: 2))
        
        /*let switchedTiles: [TilePosition: TileType] = [ .init(x: 3, y: 5): .blocked,
         .init(x: 4, y: 3):  .walkable]
         level.setSwitchTile(on: .init(x: 2, y: 5), switchedTiles: switchedTiles)*/
        
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





PlaygroundPage.current.liveView = firstLevel(.dad)

//: [Next](@next)




