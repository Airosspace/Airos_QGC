#pragma once

#include <QObject>
#include <QVector>
#include <QPointF>
#include "FactGroup.h"
#include "QGCMAVLink.h"
#include "Vehicle.h"


struct orientation2Fact_s {
    MAV_SENSOR_ORIENTATION  orientation;
    unsigned short          distance;
    unsigned short          minDistance;
    unsigned short          maxDistance;


};


class VehicleObjectApmAvoidance : public QObject
{
    Q_OBJECT
public:
    VehicleObjectApmAvoidance(Vehicle* vehicle, QObject* parent = nullptr);

    Q_PROPERTY(int  size READ size NOTIFY objectAvoidanceApmChanged  )


    void update(mavlink_distance_sensor_t* message );
    int  size    () { return _vector.count(); }


    Q_INVOKABLE unsigned short   distance(int i);
    Q_INVOKABLE unsigned short   minDistance(int i);
    Q_INVOKABLE unsigned short   maxDistance(int i);
    Q_INVOKABLE unsigned short   orientation(int i);

    Q_INVOKABLE short   level(int i);


signals:
    void            objectAvoidanceApmChanged  ();

private:
    Vehicle*        _vehicle        = nullptr;
    orientation2Fact_s _proximity[9];
    QList<orientation2Fact_s> _vector;
    size_t cntMax;





};
