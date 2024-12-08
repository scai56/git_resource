# set some stuff (machine type, current directory, source directory)
ARCH   = $(shell uname -m)
CURDIR = $(shell pwd)
SRCDIR = $(CURDIR)/SRC


ifeq ($(ARCH),x86_64) # host is 64 Bit Machine
   OBJDIR = ../OBJ
   ODIR = ../64b
   F77  = ifort
   CC   = cc
   INC     = include -Iinclude/eigenes -I/opt/intel/composer_xe_2013.1.117/mkl/include
   FOPT = -O2 -i8
   COPT = -O2
   LOPT = -L/opt/intel/mkl/lib/intel64 -lmkl_intel_ilp64 -lmkl_core -lmkl_intel_thread -lpthread -openmp -lm -ljpeg
   XLIB = -L/usr/X11R6/lib64 -lX11
# specify all directories to consider
SRCDIRS = elements/frame elements/material elements/material/finite \
          elements/material/small elements/shells elements/solid1d \
          elements/solid2d elements/solid3d elements/thermal \
          elements/couple3d main plot program \
          unix unix/jpeg unix/largemem user \
          contact/main contact/ntrnd contact/nts2d contact/nts3d \
          contact/ptpnd contact/tie2d contact/util \
          eigenes eigenes/ovtk
endif

# consider all files
SRCf   = $(foreach dir,$(SRCDIRS),$(wildcard $(dir)/*.f))
SRCc   = $(foreach dir,$(SRCDIRS),$(wildcard $(dir)/*.c))

OBJsrcf := $(addprefix $(OBJDIR)/, $(SRCf:.f=.o))
OBJsrcc := $(addprefix $(OBJDIR)/, $(SRCc:.c=.o))

feap:   $(OBJsrcf) $(OBJsrcc)
	$(F77)  -o ../$@ $(XLIB) $(ODIR)/*.o $(LOPT)

# dependencies
.SUFFIXES: .f .c

$(OBJDIR)/%.o: %.f
	$(F77) -c $(FOPT) -I$(INC) $< -o $@ 
	(cp $@ $(ODIR))
$(OBJDIR)/%.o: %.c
	$(CC)  -c $(COPT) -I$(INC) $< -o $@ 
	(cp $@ $(ODIR))

