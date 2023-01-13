#!/bin/bash

function set_detached_mode() {
   TARGET_MODE=$1
   sudo sed -i "s/DETACHED_MODE.*/DETACHED_MODE=${TARGET_MODE}/g" /etc/default/nhc
}

function exclusive_node() {
BASE_DIR="/sys/fs/cgroup/memory/slurm"
cntu=0
for dir in ${BASE_DIR}/uid_*
do
    cntu=$((cntu+1))
    if [[ $cntu -gt 1 ]]; then
       return 1
    fi
    cntj=0
    for job in ${dir}/job_*
    do
        cntj=$((cntj+1))
        if [[ $cntj -gt 1 ]]; then
           return 1
        fi
    done
done
}

exclusive_node
exclusive_node_rc=$?

set_detached_mode 0
if [ $exclusive_node_rc -eq 0 ]; then
   sudo /usr/sbin/nhc
   NHC_RC=$?
fi
set_detached_mode 1

exit ${NHC_RC}
