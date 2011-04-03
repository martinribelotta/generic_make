LIBDIRS := $(foreach l,$(libpath),-L$l)
LIBS := $(foreach l,$(libraries),-l$l)
HEADERS := $(foreach l,$(incpath),-I$l)
OBJECTS := $(source:%.cpp=%.o)
DEPFILES := $(source:%.cpp=%.P)

include config.mk

.PHONY: all clean

all: $(target)

%.o: %.cpp
	@echo "** compiling $<..."
	@$(CXX) -MD $(HEADERS) -c $(CXXFLAGS) $< -o $@
	@-cp $*.d $*.P; \
		sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
			-e '/^$$/ d' -e 's/$$/ :/' < $*.d >> $*.P; \
		rm -f $*.d

-include $(DEPFILES)

$(target): $(OBJECTS)
	@echo "** buliding target $(target)"
	@$(LDXX) $(LDXXFLAGS) -o $(target) $(OBJECTS) $(LIBDIRS) $(LIBS)

clean:
	@echo "** clean"
	@$(RM) $(DEPFILES)
	@$(RM) $(OBJECTS)
	@$(RM) $(target)
