/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "CustomBattery.h"
#include <QQuickView>
#include <QtMath>
QGC_LOGGING_CATEGORY(CustomBatteryLog, "CustomBatteryLog")

static const char* kGroupName       = "CustomBatterySettings";
static const char* kCellNumber      = "cellNumber";
static const char* kshowFeatures      = "showFeatures";
static const char* kFeatures      = "Features";



//-----------------------------------------------------------------------------
CustomBattery::CustomBattery(QObject* parent)
    : QObject(parent)
{

    qCDebug(CustomBatteryLog) << "Creating CustomBattery instance";
    QSettings settings;
    settings.beginGroup(kGroupName);
    _CellNumber = settings.value(kCellNumber, 1).toInt();
    _showFeatures= settings.value(kshowFeatures,0).toBool();
    _features= settings.value(kshowFeatures,0).toBool();
    _averageInd=0;
    _lastTime=0;

}

//-----------------------------------------------------------------------------
CustomBattery::~CustomBattery()
{

}


//-----------------------------------------------------------------------------

void CustomBattery::setvehicle(Vehicle *set)
{
    if(_vehicle!=set){
        _vehicle=set;
        emit vehicleChanged();

    }
}

//-----------------------------------------------------------------------------

void CustomBattery::setbatt(VehicleBatteryFactGroup* set)
{
    if(_batt!=set){
        _batt=set;
        emit battChanged();


    }
}

//-----------------------------------------------------------------------------

void CustomBattery::setShowFeatures(bool set){
    if (_showFeatures!=set){
        _showFeatures=set;
        QSettings settings;
        settings.beginGroup(kGroupName);
        settings.setValue(kshowFeatures,set);
        emit showFeaturesChanged();
     }

}


//-----------------------------------------------------------------------------

void CustomBattery::setCellNumber(int set){

    if (_CellNumber!=set && set > 1){
        _CellNumber=set;
        QSettings settings;
        settings.beginGroup(kGroupName);
        settings.setValue(kCellNumber,set);
        emit cellNumberChanged();
    }
}

void CustomBattery::setFeatures(int set){
    if (_features!=set ){
        _features=set;
        QSettings settings;
        settings.beginGroup(kGroupName);
        settings.setValue(kFeatures,set);
        _features>0 ? setShowFeatures(true): setShowFeatures(false);

        emit cellNumberChanged();
    }

}

//-----------------------------------------------------------------------------

void CustomBattery::setCellCapacity(int set){

    if (CellCapacity!=set && set > 0){
        CellCapacity=set;
        emit cellCapacityChanged();
    }

}


//-----------------------------------------------------------------------------

double CustomBattery::timeEstimate()
{

    double current,mahConsumed,ibat,k;
    double time=0;

    if ( _batt==nullptr || CellCapacity<=0) {
        return -1;
    }
    mahConsumed =_batt->mahConsumed()->rawValue().toDouble();

    current= _batt->current()->rawValue().toDouble();


    ibat=(CellCapacity-mahConsumed)*20;
    k=(60/20);

        if (current>0 && mahConsumed>0){
            // Average current
            if (_averageInd>2){
                _lastCurrent=_lastCurrent/(_averageInd);
                time=((ibat/(_lastCurrent*1000))*k)*60;
               // time=((ibat/(current*1000))*k)*60;
                _lastTime=time;
                 emit timeEstimateChanged();
                _averageInd=_lastCurrent=0;
            }else{
                _lastCurrent=_lastCurrent+current;
                _averageInd++;
            }

            if (_lastTime>0){
                return _lastTime;
            }else{
                return 0;
            }

        }else
        {
            emit timeEstimateChanged();
            return -1;
        }



}


//-----------------------------------------------------------------------------

double CustomBattery::cellVoltage(){
     double voltage;

    if (_batt){
          voltage=_batt->voltage()->rawValue().toDouble();
          if (voltage>LIPOMIM && _CellNumber>0){

               double var=voltage/_CellNumber;
               int value = (int)(var * 100 );
               emit cellVoltageChanged();
               return (double)value / 100;

          }else
          {
              emit cellVoltageChanged();
              return -1;
          }

    }else{
        return  -1;
    }







}

//-----------------------------------------------------------------------------

int CustomBattery::levelEstimate(){

    _CellVoltage=cellVoltage();
    _estimateLevel=0;
        if (_CellVoltage>0){

            _estimateLevel=level(_CellVoltage*1000,3000,4200,&asigmoidal);
            emit estimateLevelChanged();

        }
        return  _estimateLevel;

}


//-----------------------------------------------------------------------------

uint8_t CustomBattery::level(uint16_t voltage,uint16_t minVoltage, uint16_t maxVoltage,mapFn_t mapFunction) {
    if (voltage <= minVoltage) {
        return 0;
    } else if (voltage >= maxVoltage) {
        return 100;
    } else {
        return (*mapFunction)(voltage, minVoltage, maxVoltage);
    }
}



