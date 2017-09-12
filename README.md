## Dynamic Label Graph Matching for Unsupervised Video Re-Identification

Demo code for [Dynamic Label Graph Matching for Unsupervised Video Re-Identification](http://www.comp.hkbu.edu.hk/~mangye/) in ICCV 2017.




We revised the evaluation proctocal for the IDE on MARS dataset. In previous version, due to file traverse problem, which leads a different evaluation proctol, we achieve an extremely high performance (Unsupervised rank-1 65.2%, and supervised 75.8%) compared with other baselines . We re-evaluate our perfomance under standard settings, the rank-1 is 36.8% for our unsupervised method, and the supervised upper bound is 56.2%.

### 1. Test on PRID-2011 and iLIDS-VID datasets.


 - a. You need to download our extracted features [LOMO](https://drive.google.com/open?id=0BxD9a73ckQ0vVzVWTkhmc2NSLTA) or extract features by yourself. Put it under data/ folder

 - b. You could run the *demo_dgm.m* and edit it to adjust for different datsets and different settings. 




### 2. Test on MARS dataset.

Notes: Due to the random graph generation, the results may be slighlty different.

 - a. You need to download our extracted features [LOMO](https://drive.google.com/open?id=0BxD9a73ckQ0vVzVWTkhmc2NSLTA) or extract features by yourself. Put it under data/ folder

 - b. You could run the *demo_mars.m* and edit it to adjust for different datsets and different settings. Meanwhile, we could get the estimated labels.

 - c. With the estimated labels, we could re-arrange the dataset for IDE training. 

 - d. Train IDE with our provided code follow the [steps](https://github.com/apache/incubator-mxnet/tree/master/example/image-classification) or try the baseline provided by [Zhun Zhong](https://github.com/zhunzhong07/IDE-baseline-Market-1501).

We provide our trained models
[Unuspervised](https://drive.google.com/open?id=0BxD9a73ckQ0vYktDNllndzdpTXc)-----[Supervised](https://drive.google.com/open?id=0BxD9a73ckQ0vYktDNllndzdpTXc)


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
