//
//  Clock.swift
//  disCALCULATOR
//
//  Created by Jorrik klijnsma on 12/05/2023.
//
struct Clock: View {
    @State private var minutes: Double = 0
    @State private var hours: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("Background"))
                .frame(width: 200, height: 200)
            
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 2, height: 80)
                .rotationEffect(.degrees(minutes * 360 / 60), anchor: .bottom)
                .offset(y: -30)
            
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 2, height: 60)
                .rotationEffect(.degrees((hours * 360 / 12) + ((minutes * 30) / 60)), anchor: .bottom)
                .offset(y: -20)
        }
    }
}
