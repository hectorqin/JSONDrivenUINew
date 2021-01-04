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
        let font: Font
        if let fontSize = material.properties?.fontSize {
            let fontName = material.properties?.fontName ?? "system"
            if fontName == "system" {
                font = Font.system(size: fontSize)
            } else {
                font = Font.custom(fontName, size: fontSize)
            }
        } else {
            let fontHashValue = material.properties?.font ?? "body"
            font = Font.pick[fontHashValue]
        }
        
        let fontWeightHashValue = material.properties?.fontWeight ?? "regular"
        let fontWeight = Font.Weight.pick[fontWeightHashValue]
        Text(material.values?.text ?? "")
            .font(font)
            .fontWeight(fontWeight)
    }

    // MARK: - Timer

    @ViewBuilder func timer() -> some View {
        let fontHashValue = material.properties?.font ?? "body"
        let font = Font.pick[fontHashValue]
        let fontWeightHashValue = material.properties?.fontWeight ?? "regular"
        let fontWeight = Font.Weight.pick[fontWeightHashValue]
        Text(date ?? Date(), style: Text.DateStyle.pick[material.values?.dateStyle ?? "timer"] ?? .timer)
            .font(font)
            .fontWeight(fontWeight)
    }

    // MARK: - Image

    @ViewBuilder func image() -> some View {
        if let systemIconName = material.values?.systemIconName {
            if (material.properties?.scaleMode == "fill") {
                Image(systemName: systemIconName)
                    .resizable().scaledToFill()
            } else {
                Image(systemName: systemIconName)
                    .resizable().scaledToFit()
            }
        } else if let localIconName = material.values?.localImageName {
            if (material.properties?.scaleMode == "fill") {
                Image(localIconName)
                    .resizable().scaledToFill()
            } else {
                Image(localIconName)
                    .resizable().scaledToFit()
            }
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
              paddingBottomPercentage: material.properties?.chartLineChartPaddingBottomPercentage)
    }
    
    // MARK: - Color

    @ViewBuilder func color() -> some View {
        material.values?.hex.toColor()
            .ignoresSafeArea()
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
        case .Rectangle: Rectangle()
        case .Divider: Divider()
        case .Circle: Circle()
        default: EmptyView()
        }
    }

    @ViewBuilder func toPresentable() -> some View {
        let prop = material.properties

        let uiComponent = buildDefault().embedInAnyView()
        uiComponent
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
