import Cocoa
import SpriteKit
import PlaygroundSupport


/// Public API for accessing specific characters
/// from the playground.
///
/// - mom: Mom from first level.
/// - dad: Dad from first level.
/// - son: Son/Child from first level.
/// - groomBob: Groom bob from second level.
/// - brideAlice: Bride Alice from second level.
/// - brideCarla: Bride Carla from second level.
/// - brideDalia: Bride Carla from second level.
/// - catto: Cat from last level.
/// - doggo: Dog from last level.
/// - crabbo & crabbolino: default enemy characters.
public enum CharacterType {
    case mom
    case dad
    case son
    case groomBob
    case brideAlice
    case brideCarla
    case brideDalia
    case catto
    case doggo
    case crabbo
    case crabbolino
}
