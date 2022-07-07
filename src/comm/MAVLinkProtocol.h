/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include <QObject>
#include <QMutex>
#include <QString>
#include <QTimer>
#include <QFile>
#include <QMap>
#include <QByteArray>
#include <QLoggingCategory>

#include "LinkInterface.h"
#include "QGCMAVLink.h"
#include "QGC.h"
#include "QGCTemporaryFile.h"
#include "QGCToolbox.h"
#include "data.h"

class LinkManager;
class MultiVehicleManager;
class QGCApplication;

Q_DECLARE_LOGGING_CATEGORY(MAVLinkProtocolLog)

/**
 * @brief MAVLink micro air vehicle protocol reference implementation.
 *
 * MAVLink is a generic communication protocol for micro air vehicles.
 * for more information, please see the official website: https://mavlink.io
 **/
class MAVLinkProtocol : public QGCTool
{
    Q_OBJECT

public:
    MAVLinkProtocol(QGCApplication* app, QGCToolbox* toolbox);
    ~MAVLinkProtocol();

    /** @brief Get the human-friendly name of this protocol */
    //��ȡЭ������
    QString getName();
    /** @brief Get the system id of this application */
    //��ȡ�������վ��ϵͳID
    int getSystemId();
    /** @brief Get the component id of this application */
    //��ȡ���ID
    int getComponentId();

    /** @brief Get protocol version check state */
    //����mav��qgcЭ����ݼ��
    bool versionCheckEnabled() const {
        return m_enable_version_check;
    }
    /** @brief Get the protocol version */
    //��ȡ��ǰqgcЭ��汾
    int getVersion() {
        return MAVLINK_VERSION;
    }
    /** @brief Get the currently configured protocol version */
    unsigned getCurrentVersion() {
        return _current_version;
    }
    /**
     * Reset the counters for all metadata for this link.
     */
    //Ϊ���������������Ԫ���ݵļ�����
    virtual void resetMetadataForLink(LinkInterface *link);

    /// Suspend/Restart logging during replay.
    // �ط��ڼ���ͣ/�ָ���־
    void suspendLogForReplay(bool suspend);

    /// Set protocol version
    void setVersion(unsigned version);

    // Override from QGCTool
    //������������
    virtual void setToolbox(QGCToolbox *toolbox);

public slots:
    /** @brief Receive bytes from a communication interface */
    // ��ͨ�Žӿڽ����ֽڣ�����Э��
    // �����Բ��д��������ӣ�ÿ�����Ӷ����Լ��Ļ������ͽ���״̬��
    // ����������߳�
    void receiveBytes(LinkInterface* link, QByteArray b);

    /** @brief Log bytes sent from a communication interface */
    void logSentBytes(LinkInterface* link, QByteArray b);

    /** @brief Set the system id of this application */
    //����ϵͳID
    void setSystemId(int id);

    /** @brief Enable / disable version check */
    //����/���ð汾���
    void enableVersionCheck(bool enabled);

    /** @brief Load protocol settings */
    //����Э������
    void loadSettings();
    /** @brief Store protocol settings */
    //�洢Э������
    void storeSettings();

    /// @brief Deletes any log files which are in the temp directory
    // ɾ����ʱĿ¼�е��κ���־�ļ�
    static void deleteTempLogFiles(void);

    /// Checks for lost log files
    // ��鶪ʧ����־�ļ�
    void checkForLostLogFiles(void);

protected:
    //����mav��qgcЭ����ݼ��
    bool        m_enable_version_check;                         ///< Enable checking of version match of MAV and QGC
    uint8_t     lastIndex[256][256];                            ///< Store the last received sequence ID for each system/componenet pair
    uint8_t     firstMessage[256][256];                         ///< First message flag
    uint64_t    totalReceiveCounter[MAVLINK_COMM_NUM_BUFFERS];  ///< The total number of successfully received messages
    uint64_t    totalLossCounter[MAVLINK_COMM_NUM_BUFFERS];     ///< Total messages lost during transmission.
    float       runningLossPercent[MAVLINK_COMM_NUM_BUFFERS];   ///< Loss rate

    mavlink_message_t _message;
    mavlink_status_t _status;

    bool        versionMismatchIgnore;
    int         systemId;
    unsigned    _current_version;
    int         _radio_version_mismatch_count;

signals:
    /// Heartbeat received on link
    //�����������յ���������
    void vehicleHeartbeatInfo(LinkInterface* link, int vehicleId, int componentId, int vehicleFirmwareType, int vehicleType);

    /** @brief Message received and directly copied via signal */
    //�����������յ�����Ϣ
    void messageReceived(LinkInterface* link, mavlink_message_t message);
    /** @brief Emitted if version check is enabled / disabled */
    //�����汾����־
    void versionCheckChanged(bool enabled);
    /** @brief Emitted if a message from the protocol should reach the user */
    //����Э��״̬��Ϣ
    void protocolStatusMessage(const QString& title, const QString& message);
    /** @brief Emitted if a new system ID was set */
    //�����źţ���ϵͳID������
    void systemIdChanged(int systemId);

    void mavlinkMessageStatus(int uasId, uint64_t totalSent, uint64_t totalReceived, uint64_t totalLoss, float lossPercent);

    /**
     * @brief Emitted if a new radio status packet received
     *
     * @param rxerrors receive errors
     * @param fixed count of error corrected packets
     * @param rssi local signal strength in dBm
     * @param remrssi remote signal strength in dBm
     * @param txbuf how full the tx buffer is as a percentage
     * @param noise background noise level
     * @param remnoise remote background noise level
     */
    void radioStatusChanged(LinkInterface* link, unsigned rxerrors, unsigned fixed, int rssi, int remrssi,
    unsigned txbuf, unsigned noise, unsigned remnoise);

    /// Emitted when a temporary telemetry log file is ready for saving
    //�����źţ���һ����ʱ��ң����־�ļ�׼������ʱ
    void saveTelemetryLog(QString tempLogfile);

    /// Emitted when a telemetry log is started to save.
    //��ң����־��ʼ����ʱ����
    void checkTelemetrySavePath(void);

private slots:
    //�ɻ������ı�
    void _vehicleCountChanged(void);

private:
    bool _closeLogFile(void);
    void _startLogging(void);
    void _stopLogging(void);

    bool _logSuspendError;      ///< true: Logging suspended due to error
    bool _logSuspendReplay;     ///< true: Logging suspended due to replay
    bool _vehicleWasArmed;      ///< true: Vehicle was armed during log sequence

    QGCTemporaryFile    _tempLogFile;            ///< File to log to
    static const char*  _tempLogFileTemplate;    ///< Template for temporary log file
    static const char*  _logFileExtension;       ///< Extension for log files

    LinkManager*            _linkMgr;
    MultiVehicleManager*    _multiVehicleManager;
};

