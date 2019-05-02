

import Foundation

/*:
 All those algorithms have the same approach as the original one in deleteSelection(), which means they are all O(n^2).
 
 How could we express these operations by using functions in the standard library?
 
 We can start by describing in plain words what they do, rather than being fixated on implementation details.
 
 For instance, if we consider the function bringToFront() we can add the comment as follows:
 
 */

/// Moves the selected shapes to the front, maintaining their relative order.

/*:
 This is helpful because it allows us to think about the problem with a new perspective. If we consider that we want to bring elements of a collection to the front, we can express the problem using a partition, between elements selected (which come to the front) and non-selected elements, which go to the back.
 
 We can write the algorithm as follows:
 */

extension Canvas {
    /// Moves the selected shapes to the front, maintaining their relative order.
    mutating func bringToFront() {
        shapes.stablePartition(isSuffixElement: { !$0.isSelected} )
    }
}

print("Bring to front")
var c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.bringToFront()
print(c.shapes)
print("\n")


/*:
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */
