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

extension MutableCollection {
    
    // stablePartition(isSuffixElement:) can be found here: https://github.com/apple/swift/blob/df2307e035b02fc5828adbd6847e7fa3a5976366/test/Prototypes/Algorithms.swift#L537
    
    /// Moves all elements satisfying `isSuffixElement` into a suffix of the
    /// collection, preserving their relative order, and returns the start of the
    /// resulting suffix.
    ///
    /// - Complexity: O(n) where n is the number of elements.
    @discardableResult
    public mutating func stablePartition(
        isSuffixElement: (Element) throws -> Bool
        ) rethrows -> Index {
        return try stablePartition(count: count, isSuffixElement: isSuffixElement)
    }
    
    /// Moves all elements satisfying `isSuffixElement` into a suffix of the
    /// collection, preserving their relative order, and returns the start of the
    /// resulting suffix.
    ///
    /// - Complexity: O(n) where n is the number of elements.
    /// - Precondition: `n == self.count`
    public mutating func stablePartition(
        count n: Int, isSuffixElement: (Element) throws-> Bool
        ) rethrows -> Index {
        if n == 0 { return startIndex }
        if n == 1 {
            return try isSuffixElement(self[startIndex]) ? startIndex : endIndex
        }
        let h = n / 2, i = index(startIndex, offsetBy: h)
        let j = try self[..<i].stablePartition(
            count: h, isSuffixElement: isSuffixElement)
        let k = try self[i...].stablePartition(
            count: n - h, isSuffixElement: isSuffixElement)
        return self[j..<k].rotate(shiftingToStart: i)
    }
    
    // rotate(shiftingToStart:) can be found here: https://github.com/apple/swift/blob/df2307e035b02fc5828adbd6847e7fa3a5976366/test/Prototypes/Algorithms.swift#L98
    
    /// Rotates the elements of the collection so that the element
    /// at `middle` ends up first.
    ///
    /// - Returns: The new index of the element that was first
    ///   pre-rotation.
    /// - Complexity: O(*n*)
    @discardableResult
    fileprivate mutating func rotate(shiftingToStart middle: Index) -> Index {
        var m = middle, s = startIndex
        let e = endIndex
        
        // Handle the trivial cases
        if s == m { return e }
        if m == e { return s }
        
        // We have two regions of possibly-unequal length that need to be
        // exchanged.  The return value of this method is going to be the
        // position following that of the element that is currently last
        // (element j).
        //
        //   [a b c d e f g|h i j]   or   [a b c|d e f g h i j]
        //   ^             ^     ^        ^     ^             ^
        //   s             m     e        s     m             e
        //
        var ret = e // start with a known incorrect result.
        while true {
            // Exchange the leading elements of each region (up to the
            // length of the shorter region).
            //
            //   [a b c d e f g|h i j]   or   [a b c|d e f g h i j]
            //    ^^^^^         ^^^^^          ^^^^^ ^^^^^
            //   [h i j d e f g|a b c]   or   [d e f|a b c g h i j]
            //   ^     ^       ^     ^         ^    ^     ^       ^
            //   s    s1       m    m1/e       s   s1/m   m1      e
            //
            let (s1, m1) = _swapNonemptySubrangePrefixes(s..<m, m..<e)
            
            if m1 == e {
                // Left-hand case: we have moved element j into position.  if
                // we haven't already, we can capture the return value which
                // is in s1.
                //
                // Note: the STL breaks the loop into two just to avoid this
                // comparison once the return value is known.  I'm not sure
                // it's a worthwhile optimization, though.
                if ret == e { ret = s1 }
                
                // If both regions were the same size, we're done.
                if s1 == m { break }
            }
            
            // Now we have a smaller problem that is also a rotation, so we
            // can adjust our bounds and repeat.
            //
            //    h i j[d e f g|a b c]   or    d e f[a b c|g h i j]
            //         ^       ^     ^              ^     ^       ^
            //         s       m     e              s     m       e
            s = s1
            if s == m { m = m1 }
        }
        
        return ret
    }
    
    /// Swaps the elements of the two given subranges, up to the upper bound of
    /// the smaller subrange. The returned indices are the ends of the two ranges
    /// that were actually swapped.
    ///
    ///     Input:
    ///     [a b c d e f g h i j k l m n o p]
    ///      ^^^^^^^         ^^^^^^^^^^^^^
    ///      lhs             rhs
    ///
    ///     Output:
    ///     [i j k l e f g h a b c d m n o p]
    ///             ^               ^
    ///             p               q
    ///
    /// - Precondition: !lhs.isEmpty && !rhs.isEmpty
    /// - Postcondition: For returned indices `(p, q)`:
    ///   - distance(from: lhs.lowerBound, to: p) ==
    ///       distance(from: rhs.lowerBound, to: q)
    ///   - p == lhs.upperBound || q == rhs.upperBound
    @inline(__always)
    internal mutating func _swapNonemptySubrangePrefixes(
        _ lhs: Range<Index>, _ rhs: Range<Index>
        ) -> (Index, Index) {
        assert(!lhs.isEmpty)
        assert(!rhs.isEmpty)
        
        var p = lhs.lowerBound
        var q = rhs.lowerBound
        repeat {
            swapAt(p, q)
            formIndex(after: &p)
            formIndex(after: &q)
        }
            while p != lhs.upperBound && q != rhs.upperBound
        return (p, q)
    }
}

