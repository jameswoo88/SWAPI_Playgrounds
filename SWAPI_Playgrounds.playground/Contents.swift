import UIKit

struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
    let openingCrawl: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case openingCrawl = "opening_crawl"
        case releaseDate = "release_date"
    }
}

class SwapiService {
    static let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        
        // Step 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(nil) }
        let finalURL = baseURL.appendingPathComponent("people/\(id)")
        
        // Step 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            print("")
            // Step 3 - Handle errors
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            // Step 4 - Check for data
            guard let data = data else { return completion(nil) }
            
            // Step 5 - Decode Person from JSON
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        // Step 1 - Contact server
        URLSession.shared.dataTask(with: url) { data, _, error in
            // Step 2 - Handle errors
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            // Step 3 - Check for data
            guard let data = data else { return }
            
            // Step 4 - Decode Film from JSON
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    
}//End of class

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print()
            print("===========================================================")
            print("Title: \(film.title)")
            print("-----------------------------------------------------------")
            print("Opening Crawl: \(film.openingCrawl)")
            print("-----------------------------------------------------------")
            print("Release Date: \(film.releaseDate)")
        }
    }
}

SwapiService.fetchPerson(id: 5) { person in
    if let person = person {
        print(person.name)
        
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}

