#ifndef ARDUINO_H
#define ARDUINO_H

#include <QStringList>
#include <QColor>
#include <QDataStream>
#include <QObject>

class QSerialPort;

class Arduino : public QObject
{
    Q_OBJECT
public:
    explicit Arduino();
    virtual ~Arduino();

    Q_INVOKABLE QStringList portsAvailable() const;
    Q_INVOKABLE bool tryConnect(const QString &portName);
    Q_INVOKABLE void disconnect();
    Q_INVOKABLE bool sendColor(const QColor &color);
    Q_INVOKABLE int timeToGo(const QColor &color) const;
    Q_INVOKABLE bool isConnected();
    Q_INVOKABLE QString portName() const;

    Q_INVOKABLE QColor getRecentColor() const;

private:
    QSerialPort *port;
    QDataStream *output;
    QColor recentColor;
};

#endif // ARDUINO_H
