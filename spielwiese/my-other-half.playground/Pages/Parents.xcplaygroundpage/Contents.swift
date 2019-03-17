import PlaygroundSupport
import SpriteKit

//: ## Jack and his Parents

//:  ![A picture of mom, dad and their son Jack.](mom_dad_child.png)

/*:
 
 This is Jack and his Mom and Dad. If you execute the playground, you can see they're enjoying a day at the beach. The main goal of this game is the following: Make Jack, who is located in the left lower half of the screen, meet his Dad, which is located on the top right hand corner of the screen. _Try to bring the two together_.
 
 ## How To

 - The love between Jack and his Dad is big - but sometimes, the urge to do the opposite of what your parents expect of you is equally big. Jack and his dad are doing _exactly  opposite moves_. This means if Jack walks to the right ➡️, Dad will walk to the left ⬅️, if Jack walks down ⬇️, Dad will walk up ⬆️.
 - Just like with every relationship, there are obstacles that can obstruct your path and make your life harder. And sometimes you're not going to jump in that lovely puddle because Dad told you not to! You cannot walk on bushes, puddles and rocks! 🌳 🌊
 - Take care of the crabs! 🦀 Crabbo and Crabbolino, two little crabs, are ready to pinch your toes if you walk on them! Sometimes they just sit in one place, and sometimes they walk back and forth in a specific pattern. Understand the pattern and it will be no problem to evade them.
 - ‼️ _You can __restart the level__ at any time by pressing the R button on your keyboard._
 

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


PlaygroundPage.current.liveView = Setup.firstLevel(.dad)

//: [Next](@next)




