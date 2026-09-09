cwlVersion: v1.0
$namespaces:
  s: https://schema.org/
s:version: 1.0.0
s:softwareVersion: 1.0.0
schemas:
  - http://schema.org/version/9.0/schemaorg-current-http.rdf
$graph:
  - class: Workflow
    id: pftnc_inference
    label: xcengine notebook
    doc: xcengine notebook
    requirements: []
    inputs:
      bundle_path:
        label: bundle_path
        doc: bundle_path
        type: Directory
        default:
          class: Directory
          location: test_packaging3
      input_dataset_path:
        label: input_dataset_path
        doc: input_dataset_path
        type: Directory
        default:
          class: Directory
          location: input/elbe_bunthaus
      mode:
        label: mode
        doc: mode
        type: string
        default: from_date
      selection:
        label: selection
        doc: selection
        type: string
        default: ensemble_simple
    outputs:
      - id: stac_catalog
        type: Directory
        outputSource:
          - run_script/results
    steps:
      run_script:
        run: '#xce_script'
        in:
          bundle_path: bundle_path
          input_dataset_path: input_dataset_path
          mode: mode
          selection: selection
        out:
          - results
  - class: CommandLineTool
    id: xce_script
    requirements:
      DockerRequirement:
        dockerPull: pftnc_inference:2026.09.09.07.37.55
    hints:
      DockerRequirement:
        dockerPull: pftnc_inference:2026.09.09.07.37.55
    baseCommand:
      - /usr/local/bin/_entrypoint.sh
      - python
      - /home/mambauser/execute.py
    arguments:
      - --batch
      - --eoap
    inputs:
      bundle_path:
        label: bundle_path
        doc: bundle_path
        type: Directory
        default:
          class: Directory
          location: test_packaging3
        inputBinding:
          prefix: --bundle-path
      input_dataset_path:
        label: input_dataset_path
        doc: input_dataset_path
        type: Directory
        default:
          class: Directory
          location: input/elbe_bunthaus
        inputBinding:
          prefix: --input-dataset-path
      mode:
        label: mode
        doc: mode
        type: string
        default: from_date
        inputBinding:
          prefix: --mode
      selection:
        label: selection
        doc: selection
        type: string
        default: ensemble_simple
        inputBinding:
          prefix: --selection
    outputs:
      results:
        type: Directory
        outputBinding:
          glob: .
