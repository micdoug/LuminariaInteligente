import QtQuick 2.3

Item {
    id: root

    signal clicked

    width: 50
    height: 50

    Rectangle {
        id: rect

        anchors.fill: parent
        radius: 5
        color: "yellow"
        opacity: 0.3
    }

    Image {
        id: icon

        anchors.centerIn: parent
        source: "../icon/back.png"
    }

    MouseArea {
        id: mouse

        hoverEnabled: true
        anchors.fill: parent
        onClicked: parent.clicked()
        onEntered: root.state = "hovered"
        onExited: root.state = ""
        onPressed: root.state = "clicked"
        onReleased: root.state = "hovered"
    }

    states: [
        State {
            name: "hovered"
            PropertyChanges {
                target: rect
                opacity: 1.0
            }
        },
        State {
            name: "clicked"
            PropertyChanges {
                target: rect
                opacity: 1.0
                color: "green"
            }
        }
    ]
}
