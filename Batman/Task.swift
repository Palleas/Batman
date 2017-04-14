//
//  Task.swift
//  Batman
//
//  Created by Romain Pouclet on 2017-04-14.
//  Copyright © 2017 Perfectly-Cooked. All rights reserved.
//

import Foundation

struct Task {
    typealias Response = Task
    
    let name: String
    
    let notes: String
    
    let projects: [Project]
}

extension Task: Encodable {
    
    func encode() -> Data? {
        let projectIds = projects.map({ "\($0.id)" }).joined(separator: ",")
        
        let payload = [("name", name), ("notes", notes), ("projects", "\(projectIds)")]
            .map { "\($0.0)=\($0.1)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        
        print("Payload = \(payload!)")
        
        return payload?.data(using: .utf8)
    }
    
}
