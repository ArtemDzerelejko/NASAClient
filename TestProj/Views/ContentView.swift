
import SwiftUI

// MARK: - Views
struct ContentView: View {
    @StateObject private var viewModel = MarsPhotosViewModel()
    @State private var showCameraFilter = false
    @State private var showCustomDialog = false
    @State var isActive: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("MARS.CAMERA")
                                .font(.system(size: 34, weight: .bold, design: .default))
                                .foregroundColor(.black)
                            
                            Text(viewModel.formattedDate)
                                .font(.system(size: 17, weight: .bold, design: .default))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showCustomDialog = true
                        }) {
                            Image("calendar")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color.accentOne)

                    HStack(spacing: 12) {
                        FilterButton(title: "All", imageName: "roverImg")
                        FilterButton(title: viewModel.selectedCamera ?? "All", imageName: "cameraImg") {
                            showCameraFilter = true
                        }
                        Spacer()
                        Button(action: {
                            isActive = true
                        }) {
                            Image(.addImg)
                                .font(.system(size: 17, weight: .bold, design: .default))
                                .frame(width: 38, height: 38)
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color.accentOne)
                    
                    ScrollView {
                        if viewModel.noPhotosFound {
                            VStack {
                                   Text("No photos found for this date.")
                                    .font(.system(size: 17, weight: .bold, design: .default))
                                       .foregroundColor(.gray)
                                       .padding()
                                   
                                Button("Try Another Date") {
                                    showCustomDialog = true
                                }
                                .font(.system(size: 17, weight: .bold, design: .default))
                                   .padding()
                                   .background(Color.accentOne)
                                   .foregroundColor(.black)
                                   .cornerRadius(10)
                               }
                        } else {
                            LazyVStack(spacing: 10) {
                                ForEach(viewModel.photos) { photo in
                                    MarsPhotoView(photo: photo)
                                }
                                
                                if viewModel.isLoading {
                                    ProgressView()
                                } else if viewModel.hasMorePages {
                                    Color.clear
                                        .frame(height: 50)
                                        .onAppear {
                                            viewModel.loadMorePhotos()
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                }
                .navigationBarHidden(true)
                .onAppear {
                    viewModel.loadInitialPhotos(rover: "curiosity", camera: nil, date: "2020-07-16")
                }
                .sheet(isPresented: $showCameraFilter) {
                    CameraSelectionView(isPresented: $showCameraFilter, viewModel: viewModel)
                        .presentationDetents([.height(306)])
                        .presentationDragIndicator(.hidden)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: HistoryView()) {
                            Image(.historyButton)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 21)
                    }
                }

                if isActive {
                    CustomFilture(isActive: $isActive, title: "Save Filters", message: "The current filters and the date you have chosen can be saved to the filter history.", buttonTitle: "Give Access") {
                        print("Pass to viewModel")
                    }
                }
                
                if showCustomDialog {
                    CustomDialog(isActive: $showCustomDialog, title: "Date") { date in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateString = dateFormatter.string(from: date)
                        viewModel.loadInitialPhotos(rover: viewModel.currentRover, camera: viewModel.selectedCamera, date: dateString)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
