
import SwiftUI

struct CustomFilture: View {
    @Binding var isActive: Bool
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void
    @StateObject private var viewModel = CustomFiltureViewModel()
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            
            VStack {
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .padding(.top, 19)
                    .padding(.bottom, 2)
                
                Text(message)
                    .font(.system(size: 13, weight: .regular, design: .default))
                Divider()
                Button(action: {
                    close()
                }) {
                    Text("Save")
                        .foregroundColor(.systemTwo)
                        .font(.system(size: 17, weight: .semibold, design: .default))
                }
                Divider()
                Button(action: {
                    close()
                }) {
                    Text("Cancel")
                        .foregroundColor(.systemTwo)
                        .font(.system(size: 17, weight: .regular, design: .default))
                }
            }
            .frame(width: 270, height: 184)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .offset(x: 0, y: viewModel.offset)
            .onAppear {
                viewModel.open()
            }
        }
        .ignoresSafeArea()
    }
    
    func close() {
        viewModel.close()
        isActive = false
    }
}

struct CustomFilture_Previews: PreviewProvider {
    static var previews: some View {
        CustomFilture(isActive: .constant(true), title: "Save Filters", message: "The current filters and the date you have chosen can be saved to the filter history.", buttonTitle: "Give Access", action: {})
    }
}
