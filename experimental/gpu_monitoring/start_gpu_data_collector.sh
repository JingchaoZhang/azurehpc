#!/bin/bash

HOSTLIST=hostlist
INTERVAL_SECS=30
DCGM_FIELD_IDS="203,252,1004"
#FORCE_GPU_MONITORING="-fgm"
LOG_ANALYTICS_CUSTOMER_ID=''
LOG_ANALYTICS_SHARED_KEY=''
SCRIPT_PATH=~
EXE_PATH="${SCRIPT_PATH}/gpu_data_collector.py $FORCE_GPU_MONITORING -tis $INTERVAL_SECS -dfi $DCGM_FIELD_IDS >> /tmp/gpu_data_collector.log"
PDSH_RCMD_TYPE=ssh
CWD=`pwd`

cat << EOF > ${CWD}/run_gpu_monitor.sh
#!/bin/bash
export LOG_ANALYTICS_CUSTOMER_ID=$LOG_ANALYTICS_CUSTOMER_ID
export LOG_ANALYTICS_SHARED_KEY=$LOG_ANALYTICS_SHARED_KEY
$EXE_PATH
EOF

chmod 777 ${CWD}/run_gpu_monitor.sh

WCOLL=$HOSTLIST pdsh "sudo ${CWD}/run_gpu_monitor.sh &"
