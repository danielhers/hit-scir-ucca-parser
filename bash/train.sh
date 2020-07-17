#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=5-0
#SBATCH -p gpu --gres=gpu:titanrtx:1
#SBATCH --array=1-3%1

exp=$1
CHECKPOINTS=checkpoints/$exp${PREFIX:-}$SLURM_ARRAY_TASK_ID
rm -rf $CHECKPOINTS

CUDA_VISIBLE_DEVICES=0 \
CUDA_DEVICE=0 \
TRAIN_PATH=data/ewt.train.aug.streusle.mrp \
DEV_PATH=data/ewt.dev.aug.streusle.mrp \
BERT_PATH=/science/image/nlp-letre/bert/wwm_cased_L-24_H-1024_A-16/ \
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
config/$exp.jsonnet