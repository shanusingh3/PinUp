//
//  PixabayModal.swift
//  PinUp
//
//  Created by Shanu Singh on 15/05/20.
//  Copyright © 2020 Shanu Singh. All rights reserved.
//

import Foundation

// MARK: - PagesModel
struct PixabayModal: Codable {
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Codable {
    let id: Int
    let pageURL: String
    let type, tags: String
    let webformatURL, largeImageURL: String
    let imageWidth, imageHeight, imageSize, userID: Int
    let userImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, pageURL, type, tags, webformatURL, largeImageURL, imageWidth, imageHeight, imageSize
        case userID = "user_id"
        case userImageURL
    }
}


struct Wrapper<T: Codable>: Codable {
    let items: [T]
}
