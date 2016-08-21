LOCAL_PATH := $(call my-dir)
LOCAL_DIR := $(LOCAL_PATH)

include $(CLEAR_VARS)

LOCAL_PATH := $(LOCAL_DIR)

LOCAL_MODULE := anykernel

LOCAL_KERNEL_VERSION := blueberry-kernel-v1.4-bh3.7
LOCAL_KERNEL_AUTHOR := xdevs23
LOCAL_KERNEL_AUTHOR_ENDSTRING :=

LOCAL_KA_MOVE := true
LOCAL_KA_TOMOVE := ../KernelAdiutor/
LOCAL_KA_MVDEST := packages/apps/KernelAdiutor

LOCAL_ANYKERNEL_KA_MOVED := $(shell [ ! -e packages/apps/KernelAdiutor ] && mv $(LOCAL_KA_TOMOVE) $(LOCAL_KA_MVDEST) && \
	echo -e "${CL_MAG}KernelAdiutor inserted. Please initiate the build again.">&2 && echo -n "true")

ifeq ($(LOCAL_ANYKERNEL_KA_MOVED),true)
$(error Reinitiaion of build necessary. KernelAdiutor inserted on build time.)
endif

ifneq ($(LOCAL_KERNEL_AUTHOR),)
    LOCAL_KERNEL_AUTHOR_ENDSTRING = -$(LOCAL_KERNEL_AUTHOR)
endif

ANYKERNEL_SH := $(LOCAL_DIR)/anykernel.zip

anykernel-buildka: | bootimage KernelAdiutor

$(ANYKERNEL_SH): | bootimage anykernel-buildka
	@echo "Copying new KernelAdiutor..."
	cp $(OUT)/system/app/KernelAdiutor/KernelAdiutor.apk $(LOCAL_DIR)/KernelAdiutor/KernelAdiutor.apk
	@if [ "$(LOCAL_KA_MOVE)" == "true" ]; then \
	echo "Moving KA back to its old location"; \
	mv $(LOCAL_KA_MVDEST) $(LOCAL_KA_TOMOVE); \
	fi
	@if [ ! -e "$(OUT)/kernel" ]; then echo -e "\033[91mNo kernel image found! Please build the kernel using 'make bootimage' first.\033[0m"; exit 1; fi
	@echo "Building AnyKernel package..."
	cp $(OUT)/kernel $(LOCAL_DIR)/Image
	cd $(LOCAL_DIR); zip -r $(OUT)/anykernel.zip ./* -x README Android.mk
	mv $(OUT)/anykernel.zip $(OUT)/$(LOCAL_KERNEL_VERSION)$(LOCAL_KERNEL_AUTHOR_ENDSTRING).zip
	@echo "AnyKernel package is made."

anykernel-alltargets: | bootimage KernelAdiutor $(ANYKERNEL_SH)

all_modules: anykernel-alltargets
.PHONY: anykernel-alltargets
$(LOCAL_MODULE): anykernel-alltargets