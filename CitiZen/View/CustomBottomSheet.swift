//
//  CustomBottomSheet.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 24/06/22.
//

import SwiftUI

// To use this, add
//          CustomBottomSheet {
//              *Sheets content here*
//          }
struct CustomBottomSheet<Content: View>: View {
    @Binding var offset: CGFloat
    @Binding var lastOffset: CGFloat
    @GestureState var gestureOffset: CGFloat = 0
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content, offset: Binding<CGFloat>, lastOffset: Binding<CGFloat>) {
        self.content = content
        self._offset = offset
        self._lastOffset = lastOffset
    }
    
    var body: some View {
        GeometryReader { proxy -> AnyView in
            
            let height = proxy.frame(in: .global).height
            
            return AnyView(
                // MARK: Bottom Sheet Container
                ZStack {
                    // MARK: Background Blur
                    BlurView(style: .systemUltraThinMaterial)
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
                        
                        content()
                        
                        Spacer()
                    }
                }
                    .offset(y: height)
                    .offset(y: -offset > 0 ? -offset <= (height) ? offset : -(height) : 0)
                    .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                        out = value.translation.height
                        onChange()
                    }).onEnded({ value in
                        withAnimation(.spring()) {
                            let maxHeight = height - 100
                            
                            withAnimation(.spring()) {
                                if ((-lastOffset == maxHeight && -offset < maxHeight) ||
                                    (-offset > maxHeight / 3 && -offset < maxHeight / 2)) {
                                    offset = -(maxHeight / 2)
                                } else if (-offset > maxHeight / 2) {
                                    offset = -maxHeight
                                } else {
                                    offset = 0
                                }
                            }
                            lastOffset = offset
                        }
                        lastOffset = offset
                    }))
                    .onAppear {
                        offset = 0
                        lastOffset = 0
                    }
            )
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
}
