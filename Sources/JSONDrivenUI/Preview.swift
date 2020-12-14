//
//  Preview.swift
//  
//
//  Created by QQS on 2020/12/14.
//

import Foundation
import SwiftUI
import WidgetKit

struct JSONUIPreview: View {
    let date: Date = Date()
    var body: some View {
        let sampleJSON = """
        {
          "type": "VStack",
          "properties": {
            "spacing": 8,
            "horizontalAlignment": "center"
          },
          "subviews": [
            {
              "type": "Text",
              "values": {
                "text": "timer1221"
              },
              "properties": {
                "fontWeight": "bold",
                "font": "body"
              }
            },
            {
              "type": "Timer",
              "values": {
                "dateStyle": "date"
              },
              "properties": {
                "fontWeight": "bold",
                "font": "body"
              }
            },
            {
              "type": "Text",
              "values": {
                "text": "timer"
              },
              "properties": {
                "fontWeight": "bold",
                "font": "body"
              }
            }
          ]
        }
        """
        JSONDataView(json: sampleJSON.data(using: .utf8)!, date: date)
    }
}


struct JSONUIPreview_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            JSONUIPreview()
        }
    }
}
