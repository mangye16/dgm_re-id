import mxnet as mx
import h5py
import numpy as np
import load_args as la
import pdb
from symbol_alexnet import get_symbol
from skimage import io, transform
from os import listdir
from os.path import isfile, join

def PreprocessImage(path, show_img=False, i_round=0, max_n=10000):
    img_list = [f for f in listdir(path) if isfile(join(path,f))]
    start = i_round*max_n
    end = min(start+max_n,len(img_list))
    img_list = img_list[start:end]
    imgs = np.zeros((len(img_list),3,224,224))
    for i_img in range(len(img_list)):
        im_path = join(path,img_list[i_img])
        # load image
        img = io.imread(im_path)
        #print("Original Image Shape: ", img.shape)
        # we crop image from center
        # resize to 224, 224
        resized_img = transform.resize(img, (227, 227))
        if show_img:
            io.imshow(resized_img)
        # convert to numpy.ndarray
        sample = np.asarray(resized_img) #* 255
        # swap axes to make image from (224, 224, 3) to (3, 224, 224)
        sample = np.swapaxes(sample, 0, 2)
        sample = np.swapaxes(sample, 1, 2)

        # sub mean
        #normed_img = sample - mean_img
        normed_img = sample[:,2:2+224, 2:2+224]
        imgs[i_img] = normed_img
        #normed_img.resize(1, 3, 224, 224)
    return imgs

model_prefix = 'model/mars_alexnet'
model_load_epoch = 20

tmp_arg_params, tmp_aux_params = la.load_args(model_prefix, model_load_epoch)
symbol = get_symbol(feature=True)
model = mx.model.FeedForward(symbol, ctx=mx.gpu(0),arg_params=tmp_arg_params,
    aux_params=tmp_aux_params, begin_epoch=model_load_epoch, numpy_batch_size=256,
    allow_extra_params=True)


data_path = '../MARS/bbox_test'
folder_list = listdir(data_path)

max_single_feature = 1000
for folder in folder_list:
    print folder
    imlist = listdir(join(data_path,folder))
    n_image = len(imlist)
    n_round = np.int(np.ceil(np.float(n_image)/max_single_feature))
    feature = np.zeros((n_image,1024))
    for i_round in range(n_round):
        print '    %d round'%i_round
        data = PreprocessImage(join(data_path,folder), i_round=i_round, max_n=max_single_feature)
        start = i_round*max_single_feature
        end = min(start + max_single_feature,n_image)
        feature[start:end] = model.predict(data)
    f = h5py.File('../feature/test/%s.mat'%folder,'w')
    f.create_dataset('feature',data=feature)
    f.create_dataset('imlist', data=imlist)
    f.close()


