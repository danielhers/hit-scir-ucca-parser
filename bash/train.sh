#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=5-0
#SBATCH -p gpu --gres=gpu:titanx:1
#SBATCH --array=1-3%1

# UCCA
CUDA_VISIBLE_DEVICES=0 \
TRAIN_PATH=data/ewt.train.aug.streusle.mrp \
DEV_PATH=data/ewt.dev.aug.streusle.mrp \
BERT_PATH=bert/wwm_cased_L-24_H-1024_A-16 \
WORD_DIM=1024 \
LOWER_CASE=FALSE \
SEED=$RANDOM \
BATCH_SIZE=8 \
allennlp train \
-s checkpoints/ucca_bert${PREFIX:-}$SLURM_ARRAY_TASK_ID \
--include-package utils \
--include-package modules \
--include-package metrics \
--file-friendly-logging \
config/bert.jsonnet "$@"
