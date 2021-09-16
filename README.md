# inclinet_production_repo

![ML_model_generation](https://user-images.githubusercontent.com/13570487/133544222-479ff447-34cd-4a5e-af1b-db8ffb83a68f.png)

## Orchestration

- **test.sh**
    - This bash script runs the pipeline end-to-end from data preparation building the CNN models


## Main Components:

1. **data_prep.py**
    - This code is mainly used to **downsize (downsample)** images that are stored in a specified folder.
    - The output folder is in the form of `<size>_<size>_<band>`
    - The output files are in `pgc<xxx>_<size>x<size>_<inc>.<band>.jpg` format.
    - *inc* is the measured inclinations of the galaxy taken from the `catalog.csv`
    - Further help on how to run this code becomes available using `-h` directive.

```    
        $ python data_compress.py -h

        Usage: 

        - Resizing the original images that reside in a specific folder (image_path), e.g. ./galaxies
        - File names are formatted as pgc<xxx>_<image_root>_<image_root>_<band>.png
        - or pgc<xxx>_<image_root>_<image_root>_gri.sdss.jpg (directly from the SDSS server)
        - or pgc<xxx>_<image_root>_<image_root>_gri.jpg (processed locally)
        - <xxx> stands for the ID of galaxy

        - bands: They specify the desired waveband: 'g', 'r', 'i' for grayscale, and 'gri' for colorful
        
        - How to run: 
        
            $ data_prep.py -p <image_path> -r <image_root> -b <band> -c <catalog_name] -s <output_size> -v <verbose>
        
        - Example:
            $ python data_prep.py -p ./galaxies/ -r d25x2_rot -c catalogs/catalog.csv -b gri -s 64 -v

            This looks for images like:
                galaxies/pgc44182_d25x2_rot_gri.sdss.jpg
                or 
                galaxies/pgc44182_d25x2_rot_gri.jpg


            $ python data_prep.py --catalog catalogs/catalog.csv --band i

            This requires images like:
                galaxies/pgc44182_d25x2_rot_i.png


            
        - Author: "Ehsan Kourkchi"
        - Copyright 2021


        Options:
        -h, --help            show this help message and exit
        -p IMPATH, --impath=IMPATH
                                images path
        -r IMROOT, --imroot=IMROOT
                                images name root
        -c CATALOG, --catalog=CATALOG
                                catalog name, e.g. catalog.csv
        -b BAND, --band=BAND   waveband, e.g. "g", "r", or  "i"
        -s SIZE, --size=SIZE  number of pixels on each side (e.g. 128)
        -v, --verbose         verbose (default=False)
```
    

2. **data_compress.py**
    - compressing images of a folder that are all in the same size
    - the output compressed file is provided in `npz` format

```
        $ python data_compress.py -h

        Usage: 

        - Compressing all images in a folder
        - all images must have have the same size provided in the command line
        - make sure that the output folder exists, otherwise this code doesn't work

        - How to run: 
        
            $ data_compress.py -i <input_folder_path> -o <output_folder_path> -s <image_size> -v <verbose>
        
        - Example:
            $ python data_compress.py -i 128x128_RGB -o compressed -s 128 -v

        
        - Author: "Ehsan Kourkchi"
        - Copyright 2021


        Options:
        -h, --help            show this help message and exit
        -i INFOLDER, --infolder=INFOLDER
                                folder of resized images
        -s SIZE, --size=SIZE  number of pixels on each side (e.g. 128)
        -o OUTFOLDER, --outfolder=OUTFOLDER
                                the path of the output folder
        -v, --verbose         verbose (default=False)
```

3. **data_split.py**

This code takes the `npz` file at each filter, e.g. `data_128x128_g_originals.npz`, and splits the data into training and testing batches.

10% of all galaxies with inclinations greater than 45 degrees are set aside for the testing purpose in file `<outFileRoot>test_000.npz`.

The entire training set is also stored under the name of `<outFileRoot>train_000.npz`. To perform extra analysis (like bagging), sub-samples of the training set are generated, with the size of 67% of the entire training sample size. The number of sub-sample is set to m_iter=3, by default. Each of the sub-samples are stored in `<outFileRoot>train_<iter>.npz`, where `<outFileRoot>` is the root name of the output files, and `<iter>` is sub-sample iteration number.

**Note** that sub-samples overlap as each contain 2/3 of the data drawn randomly from the mother sample, whereas the test sample doesn't overlap with any of the training sub-samples.

```
        $ python data_split.py -h

        Usage: 

        - generating multiple data samples, each set is spitted to training/testing subsets
        - testing sample doesn't overlap with any of the training samples

        - How to run: 
        
            $ data_split.py -i <input_folder_path> -o <output_folder_path> -s <image_size> -n <m_iter> -v <verbose>

            - m_iter is the number of subsamples, each with the size of 67% of the entire dataset
        
        - Example:
            $ python data_split.py -i ./compressed/ -o samples/ -n 3 -v

            - output format for 128x128 images:
                - <band>_128x128_test_000.npz
                - <band>_128x128_train_000.npz

                - <band>_128x128_test_xxx.npz   (67% of data)
                - <band>_128x128_train_xxx.npz  (67% of data)
                where <xxx> is the iteration number. 

        
        - Author: "Ehsan Kourkchi"
        - Copyright 2021


        Options:
        -h, --help            show this help message and exit
        -i INFOLDER, --infolder=INFOLDER
                                folder of resized images
        -s SIZE, --size=SIZE  number of pixels on each side (e.g. 128)
        -o OUTFOLDER, --outfolder=OUTFOLDER
                                the path of the output folder
        -n NITER, --niter=NITER
                                number of iterations
        -v, --verbose         verbose (default=False)
```

4. **data_augment_uniform.py**

- Generating augmented samples with uniform distribution of inclination
- The augmented samples are stored as batches for a later use in the training process
    - The training batches are generated using this code. Each batch consists of the same number of grayscale and colorful images.
    - Half of the grayscale images are inverted to avoid overfitting

```
    $ python data_augment_uniform.py -h

    Usage: 

    - Augmenting training sets and storing them on the disk to be used during the traning process
    - Generating augmented samples with uniform distribution of inclinations 

    - How to run: 
    
        $ data_augment_uniform.py -i <input_folder_path> -o <output_folder_path> -s <image_size> 
            -n <m_iter> -b <n_batches> -z <batch_size> -v <verbose>

        - m_iter is the number of subsamples, each with the size of 67% of the entire dataset
        - All arrays of images are taken, and they are divided into the inclination bins of size 5, starting at 45 degrees. 
        - Each of the 5-degree sub-samples are augmented separately
        - <batch_size>=1000 means that each of the 5 degree intervals have 1,000 galaxies after the augmentation process.
    
    - Example:
        $ python data_augment_uniform.py -i samples -o augmented -s 128 -n 3 -b 5 -v

        - output format for 128x128 images:
            - <band>_128x128_test_000.npz
            - <band>_128x128_train_000.npz

            - <band>_128x128_test_xxx.npz   (67% of data)
            - <band>_128x128_train_xxx.npz  (67% of data)
            where <xxx> is the iteration number. 

    
    - Author: "Ehsan Kourkchi"
    - Copyright 2021


    Options:
    -h, --help            show this help message and exit
    -i INFOLDER, --infolder=INFOLDER
                            folder of resized images
    -s SIZE, --size=SIZE  number of pixels on each side (e.g. 128)
    -o OUTFOLDER, --outfolder=OUTFOLDER
                            the path of the output folder
    -n NITER, --niter=NITER
                            number of iterations
    -b NBATCH, --nbatch=NBATCH
                            number of batches
    -z BATCHSIZE, --batchsize=BATCHSIZE
                                                The nominal size of batches
                            within each 5 degrees of inclnation interval.
                            Total size is estimated to be 18*batchsize in full
                            production.
    -v, --verbose         verbose (default=False)

```
