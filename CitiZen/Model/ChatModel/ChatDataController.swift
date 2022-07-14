//
//  ChatDataController.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 13/07/22.
//

import Foundation
import CoreData
import UIKit

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
    
    func sendText(landmarkId: Int, landmarkName: String, landmarkIconName: String, isUser: Bool, text: String, complete: Bool, context: NSManagedObjectContext) {
        let message = Message(context: context)
        message.date = Date.now
        message.messageID = UUID()
        message.text = text
        message.senderType = isUser ? .send : .receive
        message.messageType = .text
        message.conversation = Chat(context: context)
        message.conversation?.id = Int16(landmarkId)
        message.conversation?.landmarkName = landmarkName
        message.conversation?.landmarkIconName = landmarkIconName
        message.conversation?.completedCount += complete ? 1 : 0
        
        save(context: context)
    }
    
    func sendPhoto(landmarkId: Int, landmarkName: String, landmarkIconName: String, photo: UIImage, complete: Bool, context: NSManagedObjectContext) {
        let message = Message(context: context)
        message.date = Date.now
        message.messageID = UUID()
        message.senderType = .send
        message.messageType = .photo
        message.photo = photo.jpegData(compressionQuality: 0.9)
        message.conversation = Chat(context: context)
        message.conversation?.id = Int16(landmarkId)
        message.conversation?.landmarkName = landmarkName
        message.conversation?.landmarkIconName = landmarkIconName
        message.conversation?.completedCount += complete ? 1 : 0
        
        save(context: context)
    }
}
