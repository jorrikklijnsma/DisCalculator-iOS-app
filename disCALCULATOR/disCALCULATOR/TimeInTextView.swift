//
//  TimeInText.swift
//  disCALCULATOR
//
//  Created by Jorrik klijnsma on 12/05/2023.
//
import SwiftUI

class TimeData: ObservableObject {
    @Published var selectedIntervalIndex: Int = 0
    @Published var selectedHourIndex: Int = 0
    @Published var selectedInterval: Int = 0
    @Published var selectedHour: Int = 12
    @Published var hourForClock: Int = 0
    @Published var minuteForClock: Int = 0
    @Published var early: String = ""
    @Published var earlyMomentOfDay: String = ""
    @Published var late: String = ""
    @Published var lateMomentOfDay: String = ""
    
    struct TimeTextValue {
        let text: String
        let value: Int
        let nextHour: Bool?
    }
    
    let intervalCombined = [
        TimeTextValue( text: "heel uur", value: 0, nextHour: nil),
        TimeTextValue( text: "5 over", value: 5, nextHour: nil),
        TimeTextValue( text: "10 over", value: 10, nextHour: nil),
        TimeTextValue( text: "kwart over", value: 15, nextHour: nil),
        TimeTextValue( text: "15 over", value: 15, nextHour: nil),
        TimeTextValue( text: "10 voor half", value: 20, nextHour: true),
        TimeTextValue( text: "20 over", value: 20, nextHour: nil),
        TimeTextValue( text: "5 voor half", value: 25, nextHour: true),
        TimeTextValue( text: "25 over", value: 25, nextHour: nil),
        TimeTextValue( text: "half", value: 30, nextHour: true),
        TimeTextValue( text: "30 over", value: 30, nextHour: nil),
        TimeTextValue( text: "30 voor", value: 30, nextHour: true),
        TimeTextValue( text: "5 over half", value: 35, nextHour: true),
        TimeTextValue( text: "25 voor", value: 35, nextHour: true),
        TimeTextValue( text: "10 over half", value: 40, nextHour: true),
        TimeTextValue( text: "20 voor", value: 40, nextHour: true),
        TimeTextValue( text: "kwart voor", value: 45, nextHour: true),
        TimeTextValue( text: "15 voor", value: 45, nextHour: true),
        TimeTextValue( text: "10 voor", value: 50, nextHour: true),
        TimeTextValue( text: "5 voor", value: 55, nextHour: true),
    ]
    
    let hours = [
        TimeTextValue( text: "één", value: 1, nextHour: nil),
        TimeTextValue( text: "twee", value: 2, nextHour: nil),
        TimeTextValue( text: "drie", value: 3, nextHour: nil),
        TimeTextValue( text: "vier", value: 4, nextHour: nil),
        TimeTextValue( text: "vijf", value: 5, nextHour: nil),
        TimeTextValue( text: "zes", value: 6, nextHour: nil),
        TimeTextValue( text: "zeven", value: 7, nextHour: nil),
        TimeTextValue( text: "acht", value: 8, nextHour: nil),
        TimeTextValue( text: "negen", value: 9, nextHour: nil),
        TimeTextValue( text: "tien", value: 10, nextHour: nil),
        TimeTextValue( text: "elf", value: 11, nextHour: nil),
        TimeTextValue( text: "twaalf", value: 12, nextHour: nil),
    ]

        
    func calcText() {
        selectedInterval = intervalCombined[selectedIntervalIndex].nextHour != nil ? intervalCombined[selectedIntervalIndex].value + 60 : intervalCombined[selectedIntervalIndex].value
        selectedHour = hours[selectedHourIndex].value
        let lateTime = String(format: "%02d",(selectedHour - selectedInterval / 60 + 12) % 24)
        hourForClock = selectedHour - selectedInterval / 60
        minuteForClock = selectedInterval % 60
        let hourDef = String(format: "%02d",selectedHour - selectedInterval / 60)
        let intervalTime = String(format: "%02d", selectedInterval % 60)

        early = "\(hourDef):\(intervalTime)"
        late = "\(lateTime):\(intervalTime)"
        
        earlyMomentOfDay = hourForClock == 12
            ? "'s Middags"
            : hourForClock <= 5
                ? "'s Nachts"
                : "'s Ochtends"
        lateMomentOfDay = hourForClock == 12
            ? "'s Nachts"
            : hourForClock <= 5
                ? "'s Middags"
                : "'s Avonds"
            }

    init() {
        self.calcText()
    }
}

struct TimeInTextView: View {
    @ObservedObject var timeData = TimeData()
    
    var body: some View {
        VStack {
            // fixed on top
            Text("Je leest of schrijft")
                .font(.system(size: 22))
                .padding(.bottom)
            
            // fills the available space and overflow scrolls.
            ScrollView {
                VStack {
                    if !timeData.late.isEmpty || !timeData.early.isEmpty {
                        if !timeData.early.isEmpty && !timeData.earlyMomentOfDay.isEmpty {
                            HStack {
                                Text("**\(timeData.earlyMomentOfDay)**:")
                                    .fontWeight(.light)
                                    .font(.body)
                                Spacer()
                                Text("\(timeData.early)")
                                    .fontWeight(.regular)
                                    .font(.body).italic()
                            }
                            .padding()
                            .background(Color("background"))
                            .cornerRadius(8)
                        }
                        if !timeData.late.isEmpty && !timeData.lateMomentOfDay.isEmpty {
                            HStack {
                                Text("**\(timeData.lateMomentOfDay)**:")
                                    .fontWeight(.light)
                                    .font(.body)
                                Spacer()
                                Text("\(timeData.late)")
                                    .fontWeight(.regular)
                                    .font(.body).italic()
                            }
                            .padding()
                            .background(Color("background"))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.bottom, 20)
                ClockView(minutes: Binding(get: { Double(timeData.minuteForClock) }, set: { timeData.minuteForClock = Int($0) }), hours: Binding(get: { Double(timeData.hourForClock) }, set: { timeData.hourForClock = Int($0) }))
            }
            .padding()
            
            //fixed at the bottom of the screen
            VStack {
                Text("Selecteer de text:")
                    .font(.system(size: 22))
                
                Form {
                    Picker("Kies een tijd", selection: $timeData.selectedIntervalIndex) {
                        ForEach(timeData.intervalCombined.indices, id: \.self) { index in
                            Text(timeData.intervalCombined[index].text).tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: timeData.selectedIntervalIndex, perform: { value in
                        timeData.calcText()
                    })
                    
                    Picker("Kies een uur", selection: $timeData.selectedHourIndex) {
                        ForEach(timeData.hours.indices, id: \.self) { index in
                            Text(timeData.hours[index].text).tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: timeData.selectedHourIndex, perform: { value in
                        timeData.calcText()
                    })
                }
            }
        }
        .onReceive(timeData.$selectedIntervalIndex) { _ in
            timeData.calcText()
        }
        .onReceive(timeData.$selectedHourIndex) { _ in
            timeData.calcText()
        }
    }
}

struct TimeInTextView_Previews: PreviewProvider {
    static var previews: some View {
        TimeInTextView()
    }
}
