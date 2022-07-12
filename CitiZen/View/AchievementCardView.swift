//
//  AchievementCardView.swift
//  CitiZen
//
//  Created by Trevincen Tambunan on 03/07/22.
//

import SwiftUI

struct AchievementCardView: View {
    @State var rating: Int = 3
    
    var maxRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        VStack{
            ZStack{
                VStack{
                    Image("TestGambar")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 75)
                    Text("ASD")
                }
            }.padding()
                .background(.yellow)
                .cornerRadius(20)
            HStack{
                ForEach(1..<maxRating + 1, id:\.self){number in
                    image(for: number)
                        .foregroundColor(number > rating ? offColor:onColor)
                        
                }
            }.frame(height: 20)
        }.background(Color(.systemGray4)).cornerRadius(20)
    }
    
    func image(for number:Int) -> Image {
        if number > rating{
            return offImage ?? onImage
        }else{
            return onImage
        }
    }
}

struct AchievementCardView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementCardView()
    }
}
