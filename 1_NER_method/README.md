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

## Results
- The final model can be found under `Model/training/model-best` - Specifying this path allows importing of the spaCy model.
- The cross-validation models can be found under `Model_cv/chunk_x/training/model-best` for respective folds

## Training and validation set

The primary goal of this Named Entity Recognition (NER) model is to identify and annotate the specific tool, instrument, assay method, or kit used to measure the experimental readout within assay descriptions.

The following rules were established to ensure consistency during annotation.

Rule 1: Annotate the Method with Its "Indicator" Term

The method is defined as the tool used to measure the assay readout. These terms are almost always followed by an "indicator" word, which must be included in the annotation.

    Common Indicators: assay, method, analysis, test, scopy, metry, graphy, phoresis, technique, profiling, count(ing/er), experiment.

    Exception: If the indicator is part of an acronym (e.g., ELISA - Enzyme-Linked Immunosorbent Assay), the acronym itself is annotated.

    Example Text:
    Inhibition of IDH1 R132C mutant in human HT1080 cells assessed as inhibition of 2HG production after 48 hrs by LC-MS/MS analysis

    Annotation: LC-MS/MS analysis

    Reasoning: The indicator term analysis is annotated along with the core method LC-MS/MS.

Rule 2: Annotate Exact, Adjacent Terms Only

The annotated entity must be an exact and contiguous phrase from the text. Implied or split methodology terms should not be annotated.

    Example Text:
    Agonist activity at human RXRalpha transfected in human HEK293T cells co-expressing pFR/pRL-Luc at 30 uM incubated for 14 to 16 hrs by hybrid reporter gene assay relative to bexarotene

    Annotation: hybrid reporter gene assay

    Reasoning: Only the adjacent terms describing the method are annotated. Terms related to the specific luciferase reporter (pFR/pRL-Luc) are not captured because they are not adjacent to the main method phrase.

Rule 3: Do Not Annotate Readouts or Endpoints

The final measurement or endpoint (e.g., IC50, Ki, MIC) is not annotated. This data is recorded separately.

    Example Text 1:
    Binding affinity to human recombinant 5-HT2A assessed as inhibition constant

    Annotation: Not annotated. (inhibition constant is an endpoint).

    Example Text 2:
    Potentiation of erythromycin-induced antibacterial activity ... assessed as minimum modulatory concentration

    Annotation: Not annotated. (minimum modulatory concentration is an endpoint).

Rule 4: Annotate Specific Techniques, Not General Aims

Terms that describe the broad experimental goal are not annotated. Only specific method terms that provide additional detail beyond a general category should be captured.

Case 1: General Aim (Not Annotated)

If the description lacks a specific tool or technique and only mentions the general experimental purpose, it is not annotated.

    Example Text:
    Binding affinity determined by measuring its ability to displace [3H]N-0437 radioligand in CHO-K1 cells on Cloned Human Dopamine receptor D2

    Annotation: Not annotated.

    Reasoning: This describes a general "radioligand displacement assay" but does not name a specific, unique technique or instrument used for the measurement.

Case 2: Uninformative Method Terms (Not Annotated)

Method terms that are too generic and don't detail the how of the measurement are not annotated.

    Example Text:
    Displacement of [3H]estradiol from human recombinant estrogen receptor alpha by radiometric assay relative to estradiol.

    Annotation: Not annotated.

    Reasoning: While it includes the indicator assay, the term radiometric assay is too broad and provides no new information about the specific technique used.

Case 3: Informative Method Terms (Annotated)

Even if a method seems general, if it contains a keyword that gives insight into the experimental set-up, it should be annotated.

    Example Text:
    Competitive inhibition of human mTOR using 4EBP1 as substrate ... by filter binding method.

    Annotation: filter binding method

    Reasoning: Although binding method is general, the word filter provides a specific, useful detail about the technique.

Rule 5: Do Not Annotate Substrates (With Exceptions)

Substrates and other chemical entities are generally not annotated, as they are not the "tool" used for measurement.

Exception: A substrate is annotated if it's an integral part of an established technique's name and is adjacent to the method term.

Case 1: Substrate Part of Method Name (Annotated)

    Example Text:
    Agonist activity at human 5HT1A receptor expressed in CHO cells by [35S]GTPgammaS binding assay

    Annotation: [35S]GTPgammaS binding assay

    Reasoning: The substrate [35S]GTPgammaS is integral to the name of this specific and well-known assay type.

Case 2: Substrate Not Adjacent to Method (Not Annotated)

    Example Text:
    Inhibition of CMFDA binding to human N-terminal 6x-His-tagged GSTO1-1 ... measured after 30 mins ... by in-gel fluorescence binding assay

    Annotation: in-gel fluorescence binding assay

    Reasoning: The substrate CMFDA is not annotated because the term is separate from the method description.

Case 3: Substrate with Specific vs. General Method

The annotation depends on whether the substrate is coupled with a specific, informative method.

    Example Text 1 (General):
    Binding constant for DNA by ethidium bromide displacement

    Annotation: Not annotated. (displacement is too general).

    Example Text 2 (Specific):
    ...measured after 6 mins by ethidium bromide staining based agarose gel electrophoresis

    Annotation: ethidium bromide staining based agarose gel electrophoresis

    Reasoning: Here, ethidium bromide is coupled with a highly specific technique, making the entire phrase informative.

Rule 6: Do Not Annotate Supplier Platforms

Supplier names or platforms (e.g., DiscoverX, BMG) are not annotated as the assay method.

    Example Text:
    Inhibition of human CREBBP ... at 10 uM by DiscoverX assay relative to control.

    Annotation: Not annotated.

    Reasoning: DiscoverX is a supplier, not the method itself. The term assay is not specific enough on its own.

Rule 7: Leave Blank if No Method is Provided

If no specific details about the measurement method are provided in the assay description, the entity field is left null.
