import QtQuick 2.3
import QtQuick.Controls 1.1

Rectangle {
    id: root

    property alias text: label.text
    width: parent.width
    height: 56
    border {
        width: 2
        color: "steelblue"
    }
    color: "yellow"

    Label {
        id: label
        anchors.centerIn: parent
        font {
            bold: true
            pointSize: 14
        }
    }   
}
