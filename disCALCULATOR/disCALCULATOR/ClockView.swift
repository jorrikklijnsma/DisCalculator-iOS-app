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
    
    private let screenSize = min(UIScreen.main.bounds.width * 0.56, UIScreen.main.bounds.height * 0.56)

    var body: some View {
        ZStack {
            Circle()
                .fill(Color("background"))
                .frame(width: screenSize, height:  screenSize)
            
            ForEach(0..<60) { i in
                RoundedRectangle(cornerRadius: 1)
                    .frame(width: (i % 5 != 0 ? screenSize * 0.01 : screenSize * 0.02), height: i % 5 != 0 ? screenSize * 0.05 : screenSize * 0.09)
                    .foregroundColor(Color("secondary"))
                    .offset(y: i % 5 != 0 ? screenSize * 0.48 : screenSize * 0.48 )
                    .rotationEffect(.degrees(Double(i) * 6))
            }

            RoundedRectangle(cornerRadius: 2)
                .frame(width: screenSize * 0.01, height: screenSize * 0.35)
                .rotationEffect(.degrees(minutes * 360 / 60), anchor: .bottom)
                .offset(y: -screenSize * 0.35 * 0.5)

            RoundedRectangle(cornerRadius: 2)
                .frame(width: screenSize * 0.02, height: screenSize * 0.25)
                .rotationEffect(.degrees((hours * 360 / 12) + ((minutes * 30) / 60)), anchor: .bottom)
                .offset(y: -screenSize * 0.25 * 0.5)
        }
    }
}

struct ClockView_Previews: PreviewProvider {
    
    static var previews: some View {
        var minute: Double = 25
        var hour: Double = 7
        
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
