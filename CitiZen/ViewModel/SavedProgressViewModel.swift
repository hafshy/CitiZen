//
//  SavedProgressViewModel.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 22/06/22.
//

import Foundation
import CoreData

class SavedProgressViewModel: ObservableObject {
    let container = NSPersistentContainer(name: "SavedLocationDataModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Coredata failed to load: \(error.localizedDescription)")
            }
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
