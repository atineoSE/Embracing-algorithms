
import Foundation

/*:
 
 ## Extending the approach to the remaining algorithms.
 
 Let's extend now the same approach to the remaining algorithms to manipulate shapes in our canvas.
 */

extension MutableCollection {
    /// Moves the selected shapes to the back, maintaining their relative order.
    ///
    /// - Complexity: O(n) where n is the length of the collection.
    mutating func sendToBack(elementsSatisfying predicate: (Element) -> Bool) {
        self.stablePartition(isSuffixElement: predicate)
    }
}
print("Send to back")
var c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.shapes.sendToBack(elementsSatisfying: { $0.isSelected })
print(c.shapes)
print("\n")

extension MutableCollection {
    /// Moves the selected shapes to the front, maintaining their relative order.
    ///
    /// - Complexity: O(n) where n is the length of the collection.
    mutating func bringToFront(elementsSatisfying predicate: (Element) -> Bool) {
        sendToBack(elementsSatisfying: {!predicate($0)})
    }
}

print("Bring to front")
c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.shapes.bringToFront(elementsSatisfying: { $0.isSelected })
print(c.shapes)
print("\n")

/*:
 Note that for `sendBackward()`, in order to follow a mirror approach to that of `bringForward()`, we must extend over `BidirectionalCollection`, which allows to traverse from the end towards the start.
 */

extension MutableCollection where Self : BidirectionalCollection {
    /// Gathers the elements satisfying `predicate` from the position following
    /// the last element satisfying `predicate`.
    ///
    /// - Complexity: O(n) where n is the length of the collection.
    mutating func sendBackward(elementsSatisfying predicate: (Element) -> Bool) {
        if let successor = indexAfterLast(where: predicate) {
            self[startIndex...successor].stablePartition(isSuffixElement: predicate)
        }
    }
}

extension BidirectionalCollection {
    /// Returns the `index` after the last one whose element satisfies `predicate`.
    ///
    /// - Complexity: O(n) where n is the length of the collection.
    func indexAfterLast(where predicate: (Element) -> Bool) -> Index? {
        return indices.last {
            let predecessor = index(before: $0)
            return predecessor != startIndex && predicate(self[predecessor])
        }
    }
}

print("Send backward")
c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.shapes.sendBackward(elementsSatisfying: {$0.isSelected})
print(c.shapes)
print("\n")

/*:
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */
