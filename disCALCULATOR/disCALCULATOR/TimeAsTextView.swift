//
//  TimeAsTextView.swift
//  disCALCULATOR
//
//  Created by Jorrik klijnsma on 12/05/2023.
//
import SwiftUI


class TimeAsTextData: ObservableObject {
    @Published var hours: String = ""
    @Published var hourValue: Int = 0
    @Published var minutes: String = ""
    @Published var minuteValue: Int = 0
    @Published var errorText: String = ""
    @Published var timeText: [LabelTypeObject] = []
    
    // Mapping numerical hour and minute values to their Dutch text equivalents
    let hourConvert: [String] = ["twaalf","één","twee","drie","vier","vijf","zes","zeven","acht","negen","tien","elf","twaalf","één","twee","drie","vier","vijf","zes","zeven","acht","negen","tien","elf",];
    
    let minuteConvert: [String] = ["nul","één","twee","drie","vier","vijf","zes","zeven","acht","negen","tien","elf","twaalf","dertien","veertien","vijftien","zestien","zeventien","achttien","negentien","twintig","eenentwintig","tweeëntwintig","drieëntwintig","vierentwintig","vijfentwintig","zesentwintig","zevenentwintig","achtentwintig","negenentwintig","dertig","eenendertig","tweeëndertig","drieëndertig","vierendertig","vijfendertig","zesendertig","zevenendertig","achtendertig","negenendertig","veertig","eenenveertig","tweeënveertig","drieënveertig","vierenveertig","vijfenveertig","zesenveertig","zevenenveertig","achtenveertig","negenenveertig","vijftig","eenenvijftig","tweeënvijftig","drieënvijftig","vierenvijftig","vijfenvijftig","zesenvijftig","zevenenvijftig","achtenvijftig","negenenvijftig"]

    func calcText() {
        hourValue = Int(hours) ?? 0
        minuteValue = Int(minutes) ?? 0
        
        if hourValue < 0 || hourValue > 23 {
            errorText = "Invalid hours"
            return
        }
        
        if minuteValue < 0 || minuteValue > 59 {
            errorText = "Invalid minutes"
            return
        }
        
        errorText = ""
        timeText = []
        
        let hourText = hourConvert[hourValue]
        let nextHourText = hourConvert[hourValue + 1 == 24 ? 0 : hourValue + 1]
        let minuteText = minuteConvert[minuteValue]
        
        timeText.append(LabelTypeObject(type: "Exacte tijd", value: minuteValue == 0 ? "\(hourText) uur" : minuteValue < 30 ? "\(minuteText) over \(hourText)" : "\(minuteConvert[60 - minuteValue]) voor \(nextHourText)"))
        if minuteValue != 0 {
            timeText.append(LabelTypeObject(type: "Exacte tijd versie 2", value: "\(hourText) uur \(minuteText)"))
        }
        
        var aproximationLogical = ""
        var aproximationLessLogical = ""
        
        let fiveMinuteValue = convertTo5MinuteInterval(inputMinute: minuteValue)
        
        
        switch fiveMinuteValue {
            case 0:
                aproximationLogical = "\(hourText) uur"
            case 5:
                fallthrough
            case 10:
                aproximationLogical = "\(minuteConvert[fiveMinuteValue]) over \(hourText)"
            case 15:
                aproximationLogical = "kwart over \(hourText)"
                aproximationLessLogical = "\(minuteConvert[fiveMinuteValue]) over \(hourText)"
            case 20:
                fallthrough
            case 25:
                aproximationLogical = "\(minuteConvert[30 - fiveMinuteValue]) voor half \(hourText)"
                aproximationLessLogical = "\(minuteConvert[fiveMinuteValue]) over \(hourText)"
            case 30:
                aproximationLogical = "half \(nextHourText)"
                aproximationLessLogical = "\(minuteConvert[fiveMinuteValue]) voor \(nextHourText) of \(minuteConvert[fiveMinuteValue]) over \(hourText)"
            case 35:
                fallthrough
            case 40:
                aproximationLogical = "\(minuteConvert[fiveMinuteValue - 30]) over half \(nextHourText)"
                aproximationLessLogical = "\(minuteConvert[60 - fiveMinuteValue]) voor \(nextHourText)"
            case 45:
                aproximationLogical = "kwart voor \(nextHourText)"
                aproximationLessLogical = "\(minuteConvert[60 - fiveMinuteValue]) voor \(nextHourText)"
            case 50:
                fallthrough
            case 55:
                aproximationLogical = "\(minuteConvert[60 - fiveMinuteValue]) voor \(nextHourText)"
            case 60:
                aproximationLogical = "\(hourText) uur"
            default:
                aproximationLogical = ""
        }
        
        var momentOfDay = ""
        
        switch true {
            case hourValue < 6:
                momentOfDay = "'s Nachts";
            case hourValue < 12:
                momentOfDay = "'s Ochtends";
            case hourValue < 18:
                momentOfDay = "'s Middags";
            default:
                momentOfDay = "'s Avonds";
        }
        
        if aproximationLogical != "" {
            timeText.append(LabelTypeObject(type: "Ongeveer (logisch)", value: aproximationLogical))
        }
        if aproximationLessLogical != "" {
            timeText.append(LabelTypeObject(type: "Ongeveer (minder logisch)", value: aproximationLessLogical))
        }
        if momentOfDay != "" {
            timeText.append(LabelTypeObject(type: "Moment van de dag", value: momentOfDay))
        }
    }
    
    func convertTo5MinuteInterval(inputMinute: Int) -> Int {
        return Int(round(Double(inputMinute) / 5.0) * 5.0)
    }
    
    init() {
        self.calcText()
    }
}

struct TimeAsTextView: View {
    @ObservedObject var timeAsTextData = TimeAsTextData()
    @FocusState private var minutesAreFocused: Bool
    @FocusState private var hoursAreFocused: Bool
    
    
    var body: some View {
        VStack() {
            if !timeAsTextData.errorText.isEmpty {
                Text(timeAsTextData.errorText)
            }
            
            Text("Je zegt:")
                .font(.system(size: 22))
                .padding(.bottom)
            
            ScrollView {
                VStack {
                    ForEach(timeAsTextData.timeText, id: \.self.value) { labelTypeObject in
                        HStack {
                            Text(labelTypeObject.type)
                                .fontWeight(.light)
                                .font(.body)
                            Spacer()
                            Text(labelTypeObject.value)
                                .fontWeight(.regular)
                                .font(.body).italic()
                        }
                        .padding()
                        .background(Color("background"))
                        .cornerRadius(8)
                    }
                }
                .padding(.bottom, 20)
                
                ClockView(minutes: Binding(get: { Double(timeAsTextData.minuteValue) }, set: { timeAsTextData.minuteValue = Int($0) }), hours: Binding(get: { Double(timeAsTextData.hourValue) }, set: { timeAsTextData.hourValue = Int($0) }))
            }
            .padding()
        
            VStack {
                Text("Selecteer de tijd:")
                    .font(.system(size: 22))
                    .padding(.bottom)
                
                HStack {
                    
                    Spacer()
                    
                    TextField("0", text: $timeAsTextData.hours)
                        .onChange(of: timeAsTextData.hours) { newValue in
                            if let intValue = Int(newValue), intValue >= 0, intValue <= 23 {
                                // valid input
                                
                            } else {
                                // invalid input, reset
                                timeAsTextData.hours = ""
                            }
                        }
                        .keyboardType(.numbersAndPunctuation)
                        .submitLabel(.next)
                        .onSubmit {
                            hoursAreFocused = false
                            minutesAreFocused = true
                        }
                        .frame(width: 40)
                        .focused($hoursAreFocused)
                        .padding()
                        .background(Color("background"))
                        .foregroundColor(Color("primary"))
                        .cornerRadius(10)
                    
                    Spacer()
                    
                    Text(":")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                    
                    Spacer()
                    
                    TextField("0", text: $timeAsTextData.minutes)
                        .onChange(of: timeAsTextData.minutes) { newValue in
                            if let intValue = Int(newValue), intValue >= 0, intValue <= 59 {
                                // valid input
                            } else {
                                // invalid input, reset
                                timeAsTextData.minutes = ""
                            }
                        }
                        .keyboardType(.numbersAndPunctuation)
                        .submitLabel(.done)
                        .onSubmit {
                            minutesAreFocused = false
                        }
                        .focused($minutesAreFocused)
                        .frame(width: 40)
                        .padding()
                        .background(Color("background"))
                        .foregroundColor(Color("primary"))
                        .cornerRadius(10)
                    Spacer()
                }
                .padding()
                .background(Color("secondary"))
            }
        }
        .onReceive(timeAsTextData.$minutes) { _ in
            timeAsTextData.calcText()
        }
        .onReceive(timeAsTextData.$hours) { _ in
            timeAsTextData.calcText()
        }
    }
}

struct LabelTypeObject {
    var type: String
    var value: String
}

struct TimeAsTextView_Previews: PreviewProvider {
    static var previews: some View {
        TimeAsTextView()
    }
}
