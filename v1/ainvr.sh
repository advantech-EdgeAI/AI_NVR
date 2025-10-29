#!/bin/bash
#
# Copyright (C) 2016 Advantech Co., Ltd. - http://www.advantech.com.tw/
# All Rights Reserved.
#
# NOTICE:  All information contained herein is, and remains the property of
#     Advantech Co., Ltd. and its suppliers, if any.  The intellectual and
#     technical concepts contained herein are proprietary to Advantech Co., Ltd.
#     and its suppliers and may be covered by U.S. and Foreign Patents,
#     patents in process, and are protected by trade secret or copyright law.
#     Dissemination of this information or reproduction of this material
#     is strictly forbidden unless prior written permission is obtained
#     from Advantech Co., Ltd.
#
#     Terry.Huang


CMD=${1}
DIR_BASE=`pwd`

function usage {
        echo "Usage:"
	echo "    ${0} (install | setup | start | stop | restart)"
        echo
        echo "### NOTE: Please install once and then setup before each start AINVR ###"
        return 0
}


case ${CMD} in

         install) 
		#check status
		if [ -f /etc/ainvr_ins_done ]; then
		  echo "AI-NVR has been installed."
		  exit 0
		fi

		cd ${DIR_BASE}
		sudo bash install.sh
		;;
         setup)      
		set -ex

		#check status
		if [ -f /tmp/ainvr_setup_done ]; then
		  echo "AI-NVR has been setup."
		  exit 0
		fi
		
		#sudo docker login nvcr.io -u "\$oauthtoken" -p <NGC-API-KEY>
		sudo docker login nvcr.io -u "\$oauthtoken" -p bjUxdTY3cG5qY3Vocjg4dGFkdTE5dDdvaXA6Nzk4M2IwYzQtNmY4ZS00ZGM0LTllNzgtNDhiNjNmOTQ5NjNl

		sudo sysctl -w net.core.rmem_default=2129920
		sudo sysctl -w net.core.rmem_max=10000000
		sudo sysctl -w net.core.wmem_max=2000000

		sudo systemctl enable jetson-ingress
		sudo systemctl enable jetson-redis
		sudo systemctl enable jetson-storage
		sudo systemctl enable jetson-networking
		sudo systemctl enable jetson-monitoring
		sudo systemctl enable jetson-sys-monitoring
		sudo systemctl enable jetson-gpu-monitoring
#		sudo systemctl enable jetson-vst

		sudo systemctl start jetson-storage 
		sudo systemctl start jetson-networking

		# Opiotnal
		#sudo systemctl start jetson-monitoring
		#sudo systemctl start jetson-sys-monitoring
		#sudo systemctl start jetson-gpu-monitoring

		sudo systemctl start jetson-ingress
		sudo systemctl start jetson-redis
#   sudo systemctl start jetson-vst

		touch /tmp/ainvr_setup_done
		;;
         start)       
		set -ex
		cd /opt/nvstreamer
		sudo docker compose -f compose_nvstreamer.yaml up -d  --force-recreate
		cd /opt/ai_nvr
		sudo docker compose -f compose_nx16.yaml up -d --force-recreate
		;;
         stop)         
		set -ex
		cd /opt/nvstreamer
		sudo docker compose -f compose_nvstreamer.yaml down --remove-orphans
		cd /opt/ai_nvr
		sudo docker compose -f compose_nx16.yaml down --remove-orphans
		;;
         restart)         
		set -ex
		cd /opt/nvstreamer
		sudo docker compose -f compose_nvstreamer.yaml down --remove-orphans
		sudo docker compose -f compose_nvstreamer.yaml up -d  --force-recreate
		cd /opt/ai_nvr
		sudo docker compose -f compose_nx16.yaml down --remove-orphans
		sudo docker compose -f compose_nx16.yaml up -d --force-recreate
		;;
         *)     
		usage 
		;;


esac

