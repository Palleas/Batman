// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import UIKit

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable type_body_length

protocol StoryboardSceneType {
  static var storyboardName: String { get }
}

extension StoryboardSceneType {
  static func storyboard() -> UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: Bundle(for: BundleToken.self))
  }

  static func initialViewController() -> UIViewController {
    guard let vc = storyboard().instantiateInitialViewController() else {
      fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
    }
    return vc
  }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
  func viewController() -> UIViewController {
    return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
  }
  static func viewController(identifier: Self) -> UIViewController {
    return identifier.viewController()
  }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
  func perform<S: StoryboardSegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    performSegue(withIdentifier: segue.rawValue, sender: sender)
  }
}

enum StoryboardScene {
  enum Main: String, StoryboardSceneType {
    static let storyboardName = "Main"

    case createScene = "Create"
    static func instantiateCreate() -> Batman.CreateViewController {
      guard let vc = StoryboardScene.Main.createScene.viewController() as? Batman.CreateViewController
      else {
        fatalError("ViewController 'Create' is not of the expected class Batman.CreateViewController.")
      }
      return vc
    }

    case projectsScene = "Projects"
    static func instantiateProjects() -> Batman.ProjectsViewController {
      guard let vc = StoryboardScene.Main.projectsScene.viewController() as? Batman.ProjectsViewController
      else {
        fatalError("ViewController 'Projects' is not of the expected class Batman.ProjectsViewController.")
      }
      return vc
    }
  }
}

enum StoryboardSegue {
  enum Main: String, StoryboardSegueType {
    case toolbar
  }
}

private final class BundleToken {}
