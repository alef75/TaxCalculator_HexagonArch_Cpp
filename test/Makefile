####################################################################
#                                                                  #
#                       UnitTest Package Makefile                  #
#                     DO not call this file directly               #
#              This is called by the main Package Makefile         #
#                     from the Source directory                    #
#                                                                  #
####################################################################


####################################################################
#                                                                  #
#                      PROJECT FOLDER STRUCTURE                    #
#                                                                  #
####################################################################
GTEST_BASE_DIR  := googletest
PATH_TESTDOUBLE := $(PATH_TEST)testDouble/

PATH_BUILD := build/
PATH_BIN   := $(PATH_BUILD)$(PATH_TEST)
PATH_ObJ   := $(PATH_BUILD)$(PATH_TEST)objs/
PATH_DEP   := $(PATH_BUILD)$(PATH_TEST)depends/


####################################################################
#                                                                  #
#                           UNITTEST RUNNER NAME                   #
#                                                                  #
####################################################################
RUNNER_NAME := testRunner$(PKG_BIN_NAME)
RUNNER_SRC  := $(PATH_TEST)$(RUNNER_NAME).c


####################################################################
#                                                                  #
#                            SOURCE FILES                          #
#                         PACKAGE and TEST                         #
#                                                                  #
####################################################################
TEST_FILE_SRC_C   := $(wildcard $(PATH_TEST)test*.c)
TEST_FILE_SRC_CPP := $(wildcard $(PATH_TEST)test*.cpp)
TEST_FILE_SRC_CPP += $(wildcard $(PATH_TEST)test*.cc)

TEST_FILE_SRC := $(TEST_FILE_SRC_C) $(TEST_FILE_SRC_CPP)

# Test implementation for code collaborators
# dummmy, stub, spy, mok, fake
TEST_DOUBLE_SRC_C   := $(wildcard $(PATH_TESTDOUBLE)test*.c)
TEST_DOUBLE_SRC_CPP := $(wildcard $(PATH_TESTDOUBLE)test*.cpp)
TEST_DOUBLE_SRC_CPP += $(wildcard $(PATH_TESTDOUBLE)test*.cc)

TEST_SRC_C   := $(TEST_DOUBLE_SRC_C) $(TEST_FILE_SRC_C)
TEST_SRC_CPP := $(TEST_DOUBLE_SRC_CPP) $(TEST_FILE_SRC_CPP)


BUILD_PATHS := $(PATH_BIN) $(PATH_DEP) $(PATH_ObJ)


# Creates all single object targets from sources, c and cpp
PKG_OBJ_C   := $(patsubst %.c,$(PATH_ObJ)%.o, $(PKG_SRCS_C) )
PKG_OBJ_CPP := $(patsubst %.cpp,$(PATH_ObJ)%.o,$(PKG_SRCS_CPP) )
PKG_OBJ     := $(PKG_OBJ_C) $(PKG_OBJ_CPP)

# Creates all single object targets from test sources, c and cpp
TEST_OBJ_C   := $(patsubst %.c,$(PATH_ObJ)%.o,$(notdir $(TEST_SRC_C) ))
TEST_OBJ_CPP := $(patsubst %.cpp,$(PATH_ObJ)%.o,$(notdir $(TEST_SRC_CPP) ))
TEST_OBJ     := $(TEST_OBJ_C) $(TEST_OBJ_CPP)



# Lists all single dependency targets from C and CPP sources
PKG_DEP_C   := $(patsubst %.c,$(PATH_DEP)%.dep,$(PKG_SRCS_C) )
PKG_DEP_CPP := $(patsubst %.cpp,$(PATH_DEP)%.dep,$(PKG_SRCS_CPP) )
PKG_DEP     := $(PKG_DEP_C) $(PKG_DEP_CPP)

# Lists all single dependency targets from C and CPP test sources
TEST_DEP_C   := $(patsubst %.c,$(PATH_DEP)%.dep,$(notdir $(TEST_SRC_C) ))
TEST_DEP_CPP := $(patsubst %.cpp,$(PATH_DEP)%.dep,$(notdir $(TEST_SRC_CPP) ))
TEST_DEP      := $(TEST_DEP_C) $(TEST_DEP_CPP)

DEP = $(PKG_DEP) $(TEST_DEP)




####################################################################
#                                                                  #
#                      COMPILE AND LINK COMMANDS                   #
#                                                                  #
####################################################################

# add gcc option for profiling and codecoverage
USER_PROF_FLAGS := -g -O0 -coverage -fprofile-abs-path

GTEST_LIBS = -lgtest -lgmock -lgtest_main -lgmock_main -lpthread

# additional build flags for test target
LOCAL_CFLAGS += -Wno-unused-function

ifeq ($(strip $(OBJ_CPP) $(TEST_OBJ_CPP)),)
LINK := $(CC)  $(LDFLAGS) -L$(GTEST_BASE_DIR)/build/lib -coverage
else
LINK := $(CXX) $(LDFLAGS) -L$(GTEST_BASE_DIR)/build/lib -coverage
endif

COMPILE_FLAGS := \
	-MMD -MP $(USER_PROF_FLAGS) \
	-DUNITTEST $(CFLAGS)  $(LOCAL_CFLAGS) $(PKG_INCLUDE) \
	-I$(PATH_TEST)/testDouble \
	-I$(GTEST_BASE_DIR)/googletest/include \
	-I$(GTEST_BASE_DIR)/googlemock/include

COMPILE_CPP_FLAGS := \
	-MMD -MP $(USER_PROF_FLAGS) \
	-DUNITTEST $(CFLAGS)  $(LOCAL_CFLAGS) $(PKG_INCLUDE) \
	-I$(PATH_TEST)/testDouble \
	-I$(GTEST_BASE_DIR)/googletest/include \
	-I$(GTEST_BASE_DIR)/googlemock/include



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


test_build: $(BUILD_PATHS) $(PATH_BIN)$(RUNNER_NAME)

.NOTPARALLEL: $(GTEST_BASE_DIR)

$(GTEST_BASE_DIR):
	git clone https://github.com/google/googletest.git

#libgmock.a  libgmock_main.a  libgtest.a  libgtest_main.a
GTESTLIB = $(GTEST_BASE_DIR)/build/lib/libgtest.a

$(GTESTLIB): $(GTEST_BASE_DIR)
	mkdir -p $(GTEST_BASE_DIR)/build/lib
	cd $(GTEST_BASE_DIR)/build; \
	CFLAGS="" ; \
	cmake ../; \
	make -j $(USED_CORES)


LIB_PRODUCTION := $(PATH_ObJ)libproduction.a
# Build production PKG as static library
# this way production symbols will be overridden by relevant test double symbols
$(LIB_PRODUCTION): $(PKG_OBJ)
	$(AR) rcs $@ $^

# Link Objects to build the test runner executable
# put production PKG lib in last position for for letting liker to use test symbols in first place
$(PATH_BIN)$(RUNNER_NAME): $(GTESTLIB) $(TEST_OBJ) $(LIB_PRODUCTION)
	$(LINK) $(TEST_OBJ) $(PKG_STATIC_LIB) $(GTEST_LIBS) $(LIB_PRODUCTION) -o $@



test_run: $(PATH_BIN)$(RUNNER_NAME)
	@ find $(PATH_ObJ) -type f -name '*.gcda' -delete
	$(PATH_BIN)$(RUNNER_NAME) --gtest_output="xml:$(PATH_BIN)$(RUNNER_NAME).xml"

# Run test in QEMU ARM enviroment
test_qemu_run:
	$(GCG_UNITTEST_SCRIP_DIR)/runUnittestQemu.sh

# Automatic Rules to Build sources .c .cpp in .o objects
# '-c' Flag tell compiler to not do the final link.

# Compiles Package C and CPP sources in the
# relevant objects and create dependencies
$(PATH_ObJ)%.o:: $(PATH_SRC)%.c
	@mkdir -p $(PATH_ObJ)$(dir $* )
	@mkdir -p $(PATH_DEP)$(dir $* )
	$(CC) -c $< -o $@ -MF $(PATH_DEP)$*.dep $(COMPILE_FLAGS)

$(PATH_ObJ)%.o:: $(PATH_SRC)%.cpp
	@mkdir -p $(PATH_ObJ)$(dir $* )
	@mkdir -p $(PATH_DEP)$(dir $* )
	$(CXX) -c $< -o $@ -MF $(PATH_DEP)$*.dep $(COMPILE_CPP_FLAGS)


# Compiles test_build C and CPP sources in the 
# relevant objects and create dependencies
$(PATH_ObJ)%.o:: $(PATH_TEST)%.c
	@mkdir -p $(PATH_ObJ)$(dir $* )
	@mkdir -p $(PATH_DEP)$(dir $* )
	$(CC) -c $< -o $@ -MF $(PATH_DEP)$*.dep $(COMPILE_FLAGS)

$(PATH_ObJ)%.o:: $(PATH_TEST)%.cpp
	@mkdir -p $(PATH_ObJ)$(dir $* )
	@mkdir -p $(PATH_DEP)$(dir $* )
	$(CXX) -c $< -o $@ -MF $(PATH_DEP)$*.dep $(COMPILE_CPP_FLAGS)

# Compiles test_build C and CPP sources in the 
# relevant objects and create dependencies
$(PATH_ObJ)%.o:: $(PATH_TESTDOUBLE)%.c
	@mkdir -p $(PATH_ObJ)$(dir $* )
	@mkdir -p $(PATH_DEP)$(dir $* )
	$(CC) -c $< -o $@ -MF $(PATH_DEP)$*.dep $(COMPILE_FLAGS)

$(PATH_ObJ)%.o:: $(PATH_TESTDOUBLE)%.cpp
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


test_clean:
	$(CLEANUP) $(PATH_ObJ)*
	$(CLEANUP) $(PATH_DEP)*
	$(CLEANUP) $(PATH_BIN)$(RUNNER_NAME)
	$(CLEANUP) $(RUNNER_SRC)


# These files are precious... do not delete while building
.PRECIOUS: $(PATH_BIN)$(RUNNER_NAME)
.PRECIOUS: $(PATH_DEP)%.dep
.PRECIOUS: $(PATH_ObJ)%.o


# These are virtual targets don't create them
.PHONY: test_build
.PHONY: test_run
.PHONY: test_clean

