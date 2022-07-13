//
//  Message+CoreDataProperties.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 13/07/22.
//
//

import Foundation
import CoreData

@objc
public enum SenderType: Int16 {
    case send
    case receive
}

@objc
public enum MessageType: Int16 {
    case photo
    case text
}

extension Message {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var messageID: UUID?
    @NSManaged public var text: String?
    @NSManaged public var senderType: SenderType
    @NSManaged public var messageType: MessageType
    @NSManaged public var photo: Data?
    @NSManaged public var conversation: Chat?
    
    public var wrappedDate: Date {
        date ?? Date.now
    }
    
    public var wrappedMessageID: UUID {
        messageID ?? UUID()
    }
    
    public var wrappedText: String {
        text ?? ""
    }
    
    public var wrappedPhoto: Data {
        photo ?? Data()
    }
}

extension Message : Identifiable {
    
}
