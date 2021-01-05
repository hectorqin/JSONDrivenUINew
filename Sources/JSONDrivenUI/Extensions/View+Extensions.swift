//
//  View+Extensions.swift
//  
//
//  Created by Enes Karaosman on 27.11.2020.
//

import SwiftUI

internal extension View {
    
    func embedInAnyView() -> AnyView {
        AnyView(self)
    }
    
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension View {
    @ViewBuilder func conditionalModifier<Content: View>(_ condition: Bool, _ transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    typealias ContentTransform<Content: View> = (Self) -> Content
    @ViewBuilder func conditionalModifier<TrueContent: View, FalseContent: View>( _ condition: Bool, _ ifTrue: ContentTransform<TrueContent>, _ ifFalse: ContentTransform<FalseContent>) -> some View {
        if condition {
            ifTrue(self)
        } else {
            ifFalse(self)
        }
    }
}
