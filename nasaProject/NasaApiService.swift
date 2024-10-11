//
//  NasaApiService.swift
//  nasaProject
//
//  Created by Jonathan Chen on 10/11/24.
//

import Foundation
import NetworkService

final class NasaApiService {
    
    enum NasaApiError: Error {
        case invalidURL
        case otherError // TODO split into more errors
    }
    
    static let shared = NasaApiService()
    private init() {}
    
    let baseURL = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/" //TODO can make a URL class... or can split this...
    
    func getPhotos() async throws -> PhotoList {
        
        guard let url = URL(string: baseURL + "photos?sol=1000&page=2&api_key=AyHYvkgDh4gCmDpuFPUj5kmc2nLHsJS5ikGGHKHe") else {
            throw NasaApiError.invalidURL
        }
        
        do {
            let data = try await NetworkManager.get(url: url)
            return try JSONDecoder().decode(PhotoList.self, from: data)
            
        } catch {
            throw NasaApiError.otherError
        }
        
        
    }
    
}
