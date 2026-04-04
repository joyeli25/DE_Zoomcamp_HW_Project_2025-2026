# Chicago Crime Data Pipeline Project

## Objective
The goal of this project is to build an end-to-end data pipeline on Google Cloud Platform (GCP) using infrastructure as code, orchestration, transformation, and visualization tools. The final output is a dashboard with at least two tiles showing categorical and temporal crime data distributions.

## Problem Statement
- **Dataset**: [Chicago Crimes (2001 to present)](https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-Present/ijzp-q8t2/about_data) – reported incidents of crime in Chicago, excluding the most recent seven days.
- **Data subset used**: Crimes from **January 1, 2020** through **March 30, 2026** (downloaded data by year).
- **Pipeline type**: Batch (periodic ingestion and processing).
- **Outcome**: A dashboard with:
  1. A graph showing distribution of crime types (categorical).
  2. A graph showing crime trends over time (temporal).

  
## Architecture Overview
1. **Infrastructure provisioning** – Terraform on GCP.
2. **Orchestration & ingestion** – Kestra ingests data from a GitHub release page.
3. **Storage** – Google Cloud Storage (data lake).
4. **Warehouse** – BigQuery.
5. **Transformation** – dbt (data modeling & preparation).
6. **Visualization** – Dashboard (e.g., Looker Studio / Streamlit / other BI tool) with two tiles.


## Technologies Used
| Component | Technology | Purpose |
|-----------|------------|---------|
| Cloud | GCP | Compute & storage |
| IaC | Terraform | Provision GCP resources |
| Workflow orchestration | Kestra | Schedule & run batch ingestion to GCS and BigQuery |
| Data lake | GCS | Raw data storage |
| Data warehouse | BigQuery | Analytical storage & SQL queries |
| Transformation | dbt | Data modeling, cleaning, aggregation |
| Dashboard | *to be specified* | Visualization of two key metrics |


## Pipeline Steps

### 1. Infrastructure (Terraform)
- Provision GCS bucket (data lake).
- Create BigQuery dataset and tables.
- Set up required service accounts and IAM permissions.

### 2. Ingestion (Kestra – Batch)
- **Trigger**: Scheduled (e.g., daily).
- **Source**: GitHub release page (CSV/Parquet of Chicago crimes data).
- **Sink**: GCS bucket (raw zone).
- **Load**: From GCS to BigQuery staging table.

### 3. Transformation (dbt)
- Clean & rename columns.
- Filter out recent 7 days (per dataset constraints).
- Create aggregated models:
  - `crime_counts_by_type` – for categorical chart.
  - `crime_trends_by_month` – for temporal line chart.
- Write transformed tables back to BigQuery (analytics schema).

### 4. Dashboard
- Connect BI tool to BigQuery analytics tables.
- **Tile 1 (Categorical)**: Bar chart – Top 10 crime types by count (2020–Mar 2026).
- **Tile 2 (Temporal)**: Line chart – Crime count per month from Jan 2020 to Mar 2026.
- Add titles, axis labels, and a brief description.

## How to Reproduce
1. Clone the repository.
2. Set up GCP credentials.
3. Run Terraform to provision resources.
4. Deploy Kestra flow (provided in `/kestra` folder).
5. Run dbt models (commands in `/dbt` folder).
6. Open the dashboard (link or localhost) to view both tiles.

## Dashboard Preview (Expected)
- **Tile 1 – Distribution by crime type**: Horizontal bar chart showing `THEFT`, `BATTERY`, `CRIMINAL DAMAGE`, etc.
- **Tile 2 – Temporal trend**: Line chart from 2001 to present, showing peaks in summer months.

## Future Improvements
- Add streaming ingestion for real-time crime alerts.
- Use Terraform modules for reusability.
- Implement data quality tests in dbt.
