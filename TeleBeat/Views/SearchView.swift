//
// Created by Алексей Степанов on 2023-03-14.
//

import Foundation
import SwiftUI

struct SearchView : View {
    @State var text: String = ""

    var body : some View {
        VStack {
            TextField("Введите название песни", text: $text)
            Button(action: {
                Task {
                    let song = await searchSong()
                    if let song = song {
                        Player.addSong(song: song)
                    }
                }
            }) {
                Text("Search")
            }
        }
    }

    func searchSong() async -> Song? {
        guard let myURL = URL(string: "https://ru.hitmotop.com/search?q=\(text)") else {
            print("Error: \(text) doesn't seem to be a valid URL")
            return nil
        }
        var myHTMLString: String

        do {
            myHTMLString = try String(contentsOf: myURL)
        } catch let error {
            print("Error: \(error)")
            return nil
        }

        let regex = try! NSRegularExpression(pattern:  "^https:\\/\\/[a-z]{2}\\.hitmotop\\.com\\/get\\/music\\/\\d{8}\\/(.+)_-_(\\d+)\\.mp3$", options: [])
        let match: String? = matches(for: regex, in: myHTMLString)

        print(matches(for: regex, in: "https://ru.hitmotop.com/get/music/20221217/INSTASAMKA_-_KAK_MOMMY_75305573.mp3"))

        if let match = match {
            let url = URL(string: match)!
            return await Song.getFromURL(url: url)
        } else {
            return nil
        }
    }

    private func matches(for regex: NSRegularExpression, in text: String) -> String? {
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))

        if let firstMatch = matches.first {
            return (text as NSString).substring(with: firstMatch.range)
        } else {
            return nil
        }
    }
}



