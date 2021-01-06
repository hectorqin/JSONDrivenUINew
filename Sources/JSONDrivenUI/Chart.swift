//
//  Chart.swift
//
//
//  Created by Makito on 2020/12/16.
//

import Foundation
import SwiftUI
import SwiftUICharts

struct Chart: View {
    enum Style: String {
        case line, bar
    }

    let style: Style
    let data: [Double]
    let paddingTopPercentage: Double
    let paddingBottomPercentage: Double

    private let internalStyle: ChartStyle

    init(style: Style?, data: [Double]?, backgroundColor: Color?, foregroundColor: Color?, paddingTopPercentage: Double? = 0, paddingBottomPercentage: Double? = 0) {
        self.style = style ?? .line
        self.data = data ?? []
        self.internalStyle = ChartStyle(
            backgroundColor: backgroundColor ?? Color.white.opacity(0),
            foregroundColor: [ColorGradient(foregroundColor ?? Color.black, foregroundColor ?? Color.black)]
        )
        self.paddingTopPercentage = paddingTopPercentage ?? 0
        self.paddingBottomPercentage = paddingBottomPercentage ?? 0
    }

    var body: some View {
        switch style {
        case .line:
            LineChart(
                paddingTopPercentage: paddingTopPercentage,
                paddingBottomPercentage: paddingBottomPercentage
            ).data(data).chartStyle(internalStyle).allowsHitTesting(false)
        case .bar:
            BarChart().data(data).chartStyle(internalStyle).allowsHitTesting(false)
        }
    }
}
