//
//  FilmItem.swift
//  FilmList
//
//  Created by Kurt on 19.03.17.
//  Copyright © 2017 Evgeny Koshkin. All rights reserved.
//

import Foundation

import UIKit

class FilmItem: NSObject, NSCoding {
    // A text description of this item.
    var text: String
    
    // A Boolean value that determines the completed state of this item.
    var completed: Bool
    
    // Returns a ToDoItem initialized with the given text and default completed value.
    public init(text: String) {
        self.text = text
        self.completed = false
    }
    
    
        required init?(coder aDecoder: NSCoder)
        {
            // Try to unserialize the "title" variable
            if let text = aDecoder.decodeObject(forKey: "text") as? String
            {
                self.text = text
            }
            else
            {
                // There were no objects encoded with the key "title",
                // so that's an error.
                return nil
            }
    
            // Check if the key "done" exists, since decodeBool() always succeeds
            if aDecoder.containsValue(forKey: "completed")
            {
                self.completed = aDecoder.decodeBool(forKey: "completed")
            }
            else
            {
                // Same problem as above
                return nil
            }
        }
    
        func encode(with aCoder: NSCoder)
        {
            // Store the objects into the coder object
            aCoder.encode(self.text, forKey: "text")
            aCoder.encode(self.completed, forKey: "completed")
        }
    }
    
    extension FilmItem
    {
        public class func getMockData() -> [FilmItem]
        {
            return [
                FilmItem(text: ""),
                FilmItem(text: ""),
                FilmItem(text: ""),
                FilmItem(text: "")
            ]
        }
    }

    // Creates an extension of the Collection type (aka an Array),
    // but only if it is an array of FilmItem objects.
    extension Collection where Iterator.Element == FilmItem
    {
        // Builds the persistence URL. This is a location inside
        // the "Application Support" directory for the App.
        private static func persistencePath() -> URL?
        {
            let url = try? FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
    
            return url?.appendingPathComponent("filmitems.bin")
        }
    
        // Write the array to persistence
        func writeToPersistence() throws
        {
            if let url = Self.persistencePath(), let array = self as? NSArray
            {
                let data = NSKeyedArchiver.archivedData(withRootObject: array)
                try data.write(to: url)
            }
            else
            {
                throw NSError(domain: "ru.wylde.FilmList", code: 10, userInfo: nil)
            }
        }
    
        // Read the array from persistence
        static func readFromPersistence() throws -> [FilmItem]
        {
            if let url = persistencePath(), let data = (try Data(contentsOf: url) as Data?)
            {
                if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [FilmItem]
                {
                    return array
                }
                else
                {
                    throw NSError(domain: "ru.wylde.FilmList", code: 11, userInfo: nil)
                }
            }
            else
            {
                throw NSError(domain: "ru.wylde.FilmList", code: 12, userInfo: nil)
            }
        }

}
