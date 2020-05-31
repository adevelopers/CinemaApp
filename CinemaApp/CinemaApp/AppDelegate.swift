//
//  AppDelegate.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 27.05.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var store: AppStore = AppStore()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        store.movies
            .accept(MovieService().movies())
        
        // build controller
//        let controller = FilmsGalleryViewController.init(movies: store.movies)
        //
        
        window = UIWindow()
        window?.rootViewController = NavigationController(rootViewController: Animator2ViewController())
        window?.makeKeyAndVisible()
        
        return true
    }

}
