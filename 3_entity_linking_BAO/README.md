This part of the pipeline evaluates the text2term package on a Gold Standard of assays manually annotated with experimental methods and BioAssay Ontology ids.
Links for text2term:
- https://pypi.org/project/text2term/
- https://text2term.readthedocs.io/en/latest/#
- https://arxiv.org/abs/2407.02626

Links for BioAssay Ontology:
- https://bioportal.bioontology.org/ontologies/BAO?p=summary
- Abeyruwan, S. et al. Evolving BioAssay Ontology (BAO): modularization, integration and applications. J Biomed Semantics 5, S5 (2014).
https://jbiomedsem.biomedcentral.com/articles/10.1186/2041-1480-5-S1-S5

#### Gold Standard creation
data/BAO_linking_gold_standard.csv
Assays manually annotated with experimental method and BioAssay Ontology IDs (Ontology version 2.8.11). The set of assays is the same as for the training set of the NER model (part 1). It consists of the following assays from ChEMBL 33:
- 300 selected affinity-focused binding assays
- 200 randomly selected human binding assays with target_type SINGLE PROTEIN
- 300 randomly selected functional assays

The assays were manually annotated by ChEMBL biological curators who extracted the experimental method from the assay description and then browsed the BAO ontology to find appropriate BAO terms.
Note that not all of the assays have an experimental method, i.e. sometimes there is no method present in the assay description. In other cases, there may be an experimental method but no suitable BAO id could be identified. Both these types of assays are included in the data file but the respective fields are left blank.

#### Input data:
- data/BAO_linking_gold_standard.csv: 800 assays manually annotated with experimental method and appropriate BAO term (of which 340 assays do not have a method, and 53 have a method but no appropriate BAO id could be found, leaving 407 assays fully annotated with method and BAO id). Out of these 407, 377 assays have exactly 1 BAO term assigned, whereas the rest have 2 or 3 terms assigned per assay to fully describe the experimental method.
- 

#### Pipeline Execution:
1. Install text2term: https://text2term.readthedocs.io/en/latest/#
You can use the requirements file with python venv:
```
python -m venv bao_linking
source bao_linking/bin/activate
pip install -r requirements.txt
```
2. Run `bao_linking_gold_standard.ipynb` (can be run interactivey as dataset is small). This notebooks takes the Gold Standard `data/BAO_linking_gold_standard.csv` file and submits the terms to text2term. The full results are saved to `data/t2t_all_annotations_GS.csv`. Accuracy of the results are first evaluated separately for assays with a single BAO mapping and assays with multiple correct BAO mappings in the Gold Standard, and then combined to plot the overall Precision-Recall curves (saved to the `plots` folder). 

3. Run text2term on all ChEMBL 35 B/F src_id 1 assays. Depending on the minimum Mapping Score (min_score setting in text2term) this takes a little more memory and disk space for the resulting file. Advised to submit as slurm job:
`sbatch submit_slurm_chembl_35_bao_linking.sh`. This then executes the `bao_linking_chembl35.ipynb` notebook (as script). For min_score 0.6, 8GB and 1h was sufficient. For min_score 0.3 need to increase the memory to 16GB.
This creates the file `chembl35_assays_bao_annotations.tsv` (and will append to file with this name, so be careful to remove before rerunning). The current minimum mapping score in the notebook is set to 0.6. Output file was renamed to `chembl35_assays_bao_annotations_0_6.tsv` after running.

4. To get some counts and stats about the ChEMBL35 results, use the `calculate_stats_bao_linking_chembl35.ipynb` notebook interactively. 

#### Results:
- data/t2t_all_annotations_GS.csv: The full output from text2term for the 407 assays from the gold standard
- results/chembl35_assays_bao_annotations_0_6.tsv: BAO annotations for ChEMBL 35 with a mininmum mapping score of 0.6
- plots

