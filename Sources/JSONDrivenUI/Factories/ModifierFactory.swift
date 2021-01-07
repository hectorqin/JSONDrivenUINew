//
//  ModifierFactory.swift
//  
//
//  Created by Enes Karaosman on 27.11.2020.
//

import SwiftUI

internal struct ModifierFactory {
    
    /// Applies Frame in case `width` & `height` is not nil.
    struct FrameModifier: ViewModifier {
        var width: CGFloat? = nil
        var height: CGFloat? = nil
        var clipContent: Bool? = false
        var alignment: Alignment? = .center

        @ViewBuilder func body(content: Content) -> some View {
            content.frame(width: width, height: height, alignment: alignment ?? .center)
                .conditionalModifier(clipContent != nil && clipContent == true, {
                    $0.clipped()
                })
        }
    }
    
    /// Applies ForegroundColor in case `foregroundColor` is not nil.
    struct ForegroundModifier: ViewModifier {
        var foregroundColor: Color?
        
        @ViewBuilder func body(content: Content) -> some View {
            if let color = foregroundColor {
                content.foregroundColor(color)
            } else {
                content
            }
        }
    }
    
    struct OpacityModifier: ViewModifier {
        var opacity: Float?
        
        @ViewBuilder func body(content: Content) -> some View {
            if let opa = opacity {
                content.opacity(Double(opa))
            } else {
                content
            }
        }
    }
    
    struct BackgroundModifier: ViewModifier {
        var backgroundColor: Color?
        
        @ViewBuilder func body(content: Content) -> some View {
            if let color = backgroundColor {
                content.background(color)
            } else {
                content
            }
        }
    }
    
    /// Applies Padding for all edges in case `padding` is not nil.
    struct PaddingModifier: ViewModifier {
        var padding: EdgeInsets?
        
        @ViewBuilder func body(content: Content) -> some View {
            if let padding = padding {
                content.padding(padding)
            } else {
                content
            }
        }
    }
    
    /// Applies Border in case `borderColor` & `borderWidth` is not nil.
    struct BorderModifier: ViewModifier {
        var borderColor: Color?
        var borderWidth: CGFloat?
        
        @ViewBuilder func body(content: Content) -> some View {
            if let borderWidth = borderWidth, let borderColor = borderColor {
                content.border(borderColor, width: borderWidth)
            } else {
                content
            }
        }
    }
    
    /// Applies Shadow in case `shadow` is not nil.
    struct ShadowModifier: ViewModifier {
        var shadow: UiShadow?
        
        @ViewBuilder func body(content: Content) -> some View {
            if let uiShadow = shadow {
                content.shadow(color: uiShadow.color!, radius: uiShadow.blur!, x: uiShadow.x!, y: uiShadow.y!)
            } else {
                content
            }
        }
    }
    
}
