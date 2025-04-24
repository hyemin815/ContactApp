import Foundation

struct Contact: Codable {
    let name: String
    let phoneNumber: String
    let imageData: Data?
}

extension UserDefaults {
    var savedContacts: [Contact] {
        get {
            guard let data = data(forKey: "contacts") else { return [] }
            return (try? JSONDecoder().decode([Contact].self, from: data)) ?? []
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            set(data, forKey: "contacts")
        }
    }
}
