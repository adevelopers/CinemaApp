//
//  AnimatedChain.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 09.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit


final class AnimatedChain {
    private var next: AnimatedChain?
    private var parent: AnimatedChain?
    private var block: () -> Void
    private var duration: TimeInterval
    
    init(_ duration: TimeInterval, _ block: @escaping ()->Void) {
        self.duration = duration
        self.block = block
    }
    
    func run(){
        UIView.animate(withDuration: duration,
                       animations: block,
                       completion: runNext)
    }
    
    private func runNext(_ isOK: Bool) {
        next?.run()
    }
    
    func then(duration: TimeInterval, _ block: @escaping () -> Void) -> AnimatedChain {
        let animationBlock = AnimatedChain(duration, block)
        animationBlock.parent = self
        self.next = animationBlock
        return animationBlock
    }
    
    func fromFirst() -> AnimatedChain {
        if let parent = parent {
            return parent.fromFirst()
        } else {
            return self
        }
    }
}
