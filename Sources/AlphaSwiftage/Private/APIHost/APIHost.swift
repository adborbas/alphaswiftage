import Alamofire
import Foundation

protocol APIHost {
    var baseURL: URL { get }
    var headers: HTTPHeaders { get }
    var baseParameters: Parameters { get }
}
