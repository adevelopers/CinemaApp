//
//  SeatButton.swift
//  CinemaApp
//
//  Created by Kirill Khudiakov on 02.06.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import SnapKit



enum SeatButtonState {
    case free, sold, reserved
}

final class SeatButton: UIButton {
    
    var seatState: SeatButtonState = .free {
        didSet {
            switch seatState {
            case .free:
                UIView.animate(withDuration: 0.3) { self.backgroundColor = .white }
            case .sold:
                UIView.animate(withDuration: 0.3) { self.backgroundColor = .soldSeat }
            case .reserved:
                UIView.animate(withDuration: 0.3) { self.backgroundColor = .title }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        addTarget(self, action: #selector(didTap), for: .touchDown)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupUI() {}
    private func setupConstraints() {}
    
    @objc
    private func didTap() {
        print("Заказ")
        switch seatState {
        case .free:
            seatState = .reserved
        case .reserved:
            seatState = .free
        case .sold:
            ()
        }
    }
}


protocol Copying {
    init(_ prototype: Self)
}

extension Copying {
    func copy() -> Self {
        return type(of: self).init(self)
    }
}

extension SeatButton: Copying {
    convenience init(_ prototype: SeatButton) {
        self.init(frame: .zero)
        titleLabel?.text = prototype.titleLabel?.text
    }
    
    
}
