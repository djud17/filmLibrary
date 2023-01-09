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
    func searchMovie(for name: String, in page: Int, completion: @escaping (Result<MovieSearch, ApiError>) -> Void)
}

final class ApiClient: ApiClientProtocol {
    private let apiToken = Constants.ApiRequest.token
    private let movieFilter = ServiceCoordinator.movieFilter
    
    func getPopularMovies(completion: @escaping (Result<PopularMovies, ApiError>) -> Void) {
        let limitRequest = "&moviesLimit=\(Constants.downloadDataNumber)"
        let sortType = "&sortField=rating.kp&sortType=-1"
        var urlString = "\(Constants.ApiRequest.mainUrl)collection?token=\(apiToken)&search=top_items_all&field=collectionId"
        urlString += "\(sortType)\(limitRequest)"
        
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
    
    func searchMovie(for name: String, in page: Int, completion: @escaping (Result<MovieSearch, ApiError>) -> Void) {
        let pageRequest = "&page=\(page)"
        let sortType = "&sortField=rating.kp&sortType=-1"
        let filterRequest = movieFilter.getFiltersRequest()
        
        var urlString = "\(Constants.ApiRequest.mainUrl)movie?search=\(name)&field=name&isStrict=false"
        urlString += "&token=\(apiToken)"
        urlString += pageRequest
        urlString += filterRequest
        urlString += sortType
        urlString += "&limit=\(Constants.downloadDataNumber)"
        
        let strUrlFormatted = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        guard let url = URL(string: strUrlFormatted) else { return }
        
        AF.request(url).responseData { response in
            if let data = response.value,
               response.response?.statusCode == 200 {
                do {
                    let results = try JSONDecoder().decode(MovieSearch.self, from: data)
                    completion(.success(results))
                } catch {
                    completion(.failure(.wrongData))
                }
            } else {
                completion(.failure(.noData))
            }
        }
    }
}
