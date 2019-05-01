import Foundation

public func getSwiftVersion() -> String {
    #if swift(>=5.0)
    return "5.x"
    #elseif swift(>=4.0)
    return "4.x"
    #elseif swift(>=3.0)
    return "3.x"
    #else
    return "lower than 3.0"
    #endif
}

public struct Shape {
    enum Form: String {
        case star = "*️⃣"
        case pound = "#️⃣"
        case doubleArrow = "⏩"
        case arrowRight = "➡️"
        case triangle1 = "🔼"
        case triangle2 = "▶️"
        case triangleOverLine = "⏏️"
        case square = "⏹"
        case circle = "⏺"
        case revolvingArrows = "🔄"
    }
    var form: Form
    public var isSelected: Bool = false
}

extension Shape: CustomStringConvertible {
    public var description: String {
        if !isSelected {
            return form.rawValue
        } else {
            return "(\(form.rawValue))"
        }
    }
}


public struct Canvas {
    public var shapes: [Shape]
}

public func getSampleCanvas(selected:[Int]) -> Canvas {
    var canvas = Canvas(shapes: [Shape(form: .star, isSelected: false),
                                 Shape(form: .pound, isSelected: false),
                                 Shape(form: .doubleArrow, isSelected: false),
                                 Shape(form: .arrowRight, isSelected: false),
                                 Shape(form: .triangle1, isSelected: false),
                                 Shape(form: .triangle2, isSelected: false),
                                 Shape(form: .triangleOverLine, isSelected: false),
                                 Shape(form: .square, isSelected: false),
                                 Shape(form: .circle, isSelected: false),
                                 Shape(form: .revolvingArrows, isSelected: false)])
    for (idx, _) in canvas.shapes.enumerated() {
        if selected.contains(idx) {
            canvas.shapes[idx].isSelected = true
        }
    }
    
    return canvas
}

extension MutableCollection {
    /// Moves all elements satisfying `isSuffixElement` into a suffix of the collection,
    /// returning the start position of the resulting suffix.
    ///
    /// - Complexity: O(n) where n is the number of elements.
    public mutating func halfStablePartitionStepByStep(isSuffixElement: (Element) -> Bool) -> Index {
        guard var i = firstIndex(where: isSuffixElement) else { return endIndex }
        var step = 0
        var j = index(after: i)
        while j != endIndex {
            if !isSuffixElement(self[j]) {
                swapAt(i, j)
                print("step=\(step), j=\(j), swapped for \(i): \(self)")
                formIndex(after: &i)
            } else {
                print("step=\(step), j=\(j), no swap: \(self)")
            }
            formIndex(after: &j)
            step += 1
        }
        return i
    }
}
