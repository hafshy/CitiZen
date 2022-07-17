//
//  ChatViewModel.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 11/07/22.
//

import Foundation
import UIKit
import SwiftUI
import CoreData

class ChatViewModel: ObservableObject {
    @Published var enteredMessage = ""
    @Published var showSheet = false
    @Published var showImagePicker = false
    @Published var sourceType: UIImagePickerController.SourceType = .camera
    @Published var tempImage: UIImage?
    @Published var landmarkID: Int = 0
    @Published var challenge: Challenge?
    
    func loadChallenge() {
        challenge = Challenge.challenge.first(where: { challenge in
            challenge.id == landmarkID
        })
    }
    
    func sendMessage(completedCount: Int, context: NSManagedObjectContext) {
        var category = ""
        var answers: [String] = []
        var choices: [String] = []
        category = challenge?.challenges[completedCount].category ?? "text"
        answers = challenge?.challenges[completedCount].answer ?? []
        
        if !enteredMessage.isEmpty && tempImage == nil && completedCount < 5 {
            withAnimation {
                ChatDataController()
                    .sendText(
                        landmarkId: landmarkID,
                        landmarkName: challenge?.name ?? "",
                        landmarkIconName: challenge?.icon ?? "",
                        isUser: true,
                        text: enteredMessage,
                        complete: completedCount,
                        context: context
                    )
                
                botReply(
                    "quiz",
                    category == "quiz" &&
                    (
                        answers != [] &&
                        answers.contains(where: { ans in
                            ans == enteredMessage
                        })
                    ),
                    completed: completedCount,
                    context: context
                )
                
                enteredMessage = ""
            }
        }
        
        if tempImage != nil && completedCount < 5{
            withAnimation {
                ChatDataController()
                    .sendPhoto(
                        landmarkId: landmarkID,
                        landmarkName: challenge?.name ?? "",
                        landmarkIconName: challenge?.icon ?? "",
                        photo: tempImage!,
                        complete: completedCount,
                        context: context
                    )
                
                botReply("photo", category == "photo", completed: completedCount, context: context)
                
                tempImage = nil
            }
        }
        
    }
    
    func botReply(_ messageType: String, _ rightAnswer: Bool, completed: Int, context: NSManagedObjectContext) {
        ChatDataController()
            .sendText(
                landmarkId: landmarkID,
                landmarkName: "",
                landmarkIconName: "",
                isUser: false,
                text: rightAnswer ?
                (challenge?.challenges[completed + 1].question ?? "") :
                    "Wrong answer template",
                complete: rightAnswer ? completed + 1 : completed,
                context: context
            )
    }
    
    func initiateChallenge(context: NSManagedObjectContext) {
        if let currentChallenge = challenge {
            let firstChallenge = currentChallenge.challenges[0]
            print("Loading Challenge")
            ChatDataController()
                .sendText(landmarkId: landmarkID, landmarkName: currentChallenge.name, landmarkIconName: currentChallenge.icon, isUser: false, text: firstChallenge.question, complete: 0, context: context)
            print("Done")
        }
    }
    
    func clearField() {
        withAnimation {
            enteredMessage = ""
            tempImage = nil
        }
    }
    
    func onClickImageSourceOption(sourceType: UIImagePickerController.SourceType) {
        showImagePicker = true
        self.sourceType = sourceType
    }
}
