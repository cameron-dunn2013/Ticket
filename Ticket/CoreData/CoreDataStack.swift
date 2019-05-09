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
    
    lazy var container: NSPersistentContainer = {
        
        // Give the container the name of your data model file
        let container = NSPersistentContainer(name: "CoreDataContainer")
        
        // Load the persistent store
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    // This should help you remember that the viewContext should be used on the main thread
    var containerMainContext: NSManagedObjectContext {
        return container.viewContext
    }
   
}
