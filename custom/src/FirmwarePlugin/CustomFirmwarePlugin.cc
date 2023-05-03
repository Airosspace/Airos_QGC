#include "CustomFirmwarePlugin.h"
#include "CustomAutoPilotPlugin.h"
#include "CustomCameraManager.h"
#include "CustomCameraControl.h"


//-----------------------------------------------------------------------------
CustomFirmwarePlugin::CustomFirmwarePlugin()
{

}

//-----------------------------------------------------------------------------
AutoPilotPlugin* CustomFirmwarePlugin::autopilotPlugin(Vehicle* vehicle)
{
    return new CustomAutoPilotPlugin(vehicle, vehicle);
}

//-----------------------------------------------------------------------------
QGCCameraManager*
CustomFirmwarePlugin::createCameraManager(Vehicle *vehicle)
{
    return new CustomCameraManager(vehicle);
}

//-----------------------------------------------------------------------------
QGCCameraControl*
CustomFirmwarePlugin::createCameraControl(const mavlink_camera_information_t* info, Vehicle *vehicle, int compID, QObject* parent)
{
    return new CustomCameraControl(info, vehicle, compID, parent);
}


//-----------------------------------------------------------------------------
const QVariantList&
CustomFirmwarePlugin::toolBarIndicators(const Vehicle* vehicle)
{
    Q_UNUSED(vehicle);
    if(_toolBarIndicatorList.size() == 0) {
#if defined(QGC_ENABLE_PAIRING)
        _toolBarIndicatorList.append(QVariant::fromValue(QUrl::fromUserInput("qrc:/custom/PairingIndicator.qml")));
#endif
        _toolBarIndicatorList.append(QVariant::fromValue(QUrl::fromUserInput("qrc:/custom/CustomGPSIndicator.qml")));
        _toolBarIndicatorList.append(QVariant::fromValue(QUrl::fromUserInput("qrc:/toolbar/RCRSSIIndicator.qml")));
       //_toolBarIndicatorList.append(QVariant::fromValue(QUrl::fromUserInput("qrc:/custom/RCRSSIIndicator.qml")));

        _toolBarIndicatorList.append(QVariant::fromValue(QUrl::fromUserInput("qrc:/toolbar/TelemetryRSSIIndicator.qml")));
        _toolBarIndicatorList.append(QVariant::fromValue(QUrl::fromUserInput("qrc:/custom/CustomBatteryIndicator.qml")));

    }

    return _toolBarIndicatorList;
}






