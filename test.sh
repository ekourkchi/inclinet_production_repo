python data_prep.py -p ./galaxies/ -b g -c catalogs/catalog.csv  -v
python data_prep.py -p ./galaxies/ -b r -c catalogs/catalog.csv  -v
python data_prep.py -p ./galaxies/ -b i -c catalogs/catalog.csv  -v
python data_prep.py -p ./galaxies/ -b gri -c catalogs/catalog.csv  -v

python data_compress.py -i 128x128_g -o compressed -s 128 -v
python data_compress.py -i 128x128_r -o compressed -s 128 -v
python data_compress.py -i 128x128_i -o compressed -s 128 -v
python data_compress.py -i 128x128_RGB -o compressed -s 128 -v

python data_split.py -i ./compressed/ -o samples/ -n 3 -v