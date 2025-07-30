# Classifying assay descriptions into broad categories
Trains a multi-class classification model using spaCy for 7 broad assay categories for a given assay description.

### Training data
- data/2_broad_category_all_annotated.csv: Collection of 900 assays manually annotated with one of 15 broad assay categories
- data/2_broad_category_training_data.csv: Assays actually used for training (categories with enough assays only)
- data/dataset_counts.csv: Summarises the number of assays per category in the manually annotated dataset

### Setup
**Virtual enviroment**
This virtual environment is for running the notebooks for part 2 (broad assay category).
Create and activate the venv, then install the requirements using pip.

```
module load python/3.11.7
python -m venv assays_venv
source assays_venv/bin/activate
pip install -r requirements.txt
```

**Queries to ChEMBL database**
Some queries to the ChEMBL database are required within the pipeline. For that we use the module sqlite3 which comes included in the standard library (since Python 2.5). The sqlite engine needs to load the ChEMBL dump which can be downloaded from https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/. For EBI internal use, the dump can be found in the ChEMBL release.


### Pipeline
1. Train the main model with 100% of the data by running the `broad_categories_model.ipynb`. Recommend using slurm like `sbatch submit_slurm_model.sh`.
2. Perform repeated 5-fold cross-validation by running the `broad_categories_cv.ipynb`. Recommend using slurm like `sbatch submit_slurm_cv.sh`.
3. Calculate cross-validation performance by running `plot_cv_results.ipynb`, which saves the results to `results/average_performance.csv` and `results/cv_broad_category.png`
4. Download all B and F assays from ChEMBL 35 and use the model to predict a broad category with `chembl_35_broad_predictions.ipynb` submitted by `submit_slurm_chembl_35.sh` using `sbatch submit_slurm_chembl_35.sh`
5. Process the results, namely extracting the category with highest prediction score, using the `chembl_35_process_results.ipynb` notebook, which produces `chembl_35_broad_results_processed.txt` (use 8GB on cluster interactive job)
6. Investigate results and create plots for ChEMBL 35 using `chembl_35_plot_results.ipynb`

### Options for running notebooks on cluster
#### Run interactively
1. Make sure currently activated venv (such as per requirements) has jupyter installed
2. Request interactive allocation on slurm, e.g. for 30 minutes:: `salloc -p research --cpus-per-task=2 --mem=2G --time=0:30:00`
3. Run `jupyter notebook --ip 0.0.0.0` to start the notebook and copy the URL with remote server name in it to local browser
#### Submit to slurm
See `submit_slurm_model.sh` and `submit_slurm_cv.sh`, make sure to adjust email address in script.
Then submit using `sbatch submit_slurm_model.sh`.

### Run times
Per current details in `submit_slurm_model.sh` and `submit_slurm_cv.sh` running times for training the models were 15 minutes and 3:30h respectively.
Executing the model on 1.17M assays from ChEMBL 35 (submit_slurm_chembl_35.sh) took ~1h.

### Results
- The final model can be found under `Model/training/model-best` - Specifying this path allows importing of the spaCy model.
- The cross-validation models can be found under `Model_cv/chunk_x/training/model-best` for respective folds
- Average performances (Precision, Recall, F-score) are in `results/average_performance.csv`
- Detailed performance of each fold is visualised in `results/cv_broad_category.png`

### Validation
In the`validation` folder are various files and notebooks relating to the independent validation set of 200 assays from ChEMBL35, as well as the additional set of 50 nucleic acid binding assays that were inspected. Some plots are created here too.

#### Curation of the broad assay category

To broadly assign assays to categories, assay descriptions were reviewed and annotated with one of 15 labels that reflected the most common assay set-up for binding and functional assays. 

- Protein activity
- Binding affinity, displacement, competition
- Radioligand competition, displacement, binding
- Cell phenotype
- Antimicrobial activity
- In vivo method
- Nucleic acid binding
- Whole-organism assay
- Antioxidant activity
- Protein-protein interaction assay
- Stimulation of binding
- Binding/activity - mixed measurements
- Tissue based assay
- Prodrug metabolism
- Unclear

Categories were then mapped to the closest label from the Bioassay Ontology.

| Assay Category                                    | BAO Preferred Term                 | BAO ID            |
|-----------------------------------------------|--------------------------------|-------------------|
| Whole-organism assay                         | NaN          | NaN       |
| Tissue based assay                           | NaN            | NaN       |
| Antioxidant activity                         | NaN | NaN       |
| Cell phenotype                                | cell phenotype                 | BAO_0002542       |
| Radioligand competition, displacement, binding | radioligand binding assay      | BAO_0002776       |
| Binding affinity, displacement, competition   | binding assay                  | BAO_0002989       |
| Protein-protein interaction assay            | NaN | NaN    |
| Protein activity                              | functional target-based        | BAO_0013016       |
| In vivo method                               | in vivo assay method           | BAO_0040021       |
| Nucleic acid binding                         | NaN                            | No suitable ID at present |
| Antimicrobial activity                       | NaN                            | No suitable ID at present |
| Binding/activity - mixed measurements        | NaN                            | NaN               |
| Stimulation of binding                        | NaN                            | NaN               |
| Prodrug metabolism                           | NaN                            | NaN               |
| Unclear                                            | NaN                            | NaN               |

Assays with conflicting terms or where the set-up was ambiguous were assigned as unclear. For example, "Inhibition of human recombinant NTS1 receptor at 10 uM by radioligand binding assay" contains conflicting terms referring to enzyme activity (inhibition) and also to binding methods (radioligand binding assay). Other examples include the assay "
Inhibition of RTK/PI3K/AKT/mTOR signaling in human U87 cells assessed as down regulation of TRAF4 gene expression at cytotoxic IC50 measured after 48 hrs relative to control" where it was unclear if this was a functional target-based or a cell phenotypic assay.

Overall, categories such as the "cell phenotype" group include cytotoxicity, cell metabolism and other assays measuring cellular changes to protein expression. The "functional target-based" category includes enzyme activity, receptor signalling and other assays where a change in function, as a result of compound-target interactions, is measured. Notably, the annotation is somewhat dependent on the structure of the assay description and overlap is possible. For instance, target-based functional assays performed in cells could have a phenotypic readout and be classified as either "target-based functional" or "cell phenotypic" depending on the structure of the assay description. Imprecise wording or atypical assay set-up may also effect categorisation; the assay "Minimum protective concentration against beta-lactamase in Staphylococcus aureus (95 strain)" uses terms often found within in vivo assays (minimum protective concentration) but is most likely a functional target-based assay. Similar categories such as the whole-organism assay and the in vivo assay category were used to differentiate in vivo assays with model organism to other whole-organism assays with plants or microorganisms (that didn't belong to the antimicrobial category and were not classed as cell phenotype changes). 

In addition to potentially overlapping assays, other challenges included differentiating assays where the information in assay descriptions was insufficient to determine if assays were simply binding or functional. The binding and target-based functional assays categories were the most difficult to differentiate. Some compromises were made such as antagonist assays being assigned to the "protein activity" group since the direction of the effect is recorded although the assay could be binding or functional.
