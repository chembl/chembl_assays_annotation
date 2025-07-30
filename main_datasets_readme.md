## ChEMBL 35 annotations
Two files:
- main_ner_bao_chembl_35.tsv: Assays with experimental method and BioAssay Ontology (BAO) annotations
- main_broad_category_chembl_35.tsv: Assays with predicted high-level assay category

#### ChEMBL 35 Assays with Experimental Method and BAO Annotation

This file contains a dataset of assay descriptions from ChEMBL release 35, enriched with annotations pertaining to their experimental methods. Each assay description has been linked to a corresponding BioAssay Ontology (BAO) term, providing a standardized and machine-readable representation of the experimental methodology. 
To provide comprehensive context for each entry, the dataset includes various metadata points from ChEMBL 35 and new annotations from the NER method and BAO linking pipeline proposed in this project.

##### File Contents

The dataset is structured with the following columns:

| Column Name         | Description                                                                                                      | Data Origin    |
| :------------------ | :----------------------------------------------------------------------------------------------------------------|----------------|
| `assay_id`          | Unique identifier for the assay within ChEMBL.                                                                   | ChEMBL 35      |
| `assay_chembl_id`   | ChEMBL identifier associated with the assay (for use on web interface).                                    | ChEMBL 35      |
| `description`       | Detailed textual description of the assay.                                                                       | ChEMBL 35      |
| `assay_type`        | Type of assay ('B' for binding and 'F' for functional).                                                          | ChEMBL 35      |
| `method`            | All NER experimental methods derived from the assay description (multiple entities separated by '\|').           | new annotation |
| `individual_method` | Each experimental method after `method` column is exploded.                                                      | new annotation | 
| `mapped_term_label` | Human-readable label of the mapped BAO or GO term (multiple labels separated by ',').                            | new annotation |
| `mapped_term_curie` | CURIE (Compact Uniform Resource Identifier) for the mapped BAO or GO term.                                       | new annotation |
| `mapped_term_iri`   | Internationalised Resource Identifier (IRI) for the mapped BAO or GO term.                                       | new annotation |
| `mapping_score`     | Text2term score indicating the confidence or quality of the mapping to the BAO/GO term.                          | new annotation |
| `year`              | Year of document publication.                                                                                    | ChEMBL 35      |
| `document_chembl_id`| ChEMBL document identifier associated with the assay.                                                            | ChEMBL 35      |
| `bao_format`        | ID for the corresponding format type in BioAssay Ontology for the assay (e.g., cell-based, organism-based, etc.) | ChEMBL 35      |
| `bao_label`.        | Bioassay Ontology label for the term.                                                                            | ChEMBL 35.     |
| `pubmed_id`         | PubMed ID of the publication associated with the assay.                                                          | ChEMBL 35      |
| `chembl_release_id` | The ChEMBL release version from which the data was extracted.                                                    | ChEMBL 35      |

#### ChEMBL 35 Assays with predicted high-level assay category

This file contains a dataset of assay descriptions from ChEMBL release 35 with predictions for the high-level assay category. These are based on a multiclass classification model developed in this project. To provide comprehensive context for each entry, the dataset includes various metadata points from ChEMBL 35.

##### File Contents

The dataset is structured with the following columns:

| Column Name         | Description                                                                                                      | Data Origin    |
| :------------------ | :----------------------------------------------------------------------------------------------------------------|----------------|
| `assay_id`          | Unique identifier for the assay within ChEMBL.                                                                   | ChEMBL 35      |
| `assay_chembl_id`         | ChEMBL identifier associated with the assay (for use on web interface).                                          | ChEMBL 35      |
| `description`       | Detailed textual description of the assay.                                                                       | ChEMBL 35      |
| `assay_type`        | Type of assay ('B' for binding and 'F' for functional).                                                          | ChEMBL 35      |
| `predicted_category`   | Assay category with the highest prediction score, considered to be the predicted assay category for the given assay description           | new annotation |
| `prediction_score` | Prediction score for the predicted_category from the model, this is the highest prediction score for the given assay.                                                        | new annotation |
| `predicted_bao_id`    | BAO Identifier for the predicted_category                                                           | new annotation |
| `predicted_bao_term` | Preferred Term in BAO for the predicted_category                           | new annotation |
| `Radioligand binding (BAO_0002776) prediction score` | Prediction score for the Radioligand binding category (not the predicted category but provided for reference)                                    | new annotation |
| `Binding (BAO_0002989) prediction score`   | Prediction score for the Binding category (not the predicted category but provided for reference)                                       | new annotation |
| `Protein activity (BAO_0013016) prediction score`     | Prediction score for the Protein activity category (not the predicted category but provided for reference)                          | new annotation |
| `in vivo method (BAO_0040021) prediction score`     | Prediction score for the in vivo method category (not the predicted category but provided for reference)                          | new annotation |
| `Cell phenotype (BAO_0002542) prediction score`     | Prediction score for the Cell phenotype category (not the predicted category but provided for reference)                          | new annotation |
| `Nucleic acid binding prediction score`     | Prediction score for the Nucleic acid binding category (not the predicted category but provided for reference)                          | new annotation |
| `Antimicrobial activity prediction score`     | Prediction score for the Antimicrobial activity category (not the predicted category but provided for reference)                          | new annotation |
| `year`              | Year of document publication.                                                                   | ChEMBL 35      |
| `document_chembl_id`            | ChEMBL document identifier associated with the assay.                                                            | ChEMBL 35      |
| `bao_format`        | ID for the corresponding format type in BioAssay Ontology for the assay (e.g., cell-based, organism-based, etc.) | ChEMBL 35      |
| `bao_label`.        | Bioassay Ontology label for the term.                                                                            | ChEMBL 35.     |
| `pubmed_id`         | PubMed ID of the publication associated with the assay.                                                          | ChEMBL 35      |
| `chembl_release_id` | The ChEMBL release version from which the data was extracted.                                                    | ChEMBL 35      |
