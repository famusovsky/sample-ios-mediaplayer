//
// Created by Алексей Степанов on 2023-03-07.
//

import Foundation
import AVFoundation
import UIKit

// TODO: сделать codable
public struct Song {
    let name: String
    let artist: String
    let album: String
    let duration: CMTime
    let url: URL

    init(name: String?, artist: String?, album: String?, duration: CMTime?, url: URL) {
        self.name = name ?? "Name is Unknown"
        self.artist = artist ?? "Artist is Unknown"
        self.album = album ?? "Album is Unknown"
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

        print("Common metadata: \(commonMetadata.count)")
        for item in commonMetadata {
            print(item)
        }

        var name: String?
        var artist: String?
        var album: String?
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

            guard let key = key, let value = value else {
                continue
            }

            switch key {
            case "title": name = value as? String
            case "artist": artist = value as? String
            case "albumName": album = value as? String
            default:
                continue
            }
        }

        return Song(name: name, artist: artist, album: album, duration: duration, url: url)
    }

    func getArtwork() async -> UIImage? {
        let data = AVURLAsset(url: url, options: nil)
        var commonMetadata: [AVMetadataItem] = []
        do {
            try await commonMetadata = data.load(.commonMetadata)
        } catch {
            print(error)
        }

        if let artwork = commonMetadata.first(where: { $0.commonKey?.rawValue == "artwork" }) {
            var value: Any?
            do {
                try await value = artwork.load(.value)
                if let value = value as? Data {
                    return UIImage(data: value)
                }
            } catch {
                print(error)
            }
        }

        return nil
    }
}

