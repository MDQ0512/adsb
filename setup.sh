#!/bin/bash
clear
echo " "
echo "安装飞常准 ADS-B 客户端..."
echo "请确保您的设备中有可以正常工作的 ADS-B 程序."
echo "例如已预构建 ADS-B 映像或脚本安装的 ADS-B 程序 ."
echo "否则安装程序将设置失败!"
echo "此设置脚本依靠 Dump1090 Dump1090-fa Readsb 等解码器即可运行."
echo " "

apt-get install dos2unix -y

cd /root
chmod +x *.sh
dos2unix *.*
cd get_message
chmod +x *.sh
chmod +x *.py
dos2unix *.*

python get_ip.py
ps aux | grep py

update-alternatives --config editor
crontab -l > mycron
#echo new cron into cron file
echo "* * * * * /root/task.sh >/dev/null 2>&1" >> mycron
echo "* * * * * /root/synctime.sh >/dev/null 2>&1" >> mycron
#install new cron file
crontab mycron
rm mycron
crontab -e

bash /root/get_message/init.sh
bash /root/task.sh
sudo rm /etc/profile.d/sshpwd.sh
sudo mv /root/uuid.sh /etc/profile.d
sudo chmod +x /etc/profile.d/uuid.sh

echo " "
echo " "
echo "程序将在1分钟重新启动并激活..."
echo "UUID代码将在设备重新启动后显示在屏幕上"
echo "同时请将UUID代码与您的账户相关联"
echo " "
echo " "
sleep 60
reboot
