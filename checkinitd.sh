#!/sbin/sh

if [ ! -f /system/bin/sysinit ] || [[ "$(cat /system/bin/sysinit)" != *"init.d"* ]]; then
    if [ -f /system/xbin/busybox ]; then
        echo -en "\n# init.d\n/system/xbin/busybox run-parts /system/etc/init.d\n">>/system/bin/sysinit
    else
        echo -en "\n# init.d\nALLINITS="'"$(ls /system/etc/init.d/)"'"\nfor "'initd in $ALLINITS; do'"\n"'/system/bin/sh /system/etc/init.d/$initd'"\ndone\n">>/system/bin/sysinit
    fi
fi
