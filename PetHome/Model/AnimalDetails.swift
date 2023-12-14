import Foundation

struct AnimalDetails: Decodable {
    let id: Int // 1234
    let name: String // Nebula
    let species: String // Cat
    let breeds: Breeds
    let age: String // young
    let size: String // Medium
    let gender: String // Female
    let description: String? // Nebula is ...
    let photos: [Photos]
    let status: String // adoptable
    let tags: [String]
    let colors: Colors
}

struct Breeds: Decodable {
    let primary: String? // American Shorthair
    let secondary: String?
    let mixed: Bool?
    let unknown: Bool?
}

struct Photos: Decodable {
    let small: String
    let medium: String
    let large: String
    let full: String
}

struct Colors: Decodable {
    let primary: String? // Tortoiseshell
    let secondary: String?
    let tertiary: String?
}
