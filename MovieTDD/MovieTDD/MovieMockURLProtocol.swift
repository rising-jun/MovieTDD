//
//  MovieMockURLProtocol.swift
//  MovieTDD
//
//  Created by 김동준 on 2022/05/28.
//

import Foundation

final class MovieMockProtocol: URLProtocol {
    static var loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MovieMockProtocol.loadingHandler else { return }
        let (response, data, error) = handler(request)
        if let data = data {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
        else {
            client?.urlProtocol(self, didFailWithError: error!)
        }
    }
    
    override func stopLoading() {}
}
