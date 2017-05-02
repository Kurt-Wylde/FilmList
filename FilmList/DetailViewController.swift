//
//  DataViewController.swift
//  FilmList
//
//  Created by Kurt on 02.05.17.
//  Copyright © 2017 Evgeny Koshkin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //current controller IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    //data from previous controller
    var titleString:String!
    var yearString:String!
    var imageString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        self.titleLabel.text = titleString
        self.yearLabel.text = yearString
        
        let imgURL = URL(string:imageString)
        
        let data = NSData(contentsOf: (imgURL)!)
        self.imageView.image = UIImage(data: data as! Data)
    }
}
