import QtQuick.Layouts 1.1
import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2

GridLayout {
    id: root

    width: parent.width
    height: parent.height
    columns: 2

    Label {
        id: label

        Layout.fillWidth: true
        Layout.columnSpan: 2
        text: "Crie uma lista de cores e envie-as para o arduino. \n "+
              "Você pode também, ligar o gerador automático de cores. \n" +
              "Para remover uma cor da lista, basta clicar nela."

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
        id: colorList

        Layout.columnSpan: 2
        Layout.fillHeight: true
        Layout.fillWidth: true
        ListView {
            id: colorListView
            model: ListModel
            {
                id: colorListModel
                onCountChanged:
                {
                    if(generateColorButton.checked)
                    {
                        generateColor()
                    }
                }
            }
            delegate: ListButton {
                text: index
                backgroundColor: modelData
                hoveredColor: modelData
                borderWidth: 3
                onClicked: colorListModel.remove(index)
            }
        }
    }

    ListButton {
        id: addColor

        text: "Adicionar cor"
        Layout.preferredWidth: parent.width/2
        Layout.fillWidth: true

        onClicked: {
            colorDialog.open()
        }
    }

    ListButton {
        id: generateColorButton

        property bool checked: false
        text: checked ? "Cancelar geração de cores" : "Gerar cores aleatórias"
        Layout.preferredWidth: parent.width/2
        Layout.fillWidth: true
        onClicked: {
            checked = !checked
            if(checked)
                generateColor()
        }
    }

    ListButton {
        id: sendColorButton

        Layout.columnSpan: 2
        Layout.fillWidth: true
        text: timer.running ? "Enviando cores..." : "Enviar sequência de cores"
        onClicked: {
            if(!timer.running)
                sendColor()
        }

        Timer {
            id: timer

            repeat: false
            onRunningChanged: {
                if(running == true)
                {
                    if(colorListModel.count > 0)
                    {
                        progress.duration = arduino.timeToGo(colorListModel.get(0).color)+200;
                        arduino.sendColor(colorListModel.get(0).color);
                        progress.value = 100;
                    }
                }
            }
            onTriggered: {
                colorListModel.remove(0);
                sendColor()
            }
        }
    }
    ProgressBar {
        id: progress
        Layout.fillWidth: true
        Layout.columnSpan: 2
        minimumValue: 0
        maximumValue: 100
        value: 0
        property int duration : 0

        Behavior on value {
            NumberAnimation { duration: progress.duration }
        }
        onValueChanged: {
            if(value == 100)
            {
                duration = 0
                value = 0
            }
        }
    }

    ColorDialog {
        id: colorDialog
        title: "Escolha a cor que deseja enviar"
        onAccepted: {
            colorListModel.append({ color: colorDialog.color.toString() })
        }
    }

    function sendColor() {
        if(colorListModel.count > 0)
        {
            timer.interval = arduino.timeToGo(colorListModel.get(0).color)+200
            timer.start()
        }
    }

    function generateColor() {
       if(colorListModel.count < 2)
       {
           colorListModel.append({ color: '#'+Math.floor(Math.random()*16777215).toString(16) });
       }
    }
}
