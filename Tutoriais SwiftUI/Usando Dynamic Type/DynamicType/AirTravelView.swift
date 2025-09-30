//
//  AirTravelView.swift
//  DynamicType
//
//  Created by Joel Davies on 2/20/24.
//
//  os26 version July 2025


import SwiftUI

struct AirTravelView: View {
    var body: some View {
        VStack {
            
            HStack {
                //MARK: ViewThatFits chooses a view that fits into the space - from top to bottom of the choices you list. When views are rendered, it chooses the best view that fits in every situation. In this case, as the text gets bigger, it goes down the list and picks the option that fits best.
                ViewThatFits {
                    Label("San Francisco, USA", systemImage: "airplane.departure")// first choice
                    Label("San Francisco, USA", systemImage: "airplane.departure").fontWidth(.compressed)
                    Label("SFO, USA", systemImage: "airplane.departure")//second choice
                    Text("SFO")//third choice
                }
                .padding(.leading, 10)
                .font(.caption)
                
                Spacer()
                Image(systemName: "arrow.forward")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                
                ViewThatFits {
                    Label("Riyadh, Saudi Arabia", systemImage: "airplane.arrival")
                    Label("RUH, KSA", systemImage: "airplane.arrival")
                    Text("RUH")
                }
                .padding(.trailing, 10)
                .font(.caption)
            }
            Divider()
            HStack{
                ViewThatFits {
                    Text("Departure Time 18:30 PST")
                    Text("Depart 18:30 PST")
                    Text("18:30")
                }
                .padding(.leading, 10)
                .font(.caption)
                .foregroundStyle(.blue)
                
                Spacer()
                Image(systemName: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                
                ViewThatFits {
                    Text("Arrival Time 17:30 SAST")
                    Text("Arrive 18:30 SAST")
                    Text("17:30")
                }
                .padding(.trailing, 10)
                .font(.caption)
                .foregroundStyle(.blue)
            }
            
        }
        .padding(.vertical)
        .background(in:RoundedRectangle(cornerRadius: 8))
        .foregroundStyle(.primary)
        .backgroundStyle(.quinary)
    }
}

#Preview {
    AirTravelView()
}
