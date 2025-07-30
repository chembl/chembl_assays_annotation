#!/bin/bash
#SBATCH --ntasks=1
#SBATCH -t 0:30:00
#SBATCH --mem=4G
#SBATCH --mail-user adasme@ebi.ac.uk
#SBATCH --mail-type ALL
source /hps/software/users/chembl/adasme/assays_description/bin/activate
jupyter nbconvert --to notebook --execute ner_assays_model.ipynb





