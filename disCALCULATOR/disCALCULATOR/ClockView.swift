//
//  ClockView.swift
//  disCALCULATOR
//
//  Created by Jorrik klijnsma on 12/05/2023.
//

import SwiftUI

struct ClockView: View {
    @Binding var minutes: Double
    @Binding var hours: Double

    var body: some View {
        ZStack {
            Circle()
                .fill(Color("background"))
                .frame(width: 200, height: 200)
            
            ForEach(0..<60) { i in
                RoundedRectangle(cornerRadius: 1)
                    .frame(width: (i % 5 != 0 ? 1 : 4), height: i % 5 != 0 ? 10 : 15)
                    .foregroundColor(Color("secondary"))
                    .offset(y: -95)
                    .rotationEffect(.degrees(Double(i) * 6))
            }

            RoundedRectangle(cornerRadius: 2)
                .frame(width: 2, height: 70)
                .rotationEffect(.degrees(minutes * 360 / 60), anchor: .bottom)
                .offset(y: -35)

            RoundedRectangle(cornerRadius: 2)
                .frame(width: 4, height: 50)
                .rotationEffect(.degrees((hours * 360 / 12) + ((minutes * 30) / 60)), anchor: .bottom)
                .offset(y: -25)
        }
    }
}

struct ClockView_Previews: PreviewProvider {
    
    static var previews: some View {
        var minute: Double = 25
        var hour: Double = 12
        
        let hourForClock = Binding(
            get: { hour },
            set: { hour = $0 }
        )
        
        let minuteForClock = Binding(
            get: { minute },
            set: { minute = $0 }
        )
        
        ClockView(minutes: minuteForClock, hours:hourForClock)
    }
}
