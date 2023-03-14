//
// Created by Алексей Степанов on 2023-03-13.
//

import Foundation
import SwiftUI

struct QueueView: View {
    @ObservedObject var model = QueueViewModel()
    @State var isDeletionHidden = true

    var body: some View {
        VStack {
            HStack {
                Text("Сейчас играет: \(model.currentSong ?? "Nothing")")
                        .italic()
                        .bold()
                Button(action: {
                    isDeletionHidden.toggle()
                }) {
                    Text(isDeletionHidden ? "Удалить" : "Отменить")
                }
            }
            List {
                ForEach(model.songs.indices, id: \.self) { index in
                    HStack {
                        Button(action: {
                            if isDeletionHidden {
                                Player.setupSongNumber(num: index)
                            } else {
                                Player.removeSong(index: index)
                            }
                        }) {
                            HStack {
                                Text(model.songs[index])
                                        .foregroundColor(Color.black)
                                if !isDeletionHidden {
                                    Spacer()
                                    Image(systemName: "trash.circle.fill")
                                }
                            }
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

        updateSong()
        updateQueue()
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
