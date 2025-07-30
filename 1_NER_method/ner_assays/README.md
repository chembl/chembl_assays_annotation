<!-- WEASEL: AUTO-GENERATED DOCS START (do not remove) -->

# 🪐 Weasel Project: Detecting methods in ChEMBL assays descriptions (Named Entity Recognition)

This project uses ChEMBL manually annotated data to bootstrap an NER model to detect methods in ChEMBL assays descriptions.

## 📋 project.yml

The [`project.yml`](project.yml) defines the data assets required by the
project, as well as the available commands and workflows. For details, see the
[Weasel documentation](https://github.com/explosion/weasel).

### ⏯ Commands

The following commands are defined by the project. They
can be executed using [`weasel run [name]`](https://github.com/explosion/weasel/tree/main/docs/cli.md#rocket-run).
Commands are only re-run if their inputs have changed.

| Command | Description |
| --- | --- |
| `download` | Download a spaCy model with pretrained vectors |
| `preprocess` | Convert the data to spaCy's binary format |
| `train` | Train a named entity recognition model |
| `evaluate` | Evaluate the model and export metrics |
| `preprocess-final` | Convert the data to spaCy's binary format |
| `train-final` | Train a named entity recognition model |
| `package` | Package the trained model so it can be installed |
| `visualize-model` | Visualize the model's output interactively using Streamlit |
| `visualize-data` | Explore the annotated data in an interactive Streamlit app |

### ⏭ Workflows

The following workflows are defined by the project. They
can be executed using [`weasel run [name]`](https://github.com/explosion/weasel/tree/main/docs/cli.md#rocket-run)
and will run the specified commands in order. Commands are only re-run if their
inputs have changed.

| Workflow | Steps |
| --- | --- |
| `model-cv` | `download` &rarr; `preprocess` &rarr; `train` &rarr; `evaluate` |
| `model-final` | `download` &rarr; `preprocess-final` &rarr; `train-final` &rarr; `package` |

### 🗂 Assets

The following assets are defined by the project. They can
be fetched by running [`weasel assets`](https://github.com/explosion/weasel/tree/main/docs/cli.md#open_file_folder-assets)
in the project directory.

| File | Source | Description |
| --- | --- | --- |
| [`assets/assays_training.jsonl`](assets/assays_training.jsonl) | Local | JSONL-formatted training data annotated with `METHOD` entities |
| [`assets/assays_eval.jsonl`](assets/assays_eval.jsonl) | Local | JSONL-formatted development data annotated with `METHOD` entities |
| `assets/methods_patterns.jsonl` | Local | Patterns file generated with `terms.teach` and used to pre-highlight during annotation  |

<!-- WEASEL: AUTO-GENERATED DOCS END (do not remove) -->

## 📚 Data

Labelling the data was manually done by ChMEBL curators. The raw text was randomly selected from ChEMBL Binding assays first and the Functional assays. 

| File                                                  | Count | Description                                                                                                                                                                                                                                                                                                                     |
| ----------------------------------------------------- | ----: | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`drugs_patterns.jsonl`](assets/drugs_patterns.jsonl) |   118 | Single-token patterns created with [`terms.teach`](https://prodi.gy/docs/recipes#terms-teach) and [`terms.to-patterns`](https://prodi.gy/docs/recipes#terms-to-patterns). Can be used with spaCy's [`EntityRuler`](https://spacy.io/usage/rule-based-matching#entityruler) for a rule-based baseline and faster NER annotation. |
| [`drugs_training.jsonl`](assets/drugs_eval.jsonl)     |  1477 | Training data annotated with `DRUG` entities.                                                                                                                                                                                                                                                                                   |
| [`drugs_eval.jsonl`](assets/drugs_eval.jsonl)         |   500 | Evaluation data annotated with `DRUG` entities.                                                                                                                                                                                                                                                                                 |

### Visualize the data and model

The [`visualize_data.py`](scripts/visualize_data.py) script lets you visualize
the training and evaluation datasets with
[displaCy](https://spacy.io/usage/visualizers).

```bash
python -m spacy project run visualize-data
```

The [`visualize_model.py`](scripts/visualize_model.py) script is powered by
[`spacy-streamlit`](https://github.com/explosion/spacy-streamlit) and lets you
explore the trained model interactively.

```bash
python -m spacy project run visualize-model
```

### Training and evaluation data format

The training and evaluation datasets are distributed in Prodigy's simple JSONL
(newline-delimited JSON) format. Each entry contains a `"text"` and a list of
`"spans"` with the `"start"` and `"end"` character offsets and the `"label"` of
the annotated entities. The data also includes the tokenization. Here's a
simplified example entry:

```json
{
  "text": "Idk if that Xanax or ur just an ass hole",
  "tokens": [
    { "text": "Idk", "start": 0, "end": 3, "id": 0 },
    { "text": "if", "start": 4, "end": 6, "id": 1 },
    { "text": "that", "start": 7, "end": 11, "id": 2 },
    { "text": "Xanax", "start": 12, "end": 17, "id": 3 },
    { "text": "or", "start": 18, "end": 20, "id": 4 },
    { "text": "ur", "start": 21, "end": 23, "id": 5 },
    { "text": "just", "start": 24, "end": 28, "id": 6 },
    { "text": "an", "start": 29, "end": 31, "id": 7 },
    { "text": "ass", "start": 32, "end": 35, "id": 8 },
    { "text": "hole", "start": 36, "end": 40, "id": 9 }
  ],
  "spans": [
    {
      "start": 12,
      "end": 17,
      "token_start": 3,
      "token_end": 3,
      "label": "DRUG"
    }
  ],
  "_input_hash": -2128862848,
  "_task_hash": -334208479,
  "answer": "accept"
}
```
