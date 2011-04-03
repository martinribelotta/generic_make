LIBDIRS := $(foreach l,$(libpath),-L$l)
LIBS := $(foreach l,$(libraries),-l$l)
HEADERS := $(foreach l,$(incpath),-I$l)
OBJECTS := $(source:%.c=%.o)
DEPFILES := $(source:%.c=%.P)

include config.mk

.PHONY: all clean

all: $(target)

%.o: %.c
	@echo "** compiling $<..."
	@$(CC) -MD $(HEADERS) -c $(CFLAGS) $< -o $@
	@-cp $*.d $*.P; \
		sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
			-e '/^$$/ d' -e 's/$$/ :/' < $*.d >> $*.P; \
		rm -f $*.d

-include $(DEPFILES)

$(target): $(OBJECTS)
	@echo "** buliding target $(target)"
	@$(LD) $(LDFLAGS) -o $(target) $(OBJECTS) $(LIBDIRS) $(LIBS)

clean:
	@echo "** clean"
	@$(RM) $(DEPFILES)
	@$(RM) $(OBJECTS)
	@$(RM) $(target)
