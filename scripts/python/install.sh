#! /usr/bin/env bash

conda config --append channels conda-forge 
conda config --append channels auto
conda config --append channels jim-hart


while read requirement; do conda install --name py27 --yes $requirement; done < ./requirements.py27.txt

while read requirement; do conda install --name root --yes $requirement; done < ./requirements.py36.txt
