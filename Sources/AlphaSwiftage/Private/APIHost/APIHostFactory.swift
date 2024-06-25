import Foundation

class APIHostFactory {
    private init () {}
    
    static let shared = APIHostFactory()
    
    func host(for serviceType: AlphaVantageServiceType) -> APIHost {
        switch serviceType {
        case .native(let apiKey):
            return NativeAPIHost(apiKey: apiKey)
        case .rapidAPI(let apiKey):
            return RapidAPIHost(apiKey: apiKey)
        }
    }
}
