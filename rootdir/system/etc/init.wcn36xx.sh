# Load modules necessary for wcn36xx driver

if [[ `/system/bin/getprop cozybit.disable_wcn36xx` == "1" ]]; then
    /system/bin/insmod /system/lib/modules/cfg80211.ko
    exit 0
fi

[[ -e /system/lib/modules/seqiv.ko ]] && \
        /system/bin/insmod /system/lib/modules/seqiv.ko
[[ -e /system/lib/modules/ctr.ko ]] && \
        /system/bin/insmod /system/lib/modules/ctr.ko
[[ -e /system/lib/modules/ccm.ko ]] && \
        /system/bin/insmod /system/lib/modules/ccm.ko

/system/bin/mount -o remount,rw /system

/system/bin/rm -f /system/etc/firmware/wlan/macaddr0
/system/bin/ln -s /data/etc/wlan_macaddr0 /system/etc/firmware/wlan/macaddr0

/system/bin/mount -o remount,ro /system

/system/bin/insmod /system/lib/modules/backports/compat.ko
/system/bin/insmod /system/lib/modules/backports/cfg80211.ko
/system/bin/insmod /system/lib/modules/backports/mac80211.ko

#   WCN36XX_DBG_DXE         = 0x00000001,
#   WCN36XX_DBG_DXE_DUMP    = 0x00000002,
#   WCN36XX_DBG_SMD         = 0x00000004,
#   WCN36XX_DBG_SMD_DUMP    = 0x00000008,
#   WCN36XX_DBG_RX          = 0x00000010,
#   WCN36XX_DBG_RX_DUMP     = 0x00000020,
#   WCN36XX_DBG_TX          = 0x00000040,
#   WCN36XX_DBG_TX_DUMP     = 0x00000080,
#   WCN36XX_DBG_HAL         = 0x00000100,
#   WCN36XX_DBG_HAL_DUMP    = 0x00000200,
#   WCN36XX_DBG_MAC         = 0x00000400,
#   WCN36XX_DBG_BEACON      = 0x00000800,
#   WCN36XX_DBG_BEACON_DUMP = 0x00001000,
#   WCN36XX_DBG_PMC         = 0x00002000,
#   WCN36XX_DBG_PMC_DUMP    = 0x00004000,
#   WCN36XX_DBG_ANY         = 0xffffffff,

# SMD + HAL
#/system/bin/insmod /system/lib/modules/backports/wcn36xx.ko \
#    debug_mask=0x104 nohwcrypt=1

# Everything - *_DUMP
#/system/bin/insmod /system/lib/modules/backports/wcn36xx.ko \
#    debug_mask=0x2d55 nohwcrypt=1

# Everything - *_DUMP - *_DXE
#/system/bin/insmod /system/lib/modules/backports/wcn36xx.ko \
#    debug_mask=0x2d54 nohwcrypt=1

/system/bin/insmod /system/lib/modules/backports/wcn36xx.ko nohwcrypt=1
/system/bin/insmod /system/lib/modules/backports/wcn36xx_msm.ko

#/system/bin/iw reg set US

WIFI_CONF=/data/misc/wifi/wpa_supplicant.conf
WIFI_CONF_SRC=/system/etc/wifi/wpa_supplicant.conf

if [[ ! -f $WIFI_CONF ]] || [[ -f /data/misc/wifi/reset_wpa_s_conf ]]; then
    /system/bin/cp $WIFI_CONF_SRC $WIFI_CONF
    /system/bin/chmod 0660 $WIFI_CONF
    /system/bin/chown wifi:wifi $WIFI_CONF
fi

/system/bin/setprop wlan.driver.status ok
