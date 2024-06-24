import Alamofire
import Foundation

class NativeAPIHost: APIHost {
    private let apiKey: String
    
    let baseURL = URL(string: "https://www.alphavantage.co/query")!
    let  headers = HTTPHeaders()
    lazy var baseParameters: Parameters = {
        return ["apikey": apiKey]
    }()
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
}
