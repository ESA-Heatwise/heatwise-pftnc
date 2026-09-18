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
          location: hw-berlin_muggelsee_mlrun_20260916_113308
      input_dataset_path:
        label: input_dataset_path
        doc: input_dataset_path
        type: Directory
        default:
          class: Directory
          location: ''
      mode:
        label: mode
        doc: mode
        type: string
        default: from_date
      save_index:
        label: save_index
        doc: save_index
        type: boolean
        default: true
      save_outputs:
        label: save_outputs
        doc: save_outputs
        type: boolean
        default: false
      selection:
        label: selection
        doc: selection
        type: string
        default: ensemble_simple
      start_date:
        label: start_date
        doc: start_date
        type: string
        default: '2023-12-01'
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
          save_index: save_index
          save_outputs: save_outputs
          selection: selection
          start_date: start_date
        out:
          - results
  - class: CommandLineTool
    id: xce_script
    requirements:
      DockerRequirement:
        dockerPull: pftnc_inference:2026.09.17.11.35.14
    hints:
      DockerRequirement:
        dockerPull: pftnc_inference:2026.09.17.11.35.14
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
          location: hw-berlin_muggelsee_mlrun_20260916_113308
        inputBinding:
          prefix: --bundle-path
      input_dataset_path:
        label: input_dataset_path
        doc: input_dataset_path
        type: Directory
        default:
          class: Directory
          location: ''
        inputBinding:
          prefix: --input-dataset-path
      mode:
        label: mode
        doc: mode
        type: string
        default: from_date
        inputBinding:
          prefix: --mode
      save_index:
        label: save_index
        doc: save_index
        type: boolean
        default: true
        inputBinding:
          prefix: --save-index
      save_outputs:
        label: save_outputs
        doc: save_outputs
        type: boolean
        default: false
        inputBinding:
          prefix: --save-outputs
      selection:
        label: selection
        doc: selection
        type: string
        default: ensemble_simple
        inputBinding:
          prefix: --selection
      start_date:
        label: start_date
        doc: start_date
        type: string
        default: '2023-12-01'
        inputBinding:
          prefix: --start-date
    outputs:
      results:
        type: Directory
        outputBinding:
          glob: .
