//
//  ViewController.swift
//  Batman
//
//  Created by Romain Pouclet on 2017-04-12.
//  Copyright © 2017 Perfectly-Cooked. All rights reserved.
//

import UIKit

protocol CreateViewControllerDelegate: class {
    func didTapSelectProject()
}

final class CreateViewController: UIViewController {

    weak var delegate: CreateViewControllerDelegate?
    
    @IBAction func didTapCreate() {
        delegate?.didTapSelectProject()
    }
}

