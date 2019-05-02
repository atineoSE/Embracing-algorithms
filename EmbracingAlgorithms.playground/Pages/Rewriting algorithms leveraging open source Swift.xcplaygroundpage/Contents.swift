

import Foundation

/*:
 All those algorithms have the same approach as the original one in `deleteSelection()``, which means they are all `O(n^2)`.
 
 How could we express these operations by using functions in the standard library?
 
 We can start by describing in plain words what they do, rather than being fixated on implementation details.
 
 For instance, if we consider the function bringToFront() we can add the comment as follows:
 
 */

/// Moves the selected shapes to the front, maintaining their relative order.

/*:
 This is helpful because it allows us to think about the problem with a new perspective. If we consider that we want to bring elements of a collection to the front, we can express the problem using a partition, between elements selected (which come to the front) and non-selected elements, which go to the back.
 
 Now, the non-selected elements need to keep their relative order, so this is no longer a `halfStablePartition` operation but a `stablePartition` operation. Luckily, we can pull an implementation from the Swift public repo, just as we did for `halfStablePartition`.
 
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
 
 We can do better though. What do these algorithms have to do with shapes in a canvas? Nothing, actually.
 
 We can generalize these algorithms to make them reusable by extracting all the unnecessary details for the operation.
 
 Let's refactor step by step.
 */

extension Array where Element == Shape {
    mutating func bringForward() {
        if let i = firstIndex(where: { $0.isSelected }) {
            if i == 0 { return }
            let predecessor = i - 1
            self[predecessor...].stablePartition(isSuffixElement: { !$0.isSelected })
        }
    }
}

print("Bring forward (from array extension)")
c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.shapes.bringForward()
print(c.shapes)
print("\n")

/*:
 We can further extract further details by passing a predicate function to compute whether a given element belongs to a given partition like so:
 */

extension Array {
    mutating func bringForward(elementsSatisfying predicate: (Element) -> Bool) {
        if let i = firstIndex(where: predicate) {
            if i == 0 { return }
            let predecessor = i - 1
            self[predecessor...].stablePartition(isSuffixElement: { !predicate($0)})
        }
    }
}

print("Bring forward (from array extension with predicate)")
c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.shapes.bringForward(elementsSatisfying: { $0.isSelected })
print(c.shapes)
print("\n")


/*:
 Note that we have removed all dependencies with our data types, Canvas and Shape. This is now a generic algorithm working on any array.
 
 Can we generalize even more? It turns out we can, since the only requirement of this algorithm is `stablePartition` which requires a `MutableCollection`.
 
 This requires though that we treat the indices more generally, since a `MutableCollection` is not indexed by integers.
 
 We can finally write the algorithm as:
 */

extension MutableCollection {
    /// Gathers the elements satisfying `predicate` at the position preceding
    /// the first element satisfying `predicate`.
    ///
    /// - Complexity: O(n) where n is the length of the collection.
    mutating func bringForward2(elementsSatisfying predicate: (Element) -> Bool) {
        if let predecessor = indexBeforeFirst(where: predicate) {
            self[predecessor...].stablePartition(isSuffixElement: { !predicate($0)})
        }
    }
}

extension Collection {
    /// Returns the `index` before the first one whose element satisfies `predicate`.
    ///
    /// - Complexity: O(n) where n is the length of the collection.
    func indexBeforeFirst(where predicate: (Element) -> Bool) -> Index? {
        return indices.first {
            let successor = index(after: $0)
            return successor != endIndex && predicate(self[successor])
        }
    }
}

print("Bring forward (from MutableCollection extension with predicate)")
c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.shapes.bringForward2(elementsSatisfying: { $0.isSelected })
print(c.shapes)
print("\n")

/*:
 Not only is this algorithm more generic and thus reusable, but it reads more natural, since it hides away implementation details about how the collection is indexed.
 
 In that case, it is strongly advisable that we add some documentation (as above) for users of this function, since it can now be applied to a broad range of problems.
 */

/*:
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */
