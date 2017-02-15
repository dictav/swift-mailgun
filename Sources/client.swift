import Foundation

let endpoint = "https://api.mailgun.net/v3"
let timeoutSeconds = 10_000_000_000_000 as UInt64 // 10sec
struct Client {
    var aSession : URLSession?

    var session: URLSession {
        get {
            return self.aSession ?? URLSession.shared
        }
    }
}

extension Client {
    func get(path: String, opts: [String:String] = [:], completion: @escaping ResultCompletion<JSON>) -> URLSessionDataTask {
        let s = URLSession.shared
        let url = URL(string: endpoint + path)!
        let task = s.dataTask(with: url) {
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

            if let d = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: d, options: .allowFragments)
                    let result = Result<JSON>(value: json as! JSON, error: nil)
                    completion(result)

                } catch(let err) {
                    let result = Result<JSON>(value: nil, error: err)
                    completion(result)
                }
            }
            let result = Result<JSON>(value: nil, error: Error(message: "unexpected error"))
            completion(result)
        }
        task.resume()
        return task
    }

    func getSync(path: String, opts: [String:String] = [:]) -> (Result<JSON>) {
        let sema = DispatchSemaphore(value: 0)
        var result = Result<JSON>(value: nil, error: Error(message:"unexpected error"))
        let task = get(path: path, opts: opts) {
            res in
            result = res
            sema.signal()
        }

        let timeout = DispatchTime(uptimeNanoseconds: timeoutSeconds)
        switch sema.wait(timeout: timeout) {
        case .success:
            return result
        case .timedOut:
            task.cancel()
            return Result<JSON>(value: nil, error: Error(message: "get Google timeout error"))
        }
    }
}
