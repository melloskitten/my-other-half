//: [Previous](@previous)

import Foundation
import Cocoa
import PlaygroundSupport
import SpriteKit

let DEFAULT_GAME_SIZE = CGSize(width: 675, height: 800)
let INTRO_SCREEN_SIZE = CGSize(width: 675, height: 545)

let introView = SKView(frame: NSRect(x: 0, y: 0, width: INTRO_SCREEN_SIZE.width, height: INTRO_SCREEN_SIZE.height))
let scene = SKScene(size: INTRO_SCREEN_SIZE)
let node = SKSpriteNode(imageNamed: "bg-logo.png")
node.texture?.filteringMode = .nearest
node.position = CGPoint(x: node.frame.width/2 , y: node.frame.height/2)



scene.addChild(node)
introView.presentScene(scene)

PlaygroundPage.current.liveView = introView

//: [Next](@next)

