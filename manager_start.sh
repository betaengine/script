#!/bin/bash
# SkyWire Install
Manager_Pid_FILE=manager.pid
GOBIN_DIR=/usr/local/go
if [[ -z $1 ]];then
	[[ -f /tmp/skywire-pids/${Manager_Pid_FILE} ]] && pkill -F "/tmp/skywire-pids/${Manager_Pid_FILE}" && rm "/tmp/skywire-pids/${Manager_Pid_FILE}"
fi
command -v "${GOBIN_DIR}/bin/manager" && command -v "${GOBIN_DIR}/bin/discovery" && command -v "${GOBIN_DIR}/bin/socksc" && command -v "${GOBIN_DIR}/bin/sockss" && command -v "${GOBIN_DIR}/bin/sshc" && command -v "${GOBIN_DIR}/bin/sshs" > /dev/null || {
		[[ -d ${GOBIN_DIR}/pkg/linux_arm64/github.com/skycoin ]] && rm -rf ${GOBIN_DIR}/pkg/linux_arm64/github.com/skycoin
		cd ${GOBIN_DIR}/src/github.com/skycoin/skywire/cmd
		${GOBIN_DIR}/bin/go install ./...
}
echo "Starting SkyWire Manager"
if [[ ! -d /tmp/skywire-pids ]]; then
	mkdir -p /tmp/skywire-pids
fi
cd ${GOBIN_DIR}/bin/
nohup ./manager -web-dir ${GOBIN_DIR}/bin/dist-manager > /dev/null 2>&1 &
echo $! > "/tmp/skywire-pids/${Manager_Pid_FILE}"
cat "/tmp/skywire-pids/${Manager_Pid_FILE}"
cd /root
echo "SkyWire Manager Done"

/usr/bin/node_start.sh
