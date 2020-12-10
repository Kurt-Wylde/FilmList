
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
