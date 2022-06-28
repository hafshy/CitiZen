//
//  DetailView.swift
//  CitiZen
//
//  Created by Kenneth Widjaya on 23/06/22.
//

import SwiftUI

struct DetailView: View {
    @Binding var offset: CGFloat
    var item : Datum
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text(item.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button {
                        offset = 0
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .foregroundColor(.gray)
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                    }
                }
                Text("\(item.category) | ") +
                Text("CLOSE")
                    .foregroundColor(.red)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(0 ..< 3) { item in
                            Image(systemName: "square")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 15) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Address")
                            .font(.headline)
                        
                        Text(item.adress)
                            .font(.caption)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Trivia")
                            .font(.headline)
                        
                        Text(item.trivia)
                            .font(.caption)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Jam Operasional")
                            .font(.headline)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Senin")
                                Text("Selasa")
                                Text("Rabu")
                                Text("Kamis")
                                Text("Jumat")
                                Text("Sabtu")
                                Text("Minggu")
                                if item.operasionalHours.siteTour == nil {
                                    
                                } else {
                                    Text("Site Tour")
                                }
                            }
                            .font(.caption)
                            
                            VStack(alignment: .leading) {
                                Text(item.operasionalHours.senin)
                                Text(item.operasionalHours.selasa)
                                Text(item.operasionalHours.rabu)
                                Text(item.operasionalHours.kamis)
                                Text(item.operasionalHours.jumat)
                                Text(item.operasionalHours.sabtu)
                                Text(item.operasionalHours.minggu)
                                if item.operasionalHours.siteTour == nil {
                                    
                                } else {
                                    Text(item.operasionalHours.siteTour ?? "")
                                }
                            }
                            .font(.caption)
                        }
                    }
                    
                    if item.tourPrice == nil {
                        
                    } else {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Price")
                                .font(.headline)
                            
                            Text(item.tourPrice ?? "")
                                .font(.caption)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Website")
                            .font(.headline)
                        
//                        Text(item.)
//                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}
