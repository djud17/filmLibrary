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
}

protocol StorageProtocol {
    func writeTo(object: Movie) throws
    func readFrom() -> [Movie]
    func deleteFrom(by objectId: Int) throws
    func checkItemIn(by objectId: Int) -> Bool
}

final class RealmStorage: StorageProtocol {
    static let shared = RealmStorage()
    
    private let realm = try? Realm()
    private let realmConverter: ConverterProtocol = RealmConverter.shared
    
    func writeTo(object: Movie) throws {
        guard let realm else { return }
        
        let realmObject = realmConverter.convertToRealm(object: object)
        
        do {
            try realm.write { realm.add(realmObject) }
        } catch {
            throw RealmError.writeError
        }
    }
    
    func readFrom() -> [Movie] {
        guard let realm else { return [] }
        
        let objects = realm.objects(RealmMovie.self)
        var movies = [Movie]()
        
        for realmObject in objects {
            let movie = realmConverter.convertFromRealm(object: realmObject)
            movies.append(movie)
        }
        
        return movies
    }
    
    func deleteFrom(by objectId: Int) throws {
        guard let realm else { return }
        
        let objects = realm.objects(RealmMovie.self)
        let deleteObject = objects.first { $0.id == objectId }
        
        guard let deleteObject = deleteObject else { return }
        
        do {
            try realm.write { realm.delete(deleteObject) }
        } catch {
            throw RealmError.deleteError
        }
    }
    
    func checkItemIn(by objectId: Int) -> Bool {
        guard let realm else { return false }
        
        let objects = realm.objects(RealmMovie.self)
        
        return objects.filter { $0.id == objectId }.count > 0
    }
}

// MARK: - Realm struct

final class RealmMovie: Object {
    @objc dynamic var poster = ""
    @objc dynamic var rating = 0.0
    @objc dynamic var movieLength = 0
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var movieDescription = ""
    @objc dynamic var year = 0
    @objc dynamic var shortDescription = ""
}

// MARK: - Realm Converter

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
