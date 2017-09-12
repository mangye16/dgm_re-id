#!/usr/bin/sh

python train_mars.py --model-prefix model/mars_alexnet --save-model-prefix model/mars_alexnet --gpus 0,1,2,3 --log-file mars_alexnet --batch-size 256 --lr 0.01 --train-dataset mars_new_train.rec

