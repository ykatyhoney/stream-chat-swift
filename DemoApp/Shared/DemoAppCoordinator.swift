//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import StreamChat
import StreamChatUI
import UIKit

final class DemoAppCoordinator: NSObject {
    internal let window: UIWindow
    internal let chat: StreamChatWrapper
    internal let pushNotifications: PushNotifications

    init(
        window: UIWindow,
        chat: StreamChatWrapper,
        pushNotifications: PushNotifications
    ) {
        self.window = window
        self.chat = chat
        self.pushNotifications = pushNotifications
        
        super.init()

        handlePushNotificationResponse()
    }

    func handlePushNotificationResponse() {
        pushNotifications.listenToNotificationsResponse { [weak self] response in
            guard case UNNotificationDefaultActionIdentifier = response.actionIdentifier else {
                return
            }
            guard
                let chatNotificationInfo = self?.chat.notificationInfo(for: response),
                let cid = chatNotificationInfo.cid else {
                return
            }

            self?.start(cid: cid)
        }
    }
    
    func set(rootViewController: UIViewController, animated: Bool) {
        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromLeft) {
                self.window.rootViewController = rootViewController
            }
        } else {
            window.rootViewController = rootViewController
        }
    }
}
