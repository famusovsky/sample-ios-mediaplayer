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

    static func addSong(song: Song?) {
        if let song = song {
            print("playing \(song.url)")
            do {
                //TODO: add error handling and make normal
                let playerItem = AVPlayerItem(url: song.url)
                player = AVPlayer(playerItem: playerItem)
                player.volume = 1.0
            } catch {
                print("AVAudioPlayer init failed")
            }
        }
    }
}

