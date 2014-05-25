import QtQuick 2.3

Item {
    id: root

    property color backgroundColor: "black"
    property color hoveredColor: "steelblue"
    property color pressedColor: "slategray"
    property color borderColor: "white"
    property color borderHoveredColor: "yellow"
    property int borderWidth
    property alias text: label.text
    property alias font: label.font
    property alias textColor: label.color
    signal clicked
    width: parent.width
    height: 50

    Rectangle {
        id: rect

        anchors.fill: parent
        Behavior on color {
            ColorAnimation { duration: 200 }
        }
        border.width: root.borderWidth
        color: root.backgroundColor
        border.color: root.borderColor
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        onClicked: parent.clicked()
        onPressed: root.state = "pressed"
        onReleased: root.state = "hovered"
        onEntered: root.state = "hovered"
        onExited: root.state = ""
    }

    Text {
        id: label

        anchors.fill: parent
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font {
            bold: true
            family: "Trebuchet"
            pointSize: 14
        }
        color: "white"
    }
    state: ""

    states: [
        State {
            name: "hovered"
            PropertyChanges {
                target: rect
                color: root.hoveredColor
                border.color: root.borderHoveredColor
            }
        },
        State {
            name: "pressed"
            PropertyChanges {
                target: rect
                color: root.pressedColor
            }
        }
    ]
}


