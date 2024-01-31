#include "model.hpp"
#include "event.hpp"

Model::Model() {
    parameters = new ModelParameters();
}


void Model::init() {
    for (Event *event: events) {
        event->init(this);
    }
}
