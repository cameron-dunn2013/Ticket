//
//  CoreDataStack.swift
//  Ticket
//
//  Created by Cameron Dunn on 5/6/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation
import CoreData
class CoreDataStack {
    private init(){}
    static let shared = CoreDataStack()
    
    lazy var dayContainer: NSPersistentContainer = {
        
        // Give the container the name of your data model file
        let container = NSPersistentContainer(name: "Day")
        
        // Load the persistent store
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    // This should help you remember that the viewContext should be used on the main thread
    var dayMainContext: NSManagedObjectContext {
        return dayContainer.viewContext
    }
    
    
    lazy var tipContainer: NSPersistentContainer = {
        
        // Give the container the name of your data model file
        let container = NSPersistentContainer(name: "Tip")
        
        // Load the persistent store
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    // This should help you remember that the viewContext should be used on the main thread
    var tipMainContext: NSManagedObjectContext {
        return tipContainer.viewContext
    }
}
