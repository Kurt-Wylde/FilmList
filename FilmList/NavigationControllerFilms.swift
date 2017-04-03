//
//  NavigationControllerFilms.swift
//  FilmList
//
//  Created by Kurt on 03.04.17.
//  Copyright © 2017 Evgeny Koshkin. All rights reserved.
//

import Foundation
import UIKit

class NavigationControllerFilms: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar white font
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.tintColor = UIColor.white
    }
}
