To replicate the experiments described in the paper,

1. Install requirements:
```
pip install -r requirements.txt
```
2. Get, convert and split the data:
```
cd data
make split
```
3. Train the models:
```
slurm bash/train_saga.sh bert
slurm bash/train_saga.sh bert_feats
slurm bash/train_saga.sh feats
slurm bash/train_saga.sh glove
slurm bash/train_saga.sh glove_feats
```
4. Evaluate the models:
```
slurm bash/predict_saga.sh bert
slurm bash/predict_saga.sh bert_feats
slurm bash/predict_saga.sh feats
slurm bash/predict_saga.sh glove
slurm bash/predict_saga.sh glove_feats
```
