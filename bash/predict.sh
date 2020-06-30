#!/bin/bash
#SBATCH --mem=30G
#SBATCH --time=0-1
#SBATCH --array=1-3

# UCCA
for split in dev test; do
  allennlp predict \
  --cuda-device -1 \
  --output-file data/ucca-output$SLURM_ARRAY_TASK_ID.$split.streusle.mrp \
  --predictor transition_predictor_ucca \
  --include-package utils \
  --include-package modules \
  --include-package metrics \
  --use-dataset-reader \
  --batch-size 32 \
  --silent \
  checkpoints/ucca_bert${PREFIX:-}$SLURM_ARRAY_TASK_ID \
  data/ewt.$split.aug.streusle.mrp

  mkdir -p data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split
  for i in 1 2; do # workaround - do it twice for it to work
    python toolkit/mtool/main.py data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split.mrp data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split.xml --read mrp --write ucca && break
  done
  csplit -zk data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split.xml '/^<root/' -f '' -b "data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split/%03d.xml" {553}
  python toolkit/evaluate_standard.py data/ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.dev data/ewt/dev -q --summary-file ucca-output${PREFIX:-}$SLURM_ARRAY_TASK_ID.dev.scores.txt
done
