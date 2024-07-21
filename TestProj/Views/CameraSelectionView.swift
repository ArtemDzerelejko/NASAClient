
import SwiftUI

struct CameraSelectionView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: MarsPhotosViewModel
    @State private var selectedCamera: String
    
    init(isPresented: Binding<Bool>, viewModel: MarsPhotosViewModel) {
        self._isPresented = isPresented
        self.viewModel = viewModel
        self._selectedCamera = State(initialValue: viewModel.selectedCamera ?? "All")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Image("closeCircle")
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("Camera")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    viewModel.selectCamera(selectedCamera)
                    isPresented = false
                }) {
                    Image("okButton")
                        .foregroundColor(.orange)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            Picker("Camera", selection: $selectedCamera) {
                ForEach(viewModel.cameras, id: \.self) { camera in
                    Text(camera).tag(camera)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 200)
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(50)
        .edgesIgnoringSafeArea(.bottom)
    }
}

