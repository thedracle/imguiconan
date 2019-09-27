CXX := clang++
CXXFLAGS := -Werror -std=c++14 -g
all: build

-include conanbuildinfo.mak
CXXFLAGS+=$(CONAN_CXXFLAGS) -fvisibility=hidden -fvisibility-inlines-hidden
CXXFLAGS+=$(addprefix -I, $(CONAN_INCLUDE_DIRS))
CXXFLAGS+=$(addprefix -D, $(CONAN_DEFINES)) $(EXTRAFLAGS)
LDFLAGS+=$(addprefix -L, $(CONAN_LIB_DIRS))
LDLIBS+=$(addprefix -l, $(CONAN_LIBS))

srcfiles := $(shell find src -name "*.cpp")
srcfiles += $(shell find imgui -name "*.cpp")
objects  := $(patsubst %.cpp, %.o, $(srcfiles))

build: $(objects)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o bin/testimgui -rdynamic $(objects) $(LDLIBS)

depend: .depend

.depend: $(srcfiles)
	rm -f ./.depend
	$(CXX) $(CXXFLAGS) -MM $^>>./.depend

conanbuildinfo.mak:
	bash -c "./bin/install_conan.sh"

deps: conanbuildinfo.mak

clean:
	rm -f $(objects)

dist-clean: clean
	rm -f *~ .depend

include .depend
