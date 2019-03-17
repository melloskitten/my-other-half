import PlaygroundSupport
// TODO: Remove me!
import SpriteKit

//:  ![A picture of mom, dad and their son Jack.](mom_dad_child.png)


public func momDadChild() -> SKView {

    let view = Setup.getStandardBGViewAndScene()
    if let scene = view.scene as? GameScene {
        // TODO: Create proper level here!
        let size = LevelSize(width: 7, height: 7)
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
        
        let player = Player(characterType: .dad)
        let partner = Partner(characterType: .mom)
        let enemy = Enemy(characterType: .crabbo)
        let standingEnemy = Enemy(characterType: .crabbolino)
        
        
        
        let e1 = TilePosition(x: 2, y: 2)
        let e2 = TilePosition(x: 2, y: 3)
        let e3 = TilePosition(x: 2, y: 4)
        
        let walkingRoute = [e1, e2, e3]
        
        enemy.addWalkingRoute(walkingRoute)
        
        scene.setLevel(level)
        scene.setCharacter(player, on: TilePosition(x: 0, y: 0))
        scene.setCharacter(partner, on: TilePosition(x: 4, y: 5))
        scene.setCharacter(enemy, on: e1)
        scene.setCharacter(standingEnemy, on: TilePosition(x: 4, y: 0))
    }
    
    
    return view
}


PlaygroundPage.current.liveView = momDadChild()




