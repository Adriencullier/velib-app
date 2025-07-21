//
//  HTTPError.swift
//  Core
//
//  Created by Adrien Cullier on 18/07/2025.
//


public enum HTTPError: Error {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed(Error)
    case networkError(Error)
}