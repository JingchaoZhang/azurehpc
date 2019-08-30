# Please update these values
LICENSE_PORT_IP="port@IP"
APP_VERSION="xxx"
INSTALL_TAR="LBsolver_xxx.tgz"
TAR_SAS_URL="<SAL URL FROM WHERE TO DOWNLOAD LBSOLVER>"
DOWNLOAD_DIR=/mnt/resource
APP_NAME=prolb
SHARED_APP=/apps
INSTALL_DIR=${SHARED_APP}/${APP_NAME}
MODULE_DIR=${SHARED_APP}/modulefiles
MODULE_NAME=${APP_NAME}_${APP_VERSION}

function create_modulefile {
mkdir -p ${MODULE_DIR}
chmod 777 ${MODULE_DIR}

cat << EOF > ${MODULE_DIR}/${MODULE_NAME}
#%Module 1.0
#
#  Prolb module for use with 'environment-modules' package:
#
setenv                  PROLB_LICPATH        ${LICENSE_PORT_IP}
setenv                  PROLB_HOME           ${INSTALL_DIR}/${INSTALL_TAR%.[^.]*}
EOF
}

pushd ${DOWNLOAD_DIR}
if [ ! -f ${INSTALL_DIR} ]; then
mkdir -p ${INSTALL_DIR}
wget "$TAR_SAS_URL" -O ${INSTALL_TAR}
tar xvzf ${INSTALL_TAR} -C ${INSTALL_DIR}
fi
popd

create_modulefile
