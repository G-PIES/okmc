#pragma once

#include "../model_object.hpp"
#include "../../vector3.hpp"

class Defect : public ModelObject {
public:
    double size;
    Vector3<double> position;
};