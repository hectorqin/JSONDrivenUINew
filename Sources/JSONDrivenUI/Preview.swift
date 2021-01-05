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
            "type":"ZStack",
            "values":{},
            "properties":{"backgroundColor": "#FFF","padding": "12"},
            "subviews":[
                {"type": "LinearGradient", "values": {"gradient": "#A82323,#000000", "direction": "0,1 1,0.3"}},
                {"type":"Image","values":{"imageUrl":"https://xinxiao.tech/assets/products/duohui.png"},"properties":{"width":100,"height":40, "scaleMode": "fill", "clipContent": true}},
                {"type":"Text","values":{"text":"Steven Cheng Da Da"},
                "properties":{"fontName":"New York","foregroundColor":"#ffffff","fontSize":20, "fontStyle": "bold lowercaseSmallCaps", "shadow": "2 2 1 #00000055", "width": 200, "height": 200, "alignment": "topCenter"}}
            ]
        
        }
        """
//        let sampleJSON = """
//        {"type":"ZStack","values":{},"properties":{"horizontalAlignment":"center"},"subviews":[{"type":"Rectangle","values":{"foregroundColor":"#aaa","width":1000,"height":1000},"properties":{"foregroundColor":"#aaa","width":1000,"height":1000}},{"type":"VStack","values":{},"properties":{},"subviews":[{"type":"Text","values":{"text":"Content"},"properties":{"font":"body","foregroundColor":"#333","fontWeight":"bold"}},{"type":"Image","values":{"imageUrl":"https://xinxiao.tech/assets/products/duohui.png"},"properties":{"width":100,"height":100}}]}]}
//        """
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
