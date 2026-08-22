import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "config.js" as Config

Scope {
    id: root
    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n => {
            console.log("Got:", n.summary, "---", n.body)
            n.tracked = true
        }
    }

    PanelWindow {
        anchors { top: true; right: true}
        margins { top: 12; right: 12 }

        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)
        color: "transparent"

        exclusionMode: ExclusionMode.Ignore

        ColumnLayout {
            id: column
            width: parent.width
            spacing: 10

            Repeater {
                model: server.trackedNotifications
                delegate: Rectangle {
                    id: card
                    required property var modelData

                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    // Layout.preferredHeight: layout.implicitHeight + 20
                    radius: 8
                    color: Config.colors.bg
                    border.width: 2
                    border.color: modelData.urgency === NotificationUrgency.Critical
                    ? Config.colors.red : Config.colors.purple
                }
            }
        }
    }
}
