import Cocoa
import SpriteKit
import PlaygroundSupport

public class OpenConstants {
    public static let GAME_SCENE_SIZE = CGSize(width: 700, height: 800)
    public static let DEFAULT_TILE_SIZE = CGSize(width: 65, height: 65)
    public static let INTRO_SCREEN_SIZE = CGSize(width: 675, height: 545)
}

// MARK: - Key constants.
let LEFT_ARROW_KEY: UInt16 = 123
let RIGHT_ARROW_KEY: UInt16 = 124
let DOWN_ARROW_KEY: UInt16 = 125
let UP_ARROW_KEY: UInt16 = 126
let RETRY_KEY: UInt16 = 15

// Screen stuff
let DEFAULT_GAME_SIZE = CGSize(width: 675, height: 800)
let INTRO_SCREEN_SIZE = CGSize(width: 675, height: 545)

// CONSTANTS:
let GAME_SCENE_SIZE = CGSize(width: 700, height: 800)
let ENEMY_CATEGORY: UInt32 = 1
let SWITCH_CATEGORY: UInt32 = 4
let BLOCKED_TILE_CATEGORY: UInt32 = 2
let SWITCH_AND_ENEMY_CATEGORY: UInt32 = 5
let SWITCH_ENEMY_BLOCKABLE_TILE_CATEGORY: UInt32 = 7
let DEFAULT_TILE_SIZE = CGSize(width: 65, height: 65)
let DEFAULT_CHARACTER_SIZE = CGSize(width: 50, height: 60)
let WALK_ANIMATION_DURATION = 0.15
let X_OFFSET: CGFloat = (GAME_SCENE_SIZE.width - 7.0 * DEFAULT_TILE_SIZE.width) / 2.0 - DEFAULT_TILE_SIZE.width / 4.0 + 20
let Y_OFFSET: CGFloat = 60

// Tile constants:
let SWITCH = "switch.png"
let SWITCHABLE_BLOCKED = "switchable_blocked.png"
let SWITCHABLE_WALKABLE = "switchable_walkable.png"
let SWITCH_SYM = "switch_partner_node_sym"
let SWITCH_OPP = "switch_partner_node_opp"
let REQUIRED_TILE = "altar.png"
let WALKABLE_TEXTURES = ["walkable_1.png", "walkable_2.png",
                         "walkable_3.png", "walkable_3.png", "walkable_2.png", "walkable_2.png", "walkable_2.png", "walkable_2.png", "walkable_2.png", "walkable_2.png", "walkable_2.png", "walkable_2.png", "walkable_2.png", "walkable_2.png"]
let BLOCKED_TEXTURES = ["blocked_1.png", "blocked_2.png",
                        "blocked_3.png", "blocked_4.png",
                        "blocked_4.png",
                        "blocked_4.png",
                        "blocked_4.png",
                        "blocked_5.png"]

// Character constants:
let MOM = "mom.png"
let DAD = "dad.png"
let SON = "son.png"
let GROOM_BOB = "groom.png"
let BRIDE_ALICE = "bride_alice.png"
let BRIDE_CARLA = "bride_carla.png"
let BRIDE_DALIA = "bride_dalia.png"
let CATTO = "catto.png"
let DOGGO = "doggo.png"
let CRABBO = "crabbo.png"
let CRABBOLINO = "crabbolino.png"

// Screen constants:
let SUCCESS_SCREEN = "success_screen.png"
let FAILURE_SCREEN = "failure_screen.png"
