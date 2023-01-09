//
//  Persistance.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 10.01.2023.
//

import RealmSwift

enum RealmError: Error {
    case writeError
    case deleteError
    case readError
}

protocol StorageProtocol {
    func writeTo(object: Movie) throws
    func readFrom() throws -> [Movie]
    func deleteFrom(object: Movie) throws
}

final class RealmStorage: StorageProtocol {
    static let shared = RealmStorage()
    
    private let realm = try? Realm()
    private let realmConverter = RealmConverter.shared
    
    func writeTo(object: Movie) throws {
        guard let realm else { return }
        
        let realmObject = realmConverter.convertToRealm(object: object)
        
        do {
            try realm.write { realm.add(realmObject) }
        } catch {
            throw RealmError.writeError
        }
    }
    
    func readFrom() throws -> [Movie] {
        guard let realm else { return [] }
        
        let objects = realm.objects(RealmMovie.self)
        var movies = [Movie]()
        
        if objects.isEmpty {
            throw RealmError.readError
        } else {
            for realmObject in objects {
                let movie = realmConverter.convertFromRealm(object: realmObject)
                movies.append(movie)
            }
        }
        
        return movies
    }
    
    func deleteFrom(object: Movie) throws {
        guard let realm else { return }
        
        let realmObject = realmConverter.convertToRealm(object: object)
        
        do {
            try realm.write { realm.delete(realmObject) }
        } catch {
            throw RealmError.deleteError
        }
    }
}

private final class RealmMovie: Object {
    @objc dynamic var poster = ""
    @objc dynamic var rating = 0.0
    @objc dynamic var movieLength = 0
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var movieDescription = ""
    @objc dynamic var year = 0
    @objc dynamic var shortDescription = ""
}

private protocol ConverterProtocol {
    func convertToRealm(object: Movie) -> RealmMovie
    func convertFromRealm(object: RealmMovie) -> Movie
}

private final class RealmConverter: ConverterProtocol {
    static let shared = RealmConverter()
    
    func convertToRealm(object: Movie) -> RealmMovie {
        let realmMovie = RealmMovie()
        realmMovie.poster = object.poster?.previewUrl ?? ""
        realmMovie.rating = object.rating.kinopoisk
        realmMovie.movieLength = object.movieLength ?? 0
        realmMovie.id = object.id
        realmMovie.name = object.name
        realmMovie.movieDescription = object.description ?? ""
        realmMovie.year = object.year ?? 0
        realmMovie.shortDescription = object.shortDescription ?? ""
        
        return realmMovie
    }
    
    func convertFromRealm(object: RealmMovie) -> Movie {
        let poster = Poster(previewUrl: object.poster)
        let rating = Rating(kinopoisk: object.rating)
        
        let movie = Movie(poster: poster,
                          rating: rating,
                          movieLength: object.movieLength,
                          id: object.id,
                          name: object.name,
                          description: object.movieDescription,
                          year: object.year,
                          shortDescription: object.shortDescription)
        
        return movie
    }
}
