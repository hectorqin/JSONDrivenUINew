//
//  ViewFactory.swift
//
//
//  Created by Enes Karaosman on 27.11.2020.
//

import SwiftUI

internal struct ViewFactory: PresentableProtocol {
    private let material: ViewMaterial
    private let date: Date?

    init(material: ViewMaterial) {
        self.material = material
        self.date = nil
    }

    init(material: ViewMaterial, date: Date?) {
        self.material = material
        self.date = date
    }
    
    func parseFont() -> Font {
        var font: Font
        if let fontSize = material.properties?.fontSize {
            let fontName = material.properties?.fontName ?? "system"
            let fontDesign = Font.Design.pick[material.properties?.fontDesign ?? "default"] ?? Font.Design.default
            let fontWight = Font.Weight.pick[material.properties?.fontWeight ?? "regular"] ?? Font.Weight.regular
            if fontName == "system" {
                font = Font.system(size: CGFloat(fontSize), weight: fontWight, design: fontDesign)
            } else {
                font = Font.custom(fontName, size: CGFloat(fontSize))
            }
        } else {
            let fontHashValue = material.properties?.font ?? "body"
            font = Font.pick[fontHashValue] ?? Font.body
        }
        if let fontStyle = material.properties?.fontStyle {
            let fontStyleSegments = fontStyle.components(separatedBy: " ")
            for style in fontStyleSegments {
                switch style {
                case "bold":
                    font = font.bold()
                case "italic":
                    font = font.italic()
                case "smallCaps":
                    font = font.smallCaps()
                case "lowercaseSmallCaps":
                    font = font.lowercaseSmallCaps()
                case "uppercaseSmallCaps":
                    font = font.uppercaseSmallCaps()
                case "monospacedDigit":
                    font = font.monospacedDigit()
                default: break
                }
            }
        }
        return font
    }

    // MARK: - ScrollView

    @ViewBuilder func scrollView() -> some View {
        if let subviews = material.subviews {
            let axisKey = material.properties?.axis ?? "vertical"
            let axis = Axis.Set.pick[axisKey] ?? .vertical
            let showsIndicators = material.properties?.showsIndicators ?? true

            ScrollView(axis, showsIndicators: showsIndicators) {
                AxisBasedStack(axis: axis) {
                    ForEach(subviews) { subview in
                        ViewFactory(material: subview).toPresentable()
                    }
                }
            }
        } else {
            Text("Please Add Subview for ScrollView")
        }
    }

    // MARK: - List

    @ViewBuilder func list() -> some View {
        if let subviews = material.subviews {
            List(subviews) {
                ViewFactory(material: $0).toPresentable()
            }
        } else {
            Text("Please Add Subview for List")
        }
    }

    // MARK: - VStack

    @ViewBuilder func vstack() -> some View {
        if let subviews = material.subviews {
            let spacing = material.properties?.spacing.toCGFloat() ?? 0
            let horizontalAlignmentKey = material.properties?.horizontalAlignment ?? "center"
            let horizontalAlignment = HorizontalAlignment.pick[horizontalAlignmentKey] ?? .center
            VStack(alignment: horizontalAlignment, spacing: spacing) {
                ForEach(subviews) {
                    ViewFactory(material: $0).toPresentable()
                }
            }
        } else {
            Text("Please Add Subview for VStack")
        }
    }

    // MARK: - HStack

    @ViewBuilder func hstack() -> some View {
        if let subviews = material.subviews {
            let spacing = material.properties?.spacing.toCGFloat() ?? 0
            let verticalAlignmentKey = material.properties?.verticalAlignment ?? "center"
            let verticalAlignment = VerticalAlignment.pick[verticalAlignmentKey] ?? .center
            HStack(alignment: verticalAlignment, spacing: spacing) {
                ForEach(subviews) {
                    ViewFactory(material: $0).toPresentable()
                }
            }
        } else {
            Text("Please Add Subview for HStack")
        }
    }

    // MARK: - ZStack

    @ViewBuilder func zstack() -> some View {
        if let subviews = material.subviews {
            ZStack {
                ForEach(subviews) {
                    ViewFactory(material: $0).toPresentable()
                }
            }
        } else {
            Text("Please Add Subview for ZStack")
        }
    }

    // MARK: - Text

    @ViewBuilder func text() -> some View {
        let font = parseFont()
        let fontWeightHashValue = material.properties?.fontWeight ?? "regular"
        let lineLimit = material.properties?.lineLimit
        let fontWeight = Font.Weight.pick[fontWeightHashValue]
        Text(material.values?.text ?? "")
            .font(font)
            .fontWeight(fontWeight)
            .conditionalModifier(lineLimit != nil, {
                $0.lineLimit(lineLimit)
            })
    }

    // MARK: - Timer

    @ViewBuilder func timer() -> some View {
        let font = parseFont()
        let fontWeightHashValue = material.properties?.fontWeight ?? "regular"
        let fontWeight = Font.Weight.pick[fontWeightHashValue]
        Text(date ?? Date(), style: Text.DateStyle.pick[material.values?.dateStyle ?? "timer"] ?? .timer)
            .font(font)
            .fontWeight(fontWeight)
    }

    // MARK: - Image

    @ViewBuilder func image() -> some View {
        if let systemIconName = material.values?.systemIconName {
            Image(systemName: systemIconName)
                .resizable()
                .conditionalModifier(material.properties?.scaleMode == "fill", {
                    $0.scaledToFill()
                }, {
                    $0.scaledToFit()
                })
            
        } else if let localIconName = material.values?.localImageName {
            Image(localIconName)
                .resizable()
                .conditionalModifier(material.properties?.scaleMode == "fill", {
                    $0.scaledToFill()
                }, {
                    $0.scaledToFit()
                })
        } else if let remoteUrl = material.values?.imageUrl {
            NetworkImage(url: URL(string: remoteUrl), mode: material.properties?.scaleMode)
        } else {
            Text("Image value could not read")
        }
    }

    // MARK: - Spacer

    @ViewBuilder func spacer() -> some View {
        let minLength = material.properties?.minLength.toCGFloat()
        Spacer(minLength: minLength)
    }

    // MARK: - Chart

    @ViewBuilder func chart() -> some View {
        Chart(style: Chart.Style(rawValue: material.properties?.chartStyle ?? ""),
              data: material.values?.chartData,
              backgroundColor: material.properties?.backgroundColor.toColor(),
              foregroundColor: material.properties?.foregroundColor.toColor(),
              paddingTopPercentage: material.properties?.chartLineChartPaddingTopPercentage,
              paddingBottomPercentage: material.properties?.chartLineChartPaddingBottomPercentage)
    }
    
    // MARK: - Color

    @ViewBuilder func color() -> some View {
        material.values?.hex.toColor()
            .ignoresSafeArea()
    }
    
    // MARK: - LinearGradient

    @ViewBuilder func lineargradient() -> some View {
        let gradient = material.values?.gradient.toGradient() ?? Gradient(colors: [Color.gray, Color.black])
        let direction = material.values?.direction.toDirection() ?? (from: .top, to: .bottom)
        LinearGradient(gradient: gradient, startPoint: direction.from, endPoint: direction.to)
            .ignoresSafeArea()
    }
    
    // MARK: - Rectangle

    @ViewBuilder func rectangle() -> some View {
        Rectangle().fill(material.values?.fill.toColor() ?? .primary)
    }
    
    // MARK: - Circle

    @ViewBuilder func circle() -> some View {
        Circle().fill(material.values?.fill.toColor() ?? .primary)
    }
    
    // MARK: - Link

    @ViewBuilder func link() -> some View {
        if let subviews = material.subviews {
            Link(destination: URL(string: material.values?.url ?? "")!) {
                ForEach(subviews) {
                    ViewFactory(material: $0).toPresentable()
                }
            }
        } else {
            Text("Please Add Subview for Link")
        }
    }

    @ViewBuilder func buildDefault() -> some View {
        switch material.type {
        case .ScrollView: scrollView()
        case .List: list()
        case .VStack: vstack()
        case .HStack: hstack()
        case .ZStack: zstack()
        case .Text: text()
        case .Timer: timer()
        case .Image: image()
        case .Spacer: spacer()
        case .Chart: chart()
        case .Color: color()
        case .LinearGradient: lineargradient()
        case .Rectangle: rectangle()
        case .Divider: Divider()
        case .Circle: circle()
        case .Link: link()
        default: EmptyView()
        }
    }

    @ViewBuilder func toPresentable() -> some View {
        let prop = material.properties

        let uiComponent = buildDefault().embedInAnyView()
        uiComponent
            .modifier(ModifierFactory.OpacityModifier(opacity: prop?.opacity))
            .modifier(ModifierFactory.CornerRadiusModifier(cornerRadius: prop?.cornerRadius))
            .modifier(ModifierFactory.PaddingModifier(padding: prop?.padding.toPaddingEdgeInsets()))
            .modifier(ModifierFactory.ForegroundModifier(foregroundColor: prop?.foregroundColor.toColor()))
            .modifier(ModifierFactory.BackgroundModifier(backgroundColor: prop?.backgroundColor.toColor()))
            .modifier(ModifierFactory.BorderModifier(
                borderColor: prop?.borderColor.toColor(),
                borderWidth: prop?.borderWidth.toCGFloat()
            ))
            .modifier(ModifierFactory.ShadowModifier(
                shadow: prop?.shadow.toShadow()
            ))
            .modifier(ModifierFactory.FrameModifier(
                width: prop?.width.toCGFloat(),
                height: prop?.height.toCGFloat(),
                clipContent: prop?.clipContent,
                alignment: Alignment.pick[prop?.alignment ?? "center"] ?? .center
            ))
    }
}
