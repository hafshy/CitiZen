//
//  Chat+CoreDataProperties.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 13/07/22.
//
//

import Foundation
import CoreData


extension Chat {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }
    
    @NSManaged public var id: Int16
    @NSManaged public var landmarkIconName: String?
    @NSManaged public var landmarkName: String?
    @NSManaged public var completedCount: Int16
    @NSManaged public var messages: NSSet?
    
    public var wrappedLandmarkIconName: String {
        landmarkIconName ?? ""
    }
    
    public var wrappedLandmarkName: String {
        landmarkName ?? ""
    }
    
    public var messageArray: [Message] {
        let set = messages as? Set<Message> ?? []
        
        return set.sorted {
            $0.wrappedDate < $1.wrappedDate
        }
    }
}

// MARK: Generated accessors for messages
extension Chat {
    
    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)
    
    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)
    
    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)
    
    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)
    
}

extension Chat : Identifiable {
    
}
