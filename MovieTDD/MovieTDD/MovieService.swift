//
//  MovieRepository.swift
//  MovieTDD
//
//  Created by 김동준 on 2022/05/28.
//

import Foundation

final class MovieService {
    private let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MovieMockProtocol.self]
        return configuration
    }()
    
    private lazy var session = URLSession(configuration: configuration)
    
    func requestMovieInfo<T: Decodable>(api: API, completionHandler: @escaping((Result<T, NetworkError>) -> Void)) {
        guard let url = URL(string: api.baseURL + api.path) else {
            return completionHandler(.failure(.invaildURL))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method
        
        let headers = api.headerContentType
        for header in headers {
            urlRequest.addValue(header[0], forHTTPHeaderField: header[1])
        }
        
        dataTask(urlRequest: urlRequest) { result in
            completionHandler(result)
        }
    }
    
    private func dataTask<T:Decodable>(urlRequest: URLRequest, completionHandler: @escaping((Result<T,NetworkError>) -> Void)) {
        let dataTask = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            //handling transportError
            if let _ = error  {
                completionHandler(.failure(.transport))
                return
            }
            //handling NoDataError
            guard let data = data else {
                completionHandler(.failure(.nilData))
                return
            }
            //handling ServerError
            guard let statusCode = self.getStatusCode(response: response) else { return }
            guard 200..<300 ~= statusCode else {
                completionHandler(.failure(.server(statusCode: statusCode)))
                return
            }
            
            //handling DecodingError
            guard let fetchedData = try? JSONDecoder().decode(T.self, from: data) else {
                return completionHandler(.failure(.decoding))
            }
            completionHandler(.success(fetchedData))
        }
        dataTask.resume()
    }
    
    private func getStatusCode(response:URLResponse?) -> Int? {
        guard let httpResponse = response as? HTTPURLResponse else { return nil }
        return httpResponse.statusCode
    }
}

struct NoDecode {
    let noDecode:String = "noDecode"
}

enum NetworkError: Error {
    case invaildURL
    case transport
    case nilData
    case server(statusCode: Int)
    case decoding
}

struct MovieItems: Codable, Equatable {
    static func == (lhs: MovieItems, rhs: MovieItems) -> Bool {
        return lhs.items.count == rhs.items.count
    }
    
    let items: [MovieInfo]
}

struct MovieInfo: Codable {
    let title: String
}
