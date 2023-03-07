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
    @State var player: AVAudioPlayer?
    
    var body: some View {
        TabView(selection: $selection) {
            PlayerView(player: $player)
                .tag(0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
