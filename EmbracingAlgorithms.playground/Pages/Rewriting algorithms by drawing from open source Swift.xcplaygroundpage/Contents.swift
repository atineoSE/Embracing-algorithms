/*:
## Rewriting algorithms by drawing from open source Swift
 
 How could we express the operations on shapes by using functions in the standard library?
 
 We can start by describing in plain words what they do, rather than being fixated on implementation details.
 
 For instance, if we consider the function `bringToFront()`, we can add the comment as follows:
 
 */

/// Moves the selected shapes to the front, maintaining their relative order.

/*:
 This is helpful because it allows us to think about the problem with a new perspective. If we consider that we want to bring elements of a collection to the front, we can express the problem using a partition, between elements selected (which come to the front) and non-selected elements (which go to the back).
 
 Now, the non-selected elements need to keep their relative order, so this is no longer a `halfStablePartition` operation but a `stablePartition` operation. Luckily, we can pull an implementation from the Swift public repo, just as we did for `halfStablePartition`.
 
 We can write the algorithm as follows:
 */

import Foundation

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
 Let us consider now `bringForward()`. We can again express the operation by arranging selected elements in a partition, this time partitioning an slice of the array, starting at the position right before the first selected element.
 */

extension Canvas {
    mutating func bringForward() {
        if let i = shapes.firstIndex(where: { $0.isSelected }) {
            if i == 0 { return }
            let predecessor = i - 1
            shapes[predecessor...].stablePartition(isSuffixElement: { !$0.isSelected })
        }
    }
}

print("Bring forward (from canvas extension)")
c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.bringForward()
print(c.shapes)
print("\n")


/*:
 So far so good, we are rewriting our algorithms to be `O(N)` rather than `O(Nˆ2)`, by leveraring functions in the Swift repo.
 
 We can do better though. Let's see how next.
 
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */
