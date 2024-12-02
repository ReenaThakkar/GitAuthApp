//
//  Repository.swift
//  Reena_7Span_Practical
//
//  Created by Reena on 12/1/24.
//

import Foundation
struct Repository: Decodable, Identifiable{
    let id: Int
    let name: String
    let descriptionText: String?
    let stargazers_count: Int
    let forks_count: Int
    let updated_at: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case descriptionText
        case stargazers_count = "stargazers_count"
        case forks_count = "forks_count"
        case updated_at = "updated_at"
    }
    
}
