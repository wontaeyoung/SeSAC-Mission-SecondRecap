import Foundation

protocol Router {
  
  var method: HTTPMethod { get }
  var baseURL: String { get }
  var path: String { get }
  var headers: HTTPHeaders { get }
  var parameters: HTTPParameters { get }
}

extension Router {
  
  func asURLRequest() throws -> URLRequest {
    guard var components = URLComponents(string: baseURL + "/" + path) else { throw HTTPError.invalidURL }
    components.queryItems = parameters.current.isEmpty ? nil : parameters.current
    
    guard let url = components.url else { throw HTTPError.invalidURL }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers.current
    
    return request
  }
}
