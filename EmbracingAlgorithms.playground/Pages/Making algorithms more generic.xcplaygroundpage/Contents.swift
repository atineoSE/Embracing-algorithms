/*:
 ## Making algorithms more generic

What do these algorithms have to do with shapes in a canvas? Nothing, actually.

We can generalize these algorithms to make them reusable by extracting all the unnecessary details for the operation.
    
Let's start by generalizing to arrays of shapes.
 
 
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
var c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.shapes.bringForward()
print(c.shapes)
print("\n")

/*:
 We can extract further details by passing a predicate function to compute whether a given element belongs to a given partition.
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
 Note that we have removed all dependencies from our data types, `Canvas` and `Shape`. This is now a generic algorithm working on any array.
 
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
 Not only is this algorithm more generic and thus reusable, but it reads more naturally, since it hides away implementation details about how the collection is indexed.
 
 In that case, it is strongly advisable that we add some documentation (as above) for users of this function, since it can now be applied to a broad range of problems.
 
 Let's extend now the same approach to the one particularly problematic function: `gatherSelected(at:)`.
 
 This was the original implementation.
 
 */

extension Canvas {
    mutating func gatherSelected(at target: Int) {
        var shapesToInsert: [Shape] = []
        var insertionPoint = target
        var i = 0
        
        // Extract first shape selected and keep the index
        while i < insertionPoint {
            if shapes[i].isSelected {
                let x = shapes.remove(at: i)
                shapesToInsert.append(x)
                insertionPoint -= 1
            } else {
                i += 1
            }
        }
        
        // Extract remaining selected shapes from same index
        while i < shapes.count {
            if shapes[i].isSelected {
                let x = shapes.remove(at: i)
                shapesToInsert.append(x)
            } else {
                i += 1
            }
        }
        
        // Insert gathered shapes at target
        shapes.insert(contentsOf: shapesToInsert, at: insertionPoint)
    }
}

print("Gather selected at index 2 (original implementation)")
c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.gatherSelected(at: 2)
print(c.shapes)
print("\n")

/*:
 Following the same techniche, we can rewrite it in 2 lines by using `stablePartition(isSuffixElement:)` and generalize it to work on any `MutableCollection`.
 
 */


extension MutableCollection {
    /// Gathers elements satisfying `predicate` at `target`, preserving their relative order. ///
    /// - Complexity: O(n log n) where n is the number of elements.
    mutating func gather(at target: Index, allSatisfying predicate: (Element)->Bool) {
        self[..<target].stablePartition(isSuffixElement: predicate)
        self[target...].stablePartition(isSuffixElement: { !predicate($0) })
        
    }
}

print("Gather selected at index 2 (from MutableCollection extension)")
c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.shapes.gather(at: 2, allSatisfying: {$0.isSelected})
print(c.shapes)
print("\n")

/*:
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */
