//
//  ViewController.swift
//  FilmList
//
//  Created by Kurt on 12.03.17.
//  Copyright © 2017 Evgeny Koshkin. All rights reserved.
//

import UIKit

class tableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var filmItems = [FilmItem]()
    let pinchRecognizer = UIPinchGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinchRecognizer.addTarget(self, action: #selector(tableViewController.handlePinch(recognizer:)))
        tableView.addGestureRecognizer(pinchRecognizer)
        
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
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FilmViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.black
        tableView.rowHeight = 50
        
        if filmItems.count > 0 {
            return
        }
        filmItems.append(FilmItem(text: "The Godfather"))
        filmItems.append(FilmItem(text: "The Dark Knight"))
        filmItems.append(FilmItem(text: "The Crow"))
        filmItems.append(FilmItem(text: "The Shawshank Redemption"))
        filmItems.append(FilmItem(text: "The Lord of the Rings: The Return of the King"))
        filmItems.append(FilmItem(text: "Fight Club"))
    }
    
        @objc
        public func applicationDidEnterBackground(_ notification: NSNotification)
        {
            do
            {
                //saving films to persistence
                try filmItems.writeToPersistence()
            }
            catch let error
            {
                NSLog("Error writing to persistence: \(error)")
            }
        }

    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! FilmViewCell
        cell.selectionStyle = .none
        cell.textLabel?.backgroundColor = UIColor.clear
        let item = filmItems[indexPath.row]
        //            cell.textLabel?.text = item.text
        cell.delegate = self
        cell.filmItem = item
        return cell
    }
    
    func cellDidBeginEditing(editingCell: FilmViewCell) {
        let editingOffset = tableView.contentOffset.y - editingCell.frame.origin.y as CGFloat
        let visibleCells = tableView.visibleCells as! [FilmViewCell]
        for cell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.transform = CGAffineTransform(translationX: 0, y: editingOffset)
                if cell !== editingCell {
                    cell.alpha = 0.3
                }
            })
        }
    }
    
    func cellDidEndEditing(editingCell: FilmViewCell) {
        let visibleCells = tableView.visibleCells as! [FilmViewCell]
        for cell: FilmViewCell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.transform =  CGAffineTransform.identity
                if cell !== editingCell {
                    cell.alpha = 1.0
                }
            })
        }
        if editingCell.filmItem!.text == "" {
            FilmItemDeleted(filmItem: editingCell.filmItem!)
        }
    }
    
    func FilmItemDeleted(filmItem: FilmItem) {
        // could use this to get index when Swift Array indexOfObject works
        // let index = fimItems.indexOfObject(filmItem)
        // in the meantime, scan the array to find index of item to delete
        var index = 0
        for i in 0..<filmItems.count {
            if filmItems[i] === filmItem {  // note: === not ==
                index = i
                break
            }
        }
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        filmItems.remove(at: index)
        
        // loop over the visible cells to animate delete
        let visibleCells = tableView.visibleCells as! [FilmViewCell]
        let lastView = visibleCells[visibleCells.count - 1] as FilmViewCell
        var delay = 0.0
        var startAnimating = false
        for i in 0..<visibleCells.count {
            let cell = visibleCells[i]
            if startAnimating {
                UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseInOut,
                                           animations: {() in
                                            cell.frame = cell.frame.offsetBy(dx: 0.0, dy: -cell.frame.size.height)},
                                           completion: {(finished: Bool) in if (cell == lastView) {
                                            self.tableView.reloadData()
                                            }
                }
                )
                delay += 0.03
            }
            if cell.filmItem === filmItem {
                startAnimating = true
                cell.isHidden = true
            }
        }
        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(row: index, section: 0)
        tableView.deleteRows(at: [indexPathForRow as IndexPath], with: .fade)
        tableView.endUpdates()
    }
    // MARK: - Table view delegate
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = filmItems.count - 1
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
    
    let kRowHeight: CGFloat = 50.0
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kRowHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.backgroundColor = colorForIndex(index: indexPath.row)
    }
    
    // MARK: - pinch-to-add methods
    
    struct TouchPoints {
        var upper: CGPoint
        var lower: CGPoint
    }
    // the indices of the upper and lower cells that are being pinched
    var upperCellIndex = -100
    var lowerCellIndex = -100
    // the location of the touch points when the pinch began
    var initialTouchPoints: TouchPoints!
    // indicates that the pinch was big enough to cause a new item to be added
    var pinchExceededRequiredDistance = false
    
    // indicates that the pinch is in progress
    var pinchInProgress = false
    
    func handlePinch(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began {
            pinchStarted(recognizer: recognizer)
        }
        if recognizer.state == .changed
            && pinchInProgress
            && recognizer.numberOfTouches == 2 {
            pinchChanged(recognizer: recognizer)
        }
        if recognizer.state == .ended {
            pinchEnded(recognizer: recognizer)
        }
    }
    
    func pinchStarted(recognizer: UIPinchGestureRecognizer) {
        // find the touch-points
        initialTouchPoints = getNormalizedTouchPoints(recognizer: recognizer)
        
        // locate the cells that these points touch
        upperCellIndex = -100
        lowerCellIndex = -100
        let visibleCells = tableView.visibleCells  as! [FilmViewCell]
        for i in 0..<visibleCells.count {
            let cell = visibleCells[i]
            if viewContainsPoint(view: cell, point: initialTouchPoints.upper) {
                upperCellIndex = i
            }
            if viewContainsPoint(view: cell, point: initialTouchPoints.lower) {
                lowerCellIndex = i
            }
        }
        // check whether they are neighbors
        if abs(upperCellIndex - lowerCellIndex) == 1 {
            // initiate the pinch
            pinchInProgress = true
            // show placeholder cell
            let precedingCell = visibleCells[upperCellIndex]
            placeHolderCell.frame = precedingCell.frame.offsetBy(dx: 0.0, dy: kRowHeight / 2.0)
            placeHolderCell.backgroundColor = precedingCell.backgroundColor
            tableView.insertSubview(placeHolderCell, at: 0)
        }
    }
    
    func pinchChanged(recognizer: UIPinchGestureRecognizer) {
        // find the touch points
        let currentTouchPoints = getNormalizedTouchPoints(recognizer: recognizer)
        
        // determine by how much each touch point has changed, and take the minimum delta
        let upperDelta = currentTouchPoints.upper.y - initialTouchPoints.upper.y
        let lowerDelta = initialTouchPoints.lower.y - currentTouchPoints.lower.y
        let delta = -min(0, min(upperDelta, lowerDelta))
        
        // offset the cells, negative for the cells above, positive for those below
        let visibleCells = tableView.visibleCells as! [FilmViewCell]
        for i in 0..<visibleCells.count {
            let cell = visibleCells[i]
            if i <= upperCellIndex {
                cell.transform = CGAffineTransform(translationX: 0, y: -delta)
            }
            if i >= lowerCellIndex {
                cell.transform = CGAffineTransform(translationX: 0, y: delta)
            }
        }
        
        // scale the placeholder cell
        let gapSize = delta * 2
        let cappedGapSize = min(gapSize, tableView.rowHeight)
        placeHolderCell.transform = CGAffineTransform(scaleX: 1.0, y: cappedGapSize / tableView.rowHeight)
        placeHolderCell.label.text = gapSize > tableView.rowHeight ? "Release to add item" : "Pull apart to add item"
        placeHolderCell.alpha = min(1.0, gapSize / tableView.rowHeight)
        
        // has the user pinched far enough?
        pinchExceededRequiredDistance = gapSize > tableView.rowHeight
    }
    
    func pinchEnded(recognizer: UIPinchGestureRecognizer) {
        pinchInProgress = false
        
        // remove the placeholder cell
        placeHolderCell.transform = CGAffineTransform.identity
        placeHolderCell.removeFromSuperview()
        
        if pinchExceededRequiredDistance {
            pinchExceededRequiredDistance = false
            
            // Set all the cells back to the transform identity
            let visibleCells = self.tableView.visibleCells as! [FilmViewCell]
            for cell in visibleCells {
                cell.transform = CGAffineTransform.identity
            }
            
            // add a new item
            let indexOffset = Int(floor(tableView.contentOffset.y / tableView.rowHeight))
            FilmItemAddedAtIndex(index: lowerCellIndex + indexOffset)
        } else {
            // otherwise, animate back to position
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {() in
                let visibleCells = self.tableView.visibleCells as! [FilmViewCell]
                for cell in visibleCells {
                    cell.transform = CGAffineTransform.identity
                }
            }, completion: nil)
        }
    }
    
    // returns the two touch points, ordering them to ensure that
    // upper and lower are correctly identified.
    func getNormalizedTouchPoints(recognizer: UIGestureRecognizer) -> TouchPoints {
        var pointOne = recognizer.location(ofTouch: 0, in: tableView)
        var pointTwo = recognizer.location(ofTouch: 1, in: tableView)
        // ensure pointOne is the top-most
        if pointOne.y > pointTwo.y {
            let temp = pointOne
            pointOne = pointTwo
            pointTwo = temp
        }
        return TouchPoints(upper: pointOne, lower: pointTwo)
    }
    
    func viewContainsPoint(view: UIView, point: CGPoint) -> Bool {
        let frame = view.frame
        return (frame.origin.y < point.y) && (frame.origin.y + (frame.size.height) > point.y)
    }
    
    // MARK: - UIScrollViewDelegate methods
    // contains scrollViewDidScroll, and you'll add two more, to keep track of dragging the scrollView
    
    // a cell that is rendered as a placeholder to indicate where a new item is added
    let placeHolderCell = FilmViewCell(style: .default, reuseIdentifier: "cell")
    // indicates the state of this behavior
    var pullDownInProgress = false
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // this behavior starts when a user pulls down while at the top of the table
        pullDownInProgress = scrollView.contentOffset.y <= 0.0
        placeHolderCell.backgroundColor = UIColor.red
        if pullDownInProgress {
            // add the placeholder
            tableView.insertSubview(placeHolderCell, at: 0)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)  {
        // non-scrollViewDelegate methods need this property value
        let scrollViewContentOffsetY = tableView.contentOffset.y
        
        if pullDownInProgress && scrollView.contentOffset.y <= 0.0 {
            // maintain the location of the placeholder
            placeHolderCell.frame = CGRect(x: 0, y: -tableView.rowHeight,
                                           width: tableView.frame.size.width, height: tableView.rowHeight)
            placeHolderCell.label.text = -scrollViewContentOffsetY > tableView.rowHeight ?
                "Release to add item" : "Pull to add item"
            placeHolderCell.alpha = min(1.0, -scrollViewContentOffsetY / tableView.rowHeight)
        } else {
            pullDownInProgress = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // check whether the user pulled down far enough
        if pullDownInProgress && -scrollView.contentOffset.y > tableView.rowHeight {
            FilmItemAdded()
        }
        pullDownInProgress = false
        placeHolderCell.removeFromSuperview()
    }
    
    // MARK: - add, delete, edit methods
    
    func FilmItemAdded() {
        FilmItemAddedAtIndex(index: 0)
    }
    
    func FilmItemAddedAtIndex(index: Int) {
        let filmItem = FilmItem(text: "")
        filmItems.insert(filmItem, at: index)
        tableView.reloadData()
        // enter edit mode
        var editCell: FilmViewCell
        let visibleCells = tableView.visibleCells as! [FilmViewCell]
        for cell in visibleCells {
            if (cell.filmItem === filmItem) {
                editCell = cell
                editCell.label.becomeFirstResponder()
                break
            }
        }
    }
}



//class tableViewController: UITableViewController
//{
//    private var filmItems = [FilmItem]()
//    //var WatchedItems = [WatchedItem]()
//    
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        self.title = "Films"
//        //self.navigationController?.navigationBar.tintColor = UIColor.white
//        //self.navigationController?.navigationBar.titleTextAttributes? = [NSForegroundColorAttributeName: UIColor.white]
//        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tableViewController.didTapAddItemButton(_:)))
//        self.navigationItem.rightBarButtonItem?.tintColor = .white
//        
//        // Setup a notification to let us know when the app is about to close,
//        // and that we should store the user items to persistence. This will call the
//        // applicationDidEnterBackground() function in this class
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)),
//            name: NSNotification.Name.UIApplicationDidEnterBackground,
//            object: nil)
//        
//        do
//        {
//            // Try to load from persistence
//            self.filmItems = try [FilmItem].readFromPersistence()
//        }
//        catch let error as NSError
//        {
//            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError
//            {
//                NSLog("No persistence file found, not necesserially an error...")
//            }
//            else
//            {
//                let alert = UIAlertController(
//                    title: "Error",
//                    message: "Could not load the list items!",
//                    preferredStyle: .alert)
//                
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                
//                self.present(alert, animated: true, completion: nil)
//                
//                NSLog("Error loading from persistence: \(error)")
//            }
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        //setting the background image to the tableview
//        let backgroundImage = UIImage(named: "background.jpg")
//        let imageView = UIImageView(image: backgroundImage)
//        self.tableView.backgroundView = imageView
//        //hiding unusable lines in empty cells
//        tableView.tableFooterView = UIView(frame: CGRect.zero)
//        // center and scale background image
//        imageView.contentMode = .scaleAspectFill
//    }
//    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        //Cell transparency
//        //cell.backgroundColor = .clear
//        //Cell text color
//        cell.textLabel?.textColor = .white
//    }
//    
//    @objc
//    public func applicationDidEnterBackground(_ notification: NSNotification)
//    {
//        do
//        {
//            //saving films to persistence
//            try filmItems.writeToPersistence()
//        }
//        catch let error
//        {
//            NSLog("Error writing to persistence: \(error)")
//        }
//    }
//    
//    //User taps "+" button
//    func didTapAddItemButton(_ sender: UIBarButtonItem)
//    {
//        // Create an alert
//        let alert = UIAlertController(
//            title: "Movie Title:",
//            message: "",
//            preferredStyle: .alert)
//        
//        // Add a text field to the alert for the new item's title
//        alert.addTextField(configurationHandler: nil)
//        
//        // Add a "cancel" button to the alert. This one doesn't need a handler
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        
//        // Add a "Confirm" button to the alert. The handler calls addNewFilmItem()
//        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler:
//            { (_) in
//                // Get the title the user inserted, but only if it is not an empty string
//                if let title = alert.textFields?[0].text, title.characters.count > 0
//                {
//                    self.addNewFilmItem(title: title)
//                }
//        }))
//        
//        // Present the alert to the user
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    private func addNewFilmItem(title: String)
//    {
//        // The index of the new item will be the current item count
//        let newIndex = filmItems.count
//        
//        // Create new item and add it to the films items list
//        filmItems.append(FilmItem(title: title))
//        
//        // Tell the table view a new row has been created
//        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
//    }
//    
//    override func numberOfSections(in tableView: UITableView) -> Int
//    {
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return filmItems.count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        
//        if indexPath.row < filmItems.count
//        {
//            let item = filmItems[indexPath.row]
//            cell.textLabel?.text = item.title
//            
//            let accessory: UITableViewCellAccessoryType = item.done ? .checkmark : .none
//            cell.accessoryType = accessory
//        }
//        
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        if indexPath.row < filmItems.count
//        {
//            let item = filmItems[indexPath.row]
//            item.done = !item.done
//            
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
//    }
//    /* //This is all about cell actions. right swipe activated. Uncomment in case of emergency =)
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
//            //self.isEditing = false
//            print("more button tapped")
//        }
//        more.backgroundColor = UIColor.lightGray
//        
//        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
//            //self.isEditing = false
//            print("favorite button tapped")
//        }
//        favorite.backgroundColor = UIColor.orange
//        
//        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
//            //self.isEditing = false
//            print("share button tapped")
//        }
//        share.backgroundColor = UIColor.blue
//        
//        return [share, favorite, more]
//    } */ //--end
//
//    
//    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
//    {
//        if indexPath.row < filmItems.count
//        {
//            filmItems.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .top)
//        }
//    }
//    
//    
//    
//}
