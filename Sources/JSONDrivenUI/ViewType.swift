//
//  ViewType.swift
//  
//
//  Created by Enes Karaosman on 27.11.2020.
//

import Foundation

internal enum ViewType: String, Codable {
    case Image      = "Image"
    case Timer      = "Timer"
    case Text       = "Text"
    case HStack     = "HStack"
    case VStack     = "VStack"
    case ZStack     = "ZStack"
    case Rectangle  = "Rectangle"
    case Circle     = "Circle"
    case Spacer     = "Spacer"
    case Divider    = "Divider"
    case List       = "List"
    case ScrollView = "ScrollView"
    case Chart      = "Chart"
    case Color      = "Color"
    case LinearGradient      = "LinearGradient"
    case Link       = "Link"
}
