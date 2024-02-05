#pragma once

#include "../model_object.hpp"
#include "../../vector3.hpp"

class Defect : public ModelObject {
public:
    int size;
    Vector3<double> position;
};