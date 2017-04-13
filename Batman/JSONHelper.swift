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
    let debug = String(data: data, encoding: .utf8)!
    print("Debug = \(debug)")

    do {
        let result: [T] = try unbox(data: data, atKeyPath: "data")
        return .success(result)
    } catch {
        return .failure(error as! UnboxError)
    }
}

