#!/bin/bash
#SBATCH --account=nn9447k
#SBATCH --partition=accel
#SBATCH --gres=gpu:1
#SBATCH --mem=30G
#SBATCH --time=5-0
#SBATCH --array=1-3%1

exp=$1
#CHECKPOINTS=checkpoints/glove${PREFIX:-}$SLURM_ARRAY_TASK_ID
CHECKPOINTS=checkpoints/$exp${PREFIX:-}$SLURM_ARRAY_TASK_ID
rm -rf $CHECKPOINTS
#workingdir='/cluster/work/users/mdelhoneux/hit-scir-ucca-parser'
#cd $workingdir

CUDA_DEVICE=0 \
TRAIN_PATH=data/ewt.train.aug.streusle.mrp \
DEV_PATH=data/ewt.dev.aug.streusle.mrp \
PRETRAINED_FILE=glove/glove.6B.100d.txt \
BATCH_SIZE=32 \
SEED=$RANDOM \
EPOCHS=200 \
allennlp train \
-s $CHECKPOINTS \
--include-package utils \
--include-package modules \
--include-package metrics \
--file-friendly-logging \
config/$exp.jsonnet "$@"
#config/all_feats.jsonnet "$@"
#config/transition_glove_ucca.jsonnet "$@"
#config/transition_glove_feats.jsonnet "$@"
