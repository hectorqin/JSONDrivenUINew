//
//  Values.swift
//
//
//  Created by Enes Karaosman on 1.12.2020.
//

import Foundation
import SwiftUI

internal class Values: Codable {
    var text: String?
    var dateStyle: String?
    var imageUrl: String?
    var systemIconName: String?
    var localImageName: String?
    
    // for Color
    var hex: String?
    
    // Rectangle and Circle
    var fill: String?
    
    // for Chart
    var chartData: [Double]?
    
    // for LinearGradient
    var direction: String?
    var gradient: String?
    
    /// Link
    var url: String?
}

extension Text.DateStyle {
    static let pick: [String: Text.DateStyle] = [
        "timer": .timer,
        "date": .date,
        "time": .time,
        "offset": .offset,
        "relative": .relative,
    ]
}
