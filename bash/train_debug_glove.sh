#!/bin/bash

CHECKPOINTS=checkpoints/ucca_glove_debug
rm -rf $CHECKPOINTS
#workingdir='/cluster/work/users/mdelhoneux/hit-scir-ucca-parser'
#cd $workingdir
#conda activate hit_ucca
# UCCA
CUDA_DEVICE=-1 \
TRAIN_PATH=data/ewt.train.aug.streusle.debug.mrp \
DEV_PATH=data/ewt.dev.aug.streusle.debug.mrp \
PRETRAINED_FILE=glove/glove.6B.100d.txt \
BATCH_SIZE=1 \
allennlp train \
-s $CHECKPOINTS \
--include-package utils \
--include-package modules \
--include-package metrics \
--file-friendly-logging \
config/transition_glove_ucca_debug.jsonnet "$@"
