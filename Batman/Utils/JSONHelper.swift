import Foundation
import Unbox
import Result

func decode<T: Unboxable>(from data: Data) -> Result<T, UnboxError> {
    return Result(attempt: { () -> T in
        let content: [String: T] = try unbox(data: data)

        guard let object = content["data"] else {
            throw UnboxError.invalidData
        }

        return object
    })
}

func decodeArray<T: Unboxable>(from data: Data) -> Result<[T], UnboxError> {
    return Result(attempt: { () -> [T] in
        return try unbox(data: data, atKeyPath: "data")
    })
}

func decodeErrors(from data: Data) throws -> [AsanaError] {
    return try unbox(data: data, atKeyPath: "errors")
}

struct AsanaError: Error, Unboxable {
    let message: String

    init(unboxer: Unboxer) throws {
        self.message = try unboxer.unbox(key: "message")
    }

    init(message: String) {
        self.message = message
    }
}

extension AsanaError: AutoEquatable {}

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

extension ProjectColor: UnboxableEnum {}
