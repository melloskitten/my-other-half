import PlaygroundSupport
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

PlaygroundPage.current.liveView = Setup.secondLevel(.brideAlice, .groomBob)

//: [Next](@next)



