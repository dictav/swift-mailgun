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
    func get(path: String, opts: [String:String] = [:], completion: @escaping (Any?, Swift.Error?) -> ()) -> URLSessionDataTask {
        let s = URLSession.shared
        let url = URL(string: endpoint + path)!
        let task = s.dataTask(with: url) {
            (data, res, err) in
            guard err == nil else {
                completion(nil, err)
                return
            }

            let httpRes = res as! HTTPURLResponse
            guard 200..<300 ~= httpRes.statusCode else {
                completion(nil, Error(message: "status error"))
                return
            }

            if let d = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: d, options: .allowFragments)
                    completion(json, nil)

                } catch(let err) {
                    completion(nil, err)
                }
            }
            completion(nil, Error(message: "unexpected error"))
        }
        task.resume()
        return task
    }

    func getSync(path: String, opts: [String:String] = [:]) -> (Any?, Swift.Error?) {
        let sema = DispatchSemaphore(value: 0)
        var json: Any?
        var err: Swift.Error?
        let task = get(path: path, opts: opts) {
            d, e in
            json = d
            err = e

            sema.signal()
        }

        let timeout = DispatchTime(uptimeNanoseconds: timeoutSeconds)
        switch sema.wait(timeout: timeout) {
        case .success:
            if let e = err {
                return (nil, e)
            }
            if let j = json {
                return (j, nil)
            }
        case .timedOut:
            task.cancel()
            return (nil, Error(message: "get Google timeout error"))

        }
        return (nil, Error(message: "get Google unexpected error"))
    }
}
