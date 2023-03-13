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


    init() throws {
        authService.delegate = self
        try ServiceLayer.instance.telegramService.run()

        authService.sendPhone("+79955024221")
        let code = readLine()
        while code == nil {
            authService.sendCode(code ?? "")
        }
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