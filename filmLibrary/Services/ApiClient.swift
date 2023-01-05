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
    func getMovie(byId id: Int, completion: @escaping (Result<Movie, ApiError>) -> Void)
}

final class ApiClient: ApiClientProtocol {
    private let apiToken = Constants.ApiRequest.token
    
    func getMovie(byId id: Int, completion: @escaping (Result<Movie, ApiError>) -> Void) {
        let urlString = Constants.ApiRequest.mainUrl + "movie?search=\(id)&field=id&token=\(apiToken)"
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url).responseData { response in
            if let data = response.value,
               response.response?.statusCode == 200 {
                do {
                    let movie = try JSONDecoder().decode(Movie.self, from: data)
                    completion(.success(movie))
                } catch {
                    print("Error - \(error.localizedDescription)")
                    completion(.failure(.wrongData))
                }
            } else {
                completion(.failure(.noData))
            }
        }
    }
}
