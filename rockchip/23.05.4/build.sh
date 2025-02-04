#!/bin/bash
# Log file for debugging
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date)" >> $LOGFILE
# yml 传入的路由器型号 PROFILE
echo "Building for profile: $PROFILE"
# yml 传入的固件大小 ROOTFS_PARTSIZE
echo "Building for ROOTFS_PARTSIZE: $ROOTFS_PARTSIZE"

echo "Create pppoe-settings"
mkdir -p  /home/build/immortalwrt/files/etc/config

# 创建pppoe配置文件 yml传入环境变量ENABLE_PPPOE等 写入配置文件 供99-custom.sh读取
cat << EOF > /home/build/immortalwrt/files/etc/config/pppoe-settings
enable_pppoe=${ENABLE_PPPOE}
pppoe_account=${PPPOE_ACCOUNT}
pppoe_password=${PPPOE_PASSWORD}
EOF

echo "cat pppoe-settings"
cat /home/build/immortalwrt/files/etc/config/pppoe-settings


# 输出调试信息
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting build process..."


# 定义所需安装的包列表 23.05.4 下列插件你都可以自行删减
PACKAGES=""
PACKAGES="$PACKAGES curl"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-opkg-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-i18n-filebrowser-zh-cn"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES="$PACKAGES luci-i18n-passwall-zh-cn"
PACKAGES="$PACKAGES luci-app-openclash"
PACKAGES="$PACKAGES luci-i18n-homeproxy-zh-cn"
PACKAGES="$PACKAGES openssh-sftp-server"
PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
# 增加几个必备组件 方便用户安装iStore
PACKAGES="$PACKAGES fdisk"
PACKAGES="$PACKAGES script-utils"
PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"

PACKAGES="$PACKAGES luci-i18n-alist-zh-cn"
PACKAGES="$PACKAGES luci-i18n-netdata-zh-cn"
PACKAGES="$PACKAGES luci-i18n-qos-zh-cn"
PACKAGES="$PACKAGES luci-i18n-arpbind-zh-cn"
#PACKAGES="$PACKAGES luci-i18n-mwan3-zh-cn"
#PACKAGES="$PACKAGES luci-i18n-mwan3helper-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ramfree-zh-cn"
PACKAGES="$PACKAGES luci-i18n-rclone-zh-cn"
PACKAGES="$PACKAGES luci-i18n-smartdns-zh-cn"
PACKAGES="$PACKAGES luci-i18n-statistics-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ddns-go-zh-cn"
PACKAGES="$PACKAGES luci-i18n-usb-printer-zh-cn"
PACKAGES="$PACKAGES luci-i18n-watchcat-zh-cn"
PACKAGES="$PACKAGES luci-i18n-timewol-zh-cn"
PACKAGES="$PACKAGES luci-i18n-appfilter-zh-cn"
PACKAGES="$PACKAGES luci-i18n-arpbind-zh-cn"
PACKAGES="$PACKAGES luci-i18n-cifs-mount-zh-cn"
PACKAGES="$PACKAGES luci-i18n-eqos-zh-cn"
PACKAGES="$PACKAGES luci-i18n-hd-idle-zh-cn"
PACKAGES="$PACKAGES luci-i18n-minidlna-zh-cn"
PACKAGES="$PACKAGES luci-i18n-smartdns-zh-cn"
PACKAGES="$PACKAGES luci-i18n-wol-zh-cn"
PACKAGES="$PACKAGES luci-i18n-zerotier-zh-cn"
PACKAGES="$PACKAGES luci-i18n-vlmcsd-zh-cn"
PACKAGES="$PACKAGES luci-i18n-upnp-zh-cn"
PACKAGES="$PACKAGES luci-i18n-adbyby-plus-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ddns-zh-cn"
PACKAGES="$PACKAGES luci-i18n-cpulimit-zh-cn"
PACKAGES="$PACKAGES luci-i18n-cifs-mount-zh-cn"
PACKAGES="$PACKAGES luci-i18n-base-zh-cn"
PACKAGES="$PACKAGES luci-i18n-aria2-zh-cn"
PACKAGES="$PACKAGES luci-i18n-adblock-fast-zh-cn"
PACKAGES="$PACKAGES luci-i18n-wechatpush-zh-cn"
PACKAGES="$PACKAGES luci-i18n-wifischedule-zh-cn"
PACKAGES="$PACKAGES luci-i18n-nlbwmon-zh-cn"

#PACKAGES="$PACKAGES luci-i18n-socat-zh-cn"
#PACKAGES="$PACKAGES luci-i18n-ahcp-zh-cn"
#PACKAGES="$PACKAGES luci-i18n-oled-zh-cn"
#PACKAGES="$PACKAGES luci-i18n-uhttpd-zh-cn"
#PACKAGES="$PACKAGES luci-i18n-gost-zh-cn"
#PACKAGES="$PACKAGES luci-i18n-udpxy-zh-cn"
#PACKAGES="$PACKAGES luci-i18n-mwol-zh-cn"


# 构建镜像
echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

make image PROFILE=$PROFILE PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files" ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE

if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."
