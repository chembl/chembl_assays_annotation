#!/bin/bash
#SBATCH --ntasks=1
#SBATCH -t 4:30:00
#SBATCH --mem=6G
#SBATCH --mail-user ines@ebi.ac.uk
#SBATCH --mail-type ALL
source /hps/software/users/chembl/ines/assays_description/bin/activate
jupyter nbconvert --to notebook --execute broad_categories_cv.ipynb





