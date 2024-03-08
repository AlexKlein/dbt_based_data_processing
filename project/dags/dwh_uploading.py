from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.dummy import DummyOperator


DEFAULT_ARGS = {
    'owner': 'aleksandr.klein',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False
}

dag_config = {
    'dag_id': 'dwh_uploading',
    'default_args': DEFAULT_ARGS,
    'description': 'An Airflow DAG to run DBT models',
    'schedule_interval': '30 8 * * *',
    'max_active_runs': 1,
    'catchup': False,
    'start_date': datetime(2024, 3, 7)
}

with DAG(**dag_config) as dag:

    start = DummyOperator(task_id='start')
    end = DummyOperator(task_id='end')

    dwh_uploading = BashOperator(
        task_id='dwh_uploading',
        bash_command='cd /opt/airflow/dbt && dbt run',
        retries=1,
        retry_delay=timedelta(minutes=1)
    )

    start >> dwh_uploading >> end
