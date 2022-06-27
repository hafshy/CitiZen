//
//  ContentView.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 21/06/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @StateObject private var savedLocationViewModel = SavedLocationsViewModel()
    
    
    @State var isDetailView = true
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // MARK: Map Background
            Map(coordinateRegion: $viewModel.currentCoordinate, showsUserLocation: true)
                .ignoresSafeArea()
                .accentColor(.green)    // TODO: Change Color Scheme
                .onAppear {
                    viewModel.checkLocationService()
                }
                .onTapGesture(perform: {
                    withAnimation(.spring()) {
                        if isDetailView {
                            isDetailView = false
                        }
                    }
                })
            
            // MARK: City and Progress
            VStack(spacing: 4) {
                HStack {
                    Text("Surabaya")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)
                        .frame(alignment: .topLeading)
                    Spacer()
                }
                // TODO: Add Progress Here @Ken
                HStack {
                    Text("80%")
                        .font(.caption2)
                    RoundedRectangle(cornerRadius: 2.5)
                        .frame(width: UIScreen.main.bounds.width / 3.25 * 80 / 100, height: UIScreen.main.bounds.width / 78)
                        .foregroundColor(.red)
                        .overlay(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2.5)
                                .stroke(lineWidth: 1)
                                .frame(width: UIScreen.main.bounds.width / 3.25, height: UIScreen.main.bounds.width / 78)
                                .foregroundColor(.gray)
                        }
                    Spacer()
                }
                Spacer()
                
                // TODO: Add Achievements Button Here
                Button {
                    // TODO: Add Navigation Here
                    
                } label: {
                    Image("trophy")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
                        .frame(width: UIScreen.main.bounds.width / 5.06, height: UIScreen.main.bounds.width / 5.06)
                        .background(Color(.systemGray3))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 4)
                            .foregroundColor(.gray))
                }
            }
            .padding()
            
            GeometryReader { proxy -> AnyView in
                let height = proxy.frame(in: .global).height
                return AnyView(
                    // MARK: Bottom Sheet Container
                    ZStack {
                        // MARK: Background Blur
                        BlurView(style: .systemMaterial)
                            .clipShape(CustomEdge(corner: [.topLeft, .topRight], radius: 32))
                        // MARK: Bottom Sheet Content
                        // TODO: Add Converter behind capsule
                        VStack {
                            Capsule()
                                .fill(.primary)
                                .frame(
                                    width: 40,
                                    height: 4,
                                    alignment: .center
                                )
                                .padding(.top, 12)
                            DetailView()
                            Spacer()
                        }
                    }
                        .offset(y: isDetailView ? height - 300 : offset + height + 300 )
                        .offset(y: -offset > 0 ? -offset <= (height - 300) ? offset : -(height - 300) : 0)
                        .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                            out = value.translation.height
                            onChange(height: height)
                        }).onEnded({ value in
                            let maxHeight = height - 100
                            
                            withAnimation(.spring()) {
                                if (-offset > 300 && -offset < maxHeight ) {
                                    offset = -(maxHeight / 1.65)
                                } else {
                                    offset = 0
                                }
                                if isDetailView == false {
                                    offset = 0
                                }
                            }
                            lastOffset = offset
                        }))
                )
            }
            .ignoresSafeArea(.all, edges: .bottom)
            
            if isDetailView {
                ZStack {
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width, height: 100)
                            .foregroundColor(Color(.systemGray3))
                            .border(.black, width: 1)
                    }
                    .ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "paperplane.fill")
                                .font(.body)
                                .foregroundColor(.white)
                            Text("Navigate")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .frame(width: 360, height: 48)
                        .background(.blue)
                        .cornerRadius(8)
                        .border(.gray, width: 1)
                    }
                }
            }
        }
    }
    func onChange(height: CGFloat) {
        DispatchQueue.main.async {
            self.offset = max(-(height - 200), gestureOffset + lastOffset)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
