#!/bin/bash
#SBATCH --account=nn9447k
#SBATCH --mem=30G
#SBATCH --time=0-1
#SBATCH --array=1-3

# UCCA
exp=$1
for split in dev test; do
  allennlp predict \
  --cuda-device -1 \
  --output-file data/$exp$SLURM_ARRAY_TASK_ID.$split.streusle.mrp \
  --predictor transition_predictor_ucca \
  --include-package utils \
  --include-package modules \
  --include-package metrics \
  --use-dataset-reader \
  --batch-size 32 \
  checkpoints/$exp${PREFIX:-}$SLURM_ARRAY_TASK_ID \
  data/ewt.$split.aug.streusle.mrp

  mkdir -p data/$exp${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split
  for i in 1 2; do # workaround - do it twice for it to work
      python toolkit/mtool/main.py data/$exp${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split.streusle.mrp data/$exp${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split.xml --read mrp --write ucca
  done
  csplit -zk data/$exp${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split.xml '/^<root/' -f '' -b "data/$exp${PREFIX:-}$SLURM_ARRAY_TASK_ID.$split/%03d.xml" {553}
  python -m semstr.evaluate data/$exp${PREFIX:-}$SLURM_ARRAY_TASK_ID.dev data/ewt/dev -qs $exp${PREFIX:-}$SLURM_ARRAY_TASK_ID.dev.scores.txt
done
