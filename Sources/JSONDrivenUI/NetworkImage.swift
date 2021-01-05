import Foundation
import SwiftUI

struct NetworkImage: View {

  let url: URL?
  let mode: String?

  var body: some View {
        if let url = url, let imageData = try? Data(contentsOf: url),
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .conditionalModifier(mode != nil && mode == "fill", {
                    $0.scaledToFill()
                }, {
                    $0.scaledToFit()
                })
                
        }
        else {
            Image(systemName: "square.dashed")
                .resizable()
                .conditionalModifier(mode != nil && mode == "fill", {
                    $0.scaledToFill()
                }, {
                    $0.scaledToFit()
                })

        }
  }
}
