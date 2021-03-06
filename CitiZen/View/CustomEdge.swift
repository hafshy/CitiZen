//
//  CustomEdge.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 24/06/22.
//

import SwiftUI

struct CustomEdge: Shape {
    var corner: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}
