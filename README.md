# inclinet_production_repo

![ML_model_generation](https://user-images.githubusercontent.com/13570487/133544222-479ff447-34cd-4a5e-af1b-db8ffb83a68f.png)

## Main Components:

1. **data_prep.py**
    - This code is mainly used to **downsize (downsample)** images that are stored in a specified folder.
    - The application of this code is represented by *green* arrows in the above block diagram.
    - The output folder is in the form of `<size>_<size>_<band>`
    - The output files are in `pgc<xxx>_<size>x<size>_<inc>.<band>.jpg` format.
    - *inc* is the measured inclinations of the galaxy taken from the `catalog.csv`
    - Further help on how to run this code becomes available using `-h` directive.
    - `python data_prep.py -h`

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