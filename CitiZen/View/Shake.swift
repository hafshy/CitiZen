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
            if showPopUp || (showArrivedPopUp && !saveViewModel.savedLocations.contains(where: { item in
                Int(item.locationID) == currenLocationId && currenLocationId != -1
            })) {
                Color(.gray)
                    .opacity(0.3)
                    .ignoresSafeArea()
            }

            if showArrivedPopUp && !saveViewModel.savedLocations.contains(where: { item in
                Int(item.locationID) == currenLocationId && currenLocationId != -1
            }) {
                ZStack {
                    Color.yellow
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
                            .foregroundColor(.white)
                        Spacer ()
                    }.padding()
                }
                .onShake {
                    withAnimation
                    {
                        showArrivedPopUp = false
                        showPopUp = true
                        // CHANGE 2 to ID
                        if !saveViewModel.savedLocations.contains(where: { item in
                            Int(item.locationID) == currenLocationId && currenLocationId != -1
                        }) {
                            saveViewModel.addLocation(id: currenLocationId)
                        }
                    }
                }
                .frame(width: 300, height: 200)
                .cornerRadius(20).shadow(radius: 20)
            }
            
            if showPopUp {
                ZStack {
                    Color.yellow
                    Circle()
                        .fill(.white)
                        .frame(width: 130, height: 130)
                    Image("\(Location.icon)")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 115)
                    VStack {
                        Spacer()
                        Text("Selamat Datang Di \(Location.name)!")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Text("Ayo Abadikan Momen Unik Di Sini")
                            .font(.caption2)
                            .bold()
                        Button(action: {
                            withAnimation{
                                self.showPopUp = false
                            }
                        }, label: {
                            Text("BERIKUTNYA")
                                .padding(.horizontal,50)
                                .padding(.vertical,10)
                                .background(.black)
                                .foregroundColor(.yellow)
                                .font(.caption)
                                .cornerRadius(10) .shadow(radius: 20)
                        })
                    }.padding()
                }
                .frame(width: 300, height: 300)
                .cornerRadius(20).shadow(radius: 20)
            }
        }
    }
}
