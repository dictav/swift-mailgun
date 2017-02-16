import Foundation

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

func get(path: String, opts: [String:String] = [:], completion: @escaping ResultCompletion<JSON>) -> URLSessionDataTask {
    guard let session = urlSession else {
        fatalError("Please setup with Mailgun()")
    }

    let url = URL(string: endpoint + path)!
    let task = session.dataTask(with: url) {
        (data, res, err) in
        guard err == nil else {
            let result = Result<JSON>(value: nil, error: err!)
            completion(result)
            return
        }

        let httpRes = res as! HTTPURLResponse
        guard 200..<300 ~= httpRes.statusCode else {
            let result = Result<JSON>(value: nil, error: Error(message: "status error"))
            completion(result)
            return
        }

        guard let d = data else {
            completion( Result<JSON>(value: nil, error: Error(message: "unexpected error")))
            return
        }

        let jsonResult = result{
            try JSONSerialization.jsonObject(with: d, options: .allowFragments)
        }
        guard jsonResult.error == nil else {
            completion(Result<JSON>(value: nil, error: jsonResult.error!))
            return
        }

        guard let json = convertToJSON(jsonResult.value) else {
            completion(Result<JSON>(
                value: nil,
                error: Error(message: "convertToJSON: unexpected error")
            ))
            return
        }

        completion(Result<JSON>(value: json, error: nil))
    }
    task.resume()
    return task
}

func getSync(path: String, opts: [String:String] = [:]) -> (Result<JSON>) {
    let sema = DispatchSemaphore(value: 0)
    var result = Result<JSON>(value: nil, error: Error(message:"initial result"))
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
        return Result<JSON>(value: nil, error: Error(message: "timeout error"))
    }
}
