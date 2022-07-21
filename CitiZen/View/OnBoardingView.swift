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
    OnBoardingStep(image: "Onboarding1", title: "Find Landmarks", description: "Come explore your city by visiting the nearby landmarks"),
    OnBoardingStep(image: "Onboarding2", title: "Complete the mission", description: "Take on unique missions in each landmark and make memories"),
    OnBoardingStep(image: "Onboarding3", title: "Play it easily", description: "Zoom in, zoom out, and slide the screen to determine the destination landmark"),
]

struct OnBoardingView: View {
    
    @State private var currentStep = 0
    
    @StateObject private var mapViewModel = MapViewModel()
    @StateObject private var notificationViewModel = NotificationManager()
    @EnvironmentObject var viewModel: AuthtenticationVM
    
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack(){
                    Rectangle().frame(height:UIScreen.main.bounds.height/1.8).foregroundColor(.primaryYellow).ignoresSafeArea()
                    Spacer()
                }
                VStack() {
                    TabView(selection: $currentStep) {
                        ForEach(0..<onBoardingSteps.count, id:\.self) { it in
                            VStack() {
                                Image(onBoardingSteps[it].image)
                                    .resizable()
                                    .frame(width: 250, height: 250)
                                Spacer()
                                Text(onBoardingSteps[it].title)
                                    .font(.title)
                                    .bold()
                                Spacer().frame(height:10)
                                Text(onBoardingSteps[it].description)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 20)
                            }
                            .tag(it)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    Spacer().frame(height:80)
                    HStack{
                        ForEach(0..<onBoardingSteps.count, id:\.self) { it in
                            if it == currentStep {
                                Rectangle()
                                    .frame(width: 65, height: 15)
                                    .cornerRadius(10)
                                    .foregroundColor(.primaryYellow)
                            } else {
                                Circle()
                                    .frame (width: 10, height: 10)
                                    .foregroundColor(.clear)
                                    .overlay(
                                        Circle()
                                            .stroke(lineWidth: 3)
                                            .foregroundColor(.primaryYellow)
                                    )
                            }
                        }
                    }
                    .padding(.bottom)
                    
                    if self.currentStep < onBoardingSteps.count - 1 {
                        Button {
                            if self.currentStep < onBoardingSteps.count - 1 {
                                withAnimation(.easeInOut(duration: 1.0)){
                                    self.currentStep += 1
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
                                .background(Color.primaryYellow)
                                .cornerRadius(16)
                                .padding(.horizontal)
                        }
                    } else {
                        NavigationLink {
                            PermissionView(mapViewModel: mapViewModel, notificationViewModel: notificationViewModel)
                        } label: {
                            Text(currentStep < onBoardingSteps.count - 1 ? "Next" : "Get Started")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .font(.title3)
                                .padding(16)
                                .frame(maxWidth: .infinity)
                                .frame(height: UIScreen.main.bounds.width/6.09)
                                .background(Color.primaryYellow)
                                .cornerRadius(16)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
