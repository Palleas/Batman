import Quick
import Nimble
import Result
import ReactiveSwift
import OHHTTPStubs

@testable import Batman

func mock(_ endpoint: Client.Endpoint, with file: String) {
    stub(condition: isPath("/api/1.0\(endpoint.path)")) { _ in
        let path = Bundle(for: ProjectsControllerSpec.self).path(forResource: file, ofType: "json", inDirectory: "fixtures")!
        return fixture(filePath: path, headers: ["content-type": "application/json"])
    }
    
}

class ProjectsControllerSpec: QuickSpec {
    override func spec() {
        describe("ProjectsController") {
            var cache: URL!
            var client: Client!

            beforeEach {
                cache = URL(fileURLWithPath: NSTemporaryDirectory())
                client = Client(token: Token(value: "le-token"))
            }
            
            afterEach {
                OHHTTPStubs.removeAllStubs()
                cache = nil
                client = nil
            }
            
            it("fetches projects from the server") {
                mock(.projects, with: "projects")
                
                let controller = ProjectsController(client: client, cacheDirectory: cache)
                let result = controller.fetchFromRemote().first()!
                
                guard case .success(let projects) = result else {
                    fail("Invalid response from projects")
                    return
                }
                
                let expected = [
                    Project(id: 567897654345678, name: "Backlog", color: .darkPurple),
                    Project(id: 789098765432, name: "Help", color: .darkWarmGray),
                    Project(id: 1234567890, name: "Untriaged Bugs", color: nil)
                ]
                
                expect(projects.count) == 3
                expect(projects) == expected
            }
            
            it("fetches projects from the cache when available") {
                let cachedProjects = cache.appendingPathComponent("projects.json")
                try! JSONSerialization.data(withJSONObject: [
                    "data": [["id": 567897654345678, "name": "Cached Backlog", "color": "dark-purple"]]
                ], options: .prettyPrinted).write(to: cachedProjects)
                
                let controller = ProjectsController(client: client, cacheDirectory: cache)
                
                let result = controller.fetchFromCache().first()!
                
                guard case .success(let projects) = result else {
                    fail("Invalid response from projects")
                    return
                }
                
                expect(projects.count) == 1
                expect(projects) == [Project(id: 567897654345678, name: "Cached Backlog", color: .darkPurple)]
            }

            pending("Not implemented yet") {
                it("throws an error when the cache is expired") {
    //                let cachedProjects = cache.appendingPathComponent("projects.json")
    //                try! JSONSerialization.data(withJSONObject: [
    //                    "data": [["id": 567897654345678, "name": "Cached Backlog", "color": "dark-purple"]]
    //                ], options: .prettyPrinted).write(to: cachedProjects)
    //
    //                try! FileManager.default.setAttributes([.creationDate: Date.distantPast], ofItemAtPath: cachedProjects.path)
                }
                
                it("falls back to fetching remotely when the cache is invalid") {
                    
                }
            }
        }
    }
}
