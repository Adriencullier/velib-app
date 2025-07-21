//
//  TerminalResultDTO.swift
//  StationFinder
//
//  Created by Adrien Cullier on 21/07/2025.
//

public struct TerminalResultDTO: Decodable, Sendable {
    public var results: [TerminalDTO]
    public var total: Int
    
    enum CodingKeys: String, CodingKey {
        case results = "result"
        case total = "total"
    }
}
