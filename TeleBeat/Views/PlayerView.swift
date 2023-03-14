//
//  PlayerView.swift
//  TeleBeat
//
//  Created by Алексей Степанов on 2023-03-05.
//

import SwiftUI

fileprivate let links: [String] = [
    "https://ru.hitmotop.com/get/music/20221217/INSTASAMKA_-_KAK_MOMMY_75305573.mp3",
    "https://ru.hitmotop.com/get/music/20230223/DVRST_Igor_Sklyar_Atomic_Heart_-_Komarovo_75479753.mp3",
    "https://ru.hitmotop.com/get/music/20220819/MJEJJBI_BJEJJBI_-_Pokhryukajj_74658629.mp3",
    "https://ru.hitmotop.com/get/music/20211124/dora_-_Vtyurilas_73373030.mp3",
    "https://ru.hitmotop.com/get/music/20211024/GAYAZOV_BROTHER_-_MALINOVAYA_LADA_73214200.mp3",
    "https://ru.hitmotop.com/get/music/20190305/Korol_i_SHut_-_Prygnu_so_skaly_62570549.mp3"
]

struct PlayerView: View {
    @ObservedObject var model: PlayerViewModel = PlayerViewModel()
    @State var isPlayToggled: Bool = false

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 24) {
                Button(action: {
                    Task {
                        // TODO: сделать нормально + иногда падает
                        let song = await Song.getFromURL(url: URL(string: links[Int.random(in: 0..<links.count)])!)
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
                        .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                        .position(x: geometry.size.width / 2, y: -geometry.size.height / 40)

                VStack(spacing: 8) {
                    Text(model.currentSong?.name ?? "")
                            .font(.system(.title).bold())
                    Text(model.currentSong?.artist ?? "")
                            .font(.system(.headline))
                    Text(model.currentSong?.album ?? "")
                            .font(.system(.subheadline))
                    Text(model.currentSong != nil
                            ? "\(model.currentSong?.duration ?? 0, specifier: "%.2f") seconds"
                            : "")
                            .font(.system(.subheadline))
                }
                if model.currentSong != nil {
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
}

class PlayerViewModel: ObservableObject, PlayerSongUser {
    @Published var currentSong: Song?
    @Published var currentArtwork: UIImage?

    init() {
        Player.concreteUser(user: self)
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
}
