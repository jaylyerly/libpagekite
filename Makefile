#!/usr/bin/colormake

LIBEV_INC_DIR ?= /usr/include/libev
LIBEV_LIB_DIR ?= /usr/lib/libev
ifeq ($(mac),1)
    # location after a 'brew install libev'
    LIBEV_INC_DIR = /usr/local/include
    LIBEV_LIB_DIR = /usr/local/lib
endif

OPT ?= -g -O3
ifeq ($(debug),1)
   OPT = -g
endif

OSFLAGS = 
ifeq ($(mac),1)
    # LibPageKite uses a bunch of methods in the 
    # SSL lib that are deprecated as of 10.7
    OSFLAGS = -Wno-deprecated 
endif

CFLAGS ?= -std=c99 -pedantic -Wall -W -fpic -fno-strict-aliasing \
          -I$(LIBEV_INC_DIR) $(OPT) $(OSFLAGS)
CLINK ?= -L$(LIBEV_LIB_DIR) -lpthread -lssl -lcrypto -lm -lev

TOBJ = pkproto_test.o pkmanager_test.o sha1_test.o utils_test.o
OBJ = pkerror.o pkproto.o pkconn.o pkblocker.o pkmanager.o \
      pklogging.o pkstate.o utils.o pd_sha1.o pkwatchdog.o
HDRS = common.h utils.h pkstate.h pkconn.h pkerror.h pkproto.h pklogging.h \
       pkmanager.h pd_sha1.h pkwatchdog.h Makefile

PK_TRACE ?= 0
HAVE_OPENSSL ?= 1
HAVE_IPV6 ?= 1

DEFINES=-DHAVE_IPV6=$(HAVE_IPV6) \
        -DHAVE_OPENSSL=$(HAVE_OPENSSL) \
        -DPK_TRACE=$(PK_TRACE)

NDK_PROJECT_PATH ?= "/home/bre/Projects/android-ndk-r8"

default: libpagekite pagekitec

all: runtests libpagekite pagekitec httpkite

runtests: tests
	@./tests && echo Tests passed || echo Tests FAILED.

#android: clean
android:
	@$(NDK_PROJECT_PATH)/ndk-build

# for mac builds, rerun make with the mac flag set to 1
mac:
	$(MAKE) libpagekite pagekitec httpkite mac=1 debug=$(debug)
	$(MAKE) runtests mac=1 debug=$(debug)

tests: tests.o $(OBJ) $(TOBJ)
	$(CC) $(CFLAGS) -o tests tests.o $(OBJ) $(TOBJ) $(CLINK)

libpagekite: libpagekite.so libpagekite.a

libpagekite.so: $(OBJ)
	$(CC) $(CFLAGS) -shared -o libpagekite.so $(OBJ) $(CLINK)

libpagekite.a: $(OBJ)
	ar rcs libpagekite.a $(OBJ) 

httpkite: httpkite.o $(OBJ)
	$(CC) $(CFLAGS) -o httpkite httpkite.o $(OBJ) $(CLINK)

pagekitec: pagekitec.o $(OBJ)
	$(CC) $(CFLAGS) -o pagekitec pagekitec.o $(OBJ) $(CLINK)

version:
	@sed -e "s/@DATE@/`date '+%y%m%d'`/g" <version.h.in >version.h
	@touch pkproto.h

clean:
	rm -vf tests pagekitec httpkite *.o *.so *.a

allclean: clean
	find . -name '*.o' |xargs rm -vf

.c.o:
	$(CC) $(CFLAGS) $(DEFINES) -c $<

httpkite.o: $(HDRS)
pagekitec.o: $(HDRS)
pagekite-jni.o: $(HDRS)
pkblocker.o: $(HDRS)
pkconn.o: common.h utils.h pkerror.h pklogging.h
pkerror.o: common.h utils.h pkerror.h pklogging.h
pklogging.o: common.h pkstate.h pkconn.h pkproto.h pklogging.h
pkmanager.o: $(HDRS)
pkmanager_test.o: $(HDRS)
pkproto.o: common.h pd_sha1.h utils.h pkconn.h pkproto.h pklogging.h pkerror.h
pkproto_test.o: common.h pkerror.h pkconn.h pkproto.h utils.h
pd_sha1.o: common.h pd_sha1.h
sha1_test.o: common.h pd_sha1.h
tests.o: pkstate.h
utils.o: common.h
utils_test.o: utils.h
