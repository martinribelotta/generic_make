LIBDIRS := $(foreach l,$(libpath),-L$l)
LIBS := $(foreach l,$(libraries),-l$l)
OBJECTS := $(source:%.c=%.o)

include config.mk

.PHONY: all

all: $(target)

$(OBJECTS): %.o: %.cpp
	@echo $(CXX) -c $(CXXFLAGS) $< -o $@

$(target): $(OBJECTS)
	@echo $(LDXX) $(LDXXFLAGS) -o $(target) $(OBJECTS) $(LIBDIRS) $(LIBS)
