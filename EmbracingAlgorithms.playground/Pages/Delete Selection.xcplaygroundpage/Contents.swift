/*:
 Consider we have a canvas with some shapes. Some shapes may be selected and we would like to perform some operations on the selected shapes, for instance, remove them.

 This seems like a good way to remove an element from this array of shapes.
 */

extension Canvas {
    mutating func deleteSelection() {
        for i in 0..<shapes.count {
            if shapes[i].isSelected {
                shapes.remove(at: i)
            }
        }
    }
}

print("Remove selected (single element)")
var c1 = getSampleCanvas(selected: [7])
print(c1.shapes)
// c1.deleteSelection()
// print(c1.shapes)

/*:
 This is buggy though, and if you run this statement you will get a `fatal error,: index out of range`.
 The reason is that we remove elements as we traverse the array, not updating the iteration bounds.
 
 Let's fix the algorithm:
 */

extension Canvas {
    mutating func deleteSelection2() {
        var i = 0
        while i < shapes.count {
            if shapes[i].isSelected {
                shapes.remove(at: i)
            }
            i += 1
        }
    }
}

c1.deleteSelection2()
print(c1.shapes)
print("\n")

/*:
 So that worked, but it's still buggy. It does not work in all cases. Consider the case of having 2 selected shapes back-to-back:
 */
print("Remove selected (two selected elements, buggy)")
c1 = getSampleCanvas(selected: [7, 8])
print(c1.shapes)
c1.deleteSelection2()
print(c1.shapes)
print("\n")

/*:
 The second selected element was not removed because we incremented the index as we removed one element, thus skipping it.
 
 We can surely fix it:
 */

extension Canvas {
    mutating func deleteSelection3() {
        var i = 0
        while i < shapes.count {
            if shapes[i].isSelected {
                shapes.remove(at: i)
            } else {
                i += 1
            }
        }
    }
}

print("Remove selected (two selected elements, works)")
c1 = getSampleCanvas(selected: [7, 8])
print(c1.shapes)
c1.deleteSelection3()
print(c1.shapes)
print("\n")

/*:
 But it starts to get messy, and it's easy to make mistakes. Surely we can write this to be simpler by reversing the traversal, so that we don't have to account for index correcting as we remove elements. By removing from the end the part of the array, the part that is not yet traversed is not affected and we don't need to do index arithmetic.
 */

extension Canvas {
    mutating func deleteSelection4() {
        for i in (0..<shapes.count).reversed() {
            if shapes[i].isSelected {
                shapes.remove(at: i)
            }
        }
    }
}

print("Remove selected with reversed traversal (two selected elements, works)")
c1 = getSampleCanvas(selected: [7, 8])
print(c1.shapes)
c1.deleteSelection4()
print(c1.shapes)
print("\n")


/*:
 The problem with this algorithm is that it has quadratic complexity, `O(N^2)`, since `remove(at:)` has `O(N)` and it's within a loop `0..<N`.
 
 We can do better by using a method already available in the Swift Standard Library like so:
 */

extension Canvas {
    mutating func deleteSelection5() {
        shapes.removeAll(where: { $0.isSelected })
    }
}

print("Remove selected with removeAll from Foundation (two selected elements, works)")
c1 = getSampleCanvas(selected: [7, 8])
print(c1.shapes)
c1.deleteSelection5()
print(c1.shapes)
print("\n")

/*:
 Not only is this algorithm more efficient at `O(N)` but it's way more readable, it is immediately obvious what it does.
 
  [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */


