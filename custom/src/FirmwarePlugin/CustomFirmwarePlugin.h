/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 * @file
 *   @brief Custom Firmware Plugin (PX4)
 *   @author Gus Grubba <gus@auterion.com>
 *
 */

#pragma once

#include "FirmwarePlugin.h"


class CustomFirmwarePlugin : public FirmwarePlugin
{
    Q_OBJECT
public:
    CustomFirmwarePlugin();
    // FirmwarePlugin overrides
    AutoPilotPlugin*    autopilotPlugin                     (Vehicle* vehicle) override;


    QGCCameraManager*   createCameraManager                 (Vehicle *vehicle) override;
    QGCCameraControl*   createCameraControl                 (const mavlink_camera_information_t* info, Vehicle* vehicle, int compID, QObject* parent = nullptr) override;
    const QVariantList& toolBarIndicators                   (const Vehicle* vehicle) override;

private:
    QVariantList _toolBarIndicatorList;


    // Any instance data here must be global to all vehicles
    // Vehicle specific data should go into APMFirmwarePluginInstanceData

};



