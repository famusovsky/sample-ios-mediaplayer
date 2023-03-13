//
// Created by Алексей Степанов on 2023-03-13.
//

import Foundation
import SwiftUI

struct QueueView: View {
    @ObservedObject var model = QueueViewModel()

    var body: some View {
        VStack {
            Text("Now playing: \(model.currentSong ?? "Nothing")")
            List {
                ForEach(model.songs.indices, id: \.self) { index in
                    HStack {
                        Button(action: {
                            Player.setupSongNumber(num: index)
                        }) {
                            Text(model.songs[index])
                        }
                        Spacer()
                        Button(action: {
                            Player.removeSong(index: index)
                        }) {
                            Image(systemName: "minus.circle")
                        }
                    }
                }
            }
        }
    }
}

class QueueViewModel: ObservableObject, PlayerSongUser, PlayerQueueUser {
    @Published var currentSong: String?
    @Published var songs: [String] = []

    init() {
        Player.concreteUser(user: self as PlayerSongUser)
        Player.concreteUser(user: self as PlayerQueueUser)
    }

    func updateSong() {
        currentSong = Player.getCurrentSong()?.name ?? ""
    }

    func updateQueue() {
        let queue = Player.getQueue().map {
            $0.name
        }
        songs = queue
    }
}
