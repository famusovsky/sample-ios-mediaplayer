//
//  TGclient.swift
//  TeleBeat
//
//  Created by Алексей Степанов on 2023-03-11.
//

import Foundation
import TDLibKit

public class TGClient {
    let client: TdClient
    let api: TdApi
    private static let app_id = 27129313
    private static let api_hash = "5ee6e709a5f6e8f8b7089a4db04a4935"

    init() {
        client = TdClientImpl()
        api = TdApi(client: client)
    }

    func test(chatId: Int64) async {
        do {
            let chatHistory = try await api.getChatHistory(
                    chatId: chatId,
                    fromMessageId: 0,
                    limit: 50,
                    offset: 0,
                    onlyLocal: false // Request remote messages from server
            )

            var audioMessages: [Audio] = []

            for message in chatHistory.messages ?? [] {
                switch message.content {
                case .messageText(let text):
                    print(text.text.text)

                case .messageAnimation:
                    print("<Animation>")

                case .messagePhoto(let photo):
                    print("<Photo>\n\(photo.caption.text)")

                case .messageSticker(let sticker):
                    print(sticker.sticker.emoji)

                case .messageVideo(let video):
                    print("<Video>\n\(video.caption.text)")

                case .messageAudio(let audioMessage):
                    audioMessages.append(audioMessage.audio)
                    print("<Audio>")

                        // ...

                default:
                    print("Unknown message content \(message.content)")
                }
            }
        } catch {
            print("Error in getChatHistory \(error)")
        }
    }

    func setUp() async {
        do {
            try await api.setTdlibParameters(apiHash: TGClient.api_hash, apiId: TGClient.app_id, applicationVersion: "tdlib", databaseDirectory: nil,
                    databaseEncryptionKey: nil, deviceModel: nil, enableStorageOptimizer: nil, filesDirectory: nil, ignoreFileNames: nil,
                    systemLanguageCode: nil, systemVersion: nil, useChatInfoDatabase: nil, useFileDatabase: nil, useMessageDatabase: nil,
                    useSecretChats: nil, useTestDc: nil)
        } catch {
            print("Error in setTdlibParameters \(error)")
        }
    }
}
