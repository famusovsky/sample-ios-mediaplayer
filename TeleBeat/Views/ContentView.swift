//
//  ContentView.swift
//  TeleBeat
//
//  Created by Алексей Степанов on 2023-02-12.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            PlayerView()
                .tag(0)
            QueueView()
                .tag(1)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
