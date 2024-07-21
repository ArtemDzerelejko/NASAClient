
import SwiftUI
import Lottie

struct LoaderView: View {
    @State private var isLoading = true
    @State private var shouldNavigate = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.accentOne)
                        .frame(width: 123, height: 123)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.layerOne, lineWidth: 1)
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Spacer()
                    
                    LottieView(name: "loader-test-taO4P2Im7C")
                        .frame(width: 211, height: 134)
                        .clipShape(Rectangle())
                    
                    Spacer()
                }
                
                NavigationLink(destination: ContentView(), isActive: $shouldNavigate) {
                    EmptyView()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    shouldNavigate = true
                }
            }
        }
    }
}

struct LottieView: UIViewRepresentable {
    var name: String
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(name)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
