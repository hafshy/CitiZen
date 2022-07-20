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
                landmarkName: challenge?.name ?? "",
                landmarkIconName: challenge?.icon ?? "",
                isUser: false,
                text: rightAnswer ?
                (challenge?.challenges[completed + 1].question ?? "") :
                    "Maaf jawabanmu salah, silahkan coba lagi!",
                complete: rightAnswer ? completed + 1 : completed,
                context: context
            )
        
        if rightAnswer == false {
            ChatDataController()
                .sendText(
                    landmarkId: landmarkID,
                    landmarkName: challenge?.name ?? "",
                    landmarkIconName: challenge?.icon ?? "",
                    isUser: false,
                    text: challenge?.challenges[completed].question ?? "",
                    complete: completed,
                    context: context
                )
        }
    }
    
    func initiateChallenge(context: NSManagedObjectContext) {
        if let currentChallenge = challenge {
            let firstChallenge = currentChallenge.challenges[0]
            ChatDataController()
                .sendText(landmarkId: landmarkID, landmarkName: currentChallenge.name, landmarkIconName: currentChallenge.icon, isUser: false, text: firstChallenge.question, complete: 0, context: context)
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
    
    func sendAnswer(choice: String, completed: Int, context: NSManagedObjectContext) {
        var category = ""
        var answers: [String] = []
        category = challenge?.challenges[completed].category ?? "text"
        answers = challenge?.challenges[completed].answer ?? []
        
        ChatDataController()
            .sendText(
                landmarkId: landmarkID,
                landmarkName: challenge?.name ?? "",
                landmarkIconName: challenge?.icon ?? "",
                isUser: true,
                text: choice,
                complete: completed,
                context: context
            )
        
        botReply(
            "quiz",
            category == "quiz" &&
            (
                answers != [] &&
                answers.contains(where: { answer in
                    answer == choice
                })
            ),
            completed: completed,
            context: context
        )
    }
    
    func scrollDown(proxy: ScrollViewProxy, namespaceId: Namespace.ID) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                proxy.scrollTo(namespaceId)
            }
        }
    }
    
    func saveImage(view: AnyView) {
        
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
