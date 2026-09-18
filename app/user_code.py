import unittest.mock
get_ipython = unittest.mock.MagicMock
#!/usr/bin/env python
# coding: utf-8

# In[1]:


bundle_path: "EOInput" = "hw-berlin_muggelsee_mlrun_20260916_113308"
selection = "ensemble_simple" # can be one of these "best_overall", "best_per_target", "ensemble_simple", "ensemble_weighted", "ensemble_weighted_per_target",
input_dataset_path: "EOInput" = ""
mode = "from_date" # can be "latest" or "from_date". "from_date" requires additional start_date parameter
start_date: str = "2023-12-01"

save_outputs: bool = False
save_index: bool = True

xcengine_config = dict(
  # ...
    include_directory=True,
    build_includes=["../../pftnc"]  # paths relative to notebook
)


# In[ ]:


__xce_set_params()


# In[2]:


from pathlib import Path
from typing import get_type_hints

import pandas as pd
import pystac
from datetime import datetime, timezone

from pftnc.inference_config import InferenceConfig
from pftnc.predict.inference import run_inference


# In[4]:


mode_type = get_type_hints(InferenceConfig)["mode"]
model_type = get_type_hints(InferenceConfig)["model"]
selection_type = get_type_hints(model_type)["selection"]


# In[5]:


selection: selection_type = selection
mode: mode_type = mode


# In[6]:


def extract_assets_from_catalog(catalog: pystac.Catalog, asset_key: str) -> list[pystac.Asset]:
    """
    Returns all assets with a given key from the items of a catalog.
    """
    assets = []
    for item in catalog.get_all_items():
        if (asset := item.assets.get(asset_key)) is not None:
            assets.append(asset)

    return assets

def get_catalog(inp: Path | str) -> pystac.Catalog:
    p = Path(inp) / "catalog.json"
    catalog = pystac.Catalog.from_file(p)
    catalog.make_all_asset_hrefs_absolute()
    return catalog


# In[7]:


catalog = get_catalog(input_dataset_path)


# In[8]:


asset_id  = "berlin_muggelsee"
fpath = next(iter(extract_assets_from_catalog(catalog, asset_id))).href


# In[ ]:


if mode == "latest":
    start_date = None


# In[9]:


config = InferenceConfig(
      model={
          "bundle_path": Path(bundle_path),
          "selection": selection,
      },
      input_dataset={
          "path": Path(fpath),
      },
      mode=mode,
      start_date=start_date,
      save_outputs=save_outputs,
      save_index=save_index,
  )


# In[10]:


predictions = run_inference(config)
print("pftnc predictions successfully generated")


# In[ ]:


predictions.attrs = {
    "geospatial_lon_min": float(predictions["site_lon"].iloc[0]),
    "geospatial_lon_max": float(predictions["site_lon"].iloc[0]),
    "geospatial_lat_min": float(predictions["site_lat"].iloc[0]),
    "geospatial_lat_max": float(predictions["site_lat"].iloc[0]),
}
print(predictions.attrs)
print("attrs updated successfully")

