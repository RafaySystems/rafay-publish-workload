#!/bin/bash
#wget -q https://s3-us-west-2.amazonaws.com/rafay-prod-cli/publish/rctl-linux-amd64.tar.bz2
#tar -xf rctl-linux-amd64.tar.bz2
#chmod 0755 rctl
export RCTL_API_KEY=$1
export RCTL_API_SECRET=$2
export RCTL_REST_ENDPOINT=$3
export RCTL_PROJECT=$4
WORKLOAD_NAME=$5
WORKLOAD_NAMESPACE=$6
WORKLOAD_YAML=$7
LookupWorkload () {
local workload match="$1"
shift
for workload; do [[ "$workload" == "$match" ]] && return 0; done
return 1
}
rctl get namespace > /tmp/namespace
grep -i $WORKLOAD_NAMESPACE /tmp/namespace > /dev/null 2>&1
if [ $? -eq 1 ];
then
    rctl create namespace $WORKLOAD_NAMESPACE
fi
rm /tmp/namespace
wl_tmp=`rctl get workload -o json | jq '.result[]|.name' |cut -d'"' -f2`
WL_TMP_ARRAY=( $wl_tmp )
LookupWorkload $WORKLOAD_NAME "${WL_TMP_ARRAY[@]}"
if [ $? -eq 1 ];
then
    rctl create workload $WORKLOAD_YAML
else
    rctl update workload $WORKLOAD_YAML
fi
rctl publish workload $WORKLOAD_NAME
workload_status="Not Ready"
workload_status_iterations=1
while [ "$workload_status" != "Ready" ];
do
    workload_status=`rctl status workload $WORKLOAD_NAME -o json|jq .result[].status|tr -d '"'`
    echo $workload_status
    sleep 30
    if [ $workload_status_iterations -ge 30 ];
    then
        break
    fi
    if [ "$workload_status" = "Failed" ];
    then
        echo "Workload Deployment Failed"
        break
    fi
    workload_status_iterations=$((workload_status_iterations+1))
done

echo "::set-output name=workload_status::$workload_status"
