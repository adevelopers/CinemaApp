//
//  Observable.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 27.05.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import Foundation


class Variable<Type> {
    
    typealias Callback = (Type)->Void
     
    private var subscriptions: [Callback] = []
    
    var value: Type {
        didSet {
            notify(value: value)
        }
    }
    
    init(_ value: Type) {
        self.value = value
    }
    
    
    
    private func notify(value: Type) {
        subscriptions.forEach {
            $0(value)
        }
    }
    
    func accept(_ value: Type) {
        self.value = value
    }
    
    func subscribe(_ callback: @escaping Callback) {
        subscriptions.append(callback)
                notify(value: value)
    }
    
}

