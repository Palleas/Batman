import Foundation
import Result

struct Builder {
    enum BuilderError: Error, Equatable {
        case missingContent
        
    }
    
    static func task(from content: String) -> Result<(title: String, note: String?), BuilderError> {
        return .failure(.missingContent)
    }
}
