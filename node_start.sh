#!/bin/bash
# SkyWire Install
Node_Pid_FILE=node.pid
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
	[[ -f ${TMP_DIR}/${Node_Pid_FILE} ]] && pkill -F "${TMP_DIR}/${Node_Pid_FILE}" && rm "${TMP_DIR}/${Node_Pid_FILE}"
fi

command -v "${GOBIN_DIR}/bin/manager" && command -v "${GOBIN_DIR}/bin/discovery" && command -v "${GOBIN_DIR}/bin/socksc" && command -v "${GOBIN_DIR}/bin/sockss" && command -v "${GOBIN_DIR}/bin/sshc" && command -v "${GOBIN_DIR}/bin/sshs" > /dev/null || {
	  [[ -d ${GOBIN_DIR}/pkg/linux_arm64/github.com/skycoin ]] && rm -rf ${GOBIN_DIR}/pkg/linux_arm64/github.com/skycoin
			  cd ${GOBIN_DIR}/src/github.com/skycoin/skywire/cmd
			  ${GOBIN_DIR}/bin/go install ./...
}

echo "Starting SkyWire Node"
cd ${GOBIN_DIR}/bin/
nohup ./node -connect-manager -manager-address 192.168.0.2:5998 -manager-web 192.168.0.2:8000 -discovery-address www.yiqishare.com:5999 -address :5000 > /dev/null 2>&1 &
echo $! > "${TMP_DIR}/${Node_Pid_FILE}"
cat "${TMP_DIR}/${Node_Pid_FILE}"
cd /root
echo "SkyWire Node Done"