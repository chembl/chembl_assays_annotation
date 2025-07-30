#!/bin/bash
#SBATCH --ntasks=1
#SBATCH -t 1:00:00
#SBATCH --mem=8G
#SBATCH --mail-user ines@ebi.ac.uk
#SBATCH --mail-type ALL
source /hps/software/users/chembl/ines/bao_linking/bin/activate
jupyter nbconvert --to script bao_linking_chembl35.ipynb 
python bao_linking_chembl35.py 

