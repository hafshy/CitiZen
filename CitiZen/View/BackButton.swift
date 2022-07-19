//
//  BackButton.swift
//  CitiZen
//
//  Created by Hafshy Yazid Albisthami on 19/07/22.
//

import SwiftUI

struct BackButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.yellow)
                .scaledToFit()
                .frame(width: 40)
            Image(systemName: "chevron.backward") // set image here
                .foregroundColor(.black)
        }
    }
}
