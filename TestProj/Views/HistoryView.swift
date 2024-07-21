
import SwiftUI

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = HistoryViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(.backButton)
                }
                Spacer()
                Text("History")
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                Spacer()
                    .frame(width: 44)
            }
            .padding()
            .background(Color.accentOne)

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.filterHistories) { history in
                        filterCard(for: history)
                            .onTapGesture {
                                viewModel.selectedFilter = history
                                viewModel.showActionSheet = true
                            }
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
        .actionSheet(isPresented: $viewModel.showActionSheet) {
            ActionSheet(title: Text("Menu Filter").font(.system(size: 13, weight: .semibold, design: .default)),
                        message: Text(""),
                        buttons: [
                            .default(Text("Use").font(.system(size: 17, weight: .regular, design: .default))) {
                                viewModel.applyFilter()
                                presentationMode.wrappedValue.dismiss()
                            },
                            .destructive(Text("Delete").font(.system(size: 17, weight: .regular, design: .default))) {
                                viewModel.deleteFilter()
                            },
                            .cancel()
                        ])
        }
    }

    func filterCard(for history: FilterHistory) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Rectangle()
                    .fill(Color.accentOne)
                    .frame(height: 1)
                Text("Filters")
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .foregroundColor(.accentOne)
            }
            .padding(.bottom, 8)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Rover: ")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.layerTwo) +
                    Text(history.rover)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.layerOne)
                        .bold()
                    Text("Camera: ")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.layerTwo) +
                    Text(history.camera)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.layerOne)
                        .bold()
                    Text("Date: ")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.layerTwo) +
                    Text(history.date)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.layerOne)
                        .bold()
                }
                .font(.caption)
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
