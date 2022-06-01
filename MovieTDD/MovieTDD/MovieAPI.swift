//
//  MovieAPI.swift
//  MovieTDD
//
//  Created by 김동준 on 2022/05/28.
//

import Foundation

protocol API {
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
    var headerContentType: [[String]] { get }
    var parameter: [String: Any]? { get }
}

enum MovieAPI: API {
    case searchMovies(title: String)

    var baseURL: String {
        switch self {
        case .searchMovies(_):
            return "https://openapi.naver.com/v1/search/movie.json?display=10&start=1"
        }
    }

    var path: String {
        switch self {
        case .searchMovies(let title):
            return "&query=\(title)"
        }
    }

    var method: String {
        switch self {
        case .searchMovies(_):
            return "GET"
        }
    }

    var headerContentType: [[String]] {
        switch self {
        case .searchMovies(_):
            return [["application/json; charset=utf-8", "Coontent-Type"],
                    ["hVcI6jc4IdxV2n4KQXnF", "X-Naver-Client-Id"],
                    ["nBkPO4GU8Q", "X-Naver-Client-Secret"]]
        }
    }

    var parameter: [String: Any]? {
        switch self {
        case .searchMovies(_):
            return nil
        }
    }
}
