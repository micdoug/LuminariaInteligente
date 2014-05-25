#include "arduino.h"
#include <QSerialPortInfo>
#include <QSerialPort>

/**
 * \class Arduino
 * Classe de comunicação com o arduino. Através desta classe é possível enviar comandos de transição
 * de cores para o arduino.
 */

/**
 * Construtor da classe.
 */
Arduino::Arduino() : recentColor(255, 255, 255)
{
    port = nullptr;
    output = nullptr;
}

/**
 * Destrutor da classe.
 */
Arduino::~Arduino()
{
    if(this->port != nullptr)
        this->port->close();
    delete this->port;
    delete this->output;
}

/**
 * Consulta a lista de portas disponíveis para conexão serial.
 * @return
 * Lista de strings com os nomes das portas seriais disponíveis no computador.
 */
QStringList Arduino::portsAvailable() const
{
    QStringList ret;
    for(QSerialPortInfo port: QSerialPortInfo::availablePorts())
    {
        ret << port.portName();
    }
    return ret;
}

/**
 * Tenta conectarna porta informada.
 * @param portName
 * Nome da porta serial a ser utilizada para conexão.
 * @return
 * Se foi possível ou não efetuar a conexão.
 */
bool Arduino::tryConnect(const QString &portName)
{
    if(this->port != nullptr)
        return false;
    for(QSerialPortInfo port: QSerialPortInfo::availablePorts())
    {
        if(port.portName() == portName)
        {
            this->port = new QSerialPort();
            this->port->setPort(port);
            if(this->port->open(QIODevice::WriteOnly))
            {
                output =  new QDataStream(this->port);
                return true;
            }
            this->port = nullptr;
            return false;
        }
    }
    return false;
}

/**
 * Encerra a conexão com o arduino.
 */
void Arduino::disconnect()
{
    if(this->port != nullptr)
    {
        this->port->close();
    }
    this->port = nullptr;
}

/**
 * Envia um comando de transição de cor para o arduino.
 * @param color
 * Cor destino da transição.
 * @return
 * Estado de comunicação com o arduíno.
 */
bool Arduino::sendColor(const QColor &color)
{
    if(this->port == nullptr)
        return false;

    QColor rgb = color.toRgb();

    char temp[3];
    temp[0]= (char)rgb.red();
    temp[1]= (char)rgb.green();
    temp[2]= (char)rgb.blue();
    qint64 transf = this->port->write(temp, 3);

    if(transf > 0)
    {
        this->recentColor = rgb;
        return true;
    }
    else
    {
        return false;
    }
}

/**
 * Método de consulta ao tempo necessário para efetuar a transição da cor atual para a cor enviada como parâmetro
 * para o arduino.
 * @param color
 * Cor destino da transição.
 * @return
 * Tempo em milissegundos necessário para efetuar a transição.
 */
int Arduino::timeToGo(const QColor &color) const
{
    return (abs(recentColor.red()-color.red())+abs(recentColor.green()-color.green())+abs(recentColor.blue()-color.blue()))*20;
}

/**
 * Retorna o status de conexão com o arduino.
 * @return
 * Status de conexão com o arduino.
 */
bool Arduino::isConnected()
{
    if(this->port != nullptr)
    {
        return this->port->isOpen();
    }
    return false;
}

/**
 * Método de consulta ao nome da porta de conexão sendo utilizada.
 * @return
 * Nome da porta de conexão utilizada, ou string vazia em caso de não estar conectado.
 */
QString Arduino::portName() const
{
    if(this->port != nullptr)
    {
        return this->port->portName();
    }
    return "";
}

/**
 * Método de consulta da cor mais recente utilizada pelo arduino. Esta cor é atualizada imediatamente após
 * a chamada do método sendColor.
 * @return
 * Cor mais recentemente utilizada.
 */
QColor Arduino::getRecentColor() const
{
    return recentColor;
}
