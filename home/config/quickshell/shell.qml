import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: root
    property string time

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData

            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 25

            Text {
                // give the text an ID we can refer to elsewhere in the file
                anchors.centerIn: parent

                text: root.time
            }
        }
    }

    Process {
        id: dateProc

        command: ["date"]

        // run the command immediately
        running: true

        // process the stdout stream using a StdioCollector
        // Use StdioCollector to retrieve the text the process sends
        // to stdout.
        stdout: StdioCollector {
            // Listen for the streamFinished signal, which is sent
            // when the process closes stdout or exits.
            onStreamFinished: root.time = text // Refeeres to StdioCollector object
        }
    }

    Timer {
        // 1000ms = 1 second
        interval: 1000

        // Start time immediately
        running: true
        repeat: true
        onTriggered: dateProc.running = true
    }
}
