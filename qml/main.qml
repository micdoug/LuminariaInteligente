import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: root

    width: 800
    height: 600
    visible: true

    toolBar: NavigationBar {
        id: navigationBar

        backButtonVisible: stack.depth > 1
        onBackClicked: stack.pop()
    }



    StackView {
        id: stack

        focus: true
        anchors.fill: parent
        initialItem: MainPage{}
        onDepthChanged: {
            if(depth == 1)
                navigationBar.titleText = "Luminária Inteligente"
        }
    }
}


