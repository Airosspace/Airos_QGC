message("Adding Custom Plugin")

#-- Version control
#   Major and minor versions are defined here (manually)

CUSTOM_QGC_VER_MAJOR = 4
CUSTOM_QGC_VER_MINOR = 0
CUSTOM_QGC_VER_FIRST_BUILD = 5395

# Build number is automatic
# Uses the current branch. This way it works on any branch including build-server's PR branches
CUSTOM_QGC_VER_BUILD = $$system(git --git-dir ../.git rev-list $$GIT_BRANCH --first-parent --count)
win32 {
    CUSTOM_QGC_VER_BUILD = $$system("set /a $$CUSTOM_QGC_VER_BUILD - $$CUSTOM_QGC_VER_FIRST_BUILD")
} else {
    CUSTOM_QGC_VER_BUILD = $$system("echo $(($$CUSTOM_QGC_VER_BUILD - $$CUSTOM_QGC_VER_FIRST_BUILD))")
}
CUSTOM_QGC_VERSION = $${CUSTOM_QGC_VER_MAJOR}.$${CUSTOM_QGC_VER_MINOR}.$${CUSTOM_QGC_VER_BUILD}

DEFINES -= GIT_VERSION=\"\\\"$$GIT_VERSION\\\"\"
DEFINES += GIT_VERSION=\"\\\"$$CUSTOM_QGC_VERSION\\\"\"

message(Custom QGC Version: $${CUSTOM_QGC_VERSION})

# Build a single flight stack by disabling APM support
#MAVLINK_CONF = APMFirmwarePlugin
#CONFIG  += QGC_DISABLE_APM_MAVLINK
CONFIG  += QGC_DISABLE_APM_PLUGIN
CONFIG += QGC_DISABLE_APM_PLUGIN_FACTORY
CONFIG += Test
DEFINES += QGC_ENABLE_UVC

# We implement our own PX4 plugin factory
CONFIG  += QGC_DISABLE_PX4_PLUGIN_FACTORY

# Branding

DEFINES += CUSTOMHEADER=\"\\\"CustomPlugin.h\\\"\"
DEFINES += CUSTOMCLASS=CustomPlugin

TARGET   = CustomQGC
DEFINES += QGC_APPLICATION_NAME=\"\\\"CustomQGC\\\"\"

DEFINES += QGC_ORG_NAME=\"\\\"qgroundcontrol.org\\\"\"
DEFINES += QGC_ORG_DOMAIN=\"\\\"org.qgroundcontrol\\\"\"

QGC_APP_NAME        = "Custom GS"
QGC_BINARY_NAME     = "QGCCustomAPM"
QGC_ORG_NAME        = "Custom"
QGC_ORG_DOMAIN      = "org.qgroundcontrol"
QGC_APP_DESCRIPTION = "Custom QGC Ground Station"
QGC_APP_COPYRIGHT   = "Copyright (C) 2019 QGroundControl Development Team. All rights reserved."

# Our own, custom resources
RESOURCES += \
    $$QGCROOT/src/FirmwarePlugin/APM/APMResources.qrc \
    $$QGCROOT/custom/custom.qrc

QML_IMPORT_PATH += \
    $$QGCROOT/custom/res

# Our own, custom sources
SOURCES += \
    $$PWD/src/CustomPlugin.cc \
    $$PWD/src/CustomQuickInterface.cc \
    $$PWD/src/CustomVideoManager.cc \
    $$PWD/src/FirmwarePlugin/CustomBattery.cc

HEADERS += \
    $$PWD/src/CustomPlugin.h \
    $$PWD/src/CustomQuickInterface.h \
    $$PWD/src/CustomVideoManager.h \
    $$PWD/src/FirmwarePlugin/CustomBattery.h

INCLUDEPATH += \
    $$PWD/src \

#-------------------------------------------------------------------------------------
# Custom Firmware/AutoPilot Plugin

INCLUDEPATH += \
    $$QGCROOT/custom/src/FirmwarePlugin \
    $$QGCROOT/custom/src/FirmwarePlugin/APM \
    $$QGCROOT/custom/src/AutoPilotPlugin \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM



HEADERS+= \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomCameraControl.h \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomCameraManager.h \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomFirmwarePlugin.h \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomFirmwarePluginFactory.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/CustomAutoPilotPlugin.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/CustomClass.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMAirframeComponent.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMAirframeComponentController.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMAutoPilotPlugin.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMCameraComponent.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMCompassCal.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMFlightModesComponent.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMFlightModesComponentController.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMFollowComponent.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMFollowComponentController.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMHeliComponent.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMLightsComponent.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMMotorComponent.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMPowerComponent.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMRadioComponent.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSafetyComponent.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSensorsComponent.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSensorsComponentController.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSubFrameComponent.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMTuningComponent.h \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSubMotorComponentController.h \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMFirmwarePlugin.h \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMFirmwarePluginFactory.h \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterMetaData.h \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/ArduCopterFirmwarePlugin.h \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/ArduPlaneFirmwarePlugin.h \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/ArduRoverFirmwarePlugin.h \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/ArduSubFirmwarePlugin.h





SOURCES += \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomCameraControl.cc \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomCameraManager.cc \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomFirmwarePlugin.cc \
    $$QGCROOT/custom/src/FirmwarePlugin/CustomFirmwarePluginFactory.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/CustomAutoPilotPlugin.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/CustomClass.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMAirframeComponent.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMAirframeComponentController.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMAutoPilotPlugin.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMCameraComponent.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMCompassCal.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMFlightModesComponent.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMFlightModesComponentController.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMFollowComponent.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMFollowComponentController.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMHeliComponent.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMLightsComponent.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMMotorComponent.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMPowerComponent.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMRadioComponent.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSafetyComponent.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSensorsComponent.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSensorsComponentController.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSubFrameComponent.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMTuningComponent.cc \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSubMotorComponentController.cc \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMFirmwarePlugin.cc \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMFirmwarePluginFactory.cc \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterMetaData.cc \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/ArduCopterFirmwarePlugin.cc \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/ArduPlaneFirmwarePlugin.cc \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/ArduRoverFirmwarePlugin.cc \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/ArduSubFirmwarePlugin.cc


DISTFILES += \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMAirframeComponent.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMAirframeComponentSummary.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMCameraComponent.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMCameraComponentSummary.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMCameraSubComponent.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMFlightModesComponent.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMFlightModesComponentSummary.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMFollowComponent.FactMetaData.json \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMFollowComponent.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMFollowComponentSummary.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMHeliComponent.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMLightsComponent.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMLightsComponentSummary.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMMotorComponent.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMNotSupported.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMPowerComponent.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMPowerComponentSummary.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMRadioComponentSummary.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSafetyComponent.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSafetyComponentCopter.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSafetyComponentPlane.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSafetyComponentRover.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSafetyComponentSub.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSafetyComponentSummary.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSafetyComponentSummaryCopter.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSafetyComponentSummaryPlane.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSafetyComponentSummaryRover.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSafetyComponentSummarySub.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSensorsComponent.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSensorsComponentSummary.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSubFrameComponent.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSubFrameComponentSummary.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSubMotorComponent.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMTuningComponentCopter.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMTuningComponentSub.qml \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/APMSubMotorComponent \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/CMakeLists.txt \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/Images/LightsComponentIcon.png \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/Images/SubFrameComponentIcon.png \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/Images/bluerov-frame.png \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/Images/simple3-frame.png \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/Images/simple4-frame.png \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/Images/simple5-frame.png \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/Images/vectored-frame.png \
    $$QGCROOT/custom/src/AutoPilotPlugin/APM/Images/vectored6dof-frame.png \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMBrandImage.png \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMBrandImageSub.png \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterFactMetaData.Copter.3.5.xml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterFactMetaData.Copter.3.6.xml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterFactMetaData.Copter.3.7.xml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterFactMetaData.Copter.4.0.xml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterFactMetaData.Plane.3.10.xml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterFactMetaData.Plane.3.8.xml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterFactMetaData.Plane.3.9.xml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterFactMetaData.Plane.4.0.xml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterFactMetaData.Rover.3.4.xml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterFactMetaData.Rover.3.5.xml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterFactMetaData.Rover.3.6.xml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterFactMetaData.Rover.4.0.xml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterFactMetaData.Sub.3.4.xml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterFactMetaData.Sub.3.5.xml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMParameterFactMetaData.Sub.3.6dev.xml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/APMSensorParams.qml \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/BuildParamMetaData.sh \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/CMakeLists.txt \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/Copter3.6.OfflineEditing.params \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/MavCmdInfoCommon.json \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/MavCmdInfoFixedWing.json \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/MavCmdInfoMultiRotor.json \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/MavCmdInfoRover.json \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/MavCmdInfoSub.json \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/MavCmdInfoVTOL.json \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/Plane3.9.OfflineEditing.params \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/QGroundControl.ArduPilot.qmldir \
    $$QGCROOT/custom/src/FirmwarePlugin/APM/Rover3.5.OfflineEditing.params




