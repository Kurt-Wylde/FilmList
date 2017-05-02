//
//  Watched.swift
//  FilmList
//
//  Created by Kurt on 03.05.17.
//  Copyright © 2017 Evgeny Koshkin. All rights reserved.
//

import UIKit

class Watched: UITableViewController {
    
    
    private var filmItems = [FilmItem]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Watched movies"
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        //self.navigationController?.navigationBar.titleTextAttributes? = [NSForegroundColorAttributeName: UIColor.white]
        
        
        // Setup a notification to let us know when the app is about to close,
        // and that we should store the user items to persistence. This will call the
        // applicationDidEnterBackground() function in this class
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)),
            name: NSNotification.Name.UIApplicationDidEnterBackground,
            object: nil)
        
        do
        {
            // Try to load from persistence
            self.filmItems = try [FilmItem].readFromPersistence()
        }
        catch let error as NSError
        {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError
            {
                NSLog("No persistence file found, not necesserially an error...")
            }
            else
            {
                let alert = UIAlertController(
                    title: "Error",
                    message: "Could not load the list items!",
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                NSLog("Error loading from persistence: \(error)")
            }
        }
    }

}
