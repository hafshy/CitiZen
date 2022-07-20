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
        @Binding var currenLocationId: Int
        @ObservedObject var saveViewModel: SavedLocationsViewModel
        @Binding var Location: MapLocation
    
    var body: some View {
        ZStack {
            if showArrivedPopUp || showPopUp {
                Color(.gray)
                    .opacity(0.3)
                    .ignoresSafeArea()
            }
            
            if showArrivedPopUp {
                ZStack {
                    Color("kuning")
                    Circle()
                        .fill(.white)
                        .frame(width: 130, height: 130)
                    
                    VStack {
                        Spacer ()
                        Text("You are Arrived!")
                            .font(.title2)
                            .bold()
                        Spacer ()
                        Spacer ()
                        Image("ShakeImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90)
                        Spacer ()
                        Spacer ()
                        Text("Shake,Shake!")
                            .font(.title)
                            .bold()
                        Text("Shake Your Phone To Save The Progress")
                            .font(.caption2)
                            .foregroundColor(.black)
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
                .frame(width: 300, height: 300)
                .cornerRadius(10).shadow(radius: 10)
            }
            
            if showPopUp {
                
                ZStack {
                    Color("kuning")
                    Circle()
                        .fill(.white)
                        .frame(width: 130, height: 130)
                    Circle()
                        .fill(Color("Hitam"))
                        .frame(width: 120, height: 120)
                    Image("\(Location.icon)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 105)
                    VStack {
                        Text("Welcome to")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                        Text("\(Location.name)")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                            .frame(height: 160)
                        Button(action: {
                            withAnimation{
                                self.showPopUp = false
                                showArrivedPopUp = false
                                // CHANGE 2 to ID
                                if !saveViewModel.savedLocations.contains(where: { item in
                                    Int(item.locationID) == $Location.id && Location.id != -1
                                }) {
                                    saveViewModel.addLocation(id: $Location.id)
                                }
                            }
                            
                            
                        }, label: {
                            Text("Next")
                                .padding(.horizontal,50)
                                .padding(.vertical,5)
                                .background(.white)
                                .foregroundColor(.black)
                                .font(.headline)
                                .cornerRadius(10)
                            
                        })
                        Spacer()
                    }.padding()
                }
                .frame(width: 300, height: 300)
                .cornerRadius(20).shadow(radius: 20)
                
                
                
            }
        }
    }
}
