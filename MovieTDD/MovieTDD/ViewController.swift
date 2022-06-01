//
//  ViewController.swift
//  MovieTDD
//
//  Created by 김동준 on 2022/05/27.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let service = MovieService()
        service.requestMovieInfo(api: MovieAPI.searchMovies(title: "Ironman")) { (result: Result<MovieItems, NetworkError>) in
            switch result {
            case .success(let movieItems):
                print("success MovieInfo!! \(movieItems.items.count)")
            case .failure(let error):
                print("fail \(error)")
            }
        }
    }
}

