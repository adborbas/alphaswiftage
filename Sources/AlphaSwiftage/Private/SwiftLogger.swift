//
//  SwiftLogger.swift
//
//
//  Created by Adam Borbas on 23/03/2024.
//

import Foundation
import Logging
import Alamofire

private var logger: Logger = Logger(label: "com.adborbas.alphaswiftage")

class SwiftLogger: EventMonitor {
    let queue = DispatchQueue(label: "com.adborbas.alphaswiftage.swiftlogger")
    
    func requestDidFinish(_ request: Request) {
        logger.debug("Request finised \(request.description)")
    }
    
    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        guard let data = response.data else {
            logger.debug("Response missing data for request: \(request.urlAbsoluteString)")
            return
        }
        
        if let json = try? JSONSerialization
            .jsonObject(with: data, options: .mutableContainers) {
            logger.debug("Response parsed for: \(request.urlAbsoluteString)\n\(json)")
        }
    }
}

fileprivate extension DataRequest {
    var urlAbsoluteString: String {
        return convertible.urlRequest?.url?.absoluteString ?? ""
    }
}
