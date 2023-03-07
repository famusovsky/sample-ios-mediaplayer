//
// Created by Алексей Степанов on 2023-03-07.
//

import Foundation
import AVFoundation
import UIKit

public struct Song {
    let name: String
    let artist: String
    let album: String
    let artwork: UIImage
    let duration: CMTime
    let url: URL

    init(name: String?, artist: String?, album: String?, artwork: UIImage?, duration: CMTime?, url: URL) {
        self.name = name ?? "Name is Unknown"
        self.artist = artist ?? "Artist is Unknown"
        self.album = album ?? "Album is Unknown"
        self.artwork = artwork ?? UIImage(systemName: "music.note")!
        self.duration = duration ?? CMTime(seconds: 0, preferredTimescale: 1)
        self.url = url
    }
}

public extension Song {
    static func getFromURL(url: URL) async -> Song {
        let data = AVURLAsset(url: url, options: nil)
        var commonMetadata: [AVMetadataItem] = []
        do {
            try await commonMetadata = data.load(.commonMetadata)
        } catch {
            print(error)
        }

        var name: String?
        var artist: String?
        var album: String?
        var artwork: UIImage?
        var duration: CMTime?
        do {
            try await duration = data.load(.duration)
        } catch {
            print(error)
        }

        for item in commonMetadata {
            let key = item.commonKey?.rawValue
            var value: Any?
            do {
                try await value = item.load(.value)
            } catch {
                print(error)
            }

            guard let key = key, let value = value else { continue }

            switch key {
            case "title" : name = value as? String
            case "artist": artist = value as? String
            case "album": album = value as? String
            case "artwork" where value is Data : artwork = UIImage(data: value as! Data)
            default:
                continue
            }
        }

        return Song(name: name, artist: artist, album: album, artwork: artwork, duration: duration, url: url)
    }
}

// "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!)
