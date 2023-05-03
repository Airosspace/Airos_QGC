/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 * @file
 *   @author Gus Grubba <gus@auterion.com>
 */


import QtQuick                  2.11
import QtQuick.Controls         2.4
import QtQuick.Layouts          1.11
import QtQuick.Dialogs          1.3

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0

//-------------------------------------------------------------------------
//-- Mode Indicator
Item {
    anchors.top:                    parent.top
    anchors.bottom:                 parent.bottom
    width:                          selectorRow.width

    Row {
        id:                         selectorRow
        spacing:                    ScreenTools.defaultFontPixelWidth
        anchors.verticalCenter:     parent.verticalCenter
        QGCLabel {
            id:                     flightModeSelector
            text:                   activeVehicle ? activeVehicle.flightMode : qsTr("N/A")
            color:                  qgcPal.text
            font.pointSize:         ScreenTools.mediumFontPointSize
            anchors.verticalCenter:     parent.verticalCenter
        }
        QGCColoredImage {
            anchors.verticalCenter: parent.verticalCenter
            height:                 ScreenTools.defaultFontPixelHeight * 0.5
            width:                  height
            sourceSize.height:      parent.height
            fillMode:               Image.PreserveAspectFit
            source:                 "/res/DropArrow.svg"
            color:                  qgcPal.text
        }
    }
    MouseArea {
        visible:        activeVehicle && activeVehicle.flightModeSetAvailable
        anchors.fill:   parent
        onClicked:      flightModesMenu.open()
    }
    //-------------------------------------------------------------------------
    //-- Flight Modes
    Popup {
        id:                     flightModesMenu
        width:                  Rectangle.width//Math.min(mainWindow.width * 0.666, ScreenTools.defaultFontPixelWidth * 40)
        height:                 Rectangle.height//mainWindow.height * 0.5
        modal:                  true
        focus:                  true
        parent:                 Overlay.overlay
        x:                      Math.round((mainWindow.width  - width)  * 0.5)
        y:                      Math.round((mainWindow.height - height) * 0.5)
        closePolicy:            Popup.CloseOnEscape | Popup.CloseOnPressOutside
        property int selectedIndex: 0

        background: Rectangle {
            anchors.fill:       parent
            color:              qgcPal.globalTheme === QGCPalette.Light ? Qt.rgba(1,1,1,0.95) : Qt.rgba(0,0,0,0.75) //0.75
            border.color:       qgcPal.window // qgcPal.text
            radius:             ScreenTools.defaultFontPixelWidth *0.5
            width:              comboListCol.width  + (ScreenTools.defaultFontPixelWidth  * 3.5)  //New
            height:             comboListCol.height + (ScreenTools.defaultFontPixelHeight * 1.5) //New


        }
        GridLayout {
            id:                 comboListCol
            anchors.fill:       parent
            columnSpacing:          ScreenTools.defaultFontPixelWidth  * 2  //1.5
            rowSpacing:             ScreenTools.defaultFontPixelHeight * 1  //0.5
            //spacing:            ScreenTools.defaultFontPixelHeight
            anchors.centerIn:   parent
            columns: 4

            /*QGCLabel {
                text:           qsTr("Flight Modes")
                Layout.alignment:  Qt.AlignHCenter
            }*/

            Repeater {
                model:          activeVehicle ? activeVehicle.flightModes : [ ]
                QGCButton {
                    text:       modelData
                    Layout.minimumHeight:   ScreenTools.defaultFontPixelHeight * 1 //3
                    Layout.minimumWidth:    ScreenTools.defaultFontPixelWidth  * 20 //30
                    Layout.fillHeight:      true
                    Layout.fillWidth:       true
                    Layout.alignment:       Qt.AlignHCenter
                    onClicked: {
                        activeVehicle.flightMode = modelData
                        flightModesMenu.close()
                    }
                }
            }
        }
    }
}
