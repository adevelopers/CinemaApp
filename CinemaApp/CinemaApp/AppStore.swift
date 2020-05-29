//
//  AppStore.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 27.05.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import Foundation


class AppStore {
    
    var movies: Variable<[Movie]> = .init([])
    var ticket: Variable<Ticket?> = .init(nil)
    
    init() {
        
    }
}
