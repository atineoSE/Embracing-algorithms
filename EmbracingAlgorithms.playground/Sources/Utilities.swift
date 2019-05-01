import Foundation

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
