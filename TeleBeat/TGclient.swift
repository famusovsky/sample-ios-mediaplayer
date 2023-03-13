//
//  TGclient.swift
//  TeleBeat
//
//  Created by Алексей Степанов on 2023-03-11.
//

import Foundation
import TDLibKit

public class TGClient {
    internal static let api_id = 27129313
    internal static let api_hash = "5ee6e709a5f6e8f8b7089a4db04a4935"
    private var authService = ServiceLayer.instance.authService
    private var chatListService = ServiceLayer.instance.chatListService

    init() throws {
        authService.delegate = self
        try ServiceLayer.instance.telegramService.run()

        authService.sendPhone("+7(995)502-42-21")
        var code: String? = nil
        while true {
            code = readLine()
            if code != nil {
                break
            }
        }
        authService.sendCode(code!)

        var password: String? = nil
        while true {
            password = readLine()
            if password != nil {
                break
            }
        }
        authService.sendPassword(password!)

        getChats()
    }

    func getChats() -> [Int64: Chat] {
        let chats = chatListService.chats
        for chat in chats {
            print(chat)
        }
        return chatListService.chats
    }

    func test() {
        print("test")
    }

}

extension TGClient: AuthServiceDelegate {

    func waitPhoneNumer() {
        //phoneView.isHidden = false
        //codeView.isHidden = true
        //passwordView.isHidden = true
        //activityIndicator.stopAnimating()
    }

    func waitCode() {
        //phoneView.isHidden = true
        //codeView.isHidden = false
        //passwordView.isHidden = true
        //activityIndicator.stopAnimating()
    }

    func waitPassword() {
        //phoneView.isHidden = true
        //codeView.isHidden = true
        //passwordView.isHidden = false
        //activityIndicator.stopAnimating()
    }

    func onReady() {
        //ApplicationController.showMain()
    }

    func onError(_ error: Swift.Error) {
        //let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        //let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        //alert.addAction(okAction)
        //present(alert, animated: true)
    }

}