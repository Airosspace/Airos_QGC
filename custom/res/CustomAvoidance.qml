/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 * @file
 *   @author
 */

import QtQuick                              2.11
import QtQuick.Controls                     1.4
import QtQuick.Layouts                      1.11

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0
import QGroundControl.CustomBattery         1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0




Item {

    id: _CustomAvoidance
    property Fact proximitySettings
    property bool  prxParamsAvailable
    property int lastLevel
    property int lastDistance
    property string lastOrient
    property int maxdistance

    property color lastColor:qgcPal.colorGrey

    property var listTextProx: ['']
    property var listDistProx: ['']


    Connections {
        target: QGroundControl.multiVehicleManager.activeVehicle
        onConnectionLostChanged: {

        }
        onActiveChanged: {
            //checkProximityParameter()


        }


    }


    FactPanelController {
        id: controller
    }

    //---------------------------------------------------------------------

    function checkProximityParameter(proximity){
        if (activeVehicle.objectApmAvoidance.size >0 ){
            maxdistance=activeVehicle.objectApmAvoidance.maxDistance(proximity)
            return true
        }else{
            return false
        }

    }


    //-----------------------------------------------------------------------
    function getAvoidColor(proximity) {

        if(activeVehicle.objectApmAvoidance.size === proximity && checkProximityParameter(proximity)  && activeVehicle.objectApmAvoidance.orientation(proximity)===0  ) {
            if(activeVehicle.objectApmAvoidance.level(proximity)===3) {
                lastColor= qgcPal.colorGreen
            }
            if(activeVehicle.objectApmAvoidance.level(proximity)===2)  {
                lastColor= qgcPal.colorOrange
            }
            if(activeVehicle.objectApmAvoidance.level(proximity)===1) {
                lastColor= qgcPal.colorRed
            }
        }
        return lastColor
    }

    //-----------------------------------------------------------------------

    function getAvoidLevel(proximity) {
        if(activeVehicle.objectApmAvoidance.size === proximity  && checkProximityParameter(proximity) )  {
            if (activeVehicle.objectApmAvoidance.orientation(proximity)===0 ){
                lastLevel=activeVehicle.objectApmAvoidance.level(proximity)
                if (lastLevel=== 4){
                    return 0
                }
            }
        }
        return lastLevel
    }

    //-----------------------------------------------------------------------

    function getDistance(proximity,orientation) {
        if(activeVehicle.objectApmAvoidance.size === proximity  && checkProximityParameter(proximity) )  {
            if (activeVehicle.objectApmAvoidance.orientation(proximity)===orientation ){
                lastDistance=activeVehicle.objectApmAvoidance.distance(proximity)
                listDistProx[orientation]=lastDistance
                return lastDistance

            }

            return  listDistProx[orientation]

        }

        return false

    }



    //-----------------------------------------------------------------------
    /*
        0	MAV_SENSOR_ROTATION_NONE	Roll: 0, Pitch: 0, Yaw: 0
        1	MAV_SENSOR_ROTATION_YAW_45	Roll: 0, Pitch: 0, Yaw: 45
        2	MAV_SENSOR_ROTATION_YAW_90	Roll: 0, Pitch: 0, Yaw: 90
        3	MAV_SENSOR_ROTATION_YAW_135	Roll: 0, Pitch: 0, Yaw: 135
        4	MAV_SENSOR_ROTATION_YAW_180	Roll: 0, Pitch: 0, Yaw: 180
        5	MAV_SENSOR_ROTATION_YAW_225	Roll: 0, Pitch: 0, Yaw: 225
        6	MAV_SENSOR_ROTATION_YAW_270	Roll: 0, Pitch: 0, Yaw: 270
        7	MAV_SENSOR_ROTATION_YAW_315	Roll: 0, Pitch: 0, Yaw: 315
        8	MAV_SENSOR_ROTATION_ROLL_180	Roll: 180, Pitch: 0, Yaw: 0
        9	MAV_SENSOR_ROTATION_ROLL_180_YAW_45	Roll: 180, Pitch: 0, Yaw: 45
        10	MAV_SENSOR_ROTATION_ROLL_180_YAW_90	Roll: 180, Pitch: 0, Yaw: 90
        11	MAV_SENSOR_ROTATION_ROLL_180_YAW_135	Roll: 180, Pitch: 0, Yaw: 135
        12	MAV_SENSOR_ROTATION_PITCH_180	Roll: 0, Pitch: 180, Yaw: 0
        13	MAV_SENSOR_ROTATION_ROLL_180_YAW_225	Roll: 180, Pitch: 0, Yaw: 225
        14	MAV_SENSOR_ROTATION_ROLL_180_YAW_270	Roll: 180, Pitch: 0, Yaw: 270
        15	MAV_SENSOR_ROTATION_ROLL_180_YAW_315	Roll: 180, Pitch: 0, Yaw: 315
        16	MAV_SENSOR_ROTATION_ROLL_90	Roll: 90, Pitch: 0, Yaw: 0
        17	MAV_SENSOR_ROTATION_ROLL_90_YAW_45	Roll: 90, Pitch: 0, Yaw: 45
        18	MAV_SENSOR_ROTATION_ROLL_90_YAW_90	Roll: 90, Pitch: 0, Yaw: 90
        19	MAV_SENSOR_ROTATION_ROLL_90_YAW_135	Roll: 90, Pitch: 0, Yaw: 135
        20	MAV_SENSOR_ROTATION_ROLL_270	Roll: 270, Pitch: 0, Yaw: 0
        21	MAV_SENSOR_ROTATION_ROLL_270_YAW_45	Roll: 270, Pitch: 0, Yaw: 45
        22	MAV_SENSOR_ROTATION_ROLL_270_YAW_90	Roll: 270, Pitch: 0, Yaw: 90
        23	MAV_SENSOR_ROTATION_ROLL_270_YAW_135	Roll: 270, Pitch: 0, Yaw: 135
        24	MAV_SENSOR_ROTATION_PITCH_90	Roll: 0, Pitch: 90, Yaw: 0
        25	MAV_SENSOR_ROTATION_PITCH_270	Roll: 0, Pitch: 270, Yaw: 0
        26	MAV_SENSOR_ROTATION_PITCH_180_YAW_90	Roll: 0, Pitch: 180, Yaw: 90
        27	MAV_SENSOR_ROTATION_PITCH_180_YAW_270	Roll: 0, Pitch: 180, Yaw: 270
        28	MAV_SENSOR_ROTATION_ROLL_90_PITCH_90	Roll: 90, Pitch: 90, Yaw: 0
        29	MAV_SENSOR_ROTATION_ROLL_180_PITCH_90	Roll: 180, Pitch: 90, Yaw: 0
        30	MAV_SENSOR_ROTATION_ROLL_270_PITCH_90	Roll: 270, Pitch: 90, Yaw: 0
        31	MAV_SENSOR_ROTATION_ROLL_90_PITCH_180	Roll: 90, Pitch: 180, Yaw: 0
        32	MAV_SENSOR_ROTATION_ROLL_270_PITCH_180	Roll: 270, Pitch: 180, Yaw: 0
        33	MAV_SENSOR_ROTATION_ROLL_90_PITCH_270	Roll: 90, Pitch: 270, Yaw: 0
        34	MAV_SENSOR_ROTATION_ROLL_180_PITCH_270	Roll: 180, Pitch: 270, Yaw: 0
        35	MAV_SENSOR_ROTATION_ROLL_270_PITCH_270	Roll: 270, Pitch: 270, Yaw: 0
        36	MAV_SENSOR_ROTATION_ROLL_90_PITCH_180_YAW_90	Roll: 90, Pitch: 180, Yaw: 90
        37	MAV_SENSOR_ROTATION_ROLL_90_YAW_270	Roll: 90, Pitch: 0, Yaw: 270
        38	MAV_SENSOR_ROTATION_ROLL_90_PITCH_68_YAW_293	Roll: 90, Pitch: 68, Yaw: 293
        39	MAV_SENSOR_ROTATION_PITCH_315	Pitch: 315
        40	MAV_SENSOR_ROTATION_ROLL_90_PITCH_315	Roll: 90, Pitch: 315
        100	MAV_SENSOR_ROTATION_CUSTOM	Custom orientation
      */
    function getPrxOrientation(proximity,orientation) {
        if(activeVehicle.objectApmAvoidance.size === proximity  && checkProximityParameter(proximity)) {
            if (activeVehicle.objectApmAvoidance.orientation(proximity)===orientation ){
                switch (activeVehicle.objectApmAvoidance.orientation(proximity)){
                case 0:
                    lastOrient="Distance Forward"
                    break;
                case 4:
                    lastOrient="Disstance Backward"
                    break;
                case 25:
                    lastOrient="Sonar"
                    break;

                }
                listTextProx[orientation]=lastOrient
                return lastOrient
            }
        }
        return listTextProx[orientation]

    }



    Rectangle{
        id:                     avoid
        color:                  qgcPal.globalTheme === QGCPalette.Light ? Qt.rgba(0,0,0,0.0) : Qt.rgba(0,0,0,0.0)//0.3
        width:                  avoidGrid.width *2
        height:                 avoidGrid.height
        x:                      Math.round((mainWindow.width  - width)  * 0.5)//0.5
        y:                      Math.round((mainWindow.height - height) * 0.8)//0.5
        radius:                 2
        visible: getDistance(1,0)>=maxdistance || !getDistance(1,0) ? false:true



        Grid {
            id:                    avoidGrid
            columnSpacing:         1
            rowSpacing:            1
            columns:               4
            anchors.centerIn:      parent
            visible:  !mainIsMap

            QGCLabel {
                height:                 _indicatorsHeight
                width:                  height
                Layout.alignment:       Qt.AlignVCenter | Qt.AlignHCenter
                font.pointSize:         ScreenTools.mediumFontPointSize
                color:                  qgcPal.text
                text:                   getPrxOrientation(1,0)

            }

            QGCLabel {
                height:                 _indicatorsHeight
                width:                  height
                Layout.alignment:       Qt.AlignVCenter | Qt.AlignHCenter
                font.pointSize:         ScreenTools.mediumFontPointSize
                color:                  qgcPal.text
                text:                   ""
              }

            QGCLabel {
                height:                 _indicatorsHeight
                width:                  height
                Layout.alignment:       Qt.AlignVCenter | Qt.AlignHCenter
                font.pointSize:         ScreenTools.mediumFontPointSize
                color:                  qgcPal.text
                text:                   ""
               }

            QGCLabel {
                height:                 _indicatorsHeight
                width:                  height
                Layout.alignment:       Qt.AlignVCenter | Qt.AlignHCenter
                font.pointSize:         ScreenTools.mediumFontPointSize
                color:                  qgcPal.text
                text:                    activeVehicle.objectApmAvoidance.size >0 ? getDistance(1,0)+" (cm) ":""
            }

            Repeater {
                model:getAvoidLevel(1) * avoidGrid.columns
                Rectangle {
                    width: 100; height: 40
                    border.width: 1
                    color:getAvoidColor(1)
                }
            }

        }

    }

    Rectangle{
        id:                     ground
        color:                  qgcPal.globalTheme === QGCPalette.Light ? Qt.rgba(0,0,0,0.0): Qt.rgba(0,0,0,0.0)//0.3
        width:                  groundGrid.width *2
        height:                 groundGrid.height
        x:                      Math.round((mainWindow.width  - width)  * 0.9)//0.5
        y:                      Math.round((mainWindow.height - height) * 0.8)//0.5
        radius:                 2
        visible: getDistance(1,25)>=maxdistance || !getDistance(1,25) ? false:true

        Grid {
            id:                    groundGrid
            columnSpacing:         1
            rowSpacing:            1
            columns:               1
            anchors.centerIn:      parent
            visible:getDistance(1,25)>=650 || !getDistance(1,25) ? false:true //  !mainIsMap

                QGCLabel {
                    height:                 _indicatorsHeight
                    width:                  height
                    Layout.alignment:       Qt.AlignVCenter | Qt.AlignHCenter
                    font.pointSize:         ScreenTools.mediumFontPointSize
                    color:                  qgcPal.text
                    text:                    activeVehicle.objectApmAvoidance.size >0 ? getDistance(1,25)+" (cm) ":""
                }

                QGCColoredImage {
                    height:                 _indicatorsHeight
                    width:                  height
                    source:                 "/custom/img/sonar.svg"
                    fillMode:               Image.PreserveAspectFit
                    sourceSize.height:      height
                    Layout.alignment:       Qt.AlignVCenter | Qt.AlignHCenter
                    //color:                  "black"
               }


        }
    }

}















