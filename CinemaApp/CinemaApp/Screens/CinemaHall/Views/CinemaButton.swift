//
//  CinemaButton.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 09.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit


class CinameButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .title
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.title.cgColor
        layer.shadowRadius = 12
        layer.shadowOpacity = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = layer.bounds
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 8, y: 8, width: bounds.width - 16, height: bounds.height)).cgPath
    }
}
