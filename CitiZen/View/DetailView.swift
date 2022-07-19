//
//  DetailView.swift
//  CitiZen
//
//  Created by Kenneth Widjaya on 23/06/22.
//

import SwiftUI

struct DetailView: View {
    @Binding var offset: CGFloat
    @Binding var lastOffset: CGFloat
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
                        withAnimation {
                            offset = 0
                            lastOffset = 0
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundColor(Color(.systemGray5))

                            Image(systemName: "xmark")
                                .resizable()
                                .foregroundColor(.secondary)
                                .scaledToFill()
                                .frame(width: 11, height: 11)
                        }
                        .frame(width: 30, height: 30)
                    }
                }
                Text("\(item.category)")
//                + Text("CLOSE")
//                    .foregroundColor(.red)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(item.photo, id: \.self) { num in
                            Image("\(num)")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipped()
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 15) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Alamat")
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
                            Text("Harga")
                                .font(.headline)
                            
                            Text(item.tourPrice ?? "")
                                .font(.caption)
                        }
                    }
                    
                    if item.cerita == nil {
                        
                    } else {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Cerita")
                                .font(.headline)
                            
                            Text(item.cerita ?? "")
                                .font(.caption)
                        }
                        .padding(.bottom, UIScreen.main.bounds.height / 2.5)
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
