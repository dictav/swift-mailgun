import Foundation
import Result

let endpoint = "https://api.mailgun.net/v3"
let timeout: DispatchTimeInterval = .seconds(30)

var urlSession: URLSession?

func Mailgun(key: String, config: URLSessionConfiguration = URLSession.shared.configuration) {
    let apiKey = "api:\(key)"
    let data = apiKey.data(using: String.Encoding.utf8)!
    let credential = data.base64EncodedString()

    config.httpAdditionalHeaders = ["Authorization" : "Basic \(credential)"]
    urlSession = URLSession(configuration: config)
}

func get(path: String, opts: [String:String] = [:], completion: @escaping ResultCompletion<JSON,Error>) -> URLSessionDataTask {
    guard let session = urlSession else {
        fatalError("Please setup with Mailgun()")
    }

    let url = URL(string: endpoint + path)!
    let task = session.dataTask(with: url) {
        (data, res, err) in
        guard err == nil else {
            completion(.failure(err as! Error))
            return
        }

        let httpRes = res as! HTTPURLResponse
        guard 200..<300 ~= httpRes.statusCode else {
            completion(.failure(Error(message: "status error")))
            return
        }

        guard let d = data else {
            completion(.failure(Error(message: "unexpected error")))
            return
        }

        let jsonResult = Result<Any,Error>(attempt:{
            try JSONSerialization.jsonObject(with: d, options: .allowFragments)
        })
        guard jsonResult.error == nil else {
            completion(.failure(jsonResult.error!))
            return
        }

        guard let json = convertToJSON(jsonResult.value!) else {
            completion(.failure(Error(message: "convertToJSON: unexpected error")))
            return
        }

        completion(.success(json))
    }
    task.resume()
    return task
}

func getSync(path: String, opts: [String:String] = [:]) -> Result<JSON,Error> {
    let sema = DispatchSemaphore(value: 0)
    var result: Result<JSON, Error> = .failure(Error(message:"initial result"))
    let task = get(path: path, opts: opts) {
        res in
        result = res
        sema.signal()
    }

    switch sema.wait(timeout: .now() + timeout) {
    case .success:
        return result
    case .timedOut:
        task.cancel()
        return .failure(Error(message: "timeout error"))
    }
}
