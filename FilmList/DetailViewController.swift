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
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var plotView: UITextView!
    @IBOutlet weak var urlIMDBLabel: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    

    @IBAction func urlIMDBButtonPressed(sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: urlIMDBString)! as URL)

    }
    
    
    
    
    //data from previous controller
    var titleString:String!
    var yearString:String!
    var imageString:String!
    var releaseDateString:String!
    var plotString:String!
    var urlIMDBString:String!
    var ratingString:String!
    var ratedString:String!
    var votesString:String!
    var typeString:String!
    
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
        self.plotView.text = plotString
        self.releaseDateLabel.text = "Released: \(releaseDateString!)"
        self.urlIMDBLabel.setTitle("IMDB Link", for: UIControlState.normal)
        self.ratingLabel.text = "Rating: \(ratingString!)"
        self.ratedLabel.text = "Rated: \(ratedString!)"
        self.votesLabel.text = "Votes: \(votesString!)"
        self.typeLabel.text = "Type: \(typeString!)"
        
        
        let imgURL = URL(string:imageString)
        
        let data = NSData(contentsOf: (imgURL)!)
        self.imageView.image = UIImage(data: data as! Data)
        

    }
    
    func urlIMDBButtonPressed() {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        plotView.scrollRangeToVisible(NSMakeRange(0,0))
    }
}
