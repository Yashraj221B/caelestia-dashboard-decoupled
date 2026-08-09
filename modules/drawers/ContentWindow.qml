pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.components
import qs.modules.dashboard as Dashboard

ShellRoot {
    id: root

    function close() {
        Qt.quit()
    }

    PanelWindow {
        id: window

        screen: Quickshell.screens[0]
        anchors.fill: true
        color: "transparent"
        focusable: true
        exclusiveZone: 0

        mask: Region {
            item: popup
        }

        ScreenState {
            id: screenState
            modelData: window.screen
        }

        HyprlandFocusGrab {
            active: true
            windows: [window]
            onCleared: root.close()
        }

        Rectangle {
            id: popup

            anchors.centerIn: parent
            implicitWidth: dashboard.implicitWidth
            implicitHeight: header.height + dashboard.implicitHeight + 16

            color: "#1e1e2e"
            radius: 16

            Item {
                id: header

                width: parent.width
                height: 48

                Text {
                    anchors.centerIn: parent
                    text: "Decoupled Dashboard"
                    color: "#ffffff"

                    font.pixelSize: 16
                    font.weight: Font.Medium
                }

                Rectangle {
                    width: 30
                    height: 30
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    radius: width / 2
                    color: closeMouse.containsMouse ? "#6b6b65" : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "×"
                        color: "#ffffff"
                        font.pixelSize: 20
                        font.weight: Font.Medium
                    }

                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.close()
                    }
                }
            }

            Dashboard.Wrapper {
                id: dashboard

                screenState: screenState
                anchors {
                    top: header.bottom
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Shortcut {
                sequence: "Escape"
                onActivated: root.close()
            }
        }
    }
}