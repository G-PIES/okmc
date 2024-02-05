#include <iomanip>
#include <iostream>
#include <numeric>
#include <sstream>

#include "../model/objects/defect.hpp"
#include "wolfram_mathematica_exporter.hpp"

void WolframMathematicaExporter::export_model(Model *model) {
    std::stringstream out;
    out << std::fixed << std::setprecision(10);

    std::vector<ModelObject *> objects = model->objects;
    int max_size = std::transform_reduce(
            objects.begin(),
            objects.end(),
            0,
            [](const int a, const int b) { return std::max(a, b); },
            [](ModelObject *object) { return static_cast<Defect *>(object)->size; });

    std::vector<Defect *> defects_by_size[max_size];
    for (ModelObject *object: objects) {
        Defect *defect = static_cast<Defect *>(object);
        defects_by_size[defect->size - 1].push_back(defect);
    }

    out << "AppendTo[Objects, {";
    for (int size = 1; size <= max_size; size++) {
        out << "{";
        bool is_first = true;
        for (Defect *defect: defects_by_size[size - 1]) {
            if (is_first) {
                is_first = false;
            } else {
                out << ",";
            }

            out << "{" << defect->position.x << "," << defect->position.y << "," << defect->position.z << "}";
        }
        out << "}";

        if (size != max_size) {
            out << ",";
        }
    }
    out << "}];" << std::endl;

    out << "AppendTo[PlotStyles, {";
    for (int size = 1; size <= max_size; size++) {
        out << "Directive[Red,PointSize[" << size * 0.01 << "]]";
        if (size != max_size) {
            out << ",";
        }
    }
    out << "}];" << std::endl;

    std::cout << out.str();
}
