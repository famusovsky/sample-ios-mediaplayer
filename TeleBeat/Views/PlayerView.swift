//
//  PlayerView.swift
//  TeleBeat
//
//  Created by Алексей Степанов on 2023-03-05.
//

import SwiftUI

struct PlayerView: View {
    @ObservedObject var model: PlayerViewModel = PlayerViewModel()
    @State var isPlayToggled: Bool = false
    private let standardArtwork = UIImage(systemName: "app")!

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 24) {
                Button(action: {
                    Task {
                        // TODO: сделать нормально + иногда падает
                        let song = await Song.getFromURL(url: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!)
                        Player.addSong(song: song)
                    }
                }) {
                    Image(systemName: "plus.app")
                            .font(.system(.title))
                            .foregroundColor(.black)
                            .shadow(radius: 10)
                            .position(x: geometry.size.width * 8 / 10, y: geometry.size.height / 10)
                }
                Image(uiImage: model.currentArtwork ?? standardArtwork)
                        .resizable()
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                        .position(x: geometry.size.width / 2, y: -geometry.size.height / 40)

                VStack(spacing: 8) {
                    Text(model.currentSong?.name ?? "")
                            .font(.system(.title).bold())
                    Text(model.currentSong?.artist ?? "")
                            .font(.system(.headline))
                    Text(model.currentSong?.album ?? "")
                            .font(.system(.subheadline))
                    Text("\(model.currentSong?.duration.seconds ?? 0, specifier: "%.2f")")
                            .font(.system(.subheadline))
                }

                HStack(spacing: 24) {
                    Button(action: {
                        Player.rewind()
                        isPlayToggled = Player.isPlaying()
                    }) {
                        ZStack {
                            Circle()
                                    .frame(width: 80, height: 80)
                                    .accentColor(.black)
                            Image(systemName: "backward.fill")
                                    .foregroundColor(.white)
                                    .font(.system(.title))
                        }
                    }
                    Button(action: {
                        if Player.isPlaying() {
                            Player.pause()
                        } else {
                            Player.play()
                        }
                        isPlayToggled = Player.isPlaying()
                    }) {
                        ZStack {
                            Circle()
                                    .frame(width: 80, height: 80)
                                    .accentColor(.black)
                            Image(systemName: isPlayToggled ? "pause.fill" : "play.fill")
                                    .foregroundColor(.white)
                                    .font(.system(.title))
                        }
                    }
                    Button(action: {
                        Player.skip()
                        isPlayToggled = Player.isPlaying()
                    }) {
                        ZStack {
                            Circle()
                                    .frame(width: 80, height: 80)
                                    .accentColor(.black)
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

class PlayerViewModel : ObservableObject, PlayerSongUser {
    @Published var currentSong: Song?
    @Published var currentArtwork: UIImage?
    
    init() {
        Player.concreteUser(user: self)
    }

    public func updateSong() {
         Task {
             if let song = Player.getCurrentSong() {
                 currentSong = song
                 currentArtwork = await song.getArtwork()
             } else {
                 currentSong = nil
                 currentArtwork = nil
             }
         }
     }
}
