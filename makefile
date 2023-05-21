APPNAME := Sunaba
APPNAME_LC := sunaba

PYTHON := /usr/bin/python3
GODOT := /usr/local/bin/godot

ifndef GODOT
$(error GODOT is not set)
endif
$(info Version is: $(GODOT))

ifndef PYTHON
$(error PYTHON is not set)
endif
$(info Version is: $(PYTHON))

APPVER := 0.5.0
#APPVER := $(PYTHON) 
#echo $(APPVER)

ifndef APPVER
$(error APPVER is not set)
endif
$(info Version is: $(APPVER))

# PREFIX is environment variable, but if it is not set, then set default value
ifeq ($(PREFIX),)
    PREFIX := /usr/local
endif

BINDIR = ./bin/linux/

.PHONY: def
def: 
	$(info No target defined)

build-linux:
	GODOT_MAKE_CONSTANTS="GODOT_BUILD_PROD" \
	$(PYTHON) ./build.py linux $(GODOT)

build-win32:
	GODOT_MAKE_CONSTANTS="GODOT_BUILD_PROD" \
	$(PYTHON) ./build.py win32 $(GODOT)

clean:
	rm -rf bin/linux || true
	rm -rf binWin32 || true
	rm -rf bin || true
	touch export/.gdignore || true

install: $(BINDIR)
	install -d $(DESTDIR)$(PREFIX)/bin/$(APPNAME_LC)
	install -m 644 $(filter-out $(BINDIR)data_Sunaba_x86_64, $(wildcard $(BINDIR)*)) $(DESTDIR)$(PREFIX)/bin/$(APPNAME_LC)
	install -d $(DESTDIR)$(PREFIX)/bin/$(APPNAME_LC)/data_Sunaba_x86_64
	install -m 644 $(wildcard $(BINDIR)data_Sunaba_x86_64/*) -t $(DESTDIR)$(PREFIX)/bin/$(APPNAME_LC)/data_Sunaba_x86_64/


all: build-linux build-win32
