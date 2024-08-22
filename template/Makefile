# export THEOS=/var/theos


ARCHS = arm64 arm64e 

DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1
ROOTLESS = 0
IGNORE_WARNINGS=0

ifeq ($(ROOTLESS), 1)
THEOS_PACKAGE_SCHEME = rootless
endif 

MOBILE_THEOS=1
ifeq ($(MOBILE_THEOS),1)
  # path to your sdk
  SDK_PATH = $(THEOS)/sdks/iPhoneOS13.6.sdk/
  $(info ===> Setting SYSROOT to $(SDK_PATH)...)
  SYSROOT = $(SDK_PATH)
else
  TARGET = iphone:clang:latest:8.0
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = @@PROJECTNAME@@




PROJ_COMMON_FRAMEWORKS =  UIKit Foundation Security QuartzCore CoreGraphics CoreText  AVFoundation Accelerate GLKit SystemConfiguration GameController

@@PROJECTNAME@@_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG
@@PROJECTNAME@@_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value

ifeq ($(IGNORE_WARNINGS),1)
  @@PROJECTNAME@@_CFLAGS += -w
  @@PROJECTNAME@@_CCFLAGS += -w
endif
@@PROJECTNAME@@_FILES = ImGuiDrawView.mm $(wildcard Esp/*.mm)   $(wildcard Esp/*.m) $(wildcard KittyMemory/*.cpp) $(wildcard KittyMemory/*.mm) $(wildcard ImGuiMemory/*.cpp) $(wildcard ImGuiMemory/*.mm) $(wildcard img/*.m)



#kust_LIBRARIES += substrate
# GO_EASY_ON_ME = 1

include $(THEOS_MAKE_PATH)/tweak.mk

internal-package-check::
	@chmod 777 versionCheck.sh # Give permission to script 	
	@./versionCheck.sh # Script to verify template's current version

after-install::
	install.exec "killall -9 @@BINARYNAME@@ || :"


