//
//  WorkspaceSpec.swift
//  Batman
//
//  Created by Romain Pouclet on 2017-05-08.
//  Copyright © 2017 Perfectly-Cooked. All rights reserved.
//

import Quick
import Nimble
import Unbox

@testable import Batman

class WorkspaceSpec: QuickSpec {
    override func spec() {
        describe("Workspace") {
            let payload: [String: Any] = ["id": 1, "name": "Buddybuild", "is_organization": true]
            let workspace: Workspace = try! unbox(dictionary: payload)
            
            it("has an id") {
                expect(workspace.id) == 1
            }
            
            it("has a name") {
                expect(workspace.name) == "Buddybuild"
            }
            
            it("can be an organization") {
                expect(workspace.isOrganization).to(beTrue())
            }

        }
    }
}
