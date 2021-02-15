//
//  ViewProperties.swift
//
//
//  Created by Enes Karaosman on 27.11.2020.
//

import SwiftUI
import UIKit

internal class ViewProperties: Codable {
    var font: String? = "body" // font presets
    var fontWeight: String? = "regular"
    
    var fontName: String?
    var fontSize: Double?
    var fontStyle: String?
    var fontDesign: String?
    
    var lineLimit: Int?
    
    var foregroundColor: String? = "#ffffff" // Hex
    var backgroundColor: String? = "#ffffff00" // Hex
    var borderColor: String? = "#ff0000" // Hex
    var borderWidth: Int? = 0
    var padding: String? = "0"
    var spacing: Int? = 0
    var width: Float?
    var height: Float?
    var clipContent: Bool?
    var alignment: String?
    var minLength: Float? // Spacer
    
    var cornerRadius: Float? = 0
    var opacity: Float? = 1
    
    var shadow: String?

    /// leading, center, trailing
    var horizontalAlignment: String?

    /// top, bottom, center, firstTextBaseline, lastTextBaseline
    var verticalAlignment: String?

    /// vertical, horizontal (for ScrollView)
    var axis: String?
    var showsIndicators: Bool?

    /// chart settings
    var chartStyle: String? = Chart.Style.line.rawValue
    var chartLineChartPaddingTopPercentage: Double? = 0
    var chartLineChartPaddingBottomPercentage: Double? = 0
    
    /// img
    var scaleMode: String?
    
    /// LinearGradient
    var direction: String?
    var gradient: String?
}

// ScrollView
extension SwiftUI.Axis.Set {
    static let pick: [String: SwiftUI.Axis.Set] = [
        "vertical": .vertical,
        "horizontal": .horizontal
    ]
}

// VStack
extension SwiftUI.HorizontalAlignment {
    static let pick: [String: SwiftUI.HorizontalAlignment] = [
        "leading": .leading,
        "center": .center,
        "trailing": .trailing
    ]
}

// HStack
extension SwiftUI.VerticalAlignment {
    static let pick: [String: SwiftUI.VerticalAlignment] = [
        "top": .top,
        "center": .center,
        "bottom": .bottom,
        "firstTextBaseline": .firstTextBaseline,
        "lastTextBaseline": .lastTextBaseline
    ]
}

// Frame Alignment
extension SwiftUI.Alignment {
    static let pick: [String: SwiftUI.Alignment] = [
        "top": .top,
        "center": .center,
        "bottom": .bottom,
        "leading": .leading,
        "trailing": .trailing,
        "bottomLeading": .bottomLeading,
        "bottomTrailing": .bottomTrailing,
        "topLeading": .topLeading,
        "topTrailing": .topTrailing
    ]
}

// Font
extension SwiftUI.Font {
    static let pick: [String: Font] = [
        "largeTitle": .largeTitle,
        "title": .title,
        "headline": .headline,
        "subheadline": .subheadline,
        "body": .body,
        "callout": .callout,
        "footnote": .footnote,
        "caption": .caption
    ]
}

// Font Design
extension SwiftUI.Font.Design {
    static let pick: [String: Font.Design] = [
        "default": .default,
        "monospaced": .monospaced,
        "rounded": .rounded,
        "serif": .serif,
    ]
}

// FontWeight
extension SwiftUI.Font.Weight {
    static let pick: [String: Font.Weight] = [
        "ultraLight": .ultraLight,
        "thin": .thin,
        "light": .light,
        "regular": .regular,
        "medium": .medium,
        "semibold": .semibold,
        "bold": .bold,
        "heavy": .heavy,
        "black": .black
    ]
}

extension Optional where Wrapped == Int {
    func toCGFloat() -> CGFloat? {
        guard let nonNil = self else { return nil }
        return CGFloat(nonNil)
    }
}

extension Optional where Wrapped == Float {
    func toCGFloat() -> CGFloat? {
        guard let nonNil = self else { return nil }
        return CGFloat(nonNil)
    }
}

struct UiShadow {
    var color: Color? = nil
    var x: CGFloat? = nil
    var y: CGFloat? = nil
    var blur: CGFloat? = nil
}

extension Optional where Wrapped == String {
    func toColor() -> Color? {
        guard let nonNil = self else { return nil }
        return Color(hex: nonNil)
    }
    
    func toShadow() -> UiShadow? {
        guard let shadowStr = self else { return nil }
        let shadowSegments = shadowStr.components(separatedBy: " ")
        let x = CGFloat(truncating: NumberFormatter().number(from: shadowSegments[0]) ?? 0)
        let y = CGFloat(truncating: NumberFormatter().number(from: shadowSegments[1]) ?? 0)
        let blur = CGFloat(truncating: NumberFormatter().number(from: shadowSegments[2]) ?? 0)
        
        let color = Color(hex: shadowSegments[3] ?? "#00000033")
        
        return UiShadow(color: color, x: x, y: y, blur: blur)
    }
    
    func toDirection() -> (from: UnitPoint, to: UnitPoint)? {
        guard let directionStr = self else { return nil }
        switch directionStr {
        case "to bottom":
            return (from: .top, to: .bottom)
        case "to bottom right":
            return (from: .topLeading, to: .bottomTrailing)
        case "to bottom left":
            return (from: .topTrailing, to: .bottomLeading)
        case "to top":
            return (from: .bottom, to: .top)
        case "to top right":
            return(from: .bottomLeading, to: .topTrailing)
        case "to top left":
            return (from: .bottomTrailing, to: .topLeading)
        case "to left":
            return (from: .trailing, to: .leading)
        case "to right":
            return (from: .leading, to: .trailing)
        default:
            let directionSegments = directionStr.components(separatedBy: " ")
            if directionSegments.count == 2 {
                if directionSegments[0].contains(",") && directionSegments[1].contains(",") {
                    let points = directionSegments.map({ directionSegment -> UnitPoint in
                        let pointXYStrings = directionSegment.components(separatedBy: ",")
                        let x = CGFloat(truncating: NumberFormatter().number(from: pointXYStrings[0]) ?? 0)
                        let y = CGFloat(truncating: NumberFormatter().number(from: pointXYStrings[1]) ?? 0)
                        return UnitPoint(x:x, y: y)
                    })
                    return (from: points[0], to: points[1])
                }
            }
            return (from: .top, to: .bottom)
        }
    }
    
    func toGradient() -> Gradient? {
        guard let gradientStr = self else { return nil }
        let gradientSegments = gradientStr.components(separatedBy: ",")
        var gradientStops: [(color: Color, location: CGFloat?)] = []
        for c in gradientSegments {
            let color = c.trimmingCharacters(in: .whitespacesAndNewlines)
            let colorSeg = color.components(separatedBy: " ")
            if colorSeg.count > 1 {
                gradientStops.append((color: Color(hex: colorSeg[0]), location: CGFloat(truncating: NumberFormatter().number(from: colorSeg[1]) ?? 0)))
            } else {
                gradientStops.append((color: Color(hex: colorSeg[0]), location: nil))
            }
        }
        let useColorsRatherThanStops = gradientStops.contains { stop in
            if stop.location == nil {
                return true
            }
            return false
        }
        if useColorsRatherThanStops {
            return Gradient(colors: gradientStops.map({ stop in
                return stop.color
            }))
        }
        return Gradient(stops:gradientStops.map({ stop in
            return Gradient.Stop.init(color: stop.color, location: stop.location!)
        }))
    }
    
    func toPaddingEdgeInsets() -> EdgeInsets? {
        guard let paddingStr = self else { return nil }
        var edgeInsets = [CGFloat]()
        let paddingStars = paddingStr.components(separatedBy: " ")
        for p in paddingStars {
            if let n = NumberFormatter().number(from: p) {
                edgeInsets.append(CGFloat(truncating: n))
            }
        }
        
        switch (edgeInsets.count) {
        case 0:
            return nil
        case 1:
            return EdgeInsets(top: edgeInsets[0], leading: edgeInsets[0], bottom: edgeInsets[0], trailing: edgeInsets[0])
        case 2:
            return EdgeInsets(top: edgeInsets[0], leading: edgeInsets[1], bottom: edgeInsets[0], trailing: edgeInsets[1])
        case 3:
            return EdgeInsets(top: edgeInsets[0], leading: edgeInsets[1], bottom: edgeInsets[2], trailing: edgeInsets[1])
        default:
            return EdgeInsets(top: edgeInsets[0], leading: edgeInsets[3], bottom: edgeInsets[2], trailing: edgeInsets[1])
        }
    }
}
