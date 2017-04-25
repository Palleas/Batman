// Generated using Sourcery 0.5.9 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable file_length
fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return compare(lValue, rValue)
    case (nil, nil):
        return true
    default:
        return false
    }
}

fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}

// MARK: - AutoEquatable for classes, protocols, structs
// MARK: - Project AutoEquatable
extension Project: Equatable {} 
internal func == (lhs: Project, rhs: Project) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.name == rhs.name else { return false }
    guard compareOptionals(lhs: lhs.color, rhs: rhs.color, compare: ==) else { return false }
    return true
}

// MARK: - AutoEquatable for Enums
// MARK: - Builder.BuilderError AutoEquatable
extension Builder.BuilderError: Equatable {}
internal func == (lhs: Builder.BuilderError, rhs: Builder.BuilderError) -> Bool {
    switch (lhs, rhs) {
     case (.missingContent, .missingContent): 
         return true 
    default: return false
    }
}
// MARK: - ProjectsController.ProjectsError AutoEquatable
extension ProjectsController.ProjectsError: Equatable {}
internal func == (lhs: ProjectsController.ProjectsError, rhs: ProjectsController.ProjectsError) -> Bool {
    switch (lhs, rhs) {
     case (.noCache, .noCache): 
         return true 
    case (.fetchingError(let lhs), .fetchingError(let rhs)): 
        return lhs == rhs
    default: return false
    }
}

// MARK: -
