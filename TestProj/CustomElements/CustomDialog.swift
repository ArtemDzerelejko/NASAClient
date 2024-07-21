
import SwiftUI

struct CustomDialog: View {
    @Binding var isActive: Bool
    let title: String
    let action: (Date) -> Void
    @StateObject private var viewModel = CustomDialogViewModel()
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        close()
                    } label: {
                        Image("closeCircle")
                    }
                    .tint(.black)
                    
                    Spacer()
                    
                    Text(title)
                        .font(.system(size: 22, weight: .bold, design: .default))
                    
                    Spacer()
                    Button {
                        action(viewModel.selectedDate)
                        close()
                    } label: {
                        Image("okButton")
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                
                DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: [.date])
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
            }
            .frame(width: 353, height: 312)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 20)
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

struct CustomDialog_Previews: PreviewProvider {
    static var previews: some View {
        CustomDialog(isActive: .constant(true), title: "Date", action: { _ in })
    }
}
