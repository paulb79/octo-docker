#! /usr/bin/env bash

conda create -y -n py27 python=2.7 anaconda
conda config --append channels conda-forge 
conda config --append channels auto
conda config --append channels jim-hart


while read requirement; do conda install --name py27 --yes $requirement; done < /opt/setup/requirements.py27.txt

while read requirement; do conda install --name root --yes $requirement; done < /opt/setup/requirements.py36.txt

source activate root
python -m spacy download en