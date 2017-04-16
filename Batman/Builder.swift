import Foundation
import Result

protocol AutoEquatable {}

struct Builder {
    enum BuilderError: Error, AutoEquatable {
        case missingContent
    }
    
    typealias TitleAndNotes = (title: String, notes: String?)
    static func task(from content: String) -> Result<TitleAndNotes, BuilderError> {
        let scanner = Scanner(string: content)
        
        var extractedTitle: NSString?
        scanner.scanUpToCharacters(from: .newlines, into: &extractedTitle)
        
        guard let title = extractedTitle else { return .failure(.missingContent) }
        
        guard !scanner.isAtEnd else { return .success((title: title as String, notes: nil) as TitleAndNotes) }
        
        let notes = content
            .substring(from: content.index(content.startIndex, offsetBy: scanner.scanLocation))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return .success((title: title as String, notes: notes) as TitleAndNotes)
    }
}
