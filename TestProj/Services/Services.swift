
import SwiftUI
import Combine

// MARK: - Services

class NASAAPIService {
    private let apiKey = "83brZ2Jr9I4Ya0wUgGz7pxGbVArS49CG7IkxmdaR"
    private let baseURL = "https://api.nasa.gov/mars-photos/api/v1/rovers/"
    
    func fetchPhotos(rover: String, camera: String?, date: String, page: Int) -> AnyPublisher<[MarsPhoto], Error> {
        var urlString = "\(baseURL)\(rover)/photos?earth_date=\(date)&api_key=\(apiKey)&page=\(page)"
        if let camera = camera, camera != "All" {
            urlString += "&camera=\(camera.lowercased())"
        }
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        print("Fetching URL: \(urlString)")
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PhotosResponse.self, decoder: JSONDecoder())
            .map(\.photos)
            .eraseToAnyPublisher()
    }
}
