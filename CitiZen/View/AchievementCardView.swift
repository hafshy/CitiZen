//
//  AchievementCardView.swift
//  CitiZen
//
//  Created by Trevincen Tambunan on 03/07/22.
//

import SwiftUI

struct AchievementCardView: View {
    @Binding var achievement:Challenge
    @State var rating: Int = 0
    @State var status = "Visited"
    @ObservedObject private var saveViewModel = SavedLocationsViewModel()
    
    var maxRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color(.systemGray2)
    var onColor = Color.yellow
    
    var body: some View {
        VStack{
            ZStack{
                HStack{
                    Spacer()
                    VStack{
                        Spacer()
                        Image(achievement.icon)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(saveViewModel.savedLocations.contains(where: { item in
                                Int(item.locationID) == achievement.id
                           }) ? .black : .white)
                            .scaledToFit()
                            .frame(height: UIScreen.main.bounds.width/5.2)
                        Text(achievement.name).lineLimit(2).multilineTextAlignment(.center)
                        Spacer()
                    }
                    Spacer()
                }
            }.padding(.horizontal)
                .background(
                    saveViewModel.savedLocations.contains(where: { item in
                         Int(item.locationID) == achievement.id
                    }) ? .yellow:.gray
                )
                .cornerRadius(20)
            HStack{
                ForEach(1..<maxRating + 1, id:\.self){number in
                    image(for: number)
                        .renderingMode(.template).tint(.black)
                        .foregroundColor(number > rating ? offColor:onColor)
                    
                }
            }.padding(.bottom,5).padding(.vertical,5)
        }.frame(width: 165, height: 185).background(Color(.systemGray4)).cornerRadius(20)
    }
    
    func image(for number:Int) -> Image {
        if number > rating{
            return offImage ?? onImage
        }else{
            return onImage
        }
    }
}

//struct AchievementCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        AchievementCardView()
//    }
//}
