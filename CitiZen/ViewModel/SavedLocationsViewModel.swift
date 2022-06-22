//
//  SavedProgressViewModel.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 22/06/22.
//

import Foundation
import CoreData

class SavedLocationsViewModel: ObservableObject {
    @Published var savedLocations: [SavedLocation] = []
    let container = NSPersistentContainer(name: "SavedLocationsDataModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Coredata failed to load: \(error.localizedDescription)")
            }
        }
        
        fetchSavedLocations()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchSavedLocations()
            print("Data Saved")
        } catch {
            print("Could not save the data")
        }
    }
    
    func fetchSavedLocations() {
        let request = NSFetchRequest<SavedLocation>(entityName: "SavedLocation")
        
        do {
            savedLocations = try container.viewContext.fetch(request)
        } catch let error {
            print("ERROR \(error)")
        }
    }
    
    // MARK: To Save data on MapView, use savedLocationViewModel.addLocation(id)
    func addLocation(id: Int) {
        let newLocation = SavedLocation(context: container.viewContext)
        newLocation.locationID = Int16(id)
        saveData()
    }
}
