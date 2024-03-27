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
            guard let data = data else {
                logger.error("Failed to serialise request and returned data is nil. \(error.localizedDescription)")
                return .failure(.unknown(error))
            }
            
            logger.debug("Failed to serialise request: \(error.localizedDescription).")
            do {
                let error = try JSONDecoder().decode(AlphaVantageAPIError.self, from: data)
                logger.info("API Error: \(error.localizedDescription)")
                return .failure(.apiError(error))
            } catch {
                guard let response = String(data: data, encoding: .utf8) else {
                    logger.error("Unexpected response not parsable to String.")
                    return .failure(.unknown(error))
                }
                
                logger.error("Unexpected response: \(response).")
                return .failure(.unexpectedResponse(response))
            }
        }
    }
}
