//
// Created by Алексей Степанов on 2023-03-07.
//

import Foundation
import SwiftUI

protocol PlayerSongUser {
    func updateSong()
}

protocol PlayerQueueUser {
    func updateQueue()
}

protocol PlayerIsPlayingUser {
    func updateIsPlaying()
}