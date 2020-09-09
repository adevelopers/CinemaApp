//
//  NavigationController.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 27.05.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit


class NavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
    
}
