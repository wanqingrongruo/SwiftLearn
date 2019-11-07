import UIKit

var str = "Hello, 基于泛型的设计"

struct User {
}

struct Post {

}

struct Resource<T> {
    let url: URL
    let parse: (Data) throws -> T
}

extension Resource where T: Decodable {
    init(_ json: URL) {
        self.url = json
        self.parse = { data in
            try JSONDecoder().decode(T.self, from: data)
        }
    }
}

struct NoDataError: Error {

}

extension URLSession {
    func loadUser<A>(r: Resource<A>, callback: @escaping ((Result<A, Error>) -> Void)) {
        dataTask(with: r.url) { (data, response, error) in
            callback(Result {
                if let e = error { throw e }
                guard let d = data else { throw NoDataError() }
                return try r.parse(d)
            })
        }.resume()
    }
}
