#!/bin/bash

# UCCA
CUDA_VISIBLE_DEVICES=0 \
TRAIN_PATH=data/ucca-train.mrp \
DEV_PATH=data/ucca-dev.mrp \
PRETRAINED_FILE=glove/glove.6B.100d.txt \
SEED=$RANDOM \
BATCH_SIZE=32 \
allennlp train \
-s checkpoints/ucca_glove \
--include-package utils \
--include-package modules \
--file-friendly-logging \
config/glove.jsonnet

