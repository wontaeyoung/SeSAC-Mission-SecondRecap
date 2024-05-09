import Foundation
import KazUtility

final class HTTPClient {
  
  // MARK: - Singleton
  static let shared = HTTPClient()
  private init() { }
  
  // MARK: - Method
  func callRequest<T: DTO>(
    responseType: T.Type,
    router: any Router,
    successStatusRange: ClosedRange<Int> = 200...299,
    completion: @escaping (T) -> Void,
    errorHandler: ((HTTPError) -> Void)?
  ) {
    
    guard let request = try? router.asURLRequest() else {
      errorHandler?(.invalidURL)
      return
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      guard error == nil else {
        errorHandler?(.requestFailed)
        return
      }
      
      guard let data else {
        errorHandler?(.invalidResponse)
        return
      }
      
      guard let response = response as? HTTPURLResponse else {
        errorHandler?(.invalidResponse)
        return
      }
      
      guard successStatusRange ~= response.statusCode else {
        errorHandler?(.unexceptedResponse(status: response.statusCode))
        return
      }
      
      guard let result = try? JsonCoder.shared.decode(to: responseType, from: data) else {
        errorHandler?(.dataDecodingFailed)
        return
      }
      
      completion(result)
    }
    .resume()
  }
  
  func callRequest<T: DTO>(
    responseType: T.Type,
    router: any Router,
    successStatusRange: ClosedRange<Int> = 200...299,
    completion: @escaping (T?, HTTPError?) -> Void
  ) {
    
    guard let request = try? router.asURLRequest() else {
      return completion(nil, .invalidURL)
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      guard error == nil else {
        return completion(nil, .requestFailed)
      }
      
      guard let data else {
        return completion(nil, .invalidResponse)
      }
      
      guard let response = response as? HTTPURLResponse else {
        return completion(nil, .invalidResponse)
      }
      
      guard successStatusRange ~= response.statusCode else {
        return completion(nil, .unexceptedResponse(status: response.statusCode))
      }
      
      guard let result = try? JsonCoder.shared.decode(to: responseType, from: data) else {
        return completion(nil, .dataDecodingFailed)
      }
      
      completion(result, nil)
    }
    .resume()
  }
  
  func callRequest<T: DTO>(
    responseType: T.Type,
    router: any Router,
    successStatusRange: ClosedRange<Int> = 200...299,
    completion: @escaping (Result<T, HTTPError>) -> Void
  ) {
    
    guard let request = try? router.asURLRequest() else {
      return completion(.failure(.invalidURL))
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      guard error == nil else {
        return completion(.failure(.requestFailed))
      }
      
      guard let data else {
        return completion(.failure(.invalidResponse))
      }
      
      guard let response = response as? HTTPURLResponse else {
        return completion(.failure(.invalidResponse))
      }
      
      guard successStatusRange ~= response.statusCode else {
        return completion(.failure(.unexceptedResponse(status: response.statusCode)))
      }
      
      guard let result = try? JsonCoder.shared.decode(to: responseType, from: data) else {
        return completion(.failure(.dataDecodingFailed))
      }
      
      completion(.success(result))
    }
    .resume()
  }
  
  func callRequest<T: DTO>(
    responseType: T.Type,
    router: any Router,
    successStatusRange: ClosedRange<Int> = 200...299
  ) async -> Result<T, HTTPError> {
    
    guard let request = try? router.asURLRequest() else {
      return .failure(.invalidURL)
    }
    
    guard let (data, response) = try? await URLSession.shared.data(for: request) else {
      return .failure(.requestFailed)
    }
    
    guard let response = response as? HTTPURLResponse else {
      return .failure(.invalidResponse)
    }
    
    guard successStatusRange ~= response.statusCode else {
      return .failure(.unexceptedResponse(status: response.statusCode))
    }
    
    guard let result = try? JsonCoder.shared.decode(to: responseType, from: data) else {
      return .failure(.dataDecodingFailed)
    }
    
    return .success(result)
  }
  
  func callRequest<T: Decodable>(
    responseType: T.Type,
    router: any Router,
    successStatusRange: ClosedRange<Int> = 200...299,
    additionalError: [Int: HTTPError] = [:]
  ) async throws -> T {
    
    guard let request = try? router.asURLRequest() else {
      throw HTTPError.invalidURL
    }
    
    guard let (data, response) = try? await URLSession.shared.data(for: request) else {
      throw HTTPError.requestFailed
    }
    
    guard let response = response as? HTTPURLResponse else {
      throw HTTPError.invalidResponse
    }
    
    for (statusCode, error) in additionalError {
      guard response.statusCode != statusCode else {
        throw error
      }
    }
    
    guard successStatusRange ~= response.statusCode else {
      throw HTTPError.unexceptedResponse(status: response.statusCode)
    }
    
    guard let result = try? JsonCoder.shared.decode(to: responseType, from: data) else {
      throw HTTPError.dataDecodingFailed
    }
    
    return result
  }
}
