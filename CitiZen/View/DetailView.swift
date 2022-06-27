//
//  DetailView.swift
//  CitiZen
//
//  Created by Kenneth Widjaya on 23/06/22.
//

import SwiftUI

struct DetailView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Ciputra Watepark")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .scaledToFill()
                        .frame(width: 35, height: 35)
                }
                Text("Amusement Park | ") +
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
                        
                        Text("Parking lot, Kawasan, Jl. Waterpark Boulevard Jl. Citraland Surabaya, Made, Kec. Sambikerep, Kota SBY, Jawa Timur 60219")
                            .font(.caption)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Details")
                            .font(.headline)
                        
                        Text("Parking lot, Kawasan, Jl. Waterpark Boulevard Jl. Citraland Surabaya, Made, Kec. Sambikerep, Kota SBY, Jawa Timur 60219")
                            .font(.caption)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Opended")
                            .font(.headline)
                        
                        Text("Parking lot, Kawasan, Jl. Waterpark Boulevard Jl. Citraland Surabaya, Made, Kec. Sambikerep, Kota SBY, Jawa Timur 60219")
                            .font(.caption)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Price")
                            .font(.headline)
                        
                        Text("Week Day Rp 75.000 Week End Rp 95.000")
                            .font(.caption)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Website")
                            .font(.headline)
                        
                        Text("http://www.ciputrawaterparksurabaya.com/new2/")
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
