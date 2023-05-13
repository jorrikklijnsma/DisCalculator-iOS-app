//
//  HeaderView.swift
//  disCALCULATOR
//
//  Created by Jorrik klijnsma on 12/05/2023.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
            ZStack {
                Color("background")
                VStack {
                    Text("Hello, world!")
                        .font(.largeTitle)
                        .foregroundColor(Color("primary"))
                    Button(action: {}) {
                        Text("Button")
                            .font(.title)
                            .foregroundColor(Color("background"))
                            .padding()
                            .background(Color("accent"))
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            }
        }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
