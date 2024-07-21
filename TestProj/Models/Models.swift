
import Foundation

// MARK: - Models

struct MarsPhoto: Codable, Identifiable {
    let id: Int
    let sol: Int
    let camera: Camera
    let imgSrc: String
    let earthDate: String
    let rover: Rover
    
    enum CodingKeys: String, CodingKey {
        case id, sol, camera
        case imgSrc = "img_src"
        case earthDate = "earth_date"
        case rover
    }
}

struct Camera: Codable {
    let id: Int
    let name: String
    let roverId: Int
    let fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case roverId = "rover_id"
        case fullName = "full_name"
    }
}

struct Rover: Codable {
    let id: Int
    let name: String
    let landingDate: String
    let launchDate: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, status
        case landingDate = "landing_date"
        case launchDate = "launch_date"
    }
}

struct PhotosResponse: Codable {
    let photos: [MarsPhoto]
}

struct FilterHistory: Identifiable, Codable {
    let id: UUID
    let rover: String
    let camera: String
    let date: String

    init(id: UUID = UUID(), rover: String, camera: String, date: String) {
        self.id = id
        self.rover = rover
        self.camera = camera
        self.date = date
    }
}
