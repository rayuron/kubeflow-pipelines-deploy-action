from kfp import dsl
from kfp.components import InputPath, OutputPath, func_to_container_op


def path_csv_pipeline(github_sha: str):
    """Making arbitrary Dataframe with specified columns and rows"""

    @func_to_container_op
    def make_csv(n_cols: int, n_rows: int, output_csv_path: OutputPath("CSV")):
        import subprocess
        import random

        subprocess.run(["pip", "install", "pandas"])
        import pandas as pd

        # make data
        data = [
            [random.random() for _ in range(n_cols)] for __ in range(n_rows)
        ]
        columns = [f"col_{i}" for i in range(n_cols)]
        index = [f"idx_{i}" for i in range(n_rows)]
        df = pd.DataFrame(
            data=data,
            columns=columns,
            index=index,
        )
        df.to_csv(output_csv_path, index=True)
        print(f"File path: {output_csv_path}")

    @func_to_container_op
    def read_csv(input_csv_path: InputPath("CSV")):
        import subprocess

        subprocess.run(["pip", "install", "pandas"])
        import pandas as pd

        df = pd.read_csv(input_csv_path, index_col=0)
        print(f"input_csv_path: {input_csv_path}")
        print(f"type: {type(input_csv_path)}")
        print(df.head())

    # pipeline
    @dsl.pipeline(
        name="Sample pipeline", description="Make a csv file and read it."
    )
    def pipeline(n_cols: int = 5, n_rows: int = 3):
        make_csv_task = make_csv(n_cols, n_rows)
        read_csv(input_csv=make_csv_task.outputs["output_csv"])

    return pipeline
