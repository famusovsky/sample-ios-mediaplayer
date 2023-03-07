//
//  PlayerView.swift
//  TeleBeat
//
//  Created by Алексей Степанов on 2023-03-05.
//

import SwiftUI
import AVFoundation

struct PlayerView: View {
    @Binding var player: AVAudioPlayer?
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 24) {
                Image("amogus")
                    .resizable()
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .frame(width: geometry.size.width, height: geometry.size.width)
                
                VStack(spacing: 8) {
                    Text("Song")
                        .font(.system(.title).bold())
                    Text("Artist")
                        .font(.system(.headline))
                }
                
                HStack(spacing: 24) {
                    Button(action: {
                        print("Rewind")
                    }) {
                        ZStack {
                            Circle()
                                .frame(width: 80, height: 80)
                                .accentColor(.pink)
                                .shadow(radius: 10)
                            Image(systemName: "backward.fill")
                                .foregroundColor(.white)
                                .font(.system(.title))
                        }
                    }
                    Button(action: {
                        print("play")
                    }) {
                        ZStack {
                            Circle()
                                .frame(width: 80, height: 80)
                                .accentColor(.pink)
                                .shadow(radius: 10)
                            Image(systemName: "play.fill")
                                .foregroundColor(.white)
                                .font(.system(.title))
                        }
                    }
                    Button(action: {
                        print("Skip")
                    }) {
                        ZStack {
                            Circle()
                                .frame(width: 80, height: 80)
                                .accentColor(.pink)
                                .shadow(radius: 10)
                            Image(systemName: "forward.fill")
                                .foregroundColor(.white)
                                .font(.system(.title))
                        }
                    }
                }
            }
        }
    }
}
