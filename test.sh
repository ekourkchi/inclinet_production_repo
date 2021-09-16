
rm -rf compressed
rm -rf samples
rm -rf augmented
mkdir samples
mkdir compressed
mkdir augmented

## resizing
python data_prep.py -p ./galaxies/ -b g -c catalogs/catalog.csv -s 128   -v
python data_prep.py -p ./galaxies/ -b r -c catalogs/catalog.csv -s 128   -v
python data_prep.py -p ./galaxies/ -b i -c catalogs/catalog.csv -s 128   -v
python data_prep.py -p ./galaxies/ -b gri -c catalogs/catalog.csv -s 128   -v


## data compression (generating npz files)
python data_compress.py -i 128x128_g -o compressed -s 128 -v
python data_compress.py -i 128x128_r -o compressed -s 128 -v
python data_compress.py -i 128x128_i -o compressed -s 128 -v
python data_compress.py -i 128x128_RGB -o compressed -s 128 -v

## train/test splits
python data_split.py -i ./compressed/ -o samples/ -n 3 -v

## data augmentation (making the sample uniform over the full range of inclinations)
python data_augment_uniform.py -i samples -o augmented -s 128 -n 3 -b 5 -v