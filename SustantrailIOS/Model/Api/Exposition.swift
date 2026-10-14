//
//  Exposition.swift
//  SustantrailIOS
//
//  Created by Rahul Ramjeawon on 9/1/26.
//
//  Swift port of the Kotlin `Exposition` model hierarchy + custom Gson deserializer.
//  Kotlin used an abstract class with a JsonDeserializer keyed off a "type" field;
//  Swift's natural equivalent is an enum with associated values and a custom
//  Decodable initializer that reads "type" first, then decodes the matching payload.
//

import Foundation

// MARK: - Leaf models

struct ScoreInfo: Codable {
    var score: String?
    var scoreFactor: String?
    var category: String?
    
    enum CodingKeys: String, CodingKey {
        case score
        case scoreFactor = "score_factor"
        case category
    }
}

struct ScoreData: Codable {
    var data: [Float]?
    var scoreInfo: [ScoreInfo]?
    
    /// Mirrors Kotlin's computed `totalValue` property.
    var totalValue: String {
        String(Int(data?.reduce(0, +) ?? 0))
    }
}

struct Article: Codable {
    var url: String?
    var title: String?
    var category: String?
    var imageURL: String?
    var publish: String?
    
    enum CodingKeys: String, CodingKey {
        case url, title, category
        case imageURL = "image_url"
        case publish = "published"
    }
}

struct NewsSection: Codable {
    var header: String?
    var articles: [Article]?
}

struct AdPlus: Codable {
    var header: String?
    var category: String?
    var images: [String]?
}

struct Event: Codable {
    var imageUrl: String?
    var title: String?
    var url: String?
    var date: String?
    var totalSpots: Int?
    var remainingSpots: Int?
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case title, url, date
        case totalSpots = "total_spots"
        case remainingSpots = "remaining_spots"
    }
}

struct EventSection: Codable {
    var events: [Event]?
}

// MARK: - Exposition (polymorphic type)

/// Equivalent of the Kotlin `Exposition` abstract class + `ExpositionDeserializer`.
/// Decoding reads the "type" discriminator and routes to the matching payload,
/// same as the `typeMapping` dictionary in the Kotlin version.
enum Exposition: Decodable {
    case graph(ScoreData)
    case news(NewsSection)
    case ad(AdPlus)
    case event(EventSection)
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    enum ExpositionDecodingError: Error {
        case missingType
        case unknownType(String)
    }
    
    init(from decoder: Decoder) throws {
        let keyed = try decoder.container(keyedBy: CodingKeys.self)
        let type = try keyed.decode(String.self, forKey: .type)
        
        // A second, unkeyed view of the same node lets us decode the full
        // payload (including "type") into the concrete struct in one shot.
        let single = try decoder.singleValueContainer()
        
        switch type {
        case "Graph":
            self = .graph(try single.decode(ScoreData.self))
        case "News":
            self = .news(try single.decode(NewsSection.self))
        case "AD":
            self = .ad(try single.decode(AdPlus.self))
        case "Event":
            self = .event(try single.decode(EventSection.self))
        default:
            throw ExpositionDecodingError.unknownType(type)
        }
    }
}
