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
    let lineChartVpHeightPercent: CGFloat

    private let internalStyle: ChartStyle

    init(style: Style?, data: [Double]?, backgroundColor: Color?, foregroundColor: Color?, lineChartVpHeightPercent: Double?) {
        self.style = style ?? .line
        self.data = data ?? []
        self.internalStyle = ChartStyle(
            backgroundColor: backgroundColor ?? Color.white.opacity(0),
            foregroundColor: [ColorGradient(foregroundColor ?? Color.black, foregroundColor ?? Color.black)])
        self.lineChartVpHeightPercent = lineChartVpHeightPercent != nil ? CGFloat(lineChartVpHeightPercent!) : 1.0
    }

    var body: some View {
        switch style {
        case .line:
            LineChart(vpHeightPercent: lineChartVpHeightPercent).data(data).chartStyle(internalStyle).allowsHitTesting(false)
        case .bar:
            BarChart().data(data).chartStyle(internalStyle).allowsHitTesting(false)
        }
    }
}
