#!/bin/bash
#SBATCH --job-name=lambdastack
#SBATCH --time=00:15:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --hint=nomultithread
#SBATCH --gres=gpu:1

# path to the singularity image file
SIF=lambda-stack-focal.sif

# load environment modules
ml Singularity CUDA

SINGULARITY="singularity exec --nv \
                -B ${PWD} \
                -B /cm/local/apps/cuda -B ${EBROOTCUDA} \
                $SIF"

# extend container LD_LIBRARY_PATH so it can find CUDA libs
OLD_PATH=$(${SINGULARITY} printenv | grep LD_LIBRARY_PATH | awk -F= '{print $2}')
export SINGULARITYENV_LD_LIBRARY_PATH="${OLD_PATH}:${LD_LIBRARY_PATH}"

echo ${SINGULARITY} $@
${SINGULARITY} $@
