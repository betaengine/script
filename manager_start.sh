#!/bin/bash
# SkyWire Install
Manager_Pid_FILE=manager.pid
if [[ -z $1 ]];then
	[[ -f /tmp/skywire-pids/${Manager_Pid_FILE} ]] && pkill -F "/tmp/skywire-pids/${Manager_Pid_FILE}" && rm "/tmp/skywire-pids/${Manager_Pid_FILE}"
fi
command -v "manager" && command -v "discovery" && command -v "socksc" && command -v "sockss" && command -v "sshc" && command -v "sshs" > /dev/null || {
		[[ -d /usr/local/go/pkg/linux_arm64/github.com/skycoin ]] && rm -rf /usr/local/go/pkg/linux_arm64/github.com/skycoin
		cd /usr/local/go/src/github.com/skycoin/skywire/cmd
		/usr/local/go/bin/go install ./...
}
echo "Starting SkyWire Manager"
if [[ ! -d /tmp/skywire-pids ]]; then
	mkdir -p /tmp/skywire-pids
fi
cd /usr/local/go/bin/
nohup ./manager -web-dir /usr/local/go/bin/dist-manager > /dev/null 2>&1 &
echo $! > "/tmp/skywire-pids/${Manager_Pid_FILE}"
cat "/tmp/skywire-pids/${Manager_Pid_FILE}"
cd /root
echo "SkyWire Manager Done"

/usr/bin/node_start.sh
