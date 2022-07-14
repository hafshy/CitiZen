//
//  ChatViewModel.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 11/07/22.
//

import Foundation
import UIKit

class ChatViewModel: ObservableObject {
    @Published var enteredMessage = ""
    @Published var showSheet = false
    @Published var showImagePicker = false
    @Published var sourceType: UIImagePickerController.SourceType = .camera
    @Published var tempImage: UIImage?
}
