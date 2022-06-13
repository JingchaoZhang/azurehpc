#!/bin/bash
OPENMPI_VERSION=4.1.1
HPCX_VERSION=2.9.0
GCC_VERSION=9.2.0

. ~/spack/share/spack/setup-env.sh

echo "Add GCC compiler"
spack compiler find /opt/gcc-$GCC_VERSION/

echo "Configure external MPI packages"
cat <<EOF >~/.spack/packages.yaml
packages:
  all:
    target: [x86_64]
    providers: 
      mpi: [openmpi]
  openmpi:
    externals:
    - spec: openmpi@$OPENMPI_VERSION%gcc@$GCC_VERSION
      modules:
      - mpi/openmpi-$OPENMPI_VERSION
    buildable: False
  hpcx:
    externals:
    - spec: hpcx@$HPCX_VERSION%gcc@$GCC_VERSION
      modules:
      - mpi/hpcx-v$HPCX_VERSION
    buildable: False
EOF

echo "Configure local settings"

cat <<EOF >~/.spack/config.yaml
config:
  build_stage:
    - /mnt/resource/$USER/spack-stage
    - ~/.spack/stage
EOF

# from https://techcommunity.microsoft.com/t5/azure-global/spack-in-a-multi-user-hpc-environment-on-azure/ba-p/3438261
spack config --scope defaults add config:build_jobs:32

MICROARCHFILE=$SPACK_ROOT/lib/spack/external/archspec/json/cpu/microarchitectures.json
mv $MICROARCHFILE ${MICROARCHFILE}.orig
cat ${MICROARCHFILE}.orig \
| jq 'del(.microarchitectures.zen3.features[] | select (. == "pku"))' \
| jq 'del(.microarchitectures.zen.features[] | select (. == "clzero"))' \
>$MICROARCHFILE
