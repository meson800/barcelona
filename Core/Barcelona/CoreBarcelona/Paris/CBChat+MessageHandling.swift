//
//  CBChat+MessageHandling.swift
//  Barcelona
//
//  Created by Eric Rabil on 8/8/22.
//

import Foundation
import Logging
import IMSharedUtilities

private let log = Logger(label: "CBChat")

extension CBChat {
    public enum MessageInput: CustomDebugStringConvertible, CustomStringConvertible {
        case item(IMItem)
        case dict([AnyHashable: Any])

        public var guid: String? {
            switch self {
            case .item(let item): return item.id
            case .dict(let dict): return dict["guid"] as? String
            }
        }

        public func handle(message: inout CBMessage?, leaf: CBChatIdentifier) -> CBMessage {
            switch self {
            case .item(let item):
                if message != nil {
                    message!.handle(item: item)
                    return message!
                }
                message = CBMessage(item: item, chat: leaf)
                return message!
            case .dict(let dict):
                if message != nil {
                    message!.handle(dictionary: dict)
                    return message!
                }
                message = CBMessage(dictionary: dict, chat: leaf)
                return message!
            }
        }

        private var shared: CustomDebugStringConvertible & CustomStringConvertible {
            switch self {
            case .dict(let dict as CustomDebugStringConvertible & CustomStringConvertible),
                .item(let dict as CustomDebugStringConvertible & CustomStringConvertible):
                return dict
            }
        }

        public var debugDescription: String {
            shared.debugDescription
        }

        public var description: String {
            shared.description
        }
    }

    @discardableResult public func handle(leaf: CBChatIdentifier, input item: MessageInput) -> CBMessage? {
        guard let id = item.guid else {
            log.warning("dropping message \(item.debugDescription) as it has an invalid guid?!")
            return nil
        }
        let message = item.handle(message: &messages[id], leaf: leaf)
        log.info("handled message \(id), \(message.debugDescription)")
        return message
    }

    @discardableResult public func handle(leaf: CBChatIdentifier, item dictionary: [AnyHashable: Any]) -> CBMessage? {
        handle(leaf: leaf, input: .dict(dictionary))
    }
}

extension CBChat {
    @discardableResult public func handle(leaf: CBChatIdentifier, item: IMItem) -> CBMessage? {
        handle(leaf: leaf, input: .item(item))
    }
}
