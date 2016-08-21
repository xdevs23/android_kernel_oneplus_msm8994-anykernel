LOCAL_PATH := $(call my-dir)
LOCAL_DIR := $(LOCAL_PATH)

include $(CLEAR_VARS)

LOCAL_PATH := $(LOCAL_DIR)

LOCAL_MODULE := anykernel

LOCAL_KERNEL_VERSION := blueberry-kernel-v1.4-bh3.6
LOCAL_KERNEL_AUTHOR := xdevs23
LOCAL_KERNEL_AUTHOR_ENDSTRING :=

ifneq ($(LOCAL_KERNEL_AUTHOR),)
    LOCAL_KERNEL_AUTHOR_ENDSTRING = -$(LOCAL_KERNEL_AUTHOR)
endif

ANYKERNEL_SH := $(LOCAL_DIR)/anykernel.zip

$(ANYKERNEL_SH):
	@if [ ! -e "$(OUT)/kernel" ]; then echo -e "\033[91mNo kernel image found! Please build the kernel using 'make bootimage' first.\033[0m"; exit 1; fi
	@echo "Building AnyKernel package..."
	cp $(OUT)/kernel $(LOCAL_DIR)/Image
	cd $(LOCAL_DIR); zip -r $(OUT)/anykernel.zip ./* -x README Android.mk
	mv $(OUT)/anykernel.zip $(OUT)/$(LOCAL_KERNEL_VERSION)$(LOCAL_KERNEL_AUTHOR_ENDSTRING).zip
	@echo "AnyKernel package is made."

all_modules: $(ANYKERNEL_SH)