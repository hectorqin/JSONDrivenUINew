import Foundation
import SwiftUI

struct NetworkImage: View {

  let url: URL?
    let mode: String?

  var body: some View {
        if let url = url, let imageData = try? Data(contentsOf: url),
           let uiImage = UIImage(data: imageData) {
            if (mode != nil && mode == "fill") {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }
        }
        else {
            Image(uiImage: UIImage(data: Data())!)
        }
    
  }
}
