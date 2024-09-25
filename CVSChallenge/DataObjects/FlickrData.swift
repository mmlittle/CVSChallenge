//
//  FlickrData.swift
//  CVSChallenge
//
//  Created by Mike Little on 9/24/24.
//

import Foundation
import SwiftUI

// MARK: - FlickrData
struct FlickrData: Codable {
    let title: String
    let link: String
    let description: String
    let modified: String
    let generator: String
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let media: Media
    let dateTaken: String
    let description: String
    let published: String
    let author, authorID, tags: String

    enum CodingKeys: String, CodingKey {
        case title, link, media
        case dateTaken = "date_taken"
        case description, published, author
        case authorID = "author_id"
        case tags
    }
}

// MARK: - Media
struct Media: Codable {
    let m: String
}

struct ThumbnailData: Hashable {
    let title: String
    let description: String
    let published: String
    let author: String
    let image: UIImage
}
