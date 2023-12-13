import Foundation

class NetworkingManager {
    static var shared = NetworkingManager()

    //a5acad8822604b7281f78f3a58027d50
    //165c9017208a410c9bec977d1bb838f6
    func searchNews(searchText: String, completionHandler: @escaping (Result<[Article], Error>) -> Void) {
        let currentDate = getPreviousDateFormatted()
        let urlString = "https://newsapi.org/v2/everything?q=\(searchText)&from=\(currentDate)&sortBy=popularity&apiKey=a5acad8822604b7281f78f3a58027d50"

        print(urlString)
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completionHandler(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "Invalid response", code: 0, userInfo: nil)
                completionHandler(.failure(error))
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601 // Handle ISO8601 date format
                    let result = try decoder.decode(NewsData.self, from: data)
                    completionHandler(.success(result.articles))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    
    func getTopHeadLinesNews(completionHandler: @escaping (Result<[Article], Error>) -> Void) {
        let countryCode = getCurrentCountryCode()
        let urlString = "https://newsapi.org/v2/top-headlines?country=ca&apiKey=a5acad8822604b7281f78f3a58027d50"

        print(urlString)
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completionHandler(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "Invalid response", code: 0, userInfo: nil)
                completionHandler(.failure(error))
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601 // Handle ISO8601 date format
                    let result = try decoder.decode(NewsData.self, from: data)
                    completionHandler(.success(result.articles))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func getSources(completionHandler: @escaping (Result<[Source], Error>) -> Void) {

        let urlString = "https://newsapi.org/v2/top-headlines/sources?apiKey=a5acad8822604b7281f78f3a58027d50"

        print(urlString)
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completionHandler(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "Invalid response", code: 0, userInfo: nil)
                completionHandler(.failure(error))
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601 // Handle ISO8601 date format
                    let result = try decoder.decode(SourceData.self, from: data)
                    completionHandler(.success(result.sources))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }
        task.resume()
    }

    func getCurrentDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
    

    func getPreviousDateFormatted() -> String {
        let currentDate = Date()
        if let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: previousDate)
        } else {

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: currentDate)
        }
    }
}


func getCurrentCountryCode() -> String? {
    let currentLocale = Locale.current
    if let countryCode = currentLocale.region?.identifier {
        return countryCode
    } else {
        // Handle the case where the region code is not available
        return "ca"
    }
}
//
//// Example usage
//if let countryCode = getCurrentCountryCode() {
//    print("Current Country Code: \(countryCode)")
//} else {
//    print("Unable to retrieve current country code.")
//}
