//
//  Task.swift
//  Batman
//
//  Created by Romain Pouclet on 2017-04-14.
//  Copyright © 2017 Perfectly-Cooked. All rights reserved.
//

import Foundation
import Unbox

struct Task {
    typealias Response = CreatedTask
    
    let name: String
    
    let notes: String
    
    let projects: [Project]
}

extension Task: Encodable {
    
    func encode() -> Data? {
        let projectIds = projects.map({ "\($0.id)" }).joined(separator: ",")
        
        let payload = [("name", name), ("notes", notes), ("projects", "\(projectIds)")]
            .map { "\($0.0)=" + $0.1.addingPercentEncoding(withAllowedCharacters: .alphanumerics)! }
            .joined(separator: "&")
        
        return payload.data(using: .utf8)
    }
    
}

struct CreatedTask {
    let id: Int
    
    func url() -> URL {
        return URL(string: "https://app.asana.com/0/0/\(id)")!
    }

}

extension CreatedTask: Unboxable {
    init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
    }
}
