//
//  ViewController.swift
//  FilmList
//
//  Created by Kurt on 12.03.17.
//  Copyright © 2017 Evgeny Koshkin. All rights reserved.
//

import UIKit
import CoreData

class tableViewController: UITableViewController {
    
    var listItems = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(tableViewController.addItem))
    }
    
    func addItem(){
    
        let alertController = UIAlertController(title: "Type Something!", message: "Type...", preferredStyle: UIAlertControllerStyle.alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: ({
            (_) in
            if let field = alertController.textFields![0] as? UITextField {
            
                self.saveItem(itemToSave: field.text!)
                self.tableView.reloadData()
            }
        }
            
        ))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addTextField(configurationHandler: ({
            (textField) in
            textField.placeholder = "Type here something"
        }))
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveItem(itemToSave : String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ListEntity", in: managedContext)
        let item = NSManagedObject.init(entity: entity!, insertInto: managedContext)
        item.setValue(itemToSave, forKey: "item")
        
        do {
            try managedContext.save()
            listItems.append(item)
        }
        catch {
            print("Error")
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ListEntity")
        do {
            let results = try managedContext.fetch(fetchRequest)
            listItems = results as! [NSManagedObject]
        }
        catch {
            print("Error")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        let item = listItems[indexPath.row]
        cell.textLabel?.text = item.value(forKey: "item") as! String
        
        return cell
    }

}

