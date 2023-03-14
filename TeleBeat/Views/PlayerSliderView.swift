//
//  PlayerSliderView.swift
//  TeleBeat
//
//  Created by Алексей Степанов on 2023-03-14.
//

import Foundation
import SwiftUI

struct PlayerSliderView: View {
    @ObservedObject var model = PlayerSliderModel()
    @State var isPlayToggled: Bool = false

    var body: some View {
        VStack {
            Text("\(Int(model.currentSongDuration) / 60):\(Int(model.currentSongDuration) % 60) "
                    + " > \(Int(model.currentSongProgress) / 60):\(Int(model.currentSongProgress) % 60) мин.")
            HStack {
                Spacer(minLength: 36)
                CoolSlider(value: $model.currentSongProgress, duration: $model.currentSongDuration,
                        lastCoordinateValue: model.currentSongDuration,
                        onEditingChangeStart: {
                            model.pauseTimer()
                        },
                        onEditingChangeFinish: {
                            Player.seek(time: model.currentSongProgress)
                            model.updateTimer()
                        })
                        .frame(height: 30)
                Spacer(minLength: 36)
            }
        }
    }
}

class PlayerSliderModel: ObservableObject, PlayerSongUser, PlayerIsPlayingUser {
    @Published var currentSongProgress: Double = 0
    @Published var currentSongDuration: Double = 0
    @Published var isPlaying = false
    private var timer: Timer?

    init() {
        Player.concreteUser(user: self as PlayerSongUser)
        Player.concreteUser(user: self as PlayerIsPlayingUser)

        updateSong()
        updateIsPlaying()
    }

    func updateSong() {
        currentSongProgress = 0
        currentSongDuration = Player.getCurrentSong()?.duration ?? 0

        updateTimer()
    }

    func updateIsPlaying() {
        isPlaying = Player.isPlaying()

        if isPlaying {
            updateTimer()
        } else {
            pauseTimer()
        }
    }

    func pauseTimer() {
        currentSongProgress = Player.getCurrentTime()
        timer?.invalidate()
    }

    func updateTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.currentSongProgress = Player.getCurrentTime()
        }
    }
}

// Got partly from https://swdevnotes.com/swift/2021/how-to-customise-the-slider-in-swiftui/
struct CoolSlider: View {
    @Binding var value: Double
    @Binding var duration: Double
    @State var lastCoordinateValue: CGFloat = 0.0
    var onEditingChangeStart: () -> Void
    var onEditingChangeFinish: () -> Void

    var body: some View {
        GeometryReader { gr in
            let thumbSize = gr.size.height * 0.8
            let radius = gr.size.height * 0.5
            let minValue = gr.size.width * 0.015
            let maxValue = (gr.size.width * 0.98) - thumbSize / 2

            ZStack {
                RoundedRectangle(cornerRadius: radius)
                        .foregroundColor(.gray)
                HStack {
                    Circle()
                            .foregroundColor(Color.white)
                            .frame(width: thumbSize, height: thumbSize)
                            .offset(x: value / duration * (maxValue - minValue))
                            .gesture(
                                    DragGesture(minimumDistance: 0)
                                            .onChanged { v in
                                                onEditingChangeStart()

                                                if (abs(v.translation.width) < 0.1) {
                                                    self.lastCoordinateValue = value / duration * (maxValue - minValue)
                                                }
                                                if v.translation.width > 0 {
                                                    value = (lastCoordinateValue + v.translation.width) * duration / (maxValue - minValue)
                                                } else {
                                                    self.value = (lastCoordinateValue + v.translation.width) * duration / (maxValue - minValue)
                                                }

                                                onEditingChangeFinish()
                                            }
                            )
                    Spacer()
                }
            }
        }
    }
}
