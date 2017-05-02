//
//  TopList.swift
//  FilmList
//
//  Created by Kurt on 16.04.17.
//  Copyright © 2017 Evgeny Koshkin. All rights reserved.
//

import UIKit
import Foundation
    
class TopList: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
        //This is a url to JSON (a bit modified json from the myapifilms.com. It's static. The live top250 json from myapifilms.com is hard to deploy in the app)
        final let urlString = "https://api.myjson.com/bins/pvitx"
        //Old url "http://api.myapifilms.com/imdb/top?start=1&end=10&token=67fc7a85-30c9-4031-a604-f126d958e077&format=json&data=0"
        
        @IBOutlet weak var tableView: UITableView!
        
        var titleArray = [String]()
        var yearArray = [String]()
        var imgURLArray = [String]()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.downloadJsonWithURL()
            
            // Do any additional setup after loading the view, typically from a nib.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        func downloadJsonWithURL() {
            let url = NSURL(string: urlString)
            URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    print(jsonObj!.value(forKey: "movies")!)
                    
                    if let actorArray = jsonObj!.value(forKey: "movies") as? NSArray {
                        for actor in actorArray{
                            if let actorDict = actor as? NSDictionary {
                                if let name = actorDict.value(forKey: "title") {
                                    self.titleArray.append(name as! String)
                                }
                                if let name = actorDict.value(forKey: "year") {
                                    self.yearArray.append(name as! String)
                                }
                                if let name = actorDict.value(forKey: "urlPoster") {
                                    self.imgURLArray.append(name as! String)
                                }
                                
                            }
                        }
                    }
                    
                    OperationQueue.main.addOperation({
                        self.tableView.reloadData()
                    })
                }
            }).resume()
        }
        
        
        //    func downloadJsonWithTask() {
        //
        //        let url = NSURL(string: urlString)
        //
        //        var downloadTask = URLRequest(url: (url as? URL)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        //
        //        downloadTask.httpMethod = "GET"
        //
        //        URLSession.shared.dataTask(with: downloadTask, completionHandler: {(data, response, error) -> Void in
        //
        //            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
        //
        //            print(jsonData!)
        //
        //        }).resume()
        //    }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return titleArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
            cell.titleLabel.text = titleArray[indexPath.row]
            cell.yearLabel.text = yearArray[indexPath.row]
            
            let imgURL = NSURL(string: imgURLArray[indexPath.row])
            
            if imgURL != nil {
                let data = NSData(contentsOf: (imgURL as? URL)!)
                cell.imgView.image = UIImage(data: data as! Data)
            }
            
            return cell
        }
        
        ///for showing next detailed screen with the downloaded info
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            vc.imageString = imgURLArray[indexPath.row]
            vc.titleString = titleArray[indexPath.row]
            vc.yearString = yearArray[indexPath.row]
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

