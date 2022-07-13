//
//  ChatDataController.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 13/07/22.
//

import Foundation
import CoreData

class ChatDataController: ObservableObject {
    let container = NSPersistentContainer(name: "ChatDataModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load. Error: \(error.localizedDescription)")
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data Saved")
        } catch {
            print("Could not save the data")
        }
    }
}
