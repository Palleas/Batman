import Foundation


final class Store {
    
    var selectedProjectId: Int? {
        get {
            return UserDefaults.standard.integer(forKey: "project_id")
        }
        
        set(id) {
            UserDefaults.standard.set(id, forKey: "project_id")
            UserDefaults.standard.synchronize()
        }
    }
    
}
