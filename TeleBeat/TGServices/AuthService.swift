//
//  AuthService.swift
//  tdlib-ios
//
//  Created by Anton Glezman on 28/09/2019.
//  Copyright © 2019 Anton Glezman. All rights reserved.
//

import Foundation
import TDLibKit


protocol AuthServiceDelegate: AnyObject {
    func waitPhoneNumer()
    func waitCode()
    func waitPassword()
    func onReady()
    func onError(_ error: Swift.Error)
}

final class AuthService : UpdateListener {

    // MARK: - Private properties

    private let api: TdApi
    private var authorizationState: AuthorizationState?


    // MARK: - Public properties

    private(set) var isAuthorized: Bool = false
    weak var delegate: AuthServiceDelegate?


    // MARK: - Init

    init(tdApi: TdApi) {
        self.api = tdApi
    }

    func onUpdate(_ update: Update) {
        if case .updateAuthorizationState(let state) = update {
            do {
                try onUpdateAuthorizationState(state.authorizationState)
            } catch {
                print(error)
            }
        }
    }

    func sendPhone(_ phone: String) {
        let settings = PhoneNumberAuthenticationSettings(
                allowFlashCall: false,
                allowMissedCall: false,
                allowSmsRetrieverApi: false,
                authenticationTokens: [],
                firebaseAuthenticationSettings: .firebaseAuthenticationSettingsIos(FirebaseAuthenticationSettingsIos(deviceToken: "", isAppSandbox: false)),
                isCurrentPhoneNumber: false
        )
        try? self.api.setAuthenticationPhoneNumber(
                phoneNumber: phone,
                settings: settings) { [weak self] in
            self?.chekResult($0)
        }
    }

    func sendCode(_ code: String) {
        try? self.api.checkAuthenticationCode(code: code) { [weak self] in
            self?.chekResult($0)
        }
    }

    func sendPassword(_ password: String) {
        try? self.api.checkAuthenticationPassword(password: password) { [weak self] in
            self?.chekResult($0)
        }
    }

    public func logout() {
        try? self.api.logOut() { [weak self] in
            self?.chekResult($0)
        }
    }


    // MARK: - Private methods

    private func onUpdateAuthorizationState(_ state: AuthorizationState) throws {
        authorizationState = state

        switch state {
        case .authorizationStateWaitTdlibParameters:
            guard let cachesUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                return
            }
            let tdlibPath = cachesUrl.appendingPathComponent("tdlib", isDirectory: true).path

            try api.setTdlibParameters(
                    apiHash: TGClient.api_hash,
                    apiId: TGClient.api_id,
                    applicationVersion: "1.0",
                    databaseDirectory: tdlibPath,
                    databaseEncryptionKey: "sdfsdkjfkbsddsj".data(using: .utf8)!,
                    deviceModel: "iPhone",
                    enableStorageOptimizer: true,
                    filesDirectory: nil,
                    ignoreFileNames: false,
                    systemLanguageCode: "en",
                    systemVersion: nil,
                    useChatInfoDatabase: true,
                    useFileDatabase: true,
                    useMessageDatabase: true,
                    useSecretChats: true,
                    useTestDc: false) { [weak self] in
                self?.chekResult($0)
            }
            break

        case .authorizationStateWaitPhoneNumber:
            delegate?.waitPhoneNumer()
            break

        case .authorizationStateWaitCode:
            delegate?.waitCode()
            break

        case .authorizationStateWaitPassword(_):
            delegate?.waitPassword()
            break

        case .authorizationStateReady:
            isAuthorized = true
            delegate?.onReady()
            break

        case .authorizationStateLoggingOut:
            isAuthorized = false
            break

        case .authorizationStateClosing:
            isAuthorized = false
            break

        // TODO: add other states

        case .authorizationStateClosed:
            break

        case .authorizationStateWaitRegistration:
            break

        case .authorizationStateWaitOtherDeviceConfirmation(_):
            break
        case .authorizationStateWaitEmailAddress(_):
            break
        case .authorizationStateWaitEmailCode(_):
            break
        }
    }

    private func chekResult(_ result: Result<Ok, Swift.Error>) {
        switch result {
        case .success:
            // result is already received through UpdateAuthorizationState, nothing to do
            break
        case .failure(let error):
            delegate?.onError(error)
        }
    }
}
