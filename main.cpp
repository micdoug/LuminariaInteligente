#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "arduino.h"

int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("arduino", new Arduino());
    engine.load(QUrl("qrc:/qml/main.qml"));

    return app.exec();
}
