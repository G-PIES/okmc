COMPILER      = clang
CONFIGURATION = debug

SRC_PATH      := ./src
BUILD_PATH    := ./build/$(CONFIGURATION)-$(COMPILER)
OBJ_PATH      := $(BUILD_PATH)/obj
EXE           := $(BUILD_PATH)/okmc

CXX_FILES := $(sort $(shell find $(SRC_PATH) -type f -name '*.cpp'))
OBJ_FILES := $(CXX_FILES:$(SRC_PATH)/%.cpp=$(OBJ_PATH)/%.o)
DEP_FILES := $(CXX_FILES:$(SRC_PATH)/%.cpp=$(OBJ_PATH)/%.d)
OBJ_DIRS  := $(sort $(dir $(OBJ_FILES)))

CXXFLAGS := -MMD -MP -Wall -std=c++17
LDFLAGS  :=

CXXFLAGS.debug   := -Og -fsanitize=undefined -fsanitize=address
CXXFLAGS.release := -O3
LDFLAGS.debug    := -Og -fsanitize=undefined -fsanitize=address
LDFLAGS.release  := -O3

CXX.clang := clang++
LD.clang  := clang++
CXXFLAGS.clang         :=
CXXFLAGS.debug.clang   :=
CXXFLAGS.release.clang :=
LDFLAGS.clang          :=
LDFLAGS.debug.clang    :=
LDFLAGS.release.clang  :=

CXX.gcc   := g++
LD.gcc    := g++
CXXFLAGS.gcc         :=
CXXFLAGS.debug.gcc   :=
CXXFLAGS.release.gcc :=
LDFLAGS.gcc          :=
LDFLAGS.debug.gcc    :=
LDFLAGS.release.gcc  :=

CXXFLAGS := $(strip $(CXXFLAGS) $(CXXFLAGS.$(CONFIGURATION)) $(CXXFLAGS.$(COMPILER)) $(CXXFLAGS.$(CONFIGURATION).$(COMPILER)))
LDFLAGS  := $(strip $(LDFLAGS) $(LDFLAGS.$(CONFIGURATION)) $(LDFLAGS.$(COMPILER)) $(LDFLAGS.$(CONFIGURATION).$(COMPILER)))

CXX := $(CXX.$(COMPILER))
LD  := $(LD.$(COMPILER))

clean:
	rm -rf $(BUILD_PATH)

all: $(EXE)

$(EXE): $(OBJ_DIRS) $(OBJ_FILES)
	$(LD) $(LDFLAGS) $(OBJ_FILES) -o $(EXE)

$(OBJ_DIRS):
	mkdir -p $(OBJ_DIRS)

$(OBJ_FILES): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

-include $(DEP_FILES)