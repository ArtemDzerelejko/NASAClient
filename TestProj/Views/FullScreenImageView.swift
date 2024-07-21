
import SwiftUI
import Kingfisher

struct FullScreenImageView: View {
    let imageURL: String
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    KFImage(URL(string: imageURL))
                        .resizable()
                        .placeholder {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * scale, height: geometry.size.height * scale)
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    let delta = value / lastScale
                                    lastScale = value
                                    scale *= delta
                                }
                                .onEnded { _ in
                                    lastScale = 1.0
                                }
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = CGSize(
                                        width: lastOffset.width + value.translation.width,
                                        height: lastOffset.height + value.translation.height
                                    )
                                }
                                .onEnded { _ in
                                    lastOffset = offset
                                }
                        )
                        .gesture(
                            TapGesture(count: 2)
                                .onEnded {
                                    withAnimation {
                                        if scale > 1 {
                                            scale = 1
                                            offset = .zero
                                        } else {
                                            scale = 2
                                        }
                                        lastOffset = .zero
                                    }
                                }
                        )
                }
                .edgesIgnoringSafeArea(.all)
            }
            .overlay(
                Button(action: {
                    isPresented = false
                }) {
                    Image(.secondCloseCircle)
                }
                    .padding(.top, 14)
                    .padding(.leading, 20),
                alignment: .topLeading
            )
        }
    }
}
