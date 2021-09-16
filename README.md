# inclinet_production_repo

## Main Components:

1. data_prep.py
    - This code is mainly used to downsize images that are stored in a specifi folder.
    - The output folder is in the form of `<size>_<size>_<band>`
    - The output files are in `pgc<xxx>_<size>x<size>_<inc>.<band>.jpg` format.
    - *inc* is the measured inlinclination of the galaxy taken from the `catalog.csv`
    - Further help on how to run this code becomes available using `-h` directive.
    - `python data_prep.py -h`

    '
        Usage: 

        - Resizing the original images that reside in a specific folder (image_path), e.g. ./galaxies
        - File names are formated as pgc<xxx>_<image_root>_<image_root>_<band>.png
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

    '
