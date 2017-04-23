import Foundation

/// Retrieve a secure key
/// (First look in the BuddyBuildSDK secure device keys,
/// then look in Process environment variable)
///
/// - Parameter key: name of the key
/// - Returns: value for the key
func keyOrProcessEnv(_ key: String) -> String {
    if let deviceKey = BuddyBuildSDK.value(forDeviceKey: key) {
        return deviceKey
    } else if let envKey = ProcessInfo.processInfo.environment[key] {
        return envKey
    }
    
    fatalError("Key not found either in Buddybuild or in env: \(key)")
}
