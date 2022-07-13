//
//  OnBoardingView.swift
//  CitiZen
//
//  Created by Kenneth Widjaya on 12/07/22.
//

import SwiftUI

struct OnBoardingStep {
    let image: String
    let title: String
    let description: String
}

private let onBoardingSteps = [
    OnBoardingStep(image: "", title: "Hello", description: "Desctiprion"),
    OnBoardingStep(image: "", title: "Hello2", description: "Desctiprion2"),
    OnBoardingStep(image: "", title: "Hello3", description: "Desctiprion3"),
    OnBoardingStep(image: "", title: "Hello4", description: "Desctiprion4")
    ]

struct OnBoardingView: View {
    
    @State private var currentStep = 0
    
    @StateObject private var mapViewModel = MapViewModel()
    @StateObject private var notificationViewModel = NotificationManager()
    
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        VStack {
            TabView(selection: $currentStep) {
                ForEach(0..<onBoardingSteps.count, id:\.self) { it in
                    VStack {
                        Image("Gedung Bersejarah")
                            .resizable()
                            .frame(width: 250, height: 250)
                        
                        Text(onBoardingSteps[it].title)
                            .font(.title)
                            .bold()
                        
                        Text(onBoardingSteps[it].description)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .tag(it)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack{
                ForEach(0..<onBoardingSteps.count, id:\.self) { it in
                    if it == currentStep {
                        Rectangle()
                            .frame(width: 65, height: 15)
                            .cornerRadius(10)
                            .foregroundColor(Color(.systemYellow))
                    } else {
                        Circle()
                            .frame (width: 10, height: 10)
                            .foregroundColor(.clear)
                            .overlay(
                                Circle()
                                    .stroke(lineWidth: 3)
                                    .foregroundColor(Color(.systemYellow))
                            )
                    }
                }
            }
            .padding(.bottom)
            
            Button {
                withAnimation(.spring()) {
                    
                    if self.currentStep < onBoardingSteps.count - 1 {
                        self.currentStep += 1
                    } else {
                        mode.wrappedValue.dismiss()
                        LocalStorage.myUserBool = true
                        mapViewModel.checkLocationService()
                        mapViewModel.loadAllLocation()
                        notificationViewModel.requestAuthorization(places: mapViewModel.allLocations)
                    }
                }
            } label: {
                Text(currentStep < onBoardingSteps.count - 1 ? "Next" : "Get Started")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .font(.title3)
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.width/6.09)
                    .background(Color(.systemYellow))
                    .cornerRadius(16)
                    .padding(.horizontal)
            }
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}