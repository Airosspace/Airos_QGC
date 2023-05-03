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

import QtQuick                              2.11
import QtQuick.Controls                     1.4
import QtQuick.Layouts                      1.11

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.Vehicle               1.0

import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0
import QGroundControl.CustomBattery         1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0



//-------------------------------------------------------
//-- Battery Indicator
Item {
    id:                     _root
    width:                  batteryIndicatorRow.width
    anchors.top:            parent.top
    anchors.bottom:         parent.bottom

    property var    battery1:           activeVehicle ? activeVehicle.battery  : null
    property var    battery2:           activeVehicle ? activeVehicle.battery2 : null
    property bool   hasSecondBattery:   battery2 && battery2.voltage.value !== -1
    property bool   batteryFeatures
    property var    _cellModel:      ["1cell","2Cell","3Cell","4Cell","5Cell","6Cell"]
    property var    _featModel:      ["APM","Lipo","LiHV"]
    property bool  batt1ParamsAvailable
    property bool  batt2ParamsAvailable
    property Fact battCapacity

    Connections {
        target: QGroundControl.multiVehicleManager.activeVehicle
        onConnectionLostChanged: {

        }
        onActiveChanged: {
            checkBatteryParameter()

        }


    }
    FactPanelController {
        id:         controller
    }

//-------------------------------------------------------------------
// Looking for the lowestBattery
    function lowestBattery() {
        if(activeVehicle) {
            if(hasSecondBattery) {
                if(activeVehicle.battery2.percentRemaining.value < activeVehicle.battery.percentRemaining.value) {
                    return activeVehicle.battery2
                }
            }
            return activeVehicle.battery
        }
        return null
    }

//-----------------------------------------------------------------------
    function getBatteryColor(battery) {
        if(battery) {
            var _temp=qgcPal.colorGrey
            if(battery.percentRemaining.value >= 70) {
                _temp= qgcPal.colorGreen
            }
            if(battery.percentRemaining.value < 70 && battery.percentRemaining.value > 30) {
                _temp= qgcPal.colorOrange
            }
            if(battery.percentRemaining.value <=30) {
                _temp= qgcPal.colorRed
            }
        }
        return _temp
    }

//--------------------------------------------------------------------
    function getAdvBatteryColor() {
        var _temp=qgcPal.colorGrey
        if(CustomBattery.batt) {
            if(CustomBattery.levelEstimate >= 70) {
                _temp=qgcPal.colorGreen
            }
            if(CustomBattery.levelEstimate < 70 && CustomBattery.levelEstimate > 30) {
                _temp=qgcPal.colorOrange
            }
            if(CustomBattery.levelEstimate <=30) {
                _temp= qgcPal.colorRed
            }
        }
        return _temp
    }

//---------------------------------------------------------------------
    function getBatteryPercentageText(battery) {
        var _temp="N/A"
        if(battery1) {
            if(battery.percentRemaining.value > 98.9) {
                _temp= "100%"
            }
            if(battery.percentRemaining.value > 0.1) {
                _temp= battery1.percentRemaining.valueString + battery.percentRemaining.units
            }
            if(battery.voltage.value >= 0) {
                _temp= battery1.voltage.valueString + battery.voltage.units
            }
        }
        return _temp
    }

//---------------------------------------------------------------------
    function cellLevel(battery){
        var _temp="Na"
         if (battery.voltage.value >=0 ){
             CustomBattery.batt=battery;
             // To fix: no cellCount ??
             // CustomBattery.cellNumber= activeVehicle.battery ? activeVehicle.battery.cellCount.value : 0
             _temp=CustomBattery.levelEstimate + "%"

         }
         return _temp

    }
//---------------------------------------------------------------------
    function cellVoltage(battery){
        var _temp="Na"
         if (battery.voltage.value >=0){
             CustomBattery.batt=battery;
             checkBatteryParameter()
             // To fix: no cellCount ??
             //CustomBattery.cellNumber= activeVehicle.battery ? activeVehicle.battery.cellCount.value : 0
             var _num=Number(CustomBattery.cellVoltage).toFixed(2)
             _temp=_num + battery1.voltage.units

         }
         return _temp

    }

//---------------------------------------------------------------------

    function checkBatteryParameter(){

        batt1ParamsAvailable= controller.parameterExists(-1, "BATT_CAPACITY")
        batt2ParamsAvailable=controller.parameterExists(-1, "BATT2_CAPACITY")
        if (batt1ParamsAvailable){
            battCapacity= controller.getParameterFact(-1, "BATT_CAPACITY", false /* reportMissing */)
        }

        if (battCapacity){ CustomBattery.cellCapacity=battCapacity.value }

    }


    //---------------------------------------------------------------------
        function consumedMha(battery){
            var _temp="Na"
             if (battery && battery.mahConsumed.value !== -1){
                 CustomBattery.batt=battery;
                 checkBatteryParameter()
                 // To fix: ano cellCount ??
                 //CustomBattery.cellNumber= activeVehicle.battery ? activeVehicle.battery.cellCount.value : 0
                 _temp=battery.mahConsumed.valueString + " " + battery.mahConsumed.units

             }
             return _temp

        }



    // Popup window show Battery info
    Component {
        id: batteryInfo



        Rectangle {
            width:  battCol.width   + ScreenTools.defaultFontPixelWidth  * 3//3
            height: battCol.height  + ScreenTools.defaultFontPixelHeight * 3//2
            radius: ScreenTools.defaultFontPixelHeight * 0.5
            color:  qgcPal.window
            border.color:   qgcPal.text

            Column {
                id:                 battCol
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                width:              Math.max(battGrid.width, battLabel.width)
                //anchors.margins:    ScreenTools.defaultFontPixelHeight
                anchors.horizontalCenter: parent
                anchors.centerIn:   parent

                QGCLabel {
                    id:             battLabel
                    text:           qsTr("Battery Status")
                    font.family:    ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter: parent.horizontalCenter

                }

                GridLayout {
                    id:                 battGrid
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    rowSpacing:         ScreenTools.defaultFontPixelWidth*2
                    columns:            6
                    //anchors.horizontalCenter: parent.horizontalCenter

                    QGCLabel {
                        id:             batteryLabel
                        text:           qsTr("Battery 1")
                        Layout.alignment: Qt.AlignVCenter
                    }
                    Repeater{
                        model: 1// getCellCount()
                        QGCColoredImage {
                            height:         batteryLabel.height
                            width:          height
                            sourceSize.width:   width
                            source:         "/qmlimages/Battery.svg"
                            color:         qgcPal.text
                            fillMode:       Image.PreserveAspectFit
                            /*Rectangle {
                                color:              getBatteryColor(activeVehicle ? activeVehicle.battery : null)
                                anchors.left:       parent.left
                                anchors.leftMargin: ScreenTools.defaultFontPixelWidth * 0.125
                                height:             parent.height * 0.35
                                width:              activeVehicle ? (activeVehicle.battery.percentRemaining.value / 100) * parent.width * 0.875 : 0
                                anchors.verticalCenter: parent.verticalCenter
                            }*/
                    }

                    }

                    QGCLabel { text: qsTr("Voltage:") }
                    QGCLabel { text: (battery1 && battery1.voltage.value !== -1) ? (battery1.voltage.valueString + " " + battery1.voltage.units) : "N/A" }
                    QGCLabel { text: qsTr("Accumulated Consumption:") }
                    QGCLabel { text: (battery1 && battery1.mahConsumed.value !== -1) ? (battery1.mahConsumed.valueString + " " + battery1.mahConsumed.units) : "N/A" }
                    QGCLabel { text: qsTr("Current:") }
                    QGCLabel { text: (battery1 && battery1.current.value !== -1) ? (battery1.current.valueString + " " + battery1.current.units) : "N/A" }
                    QGCLabel { text: qsTr("Instant Power:") }
                    QGCLabel { text: (battery1 && battery1.instantPower.value !== -1) ? (battery1.instantPower.valueString + " " + battery1.instantPower.units) : "N/A" }

                    QGCLabel { text: qsTr("Cell override Batt1:") }

                    QGCComboBox {
                        id: comboCell
                        font.pointSize:         ScreenTools.mediumFontPointSize
                        currentIndex:           CustomBattery.cellNumber-1
                        sizeToContents:         true
                        model:                  _cellModel


                        onCurrentIndexChanged:{
                            CustomBattery.cellNumber=currentIndex+1

                     }

                    }

                    QGCLabel { text: qsTr("Cell capacity:") }
                    QGCLabel {text:battCapacity ?  battCapacity.valueString + battCapacity.units: "N/A" }

                    QGCLabel { text: qsTr("Advanced")}
                    QGCComboBox {
                        id: comboAdv
                        font.pointSize:         ScreenTools.mediumFontPointSize
                        currentIndex:           CustomBattery.features
                        sizeToContents:         true
                        model:                  _featModel


                        onCurrentIndexChanged:{
                            CustomBattery.features=currentIndex

                     }

                    }


                    // Secondary battery
                    Item {
                        width:  1
                        height: 1
                        visible: hasSecondBattery;
                        Layout.columnSpan: 2
                    }

                    QGCLabel {
                        text:           qsTr("Battery 2")
                        visible:        hasSecondBattery
                        Layout.alignment: Qt.AlignVCenter
                    }
                    QGCColoredImage {
                        height:         batteryLabel.height
                        width:          height
                        sourceSize.width:   width
                        source:         "/qmlimages/Battery.svg"
                        color:          qgcPal.text
                        visible:        hasSecondBattery
                        fillMode:       Image.PreserveAspectFit
                        Rectangle {
                            color:              getBatteryColor(activeVehicle ? activeVehicle.battery2 : null)
                            anchors.left:       parent.left
                            anchors.leftMargin: ScreenTools.defaultFontPixelWidth * 0.125
                            height:             parent.height * 0.35
                            width:              activeVehicle ? (activeVehicle.battery2.percentRemaining.value / 100) * parent.width * 0.875 : 0
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    QGCLabel { text: qsTr("Voltage:"); visible: hasSecondBattery; }
                    QGCLabel { text: (battery2 && battery2.voltage.value !== -1) ? (battery2.voltage.valueString + " " + battery2.voltage.units) : "N/A";  visible: hasSecondBattery; }
                    QGCLabel { text: qsTr("Accumulated Consumption:"); visible: hasSecondBattery; }
                    QGCLabel { text: (battery2 && battery2.mahConsumed.value !== -1) ? (battery2.mahConsumed.valueString + " " + battery2.mahConsumed.units) : "N/A"; visible: hasSecondBattery; }

                }
            }
        }
    }

    // Toolbar Icon
    Row {
        id:             batteryIndicatorRow
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        anchors.left:     parent.left
        opacity:        (activeVehicle && activeVehicle.battery.voltage.value >= 0) ? 1 : 0.5
        spacing:        ScreenTools.defaultFontPixelWidth
        QGCColoredImage {
            id:                 imagePercent
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            width:              height
            sourceSize.width:   width
            source:             "/qmlimages/Battery.svg"
            color:              CustomBattery.showFeatures? getAdvBatteryColor(): getBatteryColor(activeVehicle ? activeVehicle.battery : null)//qgcPal.text
            fillMode:           Image.PreserveAspectFit

        }
        QGCLabel {
            id:                     percentage
            text:                   getBatteryPercentageText(lowestBattery())
            font.pointSize:         ScreenTools.mediumFontPointSize
            color:                  imagePercent.color
            anchors.top:            parent.top
            visible:                CustomBattery.showFeatures? false:true
        }
        QGCLabel {
            id:                     labelLevel
            text:                   cellLevel(battery1)
            font.pointSize:         ScreenTools.mediumFontPointSize
            color:                  imagePercent.color
            anchors.top:            parent.top
            visible:                CustomBattery.showFeatures
        }

        QGCLabel {
            text:                   cellVoltage(battery1)
            font.pointSize:         ScreenTools.mediumFontPointSize
            font.capitalization: Font.AllUppercase
            color:                  labelLevel.color
            anchors.top:             parent.top
            visible:                CustomBattery.showFeatures
        }
        QGCLabel {
            text:                   consumedMha(battery1)
            font.pointSize:         ScreenTools.mediumFontPointSize
            color:                  labelLevel.color
            anchors.top:            parent.top
            visible:                true
        }



        onPositioningComplete:{
            if (activeVehicle){
                checkBatteryParameter()
            }
        }



    }

    MouseArea {
        anchors.fill:   parent
        onClicked: {
            checkBatteryParameter()
            mainWindow.showPopUp(_root, batteryInfo)
        }
    }
}
