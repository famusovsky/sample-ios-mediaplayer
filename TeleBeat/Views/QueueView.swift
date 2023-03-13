//
// Created by Алексей Степанов on 2023-03-13.
//

import Foundation
import SwiftUI

struct QueueView : View, PlayerSongUser, PlayerQueueUser {
    @State private var songs: [String] = []
    @State private var current: String = ""

    init() {
        Player.concreteUser(user: self as PlayerSongUser)
        Player.concreteUser(user: self as PlayerQueueUser)
    }

    var body : some View {
        VStack {
            Text("Now playing: \(current)")
            List {
                ForEach(songs.indices) { index in
                    Button(action: {
                        Player.setupSongNumber(num: index)
                    }) {
                        Text(self.songs[index])
                    }
                }
            }
        }
    }

    func updateSong() {
        current = Player.getCurrentSong()?.name ?? ""
    }

    func updateQueue() {
        songs = Player.getQueue().map { $0.name }
    }
}
