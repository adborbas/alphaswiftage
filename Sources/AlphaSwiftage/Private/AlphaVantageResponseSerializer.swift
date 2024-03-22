//
//  AlphaVantageResponseSerializer.swift
//
//
//  Created by Adam Borbas on 22/03/2024.
//

import Foundation
import Alamofire

struct AlphaVantageResponseSerializer<T: Decodable>: ResponseSerializer {
    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> Result<T, AlphaVantageError> {
        
        let baseSerializer = DecodableResponseSerializer<T>()
        do {
            let result = try baseSerializer.serialize(request: request, response: response, data: data, error: error)
            return .success(result)
        } catch {
            if let data = data {
                let error = try! JSONDecoder().decode(AlphaVantageAPIError.self, from: data)
                return .failure(.apiError(error))
            }
            
            return .failure(.unknown(error))
        }
    }
}