# Named entity Recognition (NER) model to identify the method from the ChEMBL assay descriptions.
The goal for the NER model is to annotate the tool, instrument, assay method or kit employed to measure the experimental read-out.

### Input data 
- assays_data.csv : Collection of 800 binding/funtional assays that have been manually reviewed for extraction of the experimental/physical detection method from the assay description.

### Intermediate files
- assays_eval.jsonl : testing set
- assays_train.jsonl : training set 


### Pipeline notebooks
- ner_assays_runner.ipynb: python notebook to execute the best NER model in desired dataset
- ner_assays_cv.ipynb : python notebook to train the model with 5-fold repeated cross validation.
- ner_assays_model.ipynb : python notebook to train the main model with 100% of data.


### Directories
- data: folder with the input data
- Model: folder with the resulting files for main model training (100% of input data)
- Model_cv: folder with the resulting files for repeated cross-validation 
- ner_assays: folder with weasel pipeline for SpaCy NER model training
- Results: folder containing results from corss validation, NER model execution in ChEMBL35, and sample data.
    -Sample: folder containing a subset of the NER model in chembl35 in multiple variations: just assays information for blind annotations, assays with ner predictions, assays with curators annotations.
- ner_assays_runner.ipynb: python notebook to execute the best NER model in desired dataset
- ner_assays_cv.ipynb: python notebook to run cross-validation on input annotated data (training/testing set)
- ner_assays_model.ipynb: python notebook to train main model in 100% of annotated data
- ner_assays_results.ipynb: python notebook to evaluate model results and generate some numbers and stats
- requirements.txt: required packages and modules 

### Main utput files in Results folder
- cv_metrics.csv: precision, recal, and F-score values from cross validation
- ner_chembl_35.tsv: binding and functional assays from chembl 35 with the predicted method by the NER model
- ner_chembl_35_sample_subset_evaluation.tsv: B/F stratified subset with 200 randomly selected assays from the ner_chembl_35.tsv file (excluding any assays used for training the NER or broad classification model) which has been blindly annotated with the method to compare predicted vs annotated and evaluate model's performance.


### Setup
**Virtual enviroment**  
This virtual environment is for running the notebooks.  
Create and activate the venv, then install the requirements using pip.

```
module load python/3.12.3 
python -m venv assays_description
source assays_description/bin/activate
pip install -r requirements.txt
```

**Spacy language model**  
The NER model, requires the spacy en_core_web_md model in the specific version 3.7.1, which needs to be loaded from github while setting up the enviroment. 

```
pip install spacy
pip install https://github.com/explosion/spacy-models/releases/download/en_core_web_md-3.7.1/en_core_web_md-3.7.1.tar.gz
```

### Options for running notebooks on cluster
**Run interactively**
1. Make sure currently activated venv (such as per requirements) has jupyter installed
2. Request interactive allocation on slurm, e.g. for 30 minutes:: `salloc -p research --cpus-per-task=2 --mem=2G --time=0:30:00`
3. Run `jupyter notebook --ip 0.0.0.0` to start the notebook and copy the URL with remote server name in it to local brows


**Submit to slurm**  
It requires nbcovert package so make sure to install it in the enviroment.

You can use pip:
```
pip install nbconvert
```

The files `submit_slurm_model.sh` and `submit_slurm_cv.sh` will train main model and cross validation respectively. 

They can be execute with sbatch command:
```
sbatch submit_slurm_model.sh
```

The file `submit_slurm_ner_assays.sh` will execute best model in desired dataset. 

They can be execute with sbatch command:
```
sbatch submit_slurm_ner_assays.sh
```

**Run times**  
Per current details in `submit_slurm_model.sh` and `submit_slurm_cv.sh` running times for training the models were xx and 4h respectively.

**Results**
- The final model can be found under `Model/training/model-best` - Specifying this path allows importing of the spaCy model.
- The cross-validation models can be found under `Model_cv/chunk_x/training/model-best` for respective folds