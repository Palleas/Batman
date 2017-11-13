import Quick
import Nimble
import OHHTTPStubs
import Result

@testable import Batman

class ClientSpec: QuickSpec {
    override func spec() {
        describe("Client") {
            afterEach {
                OHHTTPStubs.removeAllStubs()
            }

            let client = Client(token: Token(value: "invalid-token"))

            it("handles Asana errors") {
                stub(condition: isHost("app.asana.com"), response: { _ in
                    let response = ["errors": [
                        ["message": "Not Authorized"]
                    ]]

                    return OHHTTPStubsResponse(data: try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted), statusCode: 401, headers: [:]) // swiftlint:disable:this force_try
                })

                let result = client.projects().first()!

                guard case let .failure(error) = result, case let .requestError(asanaErrors) = error else {
                    fail("Expected client to fail")
                    return
                }

                expect(asanaErrors) == [AsanaError(message: "Not Authorized")]
            }

            it("handles resources not found") {
                stub(condition: isHost("app.asana.com"), response: { _ in
                    let response = ["errors": [
                        ["message": "Not Found"]
                    ]]

                    return OHHTTPStubsResponse(data: try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted), statusCode: 404, headers: [:]) // swiftlint:disable:this force_try
                })

                let result = client.project(id: 18282).first()!

                guard case let .failure(error) = result else {
                    fail("Expected client to fail")
                    return
                }

                expect(error) == Client.ClientError.doesNotExist
            }

            it("explodes") {
                let b: Client! = nil
                b.projects().startWithResult { _ in print("Sup?") }
            }
        }
    }
}
