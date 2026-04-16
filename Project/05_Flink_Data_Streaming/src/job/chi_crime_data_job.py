
from pyflink.datastream import StreamExecutionEnvironment
from pyflink.table import EnvironmentSettings, StreamTableEnvironment


def create_events_source_kafka(t_env):
    table_name = "crime_events"
    source_ddl = f"""
        CREATE TABLE {table_name} (
            `ID` INTEGER,
            `Case_Number` STRING,
            `Date` STRING,
            `Block` STRING,
            `IUCR` STRING,
            `Primary_Type` STRING,
            `Description` STRING,
            `Location_Description` STRING,
            `Arrest` BOOLEAN,
            `Domestic` BOOLEAN,
            `Ward` INTEGER,
            `Community_Area` INTEGER,
            `FBI_Code` STRING,
            `X_Coordinate` DOUBLE,
            `Y_Coordinate` DOUBLE,
            `Year` INTEGER,
            `Updated_On` STRING,
            `Latitude` DOUBLE,
            `Longitude` DOUBLE,
            `Location` STRING,
            event_timestamp AS TO_TIMESTAMP(`Date`, 'MM/dd/yyyy HH:mm:ss a'),
            updated_timestamp AS TO_TIMESTAMP(`Updated_On`, 'MM/dd/yyyy HH:mm:ss a'),
            WATERMARK FOR event_timestamp AS event_timestamp - INTERVAL '5' SECOND
        ) WITH (
            'connector' = 'kafka',
            'properties.bootstrap.servers' = 'redpanda:29092',
            'topic' = 'chi-crimes',
            'scan.startup.mode' = 'earliest-offset',
            'properties.auto.offset.reset' = 'earliest',
            'format' = 'json',
            'json.ignore-parse-errors' = 'true',
            'json.fail-on-missing-field' = 'false'
        );
        """
    t_env.execute_sql(source_ddl)
    return table_name


def create_processed_events_sink_postgres(t_env):
    table_name = 'processed_crime_events'
    sink_ddl = f"""
        CREATE TABLE {table_name} (
            `ID` INTEGER,
            `Case_Number` STRING,
            `Crime_Date` TIMESTAMP(3),
            `Block` STRING,
            `IUCR` STRING,
            `Primary_Type` STRING,
            `Description` STRING,
            `Location_Description` STRING,
            `Arrest` BOOLEAN,
            `Domestic` BOOLEAN,
            `Ward` INTEGER,
            `Community_Area` INTEGER,
            `FBI_Code` STRING,
            `X_Coordinate` DOUBLE,
            `Y_Coordinate` DOUBLE,
            `Year` INTEGER,
            `Updated_On` TIMESTAMP(3),
            `Latitude` DOUBLE,
            `Longitude` DOUBLE,
            `Location` STRING,
            `processed_time` TIMESTAMP(3)
        ) WITH (
            'connector' = 'jdbc',
            'url' = 'jdbc:postgresql://postgres:5432/postgres',
            'table-name' = '{table_name}',
            'username' = 'postgres',
            'password' = 'postgres',
            'driver' = 'org.postgresql.Driver',
            'sink.buffer-flush.max-rows' = '100',
            'sink.buffer-flush.interval' = '1s'
        );
        """
    t_env.execute_sql(sink_ddl)
    return table_name


def process_crime_data():
    env = StreamExecutionEnvironment.get_execution_environment()
    env.set_parallelism(1)   # Reduce parallelism to minimum
    env.enable_checkpointing(10 * 1000)  # checkpoint every 10 seconds

    settings = EnvironmentSettings.new_instance().in_streaming_mode().build()
    t_env = StreamTableEnvironment.create(env, environment_settings=settings)

    source_table = create_events_source_kafka(t_env)
    postgres_sink = create_processed_events_sink_postgres(t_env)

    t_env.execute_sql(
        f"""
        INSERT INTO {postgres_sink}
        SELECT
            `ID`,
            `Case_Number`,
            event_timestamp as crime_date,
            `Block`,
            `IUCR`,
            `Primary_Type`,
            `Description`,
            `Location_Description`,
            `Arrest`,
            `Domestic`,
            `Ward`,
            `Community_Area`,
            `FBI_Code`,
            `X_Coordinate`,
            `Y_Coordinate`,
            `Year`,
            updated_timestamp as updated_on,
            `Latitude`,
            `Longitude`,
            `Location`,
            CURRENT_TIMESTAMP as processed_time
        FROM {source_table}
        WHERE event_timestamp IS NOT NULL
          AND `ID` IS NOT NULL
          AND `Case_Number` IS NOT NULL
        """
    ).wait()

if __name__ == '__main__':
    process_crime_data()