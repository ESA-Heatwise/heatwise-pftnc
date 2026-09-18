# How to update and run PFTNC inference

Use this guide when you need to update the PFTNC model or inference input data,
then rebuild and run the EOAP in this repository.

## Before you start

Make sure the PFTNC environment is available with the latest version v0.1.1.

## 1. To change the model

Train the new model in the PFTNC experiment as usual. Package the completed
training run into a new, empty output directory:

```bash
pftnc package-model \
  --training-run-path outputs/<run_id> \
  --output-path <model_bundle>
```

The training run must contain the PFTNC packaging metadata, including
`run_summary.json`, `config.yml`, `model_io_schema.yml`, and
`model_selection.yml`. The resulting bundle contains the fold models and the
metadata needed to reproduce feature engineering during inference.

Copy the complete bundle into `eoap/`:

```bash
cp -R <model_bundle> eoap/<model_bundle>
```

Update the `bundle_path` value in the first cell of
`eoap/pftnc_inference.ipynb` to the bundle directory name, for example:

```python
bundle_path: "EOInput" = Path("my_new_model_bundle")
```

Rebuild the EOAP after changing the notebook so the generated CWL
workflow and image use the new default model bundle.

## 2. To change the input data

Prepare the source data with the columns required by the PFTNC inference
notebook. The [prepare inference input notebook](prepare_inference_input.ipynb)
provides the general preparation step: point it at the source data, select the
rows and columns needed for inference, and write the resulting CSV under the
appropriate `input/<your-site>/` directory. PFTNC performs feature engineering
during inference, so this notebook only prepares the input data.

After creating the CSV, the notebook automatically saves the dataframe
in the new `<your-site>` directory under `input/`. Keep the
same STAC layout as shown below by following the existing input example:

```text
input/<your-site>/
├── catalog.json
├── pftnc_<your-site>_item.json
└── inference_input.csv
```

The references must remain relative and point to one another:

```text
catalog.json
└── item link: ./pftnc_<your-site>_item.json
    └── asset "<your-site>": ./inference_input.csv
```

Follow the existing catalog and STAC item examples in `input/`. Keep the
catalog, item, and CSV together in the same site directory, and update the
catalog and item to refer to the new CSV.

## 3. To build and run the EOAP

From the `eoap/` directory, build the EOAP after changing either the model
bundle or the inference notebook:

```bash
xcetool image build pftnc_inference.ipynb \
  -e environment.yml \
  -a pftnc.cwl \
  -b ../app/
```

From the repository root, run it with the input directory:

```bash
cwltool --outdir testcwl/ \
  eoap/pftnc.cwl#pftnc_inference \
  --input_dataset_path input/<your-site> \
   --bundle_path eoap/<your-model> \
   --<other options>
```

The workflow reads the catalog and STAC item from the supplied input
directory, runs inference with the bundle, and writes the result under
`testcwl/`. Other CWL inputs, such as `--mode`, `--selection`, and
`--start_date`, can be supplied when needed.
