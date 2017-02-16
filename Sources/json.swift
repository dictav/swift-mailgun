import Foundation

protocol JSON {}
extension String: JSON {}
extension Int: JSON {}
extension Float: JSON {}
extension Bool: JSON {}

func convertToJSON(_ a: Any) -> JSON? {
    switch a {
    case let str as String: return str
    case let i as Int: return i
    case let f as Float: return f
    case let tof as Bool: return tof
    case let json as JSON: return json
    case let obj as [String:Any]: return JSONObject(from: obj)
    case let arr as [Any]: return JSONArray(from: arr)
    default:
        print("[DEBUG] it is not JSON: \(type(of:a))")
        return nil
    }
}

struct JSONObject: JSON, Sequence {
    var dict: [String:JSON]

    init?(from: [String:Any]) {
        var dict = [String:JSON]()
        for (key,json) in from {
            guard let v = convertToJSON(json) else {
                return nil
            }
            dict[key] = v
        }
        self.dict = dict
    }

    subscript(key: String) -> JSON? {
        get { return dict[key] }
        set { dict[key] = newValue }
    }

    func makeIterator() -> DictionaryIterator<String, JSON> {
        return self.dict.makeIterator()
    }

    var description: String {
        return dict.description
    }
}

struct JSONArray: JSON, Sequence {
    var array: [JSON]

    init?(from: [Any]) {
        var array = [JSON]()
        for json in from {
            guard let v = convertToJSON(json) else {
                return nil
            }
            array.append(v)
        }
        self.array = array
    }

    subscript(index: Int) -> JSON {
        get { return array[index] }
        set { array[index] = newValue}
    }

    func makeIterator() -> IndexingIterator<Array<JSON>> {
        return self.array.makeIterator()
    }
}
