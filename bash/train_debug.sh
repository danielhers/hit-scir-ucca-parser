#!/bin/bash
#SBATCH --account=nn9447k
#SBATCH --mem=30G
#SBATCH --time=0-2

CHECKPOINTS=checkpoints/debug
rm -rf $CHECKPOINTS
#workingdir='/cluster/work/users/mdelhoneux/hit-scir-ucca-parser'
#cd $workingdir

# UCCA
#BERT_PATH=/cluster/projects/nn9447k/bert/wwm_cased_L-24_H-1024_A-16/ \
PRETRAINED_FILE=glove/glove.6B.100d.txt \
TRAIN_PATH=data/ewt.train.aug.streusle.debug.mrp \
DEV_PATH=data/ewt.dev.aug.streusle.debug.mrp \
LOWER_CASE=FALSE \
BATCH_SIZE=1 \
EPOCHS=1 \
CUDA_DEVICE=-1 \
SEED=$RANDOM \
allennlp train \
-s $CHECKPOINTS \
--include-package utils \
--include-package modules \
--include-package metrics \
--file-friendly-logging \
config/transition_glove_ucca.jsonnet "$@"
#config/transition_glove_feats.jsonnet "$@"
#config/transition_bert_ucca.jsonnet "$@"
#config/all_feats.jsonnet "$@"
#config/transition_bert_feats.jsonnet "$@"
