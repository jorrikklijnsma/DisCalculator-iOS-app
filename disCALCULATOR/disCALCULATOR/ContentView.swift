import SwiftUI

enum Tab {
    case timeAsText
    case textAsTime
}

struct ContentView: View {
    @State private var selectedTab: Tab = .timeAsText
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Views", selection: $selectedTab) {
                    Text("Time as Text").tag(Tab.timeAsText)
                    Text("Text as Time").tag(Tab.textAsTime)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                switch selectedTab {
                case .timeAsText:
                    TimeAsTextView()
                case .textAsTime:
                    TimeInTextView()
                }
            }
            .navigationBarTitle("disCALCULATOR", displayMode: .inline)
        }
    }
}

struct TextAsTimeView: View {
    var body: some View {
        Text("Text as Time View")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct NumberTextField: View {
    let title: String
    @Binding var value: Int
    let formatter: NumberFormatter
    
    var body: some View {
        TextField(title, value: $value, formatter: formatter)
            .padding()
    }
}


struct TimeInTextView: View {
    @State private var currentTime: Date = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text("Current Time as Text")
                .font(.largeTitle)
                .padding()
            
            Text("\(currentTime, style: .time)")
                .font(.largeTitle)
                .onReceive(timer) { input in
                    self.currentTime = input
                }
        }
    }
}
