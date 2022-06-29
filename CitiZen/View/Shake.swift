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
    // @State private var showingAlert = false
    @State var showPopUp = false
    @Binding var showArrivedPopUp: Bool
    var body: some View {
        if $showArrivedPopUp.wrappedValue {
            
            ZStack {
                Color.white
                VStack {
                    Spacer ()
                    Text("You are Arrived!")
                        .font(.title2)
                        .bold()
                    Image(systemName: "iphone.radiowaves.left.and.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                    Text("Shake,Shake!")
                        .font(.title)
                        .bold()
                    Text("Shake Your Phone To Save The Progress")
                        .font(.caption2)
                    Spacer ()
                }.padding()
            }
            .onShake {
                withAnimation
                {
                    showArrivedPopUp = false
                    showPopUp = true
                    
                }
                
            }
            .frame(width: 300, height: 200)
            .cornerRadius(20).shadow(radius: 20)
        }
        
        if $showPopUp.wrappedValue {
            
            ZStack {
                Color.white
                VStack {
                    Spacer ()
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                    Text("Congrats!")
                        .font(.title)
                        .bold()
                    Text("Your Progress Has Been Recorded")
                        .font(.caption2)
                    Spacer ()
                    Button(action: {
                        withAnimation{
                            self.showPopUp = false
                        }
                        
                        
                    }, label: {
                        Text("Close")
                    })
                }.padding()
            }
            .frame(width: 300, height: 200)
            .cornerRadius(20).shadow(radius: 20)
            
            
            
        }
    }
    //  .onShake {showingAlert = true
    //      }
    //    .alert("Congrats Your Progress Has Been Saved", isPresented: $showingAlert) {
    //              Button("OK", role: .cancel) { }
    //     }
}


//struct Shake_Previews: PreviewProvider {
//    static var previews: some View {
//
//    }
//}

