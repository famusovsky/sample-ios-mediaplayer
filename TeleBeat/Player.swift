//
//  Player.swift
//  TeleBeat
//
//  Created by Алексей Степанов on 2023-03-05.
//

import Foundation
import AVFoundation
import SwiftUI

public class Player {
    private static var player: AVPlayer! = AVPlayer()
    public static var songs: [Song] = []
    private static var current: Int = 0
    private static var songUsers: [PlayerSongUser] = []
    private static var queueUsers: [PlayerQueueUser] = []
    private static var isPlayToggled: Bool = false
    private static let tgClient = TGClient()

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
            } else {
                if num >= songs.count {
                    current = songs.count - 1
                } else {
                    current = 0
                }
            }
        }
    }

    static func seek(time: Double) {
        if player != nil {
            let time = CMTime(seconds: time, preferredTimescale: 1)
            player.seek(to: time)
        }
    }

    private static func concreteCurrentSong() {
        for user in songUsers {
            user.updateSong()
        }
        if songs.count != 0 {
            let song = songs[current]
            print("playing \(song.url): \(song.name)")
            do {
                //TODO: add error handling and make normal
                let playerItem = AVPlayerItem(url: song.url)
                player = AVPlayer(playerItem: playerItem)
                player.volume = 1.0
            } catch {
                print("AVAudioPlayer init failed")
            }
        } else {
            player = AVPlayer()
        }
        if isPlaying() {
            player.play()
        }
    }

    static func addSong(song: Song?) {
        if let song = song {
            songs.append(song)
            for user in queueUsers {
                user.updateQueue()
            }
            print("song \(song.name) is added")

            if songs.count == 1 {
                concreteCurrentSong()
            }
        }
    }

    static func removeSong(index: Int) {
        if index >= 0 && index < songs.count {
            songs.remove(at: index)
            for user in queueUsers {
                user.updateQueue()
            }
            if index < current {
                current -= 1
            } else if index == current {
                if current >= songs.count {
                    current = songs.count == 0 ? 0 : songs.count - 1
                }
                concreteCurrentSong()
            }
            print("song is removed")
        }
    }

    static func getCurrentSong() -> Song? {
        if songs.count > 0 {
            return songs[current]
        } else {
            return nil
        }
    }

    static func getCurrentTime() -> TimeInterval {
        if player != nil {
            return player.currentTime().seconds
        } else {
            return 0
        }
    }

    static func concreteUser(user: PlayerSongUser) {
        songUsers.append(user)
        print("song user is added")
    }

    static func concreteUser(user: PlayerQueueUser) {
        queueUsers.append(user)
        print("queue user is added")
    }

    static func isPlaying() -> Bool {
        isPlayToggled
    }

    static func getQueue() -> [Song] {
        songs
    }
}
