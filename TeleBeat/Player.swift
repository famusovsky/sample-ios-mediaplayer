//
//  Player.swift
//  TeleBeat
//
//  Created by Алексей Степанов on 2023-03-05.
//

import Foundation
import AVFoundation

public class Player {
    private static var player: AVPlayer! = AVPlayer()
    private static var songs: [Song] = []
    private static var current: Int = 0
    private static var user: PlayerUser?
    private static var isPlayToggled: Bool = false
    private static var tgClient = try! TGClient()

    static func play() {
        if let player = player {
            player.play()
            isPlayToggled = true
        }
    }

    static func pause() {
        if let player = player {
            player.pause()
            isPlayToggled = false
        }
    }

    static func skip() {
        setupSongNumber(num: current + 1)
    }

    static func rewind() {
        setupSongNumber(num: current - 1)
    }

    static func setupSongNumber(num: Int) {
        if player != nil {
            if num >= 0 && num < songs.count {
                player.pause()
                current = num
                print(current, songs.count)
                concreteCurrentSong()
                if isPlaying() {
                    player.play()
                }
            } else {
                if num >= songs.count {
                    current = songs.count - 1
                } else {
                    current = 0
                }
            }
        }
    }

    private static func concreteCurrentSong() {
        if songs.count != 0 {
            let song = songs[current]
            print("playing \(song.url): \(song.name)")
            do {
                //TODO: add error handling and make normal
                let playerItem = AVPlayerItem(url: song.url)
                player = AVPlayer(playerItem: playerItem)
                player.volume = 1.0
                print(isPlaying())
            } catch {
                print("AVAudioPlayer init failed")
            }
        }
    }

    static func addSong(song: Song?) {
        if let song = song {
            songs.append(song)

            if songs.count == 1 {
                concreteCurrentSong()
            }
        }
    }

    static func getCurrentSong() -> Song? {
        if songs.count > 0 {
            return songs[current]
        } else {
            return nil
        }
    }

    static func concreteUser(user: PlayerUser) {
        self.user = user
        tgClient.test()
        print("user is added")
    }

    static func isPlaying() -> Bool {
        isPlayToggled
    }

    static func testTG() async {
        // await tgClient.setUp()
        //let num = await tgClient.getChatID()
        //print(num)
        //await tgClient.test(chatId: num)
    }
}

