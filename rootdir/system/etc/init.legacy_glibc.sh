source=/system/legacy_glibc.tar

if [ -f "$source" ]; then
    mount -o remount,rw /
    tar -C / -x -f $source
    mount -o remount,ro /
fi
