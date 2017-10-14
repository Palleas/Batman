import Foundation
import Result

struct Builder {
    enum BuilderError: Error, AutoEquatable {
        case missingContent
        case somethingElse
    }

    typealias TitleAndNotes = (title: String, notes: String?)
    static func task(from content: String) -> Result<TitleAndNotes, BuilderError> {
        let scanner = Scanner(string: content)

        var extractedTitle: NSString?
        scanner.scanUpToCharacters(from: .newlines, into: &extractedTitle)

        guard let title = extractedTitle else { return .failure(.missingContent) }

        guard !scanner.isAtEnd else { return .success((title: title as String, notes: nil) as TitleAndNotes) }

        let index = content.index(content.startIndex, offsetBy: scanner.scanLocation)
        let notes = content[index...].trimmingCharacters(in: .whitespacesAndNewlines)

        return .success((title: title as String, notes: notes) as TitleAndNotes)
    }
}
