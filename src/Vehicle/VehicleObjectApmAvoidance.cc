/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleObjectApmAvoidance.h"

VehicleObjectApmAvoidance::VehicleObjectApmAvoidance(Vehicle* vehicle, QObject* parent)
    : QObject(parent)
    , _vehicle(vehicle)
{

    _proximity[0] = { MAV_SENSOR_ROTATION_NONE,         0,0,0};
    _proximity[1] = { MAV_SENSOR_ROTATION_YAW_45,       0,0,0 };
    _proximity[2] = { MAV_SENSOR_ROTATION_YAW_90,       0,0,0 };
    _proximity[3] = { MAV_SENSOR_ROTATION_YAW_135,      0,0,0 };
    _proximity[4] = { MAV_SENSOR_ROTATION_YAW_180,      0,0,0 };
    _proximity[5] = { MAV_SENSOR_ROTATION_YAW_225,      0,0,0 };
    _proximity[6] = { MAV_SENSOR_ROTATION_YAW_270,      0,0,0 };
    _proximity[7] = { MAV_SENSOR_ROTATION_YAW_315,      0,0,0 };
  //  _proximity[8] = { MAV_SENSOR_ROTATION_PITCH_90,     0,0,0 };
     _proximity[8] = { MAV_SENSOR_ROTATION_PITCH_270,    0,0,0 };
     cntMax=0;


}

void VehicleObjectApmAvoidance::update(mavlink_distance_sensor_t* message)
{
        _vector.clear();
        for (size_t i=0; i<sizeof(_proximity)/sizeof(_proximity[0]); i++) {
        if (_proximity[i].orientation == message->orientation) {
            _proximity[i].distance=message->current_distance;
            _proximity[i].maxDistance=message->max_distance;
            _proximity[i].minDistance=message->min_distance;

            _vector.append(_proximity[i]);
               cntMax=i;
                emit objectAvoidanceApmChanged();
            }
        }
}


unsigned short
VehicleObjectApmAvoidance::distance(int i)
{
    if( _vector.count()>0 && i >= 1 && i<= 10) {
        return _vector[i-1].distance;
    }
    return 0;
}


unsigned short
VehicleObjectApmAvoidance::minDistance(int i)
{
    if( _vector.count()>0 && i >= 1 && i<= 10) {
        return _vector[i-1].minDistance;
    }
    return 0;
}


unsigned short
VehicleObjectApmAvoidance::maxDistance(int i)
{
    if( _vector.count()>0 && i >= 1 && i<= 10) {
        return _vector[i-1].maxDistance;
    }
    return 0;
}

unsigned short
VehicleObjectApmAvoidance::orientation(int i)
{
    if( _vector.count()>0 && i >= 1 && i<= 10) {
        return _vector[i-1].orientation;
    }
    return 0;
}

short
VehicleObjectApmAvoidance::level(int i)
{
    int _var;
    int level[3];

    if( _vector.count()>0 && i >= 1 && i<= 10) {

        if (_vector[i-1].maxDistance > _vector[i-1].minDistance){

            _var=_vector[i-1].maxDistance - _vector[i-1].minDistance;
            level[0]=_var/3;
            level[1]=_var/2;
            level[2]=_var/1;

            if (_vector[i-1].distance>=level[2]) return 4;
            if (_vector[i-1].distance<level[2] && _vector[i-1].distance>=level[1]) return 3;
            if (_vector[i-1].distance<level[1] && _vector[i-1].distance>=level[0]) return 2;
            if (_vector[i-1].distance<level[0]) return 1;


        }
      }
    return 0;

}

