//
//  DataRequest+SerializingAlphaVantageResponse.swift
//
//
//  Created by Adam Borbas on 22/03/2024.
//

import Foundation
import Alamofire

extension DataRequest {
    
    func serializingAlphaVantageResponse<T>() async -> Result<T, AlphaVantageError> where T: Decodable {
        do {
            return try await self.serializingResponse(using: AlphaVantageResponseSerializer<T>()).value
        } catch {
            fatalError("Error should not be thrown from AlphaVantageResponseSerializer but got: \(error.localizedDescription)")
        }
    }
    
    func serializingAlphaVantageWrappedResponse<Wrapper, T>(_ type: Wrapper.Type, _ unwrap: (Wrapper) -> T) async -> Result<T, AlphaVantageError> where Wrapper: Decodable {
        let wrappedResult: Result<Wrapper, AlphaVantageError> = await self.serializingAlphaVantageResponse()
        
        switch wrappedResult {
        case .success(let result):
            let unwrapped = unwrap(result)
            return .success(unwrapped)
        case .failure(let error):
            return .failure(error)
        }
    }
}
