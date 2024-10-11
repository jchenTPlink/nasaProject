//
//  NetworkManager.swift
//  NetworkService
//
//  Created by Jonathan Chen on 10/11/24.
//

import Foundation


public class NetworkManager {

    public static func get(url: URL) async throws -> Data {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url) // TODO look at this response
            return data
            
        } catch {
            throw error
        }
        
    }
    
}
