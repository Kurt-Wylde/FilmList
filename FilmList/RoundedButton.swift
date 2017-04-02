//
//  RoundedButton.swift
//  InMarket
//
//  Created by Kurt on 01.06.16.
//  Copyright © 2016 Evgeny Koshkin. All rights reserved.
//

import Foundation
import UIKit

class BorderedButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //layer.borderWidth = 1.0
        layer.borderColor = tintColor.cgColor
        layer.cornerRadius = 10.0
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        setTitleColor(tintColor, for: .normal)
        setTitleColor(UIColor.white, for: .highlighted)
        //setBackgroundImage(UIImage(color: tintColor), forState: .Highlighted)
    }
}
