
/*:
Since Swift is open source, it means that we can actually inspect how the code in the standard library is done.
 
 So let us have a look into the implementation of removeAll(where:)
 
 */
import Foundation

extension MutableCollection where Self : RangeReplaceableCollection {
    /// Removes all elements satisfying `shouldRemove`.
    ///   ...
    /// - Complexity: O(n) where n is the number of elements.
    mutating func removeAll(where shouldRemove: (Element)->Bool) {
         let suffixStart = halfStablePartition(isSuffixElement: shouldRemove)
        removeSubrange(suffixStart...)
    }
}


/*:
 
 (Note: find the original implementation [here](https://github.com/apple/swift/blob/master/stdlib/public/core/RangeReplaceableCollection.swift#L362))

 
Note the shorthand notation for the range suffixStart..<endIndex as suffixStart...
 
halfStablePartition is an implementation detail, which we can further inspect.
 
*/

extension MutableCollection {
    /// Moves all elements satisfying `isSuffixElement` into a suffix of the collection,
    /// returning the start position of the resulting suffix.
    ///
    /// - Complexity: O(n) where n is the number of elements.
    mutating func halfStablePartition(isSuffixElement: (Element) -> Bool) -> Index {
        guard var i = firstIndex(where: isSuffixElement) else { return endIndex }
        var j = index(after: i)
        while j != endIndex {
            if !isSuffixElement(self[j]) {
                swapAt(i, j)
                formIndex(after: &i)
            }
            formIndex(after: &j)
        }
        return i
    }
}

/*:
 Let's see how the halfStablePartition(isSuffixElement:) creates the partition step by step.
 */

var c = getSampleCanvas(selected: [2, 3, 6, 7])
print("Initial array of shapes: \(c.shapes)")
let index = c.shapes.halfStablePartitionStepByStep(isSuffixElement: {$0.isSelected})
print("Start position of the suffix partition=\(index)")
print("\n")

/*:
 Once we have the partioned collection and the index for the suffix partition, we can proceed to delete based on range.
 */

c.shapes.removeSubrange(index...)
print("Resulting shapes = \(c.shapes)")
 
/*:
[< Previous](@previous)           [Home](Introduction)           [Next >](@next)
*/
