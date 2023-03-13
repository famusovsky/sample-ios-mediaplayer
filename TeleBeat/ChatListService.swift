//
//  ChatListService.swift
//  tdlib-ios
//
//  Created by Anton Glezman on 30/09/2019.
//  Copyright © 2019 Anton Glezman. All rights reserved.
//

import Foundation
import TDLibKit

protocol ChatListServiceDelegate: AnyObject {
    func chatListUpdated()
}


final class ChatListService: UpdateListener {

    // MARK: - Private properties

    private let api: TdApi
    private var haveFullChatList: Bool = false


    // MARK: - Public properties

    private(set) var chatList: [OrderedChat] = []
    private(set) var chats: [Int64: Chat] = [:]
    weak var delegate: ChatListServiceDelegate?


    // MARK: - Init

    init(tdApi: TdApi) {
        self.api = tdApi
    }


    // MARK: - Public methods

    func getChatList(limit: Int = 20) throws {
        if !haveFullChatList, limit > chatList.count {
            do {
                try api.loadChats(chatList: .chatListMain, limit: limit - chatList.count) { result in
                    switch result {
                    case .success:
                        // chats had already been received through updates, let's retry request
                        try? self.getChatList(limit: limit)

                    case .failure(let error):
                        if let tdLibError = error as? TDLibKit.Error, tdLibError.code == 404 {
                            self.haveFullChatList = true
                        } else {
                            print("Receive an error for LoadChats: \(error)")
                        }
                    }
                }
            } catch {
            }
        }

        // have enough chats in the chat list to answer request
        delegate?.chatListUpdated()
    }


    // MARK: - Override

    func onUpdate(_ update: Update) {
        switch update {

        case .updateNewChat(let newChat):
            let chat = newChat.chat
            chats[chat.id] = chat
            setChatPositions(chat, newChat.chat.positions)

        case .updateChatTitle(let upd):
            if var chat = chats[upd.chatId] {
                let newChat = Chat(
                        actionBar: chat.actionBar,
                        availableReactions: chat.availableReactions,
                        canBeDeletedForAllUsers: chat.canBeDeletedForAllUsers,
                        canBeDeletedOnlyForSelf: chat.canBeDeletedOnlyForSelf,
                        canBeReported: chat.canBeReported,
                        clientData: chat.clientData,
                        defaultDisableNotification: chat.defaultDisableNotification,
                        draftMessage: chat.draftMessage,
                        hasProtectedContent: chat.hasProtectedContent,
                        hasScheduledMessages: chat.hasScheduledMessages,
                        id: upd.chatId,
                        isBlocked: chat.isBlocked,
                        isMarkedAsUnread: chat.isMarkedAsUnread,
                        isTranslatable: chat.isTranslatable,
                        lastMessage: chat.lastMessage,
                        lastReadInboxMessageId: chat.lastReadInboxMessageId,
                        lastReadOutboxMessageId: chat.lastReadOutboxMessageId,
                        messageAutoDeleteTime: chat.messageAutoDeleteTime,
                        messageSenderId: chat.messageSenderId,
                        notificationSettings: chat.notificationSettings,
                        pendingJoinRequests: chat.pendingJoinRequests,
                        permissions: chat.permissions,
                        photo: chat.photo,
                        positions: chat.positions,
                        replyMarkupMessageId: chat.replyMarkupMessageId,
                        themeName: chat.themeName,
                        title: upd.title,
                        type: chat.type,
                        unreadCount: chat.unreadCount,
                        unreadMentionCount: chat.unreadMentionCount,
                        unreadReactionCount: chat.unreadReactionCount,
                        videoChat: chat.videoChat
                )
                chats[upd.chatId] = newChat
            }

        case .updateChatPhoto:
            break

        case .updateChatLastMessage(let upd):
            if var chat = chats[upd.chatId] {
                var newChat: Chat
                if let msg = upd.lastMessage {
                    newChat = Chat(
                            actionBar: chat.actionBar,
                            availableReactions: chat.availableReactions,
                            canBeDeletedForAllUsers: chat.canBeDeletedForAllUsers,
                            canBeDeletedOnlyForSelf: chat.canBeDeletedOnlyForSelf,
                            canBeReported: chat.canBeReported,
                            clientData: chat.clientData,
                            defaultDisableNotification: chat.defaultDisableNotification,
                            draftMessage: chat.draftMessage,
                            hasProtectedContent: chat.hasProtectedContent,
                            hasScheduledMessages: chat.hasScheduledMessages,
                            id: upd.chatId,
                            isBlocked: chat.isBlocked,
                            isMarkedAsUnread: chat.isMarkedAsUnread,
                            isTranslatable: chat.isTranslatable,
                            lastMessage: msg,
                            lastReadInboxMessageId: chat.lastReadInboxMessageId,
                            lastReadOutboxMessageId: chat.lastReadOutboxMessageId,
                            messageAutoDeleteTime: chat.messageAutoDeleteTime,
                            messageSenderId: chat.messageSenderId,
                            notificationSettings: chat.notificationSettings,
                            pendingJoinRequests: chat.pendingJoinRequests,
                            permissions: chat.permissions,
                            photo: chat.photo,
                            positions: chat.positions,
                            replyMarkupMessageId: chat.replyMarkupMessageId,
                            themeName: chat.themeName,
                            title: chat.title,
                            type: chat.type,
                            unreadCount: chat.unreadCount,
                            unreadMentionCount: chat.unreadMentionCount,
                            unreadReactionCount: chat.unreadReactionCount,
                            videoChat: chat.videoChat
                    )
                } else {
                    newChat = Chat(
                            actionBar: chat.actionBar,
                            availableReactions: chat.availableReactions,
                            canBeDeletedForAllUsers: chat.canBeDeletedForAllUsers,
                            canBeDeletedOnlyForSelf: chat.canBeDeletedOnlyForSelf,
                            canBeReported: chat.canBeReported,
                            clientData: chat.clientData,
                            defaultDisableNotification: chat.defaultDisableNotification,
                            draftMessage: chat.draftMessage,
                            hasProtectedContent: chat.hasProtectedContent,
                            hasScheduledMessages: chat.hasScheduledMessages,
                            id: upd.chatId,
                            isBlocked: chat.isBlocked,
                            isMarkedAsUnread: chat.isMarkedAsUnread,
                            isTranslatable: chat.isTranslatable,
                            lastMessage: nil,
                            lastReadInboxMessageId: chat.lastReadInboxMessageId,
                            lastReadOutboxMessageId: chat.lastReadOutboxMessageId,
                            messageAutoDeleteTime: chat.messageAutoDeleteTime,
                            messageSenderId: chat.messageSenderId,
                            notificationSettings: chat.notificationSettings,
                            pendingJoinRequests: chat.pendingJoinRequests,
                            permissions: chat.permissions,
                            photo: chat.photo,
                            positions: chat.positions,
                            replyMarkupMessageId: chat.replyMarkupMessageId,
                            themeName: chat.themeName,
                            title: chat.title,
                            type: chat.type,
                            unreadCount: chat.unreadCount,
                            unreadMentionCount: chat.unreadMentionCount,
                            unreadReactionCount: chat.unreadReactionCount,
                            videoChat: chat.videoChat
                    )
                }
                chats[upd.chatId] = newChat
                setChatPositions(newChat, upd.positions)
            }

        case .updateChatPosition(let upd):
            if let chat = chats[upd.chatId] {
                setChatPositions(chat, [upd.position])
            }

        case .updateChatReadInbox(let upd):
            if var chat = chats[upd.chatId] {
                let newChat = Chat(
                        actionBar: chat.actionBar,
                        availableReactions: chat.availableReactions,
                        canBeDeletedForAllUsers: chat.canBeDeletedForAllUsers,
                        canBeDeletedOnlyForSelf: chat.canBeDeletedOnlyForSelf,
                        canBeReported: chat.canBeReported,
                        clientData: chat.clientData,
                        defaultDisableNotification: chat.defaultDisableNotification,
                        draftMessage: chat.draftMessage,
                        hasProtectedContent: chat.hasProtectedContent,
                        hasScheduledMessages: chat.hasScheduledMessages,
                        id: upd.chatId,
                        isBlocked: chat.isBlocked,
                        isMarkedAsUnread: chat.isMarkedAsUnread,
                        isTranslatable: chat.isTranslatable,
                        lastMessage: chat.lastMessage,
                        lastReadInboxMessageId: upd.lastReadInboxMessageId,
                        lastReadOutboxMessageId: chat.lastReadOutboxMessageId,
                        messageAutoDeleteTime: chat.messageAutoDeleteTime,
                        messageSenderId: chat.messageSenderId,
                        notificationSettings: chat.notificationSettings,
                        pendingJoinRequests: chat.pendingJoinRequests,
                        permissions: chat.permissions,
                        photo: chat.photo,
                        positions: chat.positions,
                        replyMarkupMessageId: chat.replyMarkupMessageId,
                        themeName: chat.themeName,
                        title: chat.title,
                        type: chat.type,
                        unreadCount: upd.unreadCount,
                        unreadMentionCount: chat.unreadMentionCount,
                        unreadReactionCount: chat.unreadReactionCount,
                        videoChat: chat.videoChat
                )
                chats[upd.chatId] = newChat
            }
            delegate?.chatListUpdated()

        case .updateChatReadOutbox(let upd):
            if var chat = chats[upd.chatId] {
                let newChat = Chat(
                        actionBar: chat.actionBar,
                        availableReactions: chat.availableReactions,
                        canBeDeletedForAllUsers: chat.canBeDeletedForAllUsers,
                        canBeDeletedOnlyForSelf: chat.canBeDeletedOnlyForSelf,
                        canBeReported: chat.canBeReported,
                        clientData: chat.clientData,
                        defaultDisableNotification: chat.defaultDisableNotification,
                        draftMessage: chat.draftMessage,
                        hasProtectedContent: chat.hasProtectedContent,
                        hasScheduledMessages: chat.hasScheduledMessages,
                        id: upd.chatId,
                        isBlocked: chat.isBlocked,
                        isMarkedAsUnread: chat.isMarkedAsUnread,
                        isTranslatable: chat.isTranslatable,
                        lastMessage: chat.lastMessage,
                        lastReadInboxMessageId: chat.lastReadInboxMessageId,
                        lastReadOutboxMessageId: upd.lastReadOutboxMessageId,
                        messageAutoDeleteTime: chat.messageAutoDeleteTime,
                        messageSenderId: chat.messageSenderId,
                        notificationSettings: chat.notificationSettings,
                        pendingJoinRequests: chat.pendingJoinRequests,
                        permissions: chat.permissions,
                        photo: chat.photo,
                        positions: chat.positions,
                        replyMarkupMessageId: chat.replyMarkupMessageId,
                        themeName: chat.themeName,
                        title: chat.title,
                        type: chat.type,
                        unreadCount: chat.unreadCount,
                        unreadMentionCount: chat.unreadMentionCount,
                        unreadReactionCount: chat.unreadReactionCount,
                        videoChat: chat.videoChat
                )
                chats[upd.chatId] = newChat
            }

        case .updateChatUnreadMentionCount(let upd):
            if var chat = chats[upd.chatId] {
                let newChat = Chat(
                        actionBar: chat.actionBar,
                        availableReactions: chat.availableReactions,
                        canBeDeletedForAllUsers: chat.canBeDeletedForAllUsers,
                        canBeDeletedOnlyForSelf: chat.canBeDeletedOnlyForSelf,
                        canBeReported: chat.canBeReported,
                        clientData: chat.clientData,
                        defaultDisableNotification: chat.defaultDisableNotification,
                        draftMessage: chat.draftMessage,
                        hasProtectedContent: chat.hasProtectedContent,
                        hasScheduledMessages: chat.hasScheduledMessages,
                        id: upd.chatId,
                        isBlocked: chat.isBlocked,
                        isMarkedAsUnread: chat.isMarkedAsUnread,
                        isTranslatable: chat.isTranslatable,
                        lastMessage: chat.lastMessage,
                        lastReadInboxMessageId: chat.lastReadInboxMessageId,
                        lastReadOutboxMessageId: chat.lastReadOutboxMessageId,
                        messageAutoDeleteTime: chat.messageAutoDeleteTime,
                        messageSenderId: chat.messageSenderId,
                        notificationSettings: chat.notificationSettings,
                        pendingJoinRequests: chat.pendingJoinRequests,
                        permissions: chat.permissions,
                        photo: chat.photo,
                        positions: chat.positions,
                        replyMarkupMessageId: chat.replyMarkupMessageId,
                        themeName: chat.themeName,
                        title: chat.title,
                        type: chat.type,
                        unreadCount: chat.unreadCount,
                        unreadMentionCount: upd.unreadMentionCount,
                        unreadReactionCount: chat.unreadReactionCount,
                        videoChat: chat.videoChat
                )
                chats[upd.chatId] = newChat
            }
            delegate?.chatListUpdated()

        case .updateMessageMentionRead:
            break

        case .updateChatReplyMarkup:
            break

        case .updateChatDraftMessage(let upd):
            if let chat = chats[upd.chatId] {
                chats[upd.chatId] = chat
                setChatPositions(chat, upd.positions)
            }

        case .updateChatNotificationSettings:
            break

        case .updateChatDefaultDisableNotification:
            break

        case .updateChatIsMarkedAsUnread(let upd):
            if var chat = chats[upd.chatId] {
                let newChat = Chat(
                        actionBar: chat.actionBar,
                        availableReactions: chat.availableReactions,
                        canBeDeletedForAllUsers: chat.canBeDeletedForAllUsers,
                        canBeDeletedOnlyForSelf: chat.canBeDeletedOnlyForSelf,
                        canBeReported: chat.canBeReported,
                        clientData: chat.clientData,
                        defaultDisableNotification: chat.defaultDisableNotification,
                        draftMessage: chat.draftMessage,
                        hasProtectedContent: chat.hasProtectedContent,
                        hasScheduledMessages: chat.hasScheduledMessages,
                        id: upd.chatId,
                        isBlocked: chat.isBlocked,
                        isMarkedAsUnread: upd.isMarkedAsUnread,
                        isTranslatable: chat.isTranslatable,
                        lastMessage: chat.lastMessage,
                        lastReadInboxMessageId: chat.lastReadInboxMessageId,
                        lastReadOutboxMessageId: chat.lastReadOutboxMessageId,
                        messageAutoDeleteTime: chat.messageAutoDeleteTime,
                        messageSenderId: chat.messageSenderId,
                        notificationSettings: chat.notificationSettings,
                        pendingJoinRequests: chat.pendingJoinRequests,
                        permissions: chat.permissions,
                        photo: chat.photo,
                        positions: chat.positions,
                        replyMarkupMessageId: chat.replyMarkupMessageId,
                        themeName: chat.themeName,
                        title: chat.title,
                        type: chat.type,
                        unreadCount: chat.unreadCount,
                        unreadMentionCount: chat.unreadMentionCount,
                        unreadReactionCount: chat.unreadReactionCount,
                        videoChat: chat.videoChat
                )
                chats[upd.chatId] = newChat
            }

        default:
            break
        }
    }


    // MARK: - Private methods

    private func setChatPositions(_ chat: Chat, _ positions: [ChatPosition]) {
        for position in positions {
            if case .chatListMain = position.list, let idx = chatList.firstIndex(where: { $0.chatId == chat.id }) {
                chatList.remove(at: idx)
            }
        }
        let newChat = Chat(
                actionBar: chat.actionBar,
                availableReactions: chat.availableReactions,
                canBeDeletedForAllUsers: chat.canBeDeletedForAllUsers,
                canBeDeletedOnlyForSelf: chat.canBeDeletedOnlyForSelf,
                canBeReported: chat.canBeReported,
                clientData: chat.clientData,
                defaultDisableNotification: chat.defaultDisableNotification,
                draftMessage: chat.draftMessage,
                hasProtectedContent: chat.hasProtectedContent,
                hasScheduledMessages: chat.hasScheduledMessages,
                id: chat.id,
                isBlocked: chat.isBlocked,
                isMarkedAsUnread: chat.isMarkedAsUnread,
                isTranslatable: chat.isTranslatable,
                lastMessage: chat.lastMessage,
                lastReadInboxMessageId: chat.lastReadInboxMessageId,
                lastReadOutboxMessageId: chat.lastReadOutboxMessageId,
                messageAutoDeleteTime: chat.messageAutoDeleteTime,
                messageSenderId: chat.messageSenderId,
                notificationSettings: chat.notificationSettings,
                pendingJoinRequests: chat.pendingJoinRequests,
                permissions: chat.permissions,
                photo: chat.photo,
                positions: positions,
                replyMarkupMessageId: chat.replyMarkupMessageId,
                themeName: chat.themeName,
                title: chat.title,
                type: chat.type,
                unreadCount: chat.unreadCount,
                unreadMentionCount: chat.unreadMentionCount,
                unreadReactionCount: chat.unreadReactionCount,
                videoChat: chat.videoChat
        )
        chats[newChat.id] = newChat
        for position in positions {
            if case .chatListMain = position.list {
                chatList.append(OrderedChat(chatId: chat.id, position: position))
            }
        }
        chatList.sort()
        delegate?.chatListUpdated()
    }

}


struct OrderedChat: Comparable {

    let chatId: Int64
    let position: ChatPosition

    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.position.order > rhs.position.order
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.chatId == rhs.chatId && lhs.position.order == rhs.position.order
    }
}
