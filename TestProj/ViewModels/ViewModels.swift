
import SwiftUI
import Combine

// MARK: - ViewModels

class MarsPhotosViewModel: ObservableObject {
    @Published var photos: [MarsPhoto] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasMorePages = true
    @Published var selectedCamera: String?
    @Published var formattedDate: String = ""
    @Published var noPhotosFound = false
    
    private var currentPage = 1
    private let apiService = NASAAPIService()
    var currentRover = "curiosity"
    private var currentDate = "2020-07-16"
    private var allPhotos: [String: [MarsPhoto]] = [:]
    private var cancellables = Set<AnyCancellable>()
    
    let cameras = ["All", "FHAZ", "RHAZ", "MAST", "CHEMCAM", "MAHLI", "MARDI", "NAVCAM"]
    
    func loadInitialPhotos(rover: String, camera: String?, date: String) {
        currentRover = rover
        selectedCamera = camera
        currentDate = date
        updateFormattedDate(from: date)
        currentPage = 1
        allPhotos = [:]
        photos = []
        noPhotosFound = false
        hasMorePages = true
        
        objectWillChange.send()
        
        loadMorePhotos()
    }
    
    private func updateFormattedDate(from dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMMM d, yyyy"
            formattedDate = dateFormatter.string(from: date)
        }
    }
    
    func loadMorePhotos() {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        noPhotosFound = false
        print("Fetching photos for date: \(currentDate), page: \(currentPage)")
        
        apiService.fetchPhotos(rover: currentRover, camera: selectedCamera, date: currentDate, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    print("Error fetching photos: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] newPhotos in
                print("Received \(newPhotos.count) new photos")
                self?.processNewPhotos(newPhotos)
                self?.currentPage += 1
                self?.hasMorePages = !newPhotos.isEmpty
                if newPhotos.isEmpty && self?.currentPage == 2 {
                    self?.noPhotosFound = true
                }
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    private func processNewPhotos(_ newPhotos: [MarsPhoto]) {
        for photo in newPhotos {
            if allPhotos[photo.camera.name] == nil {
                allPhotos[photo.camera.name] = []
            }
            allPhotos[photo.camera.name]?.append(photo)
        }
        filterPhotos()
    }
    
    func selectCamera(_ camera: String) {
        selectedCamera = camera
        filterPhotos()
    }
    
    private func filterPhotos() {
        if selectedCamera == "All" || selectedCamera == nil {
            photos = allPhotos.values.flatMap { $0 }
        } else {
            photos = allPhotos[selectedCamera ?? ""] ?? []
        }
    }
}

class HistoryViewModel: ObservableObject {
    @Published var filterHistories: [FilterHistory] = []
    @Published var selectedFilter: FilterHistory?
    @Published var showActionSheet = false

    init() {
        loadFilterHistories()
    }

    func loadFilterHistories() {
        if let savedHistories = UserDefaults.standard.object(forKey: "filterHistories") as? Data {
            if let decodedHistories = try? JSONDecoder().decode([FilterHistory].self, from: savedHistories) {
                self.filterHistories = decodedHistories
            }
        }
        
        if filterHistories.isEmpty {
            filterHistories = [
                FilterHistory(rover: "Curiosity", camera: "Front Hazard Avoidance Camera", date: "June 6, 2019"),
                FilterHistory(rover: "Opportunity", camera: "Navigation Camera", date: "July 10, 2018"),
                FilterHistory(rover: "Spirit", camera: "Panoramic Camera", date: "March 15, 2010")
            ]
            saveFilterHistories()
        }
    }

    func saveFilterHistories() {
        if let encoded = try? JSONEncoder().encode(filterHistories) {
            UserDefaults.standard.set(encoded, forKey: "filterHistories")
        }
    }

    func applyFilter() {
        print("Applying filter: \(selectedFilter?.rover ?? "") - \(selectedFilter?.camera ?? "")")
    }

    func deleteFilter() {
        if let selected = selectedFilter,
           let index = filterHistories.firstIndex(where: { $0.id == selected.id }) {
            filterHistories.remove(at: index)
            saveFilterHistories()
        }
    }
}

class CustomDialogViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var offset: CGFloat = 1000

    func close() {
        withAnimation(.spring()) {
            offset = 1000
        }
    }

    func open() {
        withAnimation(.spring()) {
            offset = 0
        }
    }
}

class CustomFiltureViewModel: ObservableObject {
    @Published var offset: CGFloat = 1000

    func close() {
        withAnimation(.spring()) {
            offset = 1000
        }
    }

    func open() {
        withAnimation(.spring()) {
            offset = 0
        }
    }
}
