import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1

ColumnLayout {
    id: root

    width: parent.width
    height: parent.height
    spacing: 0
    Label {
        id: label

        Layout.fillWidth: true
        text: "Abaixo estão as portas seriais detectadas em seu computador. "+
              "Indique a porta onde o arduino está conectado."
        font {
            pointSize: 16
            family: "Trebuchet"
        }
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter
        color: "white"
        Rectangle {
            anchors.fill: parent
            z: -1
            color: "dimgray"
        }
    }

    ScrollView {
        id: view

        Layout.fillHeight: true
        Layout.fillWidth: true
        ListView {
            id: listView

            model: ListModel { id: listModel }
            delegate: ListButton {
                backgroundColor: "steelblue"
                hoveredColor: "lightSteelblue"
                pressedColor: "slategray"
                borderColor: "mediumseagreen"
                borderWidth: 3
                borderHoveredColor: "white"
                text: modelData
                onClicked: arduinoConnect(modelData)
            }
        }
    }
    
    ListButton {
        id: scanButton
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        backgroundColor: "black"
        hoveredColor: "steelblue"
        pressedColor: "slategray"
        text: "Scanear portas seriais"
        textColor: "white"
        onClicked: scanPorts()
    }

    MessageDialog {
        id: messageDialog
        width: 400
    }

    Component.onCompleted: {
        scanPorts()
    }

    function scanPorts() {
        listView.model = arduino.portsAvailable()
        if(listView.count == 0)
        {
            messageDialog.title = "Dispositivos não detectados"
            messageDialog.text = "Não foram encontrados dispositivos conectados neste computador. \n" +
                                 "Tente reconectar os dipositivos e reescanear as portas";
            messageDialog.icon = StandardIcon.Information;
            messageDialog.open()
        }
    }

    function arduinoConnect(port) {
        if(arduino.isConnected())
            arduino.disconnect()

        if(!arduino.tryConnect(port))
        {
            messageDialog.title = "Conexão não diponível"
            messageDialog.text = "Não foi possível se conectar ao dispositivo serial informado! \n" +
                                 "Verifique se o dispositivo está realmente conectado e tente novamente.";
            messageDialog.icon = StandardIcon.Critical;
            messageDialog.open()
        }
        else
        {
            parent.push(Qt.resolvedUrl("SendColorPage.qml"));
        }
    }
}


