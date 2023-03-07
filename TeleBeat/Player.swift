//
//  Player.swift
//  TeleBeat
//
//  Created by Алексей Степанов on 2023-03-05.
//

import Foundation
import AVFoundation

public class Player {
    private static var player: AVPlayer!
    private static var songs: [Song] = []
    private static var current: Int = 0

    static func play() {
        if let player = player {
            player.play()
        }
    }

    static func pause() {
        if let player = player {
            player.pause()
        }
    }

    static func skip() {
        if player != nil {
            player.pause()
            current += 1
            if current >= songs.count {
                current = songs.count - 1
            } else {
                let song = songs[current]
                print("playing \(song.url): \(song.name)")
                do {
                    //TODO: add error handling and make normal
                    let playerItem = AVPlayerItem(url: song.url)
                    player = AVPlayer(playerItem: playerItem)
                    player.volume = 1.0
                    player.play()
                } catch {
                    print("AVAudioPlayer init failed")
                }
            }
        }
    }

    static func rewind() {
        if player != nil {
            player.pause()
            current -= 1
            if current <= 0 {
                current = 0
            } else {
                let song = songs[current]
                print("playing \(song.url): \(song.name)")
                do {
                    //TODO: add error handling and make normal
                    let playerItem = AVPlayerItem(url: song.url)
                    player = AVPlayer(playerItem: playerItem)
                    player.volume = 1.0
                    player.play()
                } catch {
                    print("AVAudioPlayer init failed")
                }
            }
        }
    }

    static func addSong(song: Song?) {
        if let song = song {
            songs.append(song)
        }
    }
}

