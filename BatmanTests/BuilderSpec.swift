import Quick
import Nimble
import Result

@testable import Batman

class BuilderSpec: QuickSpec {
    
    override func spec() {
        describe("builder") {
            typealias TaskResult = (title: String, note: String?)
            
            it("retrieves a title and a note") {
                let content = load(.file("task-content"))
                let result = Builder.task(from: content)

                expect(result.value?.title) == "This is a very important task to do"
                expect(result.value?.note) == "For the following reason\n* Reason 1\n* Reason 2\n* Reason 3"
            }
            
            it("fails when the content is empty") {
                
            }
            
            it("fails when the content is only spaces") {
                
            }
        }
    }
    

}

enum Fixture {
    case file(String)
}

func load(_ fixture: Fixture) -> String {
    guard case let .file(name) = fixture else {
        fatalError("Invalid fixture \(fixture)!")
    }
    
    guard let url = Bundle(for: BuilderSpec.self).url(forResource: name, withExtension: "md", subdirectory: "fixtures") else {
        fatalError("Fixture file \(name).md does not exist!")
    }
    
    guard let data = try? Data(contentsOf: url), let content = String(data: data, encoding: .utf8) else {
        fatalError("Unable to load Fixture file \(name).md!")
    }
    
    return content
}
