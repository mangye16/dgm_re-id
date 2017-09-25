## Dynamic Label Graph Matching for Unsupervised Video Re-Identification

Demo code for [Dynamic Label Graph Matching for Unsupervised Video Re-Identification](http://www.comp.hkbu.edu.hk/~mangye/files/iccv17dgm2.pdf) in ICCV 2017.




We revised the evaluation proctocal for the IDE on MARS dataset. In previous version, due to file traverse problem, which leads a different evaluation proctol, we achieve an extremely high performance (Unsupervised rank-1 65.2%, and supervised 75.8%) compared with other baselines . We re-evaluate our perfomance under standard settings, the rank-1 is 36.8% for our unsupervised method, and the supervised upper bound is 56.2%. [PDF](http://www.comp.hkbu.edu.hk/~mangye/files/iccv17dgm2.pdf)

### 1. Test on PRID-2011 and iLIDS-VID datasets.


 - a. You need to download our extracted features LOMO on [BaiduYun](https://pan.baidu.com/s/1b7UwbW) and [GoogleDrive](https://drive.google.com/open?id=0BxD9a73ckQ0vVzVWTkhmc2NSLTA) or extract features by yourself. Put it under "data/" folder

 - b. You could run the *demo_dgm.m* and edit it to adjust for different datsets and different settings. 

### Results
- LOMO on PRID-2011 and iLIDS-VID

|Datasets | Rank@1 | Rank@5 | Rank@10 |
| --------   | -----  | ---- | ----  |
|#PRID-2011  | 73.1% | 92.5% | 96.7% |
|#iLIDS-VID | 37.1% | 61.3% | 72.2% |


### 2. Test on MARS dataset.

Notes: Due to the random graph generation, the results may be slighlty different.

 - a. You need to download our extracted features LOMO on [BaiduYun](https://pan.baidu.com/s/1b7UwbW) and [GoogleDrive](https://drive.google.com/open?id=0BxD9a73ckQ0vVzVWTkhmc2NSLTA) or extract features by yourself. Put it under "data/" folder

 - b. You could run the *demo_mars.m* and edit it to adjust for different settings. Meanwhile, we could get the estimated labels.

 - c. With the estimated labels, we could re-arrange the dataset for IDE training. 

 - d. Train IDE with our provided code follow the [steps](https://github.com/apache/incubator-mxnet/tree/master/example/image-classification) based on mxNet or try the baseline provided by [Zhun Zhong](https://github.com/zhunzhong07/IDE-baseline-Market-1501).

We provide our trained models on [BaiduYun](https://pan.baidu.com/s/1qYPYXa8) and [GoogleDrive](https://drive.google.com/open?id=0BxD9a73ckQ0vYktDNllndzdpTXc) for unsupervised and supervised baseline.


### Results
- On MARS dataset

|Methods | Rank@1 | Rank@5 | mAP |
| --------   | -----  | ---- | ----  |
|#LOMO  | 24.6% | 42.6% | 11.8% |
|#IDE | 36.8% | 54.0% | 21.3% |


### Citation
Please cite this paper in your publications if it helps your research:
```
@inproceedings{iccv17dgm,
  title={Dynamic Label Graph Matching for Unsupervised Video Re-Identification},
  author={Ye, Mang and Ma, Andy J and Zheng, Liang and Li, Jiawei and Yuen, Pong C.},
  booktitle={ICCV},
  year={2017},
}
```

Contact: mangye@comp.hkbu.edu.hk
