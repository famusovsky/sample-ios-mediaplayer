//
//  PlayerView.swift
//  TeleBeat
//
//  Created by Алексей Степанов on 2023-03-05.
//

import SwiftUI
import AVFoundation

struct PlayerView: View {
    @State var currentSong: Song?
    @State var isPlaying = false

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 24) {
                Image(uiImage: currentSong?.artwork ?? UIImage(systemName: "music.note")!)
                        .resizable()
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .frame(width: geometry.size.width, height: geometry.size.width)

                VStack(spacing: 8) {
                    Text(currentSong?.name ?? "")
                            .font(.system(.title).bold())
                    Text(currentSong?.artist ?? "")
                            .font(.system(.headline))
                    Text(currentSong?.album ?? "")
                            .font(.system(.subheadline))
                    Text("\(currentSong?.duration.seconds ?? 0, specifier: "%.2f")")
                            .font(.system(.subheadline))
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
                        if isPlaying {
                            print("play")
                            Player.pause()
                            isPlaying = false
                        } else {
                            print("pause")
                            Player.play()
                            isPlaying = true
                        }
                    }) {
                        ZStack {
                            Circle()
                                    .frame(width: 80, height: 80)
                                    .accentColor(.pink)
                                    .shadow(radius: 10)
                            Image(systemName: self.isPlaying == true ? "pause.fill" : "play.fill")
                                    .foregroundColor(.white)
                                    .font(.system(.title))
                        }
                    }
                    Button(action: {
                        print("Skip")
                        Task {
                            currentSong = await Song.getFromURL(url: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!)
                            Player.addSong(song: currentSong)
                        }
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
