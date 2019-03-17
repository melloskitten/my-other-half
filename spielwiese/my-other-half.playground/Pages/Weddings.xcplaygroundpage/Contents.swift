import PlaygroundSupport
// TODO: Remove me!
import SpriteKit

/*:
 
 ## Double Weddings
 
 ![A picture of Alice and Bob marrying.](alice_and_bob.png)
 
 
 Bob, Alice, Carla and Dalia are celebrating a big double wedding! Bob is marrying Alice and Carla is marrying Dalia. Both couples have went through many beautiful moments as well as facing hardships together - but they made it and are all excited to say yes 😍
 
 ![A picture of Carla and Dalia marrying.](carla_and_dalia.png)
 
 ## How To
 
 - Bring the lovers together! For this level, you have to make sure that __both of them stand on the altar__ in order to end the level. If you bring them together but they’re not standing on the altar, they’re not able to get married properly 😋
 - In a marriage, you cannot always do the opposite of what your partner is doing. If you walk on the ⬆️⬆️ tile, both you and your lover start walking in the same direction! However, you still need to stay true to yourself - so doing the opposite is okay (sometimes 😝) and you can get to this mode by walking on the ⬆️⬇️ field.

 ## Switch weddings!
 - Do you want to switch to Carla and Dalia? Just change the method below from `.brideAlice` and `.groomBob` to `.brideCarla` and `.brideDalia`.
 
 ## Hint
 
 A possible solution for the level is:
 - 1 x ⬆️
 - 1 x ➡️
 - 1 x ⬆️
 - 2 x ➡️
 - 1 x ⬆️
 - 3 x ➡️
 - 3 x ⬆️
 - 3 x ⬅️
 - 1 x ⬇️
 
 
 */

PlaygroundPage.current.liveView = secondLevel(.brideAlice, .brideDalia)

//: [Next](@next)


public func secondLevel(_ partnerA: CharacterType, _ partnerB: CharacterType) -> SKView {
    
    let view = Setup.getStandardBGViewAndScene()
    if let scene = view.scene as? GameScene {
        
        
        // TODO: Create proper level here!
        let size = LevelSize(width: 7, height: 7)
        let level = Level(size: size, scene: scene)
        // level.setTile(type: .blocked, on: TilePosition(x: 4, y: 4))
        // level.setTile(type: .blocked, on: TilePosition(x: 3, y: 2))
        // level.setTile(type: .blocked, on: TilePosition(x: 2, y: 5))
        level.setTile(type: .requiredToStandOn, on: TilePosition(x: 3, y: 5))
        // level.setTile(type: .switchToSyncMode, on: .init(x: 0, y: 3))
        // level.setTile(type: .blocked, on: .init(x: 1, y: 4))
        // level.setTile(type: .switchToSyncMode, on: .init(x: 2, y: 2))
        level.setTile(type: .switchToSyncMode, on: .init(x: 3
            , y: 3))
        level.setTile(type: .switchToOppositeMode, on: .init(x: 6
            , y: 1))
        level.setTile(type: .blocked, on: TilePosition(x: 3, y: 4))
        
        /*let switchedTiles: [TilePosition: TileType] = [ .init(x: 3, y: 5): .blocked,
         .init(x: 4, y: 3):  .walkable]
         level.setSwitchTile(on: .init(x: 2, y: 5), switchedTiles: switchedTiles)*/
        
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


