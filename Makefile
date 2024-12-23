####################################################################
#                                                                  #
#                        Main Package Makefile                     #
#                                                                  #
####################################################################


####################################################################
#                                                                  #
#                      PACKAGE EXECUTABLE NAME                     #
#                                                                  #
####################################################################
export PKG_BIN_NAME := taxCalculator


####################################################################
#                                                                  #
#                      PROJECT FOLDER STRUCTURE                    #
#                                                                  #
####################################################################
# source base dir relative to main makefile
export PATH_SRC   := src/
export PATH_TEST  := test/

PATH_BUILD := build/
PATH_BIN   := $(PATH_BUILD)release/
PATH_ObJ   := $(PATH_BUILD)release/objs/
PATH_DEP   := $(PATH_BUILD)release/depends/

# Debug target folders
ifeq ($(strip $(CGC_BUILD_GDEBUG)),y)
PATH_BIN   := $(PATH_BUILD)debug/
PATH_ObJ   := $(PATH_BUILD)debug/objs/
PATH_DEP   := $(PATH_BUILD)debug/depends/
endif

export BUILD_PATHS := $(PATH_BIN) $(PATH_DEP) $(PATH_ObJ)


####################################################################
#                                                                  #
#                       PACKAGE SOURCE FILES                       #
#                                                                  #
####################################################################
# List here all C and CPP files that contribute to build.
# Uses relative path to this Makefile folder.
export PKG_SRCS_C   :=
export PKG_SRCS_CPP :=


export PKG_SRCS_CPP := \
	taxCalculatorConfiguratorMain.cpp \
	application/TaxCalculator.cpp \
	adapters/FixedTaxRateRepository.cpp

####################################################################
#                                                                  #
#                               DEBUG                              #
#                                                                  #
####################################################################
ifeq ($(strip $(BUILD_GDEBUG)),y)
	CFLAGS += -DGDEBUG
endif

ifeq ($(findstring test,$(MAKECMDGOALS)),test)
	export BUILD_UNITTEST:=y
endif


####################################################################
#                                                                  #
#                      PACKAGE LOCAL DEFINES                       #
#                                                                  #
####################################################################
PKG_LOCAL_CFLAGS := \
	-Werror \
	-fstack-protector-strong -O2 -D_FORTIFY_SOURCE=2 \
	-Wformat -Wformat-security -Werror=format-security




####################################################################
#                                                                  #
#                      PACKAGE INCLUDES AND LIBS                   #
#                                                                  #
####################################################################
export PKG_INCLUDE := \
	-I$(PATH_SRC) \
	-I$(PATH_SRC)include

export PKG_LIB := \
	-lpthread -lm -lrt -ldl

# Flag da passare al linker
export LDFLAGS := \
	$(PKG_LIB)


# Lists all single object targets from C  and CPP sources
PKG_OBJ_C   := $(patsubst %.c,$(PATH_ObJ)%.o,$(PKG_SRCS_C) )
PKG_OBJ_CPP := $(patsubst %.cpp,$(PATH_ObJ)%.o,$(PKG_SRCS_CPP) )

OBJ := $(PKG_OBJ_C) $(PKG_OBJ_CPP)

# Lists all single dependency targets from C  and CPP sources
PKG_DEP_C   := $(patsubst %.c,$(PATH_DEP)%.dep,$(PKG_SRCS_C) )
PKG_DEP_CPP := $(patsubst %.cpp,$(PATH_DEP)%.dep,$(PKG_SRCS_CPP) )

DEP = $(PKG_DEP_C) $(PKG_DEP_CPP)



####################################################################
#                                                                  #
#                      COMPILE AND LINK COMMANDS                   #
#                                                                  #
####################################################################
ifeq ($(strip $(PKG_OBJ_CPP)),)
export LINK := $(CC) $(LDFLAGS)
else
export LINK := $(CXX) $(LDFLAGS)
endif

export COMPILE_FLAGS 	:= \
	-MMD -MP $(CFLAGS) $(PKG_LOCAL_CFLAGS) $(PKG_INCLUDE)

export COMPILE_CPP_FLAGS := \
	-MMD -MP $(CFLAGS) -felide-constructors -Wno-psabi \
	$(PKG_LOCAL_CFLAGS) $(PKG_INCLUDE)

export MKDIR   := mkdir -p
export CLEANUP := rm -rf
export INSTALL := cp -au


####################################################################
#                                                                  #
#                            MAKE TARGETS                          #
#                                                                  #
####################################################################
# Follows the magic make variables taht do the job:
# out.o: src.c src.h
#  $@   # "out.o" (target)
#  $<   # "src.c" (first prerequisite)
#  $^   # "src.c src.h" (all prerequisites)#
#
#%.o: %.c
#  $*   # the 'stem' with which an implicit rule matches ("foo" in "foo.c")
#
#also:
#  $+   # prerequisites (all, with duplication)
#  $?   # prerequisites (new ones)
#  $|   # prerequisites (order-only?)
#
#  $(@D) # target directory


all: $(BUILD_PATHS) $(PATH_BIN)$(PKG_BIN_NAME)


# Links all objects in the executable
$(PATH_BIN)$(PKG_BIN_NAME): $(OBJ)
	$(LINK) $(OBJ) -o $@


# Automatic Rules to Build sources .c .cpp in .o objects
# '-c' Flag tell compiler to not do the final link.

# Compiles Package C and CPP sources in the
# relevant objects and create dependencies
$(PATH_ObJ)%.o::$(PATH_SRC)%.c
	@mkdir -p $(PATH_ObJ)$(dir $* )
	@mkdir -p $(PATH_DEP)$(dir $* )
	$(CC) -c $< -o $@ -MF $(PATH_DEP)$*.dep $(COMPILE_FLAGS)

$(PATH_ObJ)%.o::$(PATH_SRC)%.cpp
	@mkdir -p $(PATH_ObJ)$(dir $* )
	@mkdir -p $(PATH_DEP)$(dir $* )
	$(CXX) -c $< -o $@ -MF $(PATH_DEP)$*.dep $(COMPILE_CPP_FLAGS)


# Create build target forlders if did not exists
$(PATH_BIN):
	$(MKDIR) $(PATH_BIN)
	
$(PATH_ObJ):
	$(MKDIR) $(PATH_ObJ)

$(PATH_DEP):
	$(MKDIR) $(PATH_DEP)


#expand here the dependence targets
-include $(DEP)

test_build:
	@ $(MAKE) --no-print-directory -f $(PATH_TEST)Makefile  \
	CFLAGS="$(CFLAGS) $(PKG_LOCAL_CFLAGS)"

test_run: test_build
	@ $(MAKE) --no-print-directory -f $(PATH_TEST)Makefile test_run

test_clean:
	@ $(MAKE) --no-print-directory -f test/Makefile test_clean"

install:
	$(INSTALL) $(PATH_BIN)$(PKG_BIN_NAME) $(INSTALL_DIR)/$(CGC_BIN)/.

clean:
	$(CLEANUP) $(PATH_BIN)$(PKG_BIN_NAME)
	$(CLEANUP) $(PATH_ObJ)*
	$(CLEANUP) $(PATH_DEP)*

clean_all:
	$(CLEANUP) $(PATH_BUILD)*



# These files are precious... do not delete while building
.PRECIOUS: $(PATH_BIN)$(PKG_BIN_NAME)
.PRECIOUS: $(PATH_ObJ)%.o
.PRECIOUS: $(PATH_DEP)%.dep


# These are virtual targets don't create them
.PHONY : all
.PHONY: test_build
.PHONY: test_run
.PHONY: test_clean
.PHONY: install
.PHONY: clean
.PHONY: clean_all


####################################################################
#                                                                  #
#                          SET THREAD NUMBER                       #
#                          FOR PARALLEL MAKE                       #
#                                                                  #
####################################################################
# Tento di determinare il numero di CPU
NUM_CPUS = $(shell lscpu | grep "CPU(s):" | grep -v "NUMA" | sed 's/CPU(s): *//')
THREADS_PER_CORE = $(shell lscpu | grep "Thread(s)" | sed 's/Thread(s) per core: *//')
# Calcolo il numero di core da utilizzare
ifneq ($(strip $(NO_AUTO_CORES)),y)
export USED_CORES = $(shell echo $(NUM_CPUS)*$(THREADS_PER_CORE)-2 | bc)
else
export USED_CORES = 1
endif
# Imposto il numero di core utilizzati
ifneq ($(strip $(USED_CORES)),)
export	MAKEFLAGS += -j$(USED_CORES)
endif


