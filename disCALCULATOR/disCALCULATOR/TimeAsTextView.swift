//
//  TimeAsTextView.swift
//  disCALCULATOR
//
//  Created by Jorrik klijnsma on 12/05/2023.
//
import SwiftUI

struct TimeAsTextView: View {
    @State private var hours: String = ""
    @State private var minutes: String = ""
    @State private var errorText: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Selecteer de tijd:")
            
            HStack {
                TextField("0", text: $hours)
                    .keyboardType(.numberPad)
                    .frame(width: 40)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.blue)
                    .foregroundColor(.black)
                
                Text(":")
                
                TextField("0", text: $minutes)
                    .keyboardType(.numberPad)
                    .frame(width: 40)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.blue)
                    .foregroundColor(.black)
            }
            
            if !errorText.isEmpty {
                Text(errorText)
            }
            
            Text("Je zegt:")
            
            VStack(alignment: .center, spacing: 20) {
                // Placeholder for dynamic data
                Text("Placeholder for formattedLabel.type")
                    .fontWeight(.bold)
                    .font(.body)
                Text("Placeholder for formattedLabel.value")
                    .fontWeight(.bold)
                    .font(.title2)
            }
            
            // Clock(hours: hours, minutes: minutes)
            // Placeholder for Clock component
            Text("Placeholder for Clock component")
            
            
            Spacer() 
        }
    }
}

struct TimeCalcView_Previews: PreviewProvider {
    static var previews: some View {
        TimeAsTextView()
    }
}
