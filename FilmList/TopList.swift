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
        final let urlString = "https://api.myjson.com/bins/128p7x"
        //"https://api.myjson.com/bins/pvitx"
        //Old url "http://api.myapifilms.com/imdb/top?start=1&end=10&token=67fc7a85-30c9-4031-a604-f126d958e077&format=json&data=0"
        
        @IBOutlet weak var tableView: UITableView!
        
        var titleArray = [String]()
        var yearArray = [String]()
        var imgURLArray = [String]()
    
        var ReleaseArray = [String]()
        var DirectorsArray = [String]()
        var WritersArray = [String]()
        var CountriesArray = [String]()
        var LanguagesArray = [String]()
        var GenresArray = [String]()
        var PlotArray = [String]()
        var urlIMDBArray = [String]()
        var RatingArray = [String]()
        var RatedArray = [String]()
        var VotesArray = [String]()
        var TypeArray = [String]()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            self.title = "Top movies"
            self.navigationController?.navigationBar.titleTextAttributes? = [NSForegroundColorAttributeName: UIColor.white]
            
            self.downloadJsonWithTask()
            
            
        }
    
        
            func downloadJsonWithTask() {
        
                let url = NSURL(string: urlString)
        
                var downloadTask = URLRequest(url: (url as? URL)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60)
        
                downloadTask.httpMethod = "GET"
        
                URLSession.shared.dataTask(with: downloadTask, completionHandler: {(data, response, error) -> Void in
        
                    if let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                        print(jsonData!.value(forKey: "movies")!)
                        
                        if let FilmsArray = jsonData!.value(forKey: "movies") as? NSArray {
                            for actor in FilmsArray{
                                if let FilmsDict = actor as? NSDictionary {
                                    if let name = FilmsDict.value(forKey: "title") {
                                        self.titleArray.append(name as! String)
                                    }
                                    if let name = FilmsDict.value(forKey: "year") {
                                        self.yearArray.append(name as! String)
                                    }
                                    if let name = FilmsDict.value(forKey: "urlPoster") {
                                        self.imgURLArray.append(name as! String)
                                    }
                                    if let name = FilmsDict.value(forKey: "releaseDate") {
                                        self.ReleaseArray.append(name as! String)
                                    }
//                                    if let name = FilmsDict.value(forKey: "directors") {
//                                        self.DirectorsArray.append(name as! String)
//                                    }
//                                    if let name = FilmsDict.value(forKey: "writers") {
//                                        self.WritersArray.append(name as! String)
//                                    }
//                                    if let name = FilmsDict.value(forKey: "countries") {
//                                        self.CountriesArray.append(name as! String)
//                                    }
//                                    if let name = FilmsDict.value(forKey: "languages") {
//                                        self.LanguagesArray.append(name as! String)
//                                    }
//                                    if let name = FilmsDict.value(forKey: "genres") {
//                                        self.GenresArray.append(name as! String)
//                                    }
                                    if let name = FilmsDict.value(forKey: "plot") {
                                        self.PlotArray.append(name as! String)
                                    }
                                    if let name = FilmsDict.value(forKey: "urlIMDB") {
                                        self.urlIMDBArray.append(name as! String)
                                    }
                                    if let name = FilmsDict.value(forKey: "rating") {
                                        self.RatingArray.append(name as! String)
                                    }
                                    if let name = FilmsDict.value(forKey: "rated") {
                                        self.RatedArray.append(name as! String)
                                    }
                                    if let name = FilmsDict.value(forKey: "votes") {
                                        self.VotesArray.append(name as! String)
                                    }
                                    if let name = FilmsDict.value(forKey: "type") {
                                        self.TypeArray.append(name as! String)
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
            vc.plotString = PlotArray[indexPath.row]
            vc.releaseDateString = ReleaseArray[indexPath.row]
            vc.ratingString = RatingArray[indexPath.row]
            vc.ratedString = RatedArray[indexPath.row]
            vc.votesString = VotesArray[indexPath.row]
            vc.urlIMDBString = urlIMDBArray[indexPath.row]
            vc.typeString = TypeArray[indexPath.row]
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

