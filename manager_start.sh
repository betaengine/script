#!/bin/bash
# SkyWire Install
Manager_Pid_FILE=manager.pid
GOBIN_DIR=/usr/local/go
TMP_DIR=/tmp/skywire-pids
Need_Kill=no

if [[ ! -d ${TMP_DIR} ]]; then
	mkdir -p ${TMP_DIR}
fi

if [[ -z $1 ]];then
	Need_Kill=$1
fi

if [ $Need_Kill = "yes" ];then
	[[ -f ${TMP_DIR}/${Manager_Pid_FILE} ]] && pkill -F "${TMP_DIR}/${Manager_Pid_FILE}" && rm "${TMP_DIR}/${Manager_Pid_FILE}"
fi

command -v "${GOBIN_DIR}/bin/manager" && command -v "${GOBIN_DIR}/bin/discovery" && command -v "${GOBIN_DIR}/bin/socksc" && command -v "${GOBIN_DIR}/bin/sockss" && command -v "${GOBIN_DIR}/bin/sshc" && command -v "${GOBIN_DIR}/bin/sshs" > /dev/null || {
		[[ -d ${GOBIN_DIR}/pkg/linux_arm64/github.com/skycoin ]] && rm -rf ${GOBIN_DIR}/pkg/linux_arm64/github.com/skycoin
		cd ${GOBIN_DIR}/src/github.com/skycoin/skywire/cmd
		${GOBIN_DIR}/bin/go install ./...
}

echo "Starting SkyWire Manager"
cd ${GOBIN_DIR}/bin/
nohup ./manager -web-dir ${GOBIN_DIR}/bin/dist-manager > /dev/null 2>&1 &
echo $! > "${TMP_DIR}/${Manager_Pid_FILE}"
cat "${TMP_DIR}/${Manager_Pid_FILE}"
cd /root
echo "SkyWire Manager Done"

/usr/bin/node_start.sh
