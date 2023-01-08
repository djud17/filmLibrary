//
//  ApiClient.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import Alamofire

enum ApiError: Error {
    case noData
    case wrongData
}

protocol ApiClientProtocol {
    func getPopularMovies(completion: @escaping (Result<PopularMovies, ApiError>) -> Void)
    func getMovie(by id: Int, completion: @escaping (Result<SingleMovie, ApiError>) -> Void)
}

final class ApiClient: ApiClientProtocol {
    private let apiToken = Constants.ApiRequest.token
    
    func getPopularMovies(completion: @escaping (Result<PopularMovies, ApiError>) -> Void) {
        let limitRequest = "moviesLimit=\(Constants.downloadDataNumber)"
        let urlString = "\(Constants.ApiRequest.mainUrl)collection?token=\(apiToken)&search=top_items_all&field=collectionId&\(limitRequest)"
        
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url).responseData { response in
            if let data = response.value,
               response.response?.statusCode == 200 {
                do {
                    let topSet = try JSONDecoder().decode(PopularMovies.self, from: data)
                    completion(.success(topSet))
                } catch {
                    print("Error - \(error.localizedDescription)")
                    completion(.failure(.wrongData))
                }
            } else {
                completion(.failure(.noData))
            }
        }
    }
    
    func getMovie(by id: Int, completion: @escaping (Result<SingleMovie, ApiError>) -> Void) {
        let urlString = "\(Constants.ApiRequest.mainUrl)movie?search=\(id)&field=id&token=\(apiToken)"
        
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url).responseData { response in
            if let data = response.value,
               response.response?.statusCode == 200 {
                do {
                    let movie = try JSONDecoder().decode(SingleMovie.self, from: data)
                    completion(.success(movie))
                } catch {
                    completion(.failure(.wrongData))
                }
            } else {
                completion(.failure(.noData))
            }
        }
    }
}
