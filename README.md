# assay annotation

## Abstract
Bioactivity data in ChEMBL links compounds to their biological targets via assays that measure biological activity in a given experimental set-up. Provision of assay data enables users to better understand the experimental context and well-annotated assays are therefore key to interpreting results within broader datasets. Here, we describe our current work to apply Natural Language Processing to enrich ChEMBL assay descriptions. A pipeline using  named entity recognition for experimental methods, followed by entity linking to the BioAssay Ontology, provides novel annotations. This is complemented by a high-level assay category based on a multi-class text classification model. These tasks form part of a broader goal to enhance the annotation of entities within ChEMBL and their alignment to relevant ontologies, supporting machine learning approaches by making assay data more AI-ready.

## Background
* Assays describe the experiments performed to test compounds against biological targets
* ChEMBL maps assays to the tested compound, target and bioactivity results. Assays are also mapped to the source document and other biological entities such as tissues and cells
* Assays are broadly classified into assay_type and annotated with a BAO_format

## Goal 
A more granular classification that better addresses user queries. An in-house assay classification pipeline to offer increased consistency over the BAO_format alone and over the assay_type which can be defined by depositors, and is subject to varied interpretation. 

## Development of NLP pipeline for assays descriptions
The pipeline consists of three separate parts:
1. Named entity Recognition (NER) model
2. Classification model for broad assay category
3. Entity linking to Bioassay Ontology (BAO) terms with text2term

Each of these is described further below in this readme and the code is available in the respective folders numbered 1-3.

## Available annotations for ChEMBL 35
- Experimental methods identified by the NER model for all ChEMBL 35 assay descriptions: 1_NER_method/Results/ner_chembl_35.tsv
- Broad assay categories predicted by the broad assay category model for all ChEMBL 35 assay descripions: `2_broad_assay_category/chembl_35_broad_results_processed.txt`
- BAO annotations for ChEMBL 35 assays with a method identified by the NER model and a minimum mapping score of 0.6 returned by the text2term tool: `3_entity_linking_BAO/results/chembl35_assays_bao_annotations_0_6.tsv`

### A. Named entity Recognition (NER) model to identify the specific method entity within the ChEMBL assay descriptions

**Input data:**  
- assays_data.csv : Collection of 800 binding/funtional assays that have been manually reviewed for extraction of the experimental/physical detection method from the assay description. [`1_NER_method/data/assays_data.csv`]

**Intermediate files:**  
- Model/assays_train.jsonl : training set for the NER assays model
- Model_cv/chunkx/assays_train.jsonl : training set for cross-validation (per fold/chunk)
- Model_cv/chunkx/assays_eval.jsonl : testing set for cross-validation (per fold/chunk)


**Pipeline files:**
- ner_assays_runner.ipynb: python notebook to execute the best NER model in desired dataset
- ner_assays_cv.ipynb : python notebook to train the model with 5-fold repeated cross validation.
- ner_assays_model.ipynb : python notebook to train the main model with 100% of data.


**Pipeline Execution:**   
See file 1_NER_method/README.md for more details.


**Results**
- The final model can be found under `1_NER_method/Model/training/model-best` - Specifying this path allows importing of the spaCy model.
- The cross-validation models can be found under `1_NER_method/Model_cv/chunkx/training/model-best` for respective x fold
- Models performances (Precision, Recall, F-score) are in `1_NER_method/Results/cv_metrics.tsv` and in figure `1_NER_method/Results/cross_validation_metrics.png`


Detailed performance of each fold is visualised in 2_broad_assay_category/results/cv_broad_category.png


### B. Classification model for broad assay category
Folder name: 2_broad_assay_category
Trains a multi-class classification model using spaCy for 7 broad assay categories for a given assay description.

**Input data:**
- 2_broad_category_training_data.csv: Collection of 900 assays manually annotated with one of 15 broad assay categories [`2_broad_assay_category/data/2_broad_category_training_data.csv`]

**Intermediate files:**
- Model/assays_train.jsonl: training set for the 7 largest categories
- Model_cv/chunk_x/assays_train.jsonl: training set for cross-validation (per fold/chunk)
- Model_cv/chunk_x/assays_test.jsonl: evaluation set for cross-validation (per fold/chunk)

**Pipeline files:**
- broad_categories_cv.ipynb: Python notebook to perform 5x repeated 5-fold cross-validation (total 25 folds)
- broad_categories_model.ipynb: Python notebook to train model with 100% of the data
- plot_cv_results.ipynb: Calculate average performances across the 25 folds and create boxplot of individual fold performance

**Pipeline Execution:**   
See the instructions in the `2_broad_assay_category/2_broad_category_readme.md`

**Results:**
- The final model can be found under `2_broad_assay_category/Model/training/model-best` - Specifying this path allows importing of the spaCy model.
- The cross-validation models can be found under `2_broad_assay_category/Model_cv/chunk_x/training/model-best` for respective folds
- Average performances (Precision, Recall, F-score) are in `2_broad_assay_category/results/average_performance.csv`
- Detailed performance of each fold is visualised in `2_broad_assay_category/results/cv_broad_category.png`

### C. Entity linking to Bioassay Ontology (BAO) terms with text2term

#### Input data:
- BAO_linking_gold_standard.csv: 800 assays manually annotated with experimental method and appropriate BAO term (of which 340 assays do not have a method, and 53 have a method but no appropriate BAO id could be found, leaving 407 assays fully annotated with method and BAO id). [`3_entity_linking_BAO/data/BAO_linking_gold_standard.csv`]

#### Pipeline Execution:
Install text2term: https://text2term.readthedocs.io/en/latest/#
You can use the requirements file with python venv: 
```
python -m venv bao_linking
source bao_linking/bin/activate
pip install -r requirements.txt
```
- Run bao_linking.ipynb

#### Results:
- data/t2t_all_annotations_GS.csv: The full output from text2term for the 407 assays from the gold standard.
- plots: Plots about the gold standard performance saved by the bao_linking.ipynb
