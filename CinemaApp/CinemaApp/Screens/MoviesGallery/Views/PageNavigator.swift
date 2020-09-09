//
//  PageNavigator.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 09.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit


class PageNavigator: UIPageControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        pageIndicatorTintColor = .note
        currentPageIndicatorTintColor = .title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

