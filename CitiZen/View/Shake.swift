//
//  Shake.swift
//  CitiZen
//
//  Created by Pramudya Prameswara Trisna Saputra on 22/06/22.
//

import SwiftUI

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}


extension UIWindow {
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
     }
}

struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
            self.modifier(DeviceShakeViewModifier(action: action))
        }
}

struct Shake: View {
    @State private var showingAlert = false
    
    var body: some View {
        Text("")
            .onShake {showingAlert = true
            }
            .alert("Congrats Your Progress Has Been Saved", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
    }
                      

struct Shake_Previews: PreviewProvider {
    static var previews: some View {
        Shake()
    }
}
}
