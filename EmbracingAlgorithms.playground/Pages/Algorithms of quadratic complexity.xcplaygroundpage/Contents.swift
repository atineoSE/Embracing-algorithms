
/*:
 ## Algorithms of quadratic complexity
 
 There a bunch of other algorithms operating on shapes, namely:
 */


import Foundation

extension Canvas {
    mutating func bringToFront() {
        var i = 0, j = 0
        while i < shapes.count {
            if shapes[i].isSelected {
                let selected = shapes.remove(at: i)
                shapes.insert(selected, at: j)
                j += 1
            }
            i += 1
        }
    }
    
    mutating func sendToBack() {
        var i = 0, j = shapes.count
        while i < j {
            if shapes[i].isSelected {
                let selected = shapes.remove(at: i)
                shapes.append(selected)
                j -= 1
            } else {
                i += 1
            }
        }
    }
    
    mutating func sendBackward() {
        for i in shapes.indices.reversed()
            where shapes[i].isSelected {
                var insertionPoint = i + 1
                if insertionPoint == shapes.count { return }
                for j in (0...i).reversed()
                    where shapes[j].isSelected {
                        let x = shapes.remove(at: j)
                        shapes.insert(x, at: insertionPoint)
                        insertionPoint -= 1
                }
                return
        }
    }

    mutating func bringForward() {
        for i in shapes.indices
            where shapes[i].isSelected {
            if i == 0 { return }
            var insertionPoint = i - 1
            for j in i..<shapes.count
                where shapes[j].isSelected {
                let x = shapes.remove(at: j)
                shapes.insert(x, at: insertionPoint)
                insertionPoint += 1
            }
                return
        }
    }
    
    mutating func gatherSelected(at target: Int) {
        var shapesToInsert: [Shape] = []
        var insertionPoint = target
        var i = 0
        
        while i < insertionPoint {
            if shapes[i].isSelected {
                let x = shapes.remove(at: i)
                shapesToInsert.append(x)
                insertionPoint -= 1
            } else {
                i += 1
            }
        }
        
        while i < shapes.count {
            if shapes[i].isSelected {
                let x = shapes.remove(at: i)
                shapesToInsert.append(x)
            } else {
                i += 1
            }
        }
        
        shapes.insert(contentsOf: shapesToInsert, at: insertionPoint)
    }
}

print("Bring to front")
var c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.bringToFront()
print(c.shapes)
print("\n")

print("Send to back")
c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.sendToBack()
print(c.shapes)
print("\n")

print("Send backward")
c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.sendBackward()
print(c.shapes)
print("\n")

print("Bring forward")
c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.bringForward()
print(c.shapes)
print("\n")

print("Gather selected at index 2")
c = getSampleCanvas(selected: [2, 3, 6, 7])
print(c.shapes)
c.gatherSelected(at: 2)
print(c.shapes)
print("\n")

/*:
 
 All these algorithms have the same approach as the original one in `deleteSelection()`, which means they are all `O(n^2)`.
 
 Let's see next how we can improve this.
 
 [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
 */
