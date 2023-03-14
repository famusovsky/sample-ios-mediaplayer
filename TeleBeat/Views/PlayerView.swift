//
//  PlayerView.swift
//  TeleBeat
//
//  Created by Алексей Степанов on 2023-03-05.
//

import SwiftUI

fileprivate let testLinks: [String] = [
    "https://ru.hitmotop.com/get/music/20221217/INSTASAMKA_-_KAK_MOMMY_75305573.mp3",
    "https://ru.hitmotop.com/get/music/20230223/DVRST_Igor_Sklyar_Atomic_Heart_-_Komarovo_75479753.mp3",
    "https://ru.hitmotop.com/get/music/20220819/MJEJJBI_BJEJJBI_-_Pokhryukajj_74658629.mp3",
    "https://ru.hitmotop.com/get/music/20211124/dora_-_Vtyurilas_73373030.mp3",
    "https://ru.hitmotop.com/get/music/20211024/GAYAZOV_BROTHER_-_MALINOVAYA_LADA_73214200.mp3",
    "https://ru.hitmotop.com/get/music/20190305/Korol_i_SHut_-_Prygnu_so_skaly_62570549.mp3",
    "https://ru.hitmotop.com/get/music/20170831/Blondie_-_Call_Me_47868661.mp3"
]

struct PlayerView: View {
    @ObservedObject var model: PlayerViewModel = PlayerViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 24) {
                Button(action: {
                    Task {
                        // TODO: сделать нормально + иногда падает
                        let song = await Song.getFromURL(url: URL(string: testLinks[Int.random(in: 0..<testLinks.count)])!)
                        Player.addSong(song: song)
                    }
                }) {
                    Image(systemName: "plus.app")
                            .font(.system(.title))
                            .foregroundColor(.black)
                            .shadow(radius: 10)
                            .position(x: geometry.size.width * 8 / 10, y: geometry.size.height / 10)
                }
                Image(uiImage: model.currentSong != nil
                        ? model.currentArtwork ?? UIImage(systemName: "app.fill")!
                        : UIImage(systemName: "rays")!)
                        .resizable()
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .frame(width: geometry.size.width * 3 / 4, height: geometry.size.width * 3 / 4)
                VStack(spacing: 8) {
                    Text(model.currentSong?.name ?? "")
                            .font(.system(.title).bold())
                    Text(model.currentSong?.artist ?? "")
                            .font(.system(.headline))
                    Text(model.currentSong?.album ?? "")
                            .font(.system(.subheadline))
                }
                if model.currentSong != nil {
                    PlayerSliderView()
                    HStack(spacing: 24) {
                        Button(action: {
                            Player.rewind()
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
                        }) {
                            ZStack {
                                Circle()
                                        .frame(width: 80, height: 80)
                                        .accentColor(.black)
                                Image(systemName: model.isPlaying ? "pause.fill" : "play.fill")
                                        .foregroundColor(.white)
                                        .font(.system(.title))
                            }
                        }
                        Button(action: {
                            Player.skip()
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
                    Spacer()
                }
            }
        }
    }
}

class PlayerViewModel: ObservableObject, PlayerSongUser, PlayerIsPlayingUser {
    @Published var currentSong: Song?
    @Published var currentArtwork: UIImage?
    @Published var isPlaying = false

    init() {
        Player.concreteUser(user: self as PlayerSongUser)
        Player.concreteUser(user: self as PlayerIsPlayingUser)

        updateSong()
        updateIsPlaying()
    }

    public func updateSong() {
        Task {
            if let song = Player.getCurrentSong() {
                currentSong = song
                currentArtwork = UIImage(systemName: "app")!
                currentArtwork = await song.getArtwork()
            } else {
                currentSong = nil
                currentArtwork = nil
            }
        }
    }

    func updateIsPlaying() {
        isPlaying = Player.isPlaying()
    }
}
