#!/bin/bash
#SBATCH --account=nn9447k
#SBATCH --partition=accel
#SBATCH --gres=gpu:1
#SBATCH --mem=30G
#SBATCH --time=5-0
#SBATCH --array=1-3%1

exp=$1
CHECKPOINTS=checkpoints/$exp${PREFIX:-}$SLURM_ARRAY_TASK_ID
rm -rf $CHECKPOINTS
#workingdir='/cluster/work/users/mdelhoneux/hit-scir-ucca-parser'
#cd $workingdir

CUDA_DEVICE=0 \
TRAIN_PATH=data/ewt.train.aug.streusle.mrp \
DEV_PATH=data/ewt.dev.aug.streusle.mrp \
BERT_PATH=/cluster/projects/nn9447k/bert/wwm_cased_L-24_H-1024_A-16/ \
LOWER_CASE=FALSE \
SEED=$RANDOM \
BATCH_SIZE=8 \
EPOCHS=50 \
allennlp train \
-s $CHECKPOINTS \
--include-package utils \
--include-package modules \
--include-package metrics \
--file-friendly-logging \
config/$exp.jsonnet "$@"
#config/bert.jsonnet "$@"
#config/bert_feats.jsonnet "$@"
