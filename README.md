# Kubeflow Pipelines Deploy Action

GitHub Actions for deploying [Kubeflow Pipelines](https://github.com/kubeflow/pipelines) on Google Cloud Platform (GCP). 

## Usage
### Use Case

This action is intended for developers who manage CI/CD with GitHub Actions. If you handle it with GCP service, see also: [CI/CD workflow use case with GCP service](https://cloud.google.com/solutions/machine-learning/architecture-for-mlops-using-tfx-kubeflow-pipelines-and-cloud-build#cicd_workflow_use_case)


### Parameters

The "required" parameters must be set in your GitHub Actions yaml.

| key                       | value                   | default   | required | description                                                                                                                  | 
| :------------------------ | ----------------------- | --------- | -------- | ---------------------------------------------------------------------------------------------------------------------------- | 
| kubeflow_url              | url string              |           | True     | The endpoint where your Kubeflow UI is running.                                                                              | 
| pipeline_file_path        | path/to/pipeline.py     |           | True     | The full path to pipeline.py file. This must be relative to the root of the GitHub repository where the Action is triggered. | 
| pipeline_function_name    | function name string    |           | True     | The name of the pipeline, this name will be the name of the pipeline in the Kubeflow UI.                                     | 
| pipeline_parameters_path  | path/to/parameters.yaml |           | True     | The full path to parameters.yml which contains pipeline parameters.                                                          | 
| pipeline_namespace        | namespace string        |           | False    | The namespace in which the pipeline should run.                                                                              | 
| experiment_name           | any string              | 'Default' | False    | The name of the experiment name within which the kubeflow experiment should run.                                             | 
| run_pipeline              | True or False           | False     | False    | The flag of running the pipeline. If true, your pipeline will run after uploading.                                           | 
| recurring_cron_expression | True or False           | False     | False    | CRON string for scheduling recurring pipelines                                                                               | 
| client_id                 | any string              |           | False    | The IAP client id, which was specified when the kubeflow deployment where setup using IAP.                                   | 


The pipeline also must have the GitHub SHA as a parameter, as shown below:

```python
from kfp import dsl
def path_csv_pipeline(github_sha: str): # Required parameter for versioning artifacts
    # Define component
    ...

    # pipeline
    @dsl.pipeline
    def pipeline(n_cols: int = 5, n_rows: int = 3):
        # Define your pipeline
        ...
        # End of pipeline
    
    return pipeline
```


### Example Usage and Workflow

The following example code is from here ([example/example_pipeline.py](https://github.com/f6wbl6/kubeflow-github-action/tree/master/example)).

#### Define Pipeline

Your pipeline must be defined inside any function. The following example uses `@func_to_container_op` to declare a component, but it can be defined in any format (self built component.yaml, official component file from [Kubeflow](https://github.com/kubeflow/pipelines), etc.).

```python
def path_csv_pipeline(github_sha: str): # Required parameter for versioning artifacts
    """Making arbitrary Dataframe with specified columns and rows"""

    @func_to_container_op
    def make_csv(n_cols: int, n_rows: int, output_csv_path: OutputPath("CSV")):
        ...

    @func_to_container_op
    def read_csv(input_csv_path: InputPath("CSV")):
        ...

    # pipeline
    @dsl.pipeline(
        name="Sample pipeline", description="Make a csv file and read it."
    )
    def pipeline(n_cols: int = 5, n_rows: int = 3):
        make_csv_task = make_csv(n_cols, n_rows)
        read_csv(input_csv=make_csv_task.outputs["output_csv"])

    return pipeline
```


#### Define Workflow for Run only once

```yaml
name: Compile, Deploy and Run on Kubeflow
on:
  pull_request:
    branches:
      - 'master'
    types: [opened, synchronize, closed]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout files in repo
      uses: actions/checkout@v2

    - name: Submit a pipeline
      uses: f6wbl6/kubeflow-github-action@master
      env:
        SA_EMAIL: ${{ secrets.SA_EMAIL }} # required
        GOOGLE_APPLICATION_CREDENTIALS: ${{ secrets.GCP_CREDENTIALS }} # required
        GITHUB_SHA: ${{ github.sha }} # required
      with:
        KUBEFLOW_URL: ${{ secrets.KUBEFLOW_URL }} # required
        PIPELINE_FILE_PATH: "example/example_pipeline.py" # required
        PIPELINE_FUNCTION_NAME: "path_csv_pipeline" # required
        PIPELINE_PARAMETERS_PATH: "example/parameters.yaml" # required
        CLIENT_ID: ${{ secrets.CLIENT_ID }}
        RUN_PIPELINE: True # Run pipeline if set as "True"

```

#### Define Workflow for Recurring Run (Periodical Execution)

A cron string needs to be configured. See here for an example configuration: [Cron Expressions](https://docs.oracle.com/cd/E12058_01/doc/doc.1014/e12030/cron_expressions.htm)


## Acknowledgment

This action is forked from [NikeNano's kubeflow-github-action](https://github.com/NikeNano/kubeflow-github-action). Thanks!


## Example Workflow that uses this action 

Coming soon.
