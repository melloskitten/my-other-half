import PlaygroundSupport
// TODO: Remove me!
import SpriteKit

//:  ![A picture of Alice and Bob marrying.](alice_and_bob.png)
//:  ![A picture of Carla and Dalia marrying.](carla_and_dalia.png)



let view = SKView(frame: NSRect(x: 0, y: 0, width: 700, height: 800))
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
view.showsFPS = true

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

PlaygroundPage.current.liveView = view




