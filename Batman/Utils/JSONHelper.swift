import Foundation
import Unbox
import Result

func decode<T: Unboxable>(from data: Data) -> Result<T, UnboxError> {
    do {
        let result: [String: T] = try unbox(data: data)
        return .success(result["data"]!)
    } catch {
        return .failure(error as! UnboxError)
    }
}

func decode<T: Unboxable>(from data: Data) -> Result<[T], UnboxError> {
    do {
        let result: [T] = try unbox(data: data, atKeyPath: "data")
        return .success(result)
    } catch {
        return .failure(error as! UnboxError)
    }
}

protocol Encodable {
    associatedtype Response: Unboxable
    
    func encode() -> Data?
    
}

protocol Boxable {
    
    var encoded: [AnyHashable: Any] { get }
    
}

extension Array where Element: Boxable {
    
    func encode() throws -> Data {
        let encoded = map { $0.encoded }
        return try JSONSerialization.data(withJSONObject: encoded, options: .prettyPrinted)
    }
    
}

