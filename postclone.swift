import Foundation
import BuddybuildSwift
import Files

// Create AWS subfolder but doesn't fail if it doesn't exist
let awsConfigFolder: Folder
if Folder.home.containsSubfolder(named: ".aws") {
    print("AWS Config folder already exist")
    awsConfigFolder = try Folder.home.subfolder(named: ".aws")
} else {
    print("AWS Config doesn't exist: creating.")
    awsConfigFolder = try Folder.home.createSubfolder(named: ".aws")
}

// Copy all the aws-* secure files to my home directory
try Buddybuild.build.secureFiles.files
    .filter { $0.name.starts(with: "aws-") }
    .forEach { try $0.copy(to: awsConfigFolder) }
