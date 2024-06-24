import Alamofire
import Foundation

class RapidAPIHost: APIHost {
    private let apiKey: String
    
    let baseURL = URL(string: "https://alpha-vantage.p.rapidapi.com/query")!
    lazy var headers: HTTPHeaders = {
        return HTTPHeaders([
            "x-rapidapi-host": "alpha-vantage.p.rapidapi.com",
            "x-rapidapi-key": apiKey
        ])
    }()
    let baseParameters: Parameters = [:]
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
}
