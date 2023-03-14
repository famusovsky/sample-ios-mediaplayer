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
    public static var songs: [Song] = getFromUserDefaults() ?? []
    private static var current: Int = 0
    private static var songUsers: [PlayerSongUser] = []
    private static var queueUsers: [PlayerQueueUser] = []
    private static var isPlayingUsers: [PlayerIsPlayingUser] = []
    private static var isPlayToggled: Bool = false

    static private func getFromUserDefaults() -> [Song]? {
        if let data = UserDefaults.standard.data(forKey: "songs") {
            do {
                let songs = try JSONDecoder().decode([Song].self, from: data)
                return songs
            } catch {
                print("Error decoding songs")
            }
        }
        return nil
    }

    static func play() {
        if let player = player {
            if player.currentItem == nil {
                concreteCurrentSong()
                play()
            }
            player.play()
            isPlayToggled = true

            notifyIsPlayingUsers()
        }
    }

    static func pause() {
        if let player = player {
            player.pause()
            isPlayToggled = false

            notifyIsPlayingUsers()
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

    private static func concreteCurrentSong() {
        if player.currentItem != nil {
            notifySongUsers()
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


    static func seek(time: Double) {
        if player != nil {
            let time = CMTime(seconds: time, preferredTimescale: 1)
            player.seek(to: time)
        }
    }

    static func addSong(song: Song?) {
        if let song = song {
            songs.append(song)
            updateUserDefaults()

            notifyQueueUsers()
            print("song \(song.name) is added")

            if songs.count == 1 {
                concreteCurrentSong()
                notifySongUsers()
            }
        }
    }

    static func removeSong(index: Int) {
        if index >= 0 && index < songs.count {
            songs.remove(at: index)
            updateUserDefaults()

            notifyQueueUsers()
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

    static private func updateUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(songs) {
            UserDefaults.standard.set(encoded, forKey: "songs")
        }
    }

    static func getCurrentSong() -> Song? {
        if songs.count > 0 {
            return songs[current]
        } else {
            return nil
        }
    }

    static func concreteUser(user: PlayerSongUser) {
        songUsers.append(user)
    }

    static func concreteUser(user: PlayerQueueUser) {
        queueUsers.append(user)
    }

    static func concreteUser(user: PlayerIsPlayingUser) {
        isPlayingUsers.append(user)
    }

    static func isPlaying() -> Bool {
        isPlayToggled
    }

    static func getQueue() -> [Song] {
        songs
    }

    static func getCurrentTime() -> Double {
        if player.currentItem != nil {
            return player.currentTime().seconds
        } else {
            return 0
        }
    }

    static func notifySongUsers() {
        for user in songUsers {
            user.updateSong()
        }
    }

    static func notifyQueueUsers() {
        for user in queueUsers {
            user.updateQueue()
        }
    }

    static func notifyIsPlayingUsers() {
        for user in isPlayingUsers {
            user.updateIsPlaying()
        }
    }
}
