
import SwiftUI

struct FilterButton: View {
    let title: String
    let imageName: String
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: { action?() }) {
            HStack {
                Image(imageName)
                Text(title)
                    .font(.system(size: 17, weight: .bold, design: .default))
            }
            .frame(width: 140, height: 38, alignment: .leading)
            .foregroundColor(.black)
            .padding(.leading, 7)
            .background(Color.white)
            .cornerRadius(10)
        }
    }
}
