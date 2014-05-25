import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
    id: root

    signal backClicked
    property alias backButtonVisible: backButton.visible
    property alias titleText: title.text

    height: 80
    width: parent.width
    Image {
        anchors.fill: parent
        source: "../bg/bg.png"
    }

    RowLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: 10
        clip: true
        spacing: 10
        BackButton {
            id: backButton

            onClicked: root.backClicked()
        }

        Label {
            id: title

            horizontalAlignment: Text.AlignHCenter
            font {
                bold: true
                family: "monospace"
                pointSize: 20
            }
            color: "white"
            Layout.fillWidth: true

            Behavior on x {
                NumberAnimation { duration: 500; }
            }
        }

    }
    Rectangle {
        id: bottomLine
        width: parent.width
        anchors.bottom: parent.bottom
        color: "yellow"
        height: 3
    }
}
