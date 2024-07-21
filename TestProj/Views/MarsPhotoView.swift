
import SwiftUI
import Kingfisher

struct MarsPhotoView: View {
    let photo: MarsPhoto
    @State private var showFullScreen = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private var formattedDate: String {
        if let date = dateFormatter.date(from: photo.earthDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM d, yyyy"
            return outputFormatter.string(from: date)
        }
        return photo.earthDate
    }
    
    var body: some View {
        Button(action: {
            showFullScreen = true
        }) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Rover: ")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.layerTwo) +
                    Text(photo.rover.name)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.layerOne)
                        .bold()
                    Text("Camera: ")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.layerTwo) +
                    Text(photo.camera.fullName)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.layerOne)
                        .bold()
                    Text("Date: ")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.layerTwo) +
                    Text(formattedDate)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.layerOne)
                        .bold()
                }
                
                Spacer()
                
                KFImage(URL(string: photo.imgSrc))
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .frame(height: 150)
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenImageView(imageURL: photo.imgSrc, isPresented: $showFullScreen)
        }
    }
}
