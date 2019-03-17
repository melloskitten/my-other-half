//: [Previous](@previous)
import Foundation
import Cocoa
import PlaygroundSupport
import SpriteKit

let introView = SKView(frame: NSRect(x: 0, y: 0, width: OpenConstants.INTRO_SCREEN_SIZE.width, height: OpenConstants.INTRO_SCREEN_SIZE.height))
let scene = SKScene(size: OpenConstants.INTRO_SCREEN_SIZE)
scene.backgroundColor = .red
let node = SKSpriteNode(imageNamed: "bg-logo.png")
node.texture?.filteringMode = .nearest
node.position = CGPoint(x: node.frame.width/2 , y: node.frame.height/2)



scene.addChild(node)
introView.presentScene(scene)

PlaygroundPage.current.liveView = introView

//: [Next](@next)

