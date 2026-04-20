# Chicago Crime Data Pipeline Project

## Objective
The goal of this project is to build an end-to-end data pipeline on Google Cloud Platform (GCP) using infrastructure as code, orchestration, transformation, and visualization tools. The final output is a **2-tier dashboard** with categorical and temporal crime data distributions, supported by optimized batch and streaming pipelines.

## Problem Statement
- **Dataset**: [Chicago Crimes (2001 to present)](https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-Present/ijzp-q8t2/about_data) – reported incidents of crime in Chicago, excluding the most recent seven days.
- **Data scope**: January 1, 2020 – March 30, 2026 (downloaded data by year).
- **Pipeline type**: 
  - Batch processing (historical data ingestion)
  - Streaming processing (real-time crime events)
- **Goal**:
  - Efficiently process large-scale crime data
  - Enable real-time and historical analytics
  - Deliver insights via a **2-tier BI dashboard**

  
## Architecture Overview
1. **Infrastructure** – Provisioned via Terraform on GCP  
2. **Orchestration** – Kestra workflows with **partition-aware processing**  
3. **Batch Processing** – Scheduled ingestion and transformation  
4. **Streaming Processing** – Kafka + Flink for real-time pipelines  
5. **Storage (Data Lake)** – Google Cloud Storage (GCS)  
6. **Data Warehouse** – BigQuery with **partitioned and clustered tables**  
7. **Transformation** – dbt for modeling and aggregation  
8. **Visualization** – **2-tier dashboard in Google Looker Studio**

## Technologies Used
| Component | Technology | Purpose |
|----------|-----------|--------|
| Cloud | GCP | Infrastructure and services |
| IaC | Terraform | Resource provisioning |
| Orchestration | Kestra | Workflow orchestration with **partitioning support** |
| Streaming | Kafka + Flink | Real-time ingestion and processing |
| Data Lake | GCS | Raw and streaming data storage |
| Data Warehouse | BigQuery | Optimized analytics storage |
| Transformation | dbt | Data cleaning and modeling |
| BI Tool | Looker Studio | **2-tier dashboard visualization** |


## Pipeline Steps

### 1. Infrastructure (Terraform)
- Provision GCS bucket (data lake).
- Create BigQuery datasets and tables with:
  - **Partitioning** (by `crime_date`)
  - **Clustering** (by `primary_type`, `crime_date`)
- Configure service account and access permissions
- Set up Kafka connectors / Pub/Sub bridge

### 2. Batch Ingestion (Kestra with Partitioning)

**Partitioned Orchestration**

- Implement **partition-aware workflows** in Kestra:
  - Partition data by `crime_year`
  - Parallelize ingestion tasks by partition
- Source: GitHub dataset releases
- Sink: GCS (raw zone)

**Partitioning Strategy:**

- Load into BigQuery staging tables:
  - Use **time-based partitioning**
  - Enable incremental loads

### 3. Streaming Processing (Redpanda/Kafka + Flink)

**Real-Time Pipeline**

- **Redpanda/Kafka**
  - Acts as the event streaming platform
  - Ingests real-time crime data (simulated)

- **Flink**
  - Performs stream processing:
    - Filtering
    - Windowed aggregations
    - Enrichment

- Output:
  - Write processed streams to:
    - GCS (streaming zone)
    - BigQuery (near real-time tables)

### 4. Data Warehouse Optimization (BigQuery)

**Performance Optimization**

- Create **partitioned tables**:
  - Partition by `crime_date`

- Apply **clustering**:
  - Columns: `primary_type`, `crime_date`

**Benefits:**
- Reduced query cost
- Faster scan performance
- Improved dashboard responsiveness

### 5. Transformation (dbt)

- Clean and standardize schema
- Remove invalid or incomplete records
- Build analytical models:
  - `fact_chi_crimes`
- Implement:
  - Incremental models (aligned with partitions)
  - Data quality tests

### 6. Visualization (2-Tier Dashboard in Looker Studio)

**Tier 1: Executive Dashboard**

- KPI scorecards:
  - Total incidents
  - Arrest rate
- Time series:
  - Monthly crime trends
- Category breakdown:
  - Top crime types

**Tier 2: Detailed Dashboard**

- Drill-through table:
  - Individual crime records
- Filters:
  - Year, crime type, location
- Interactive exploration

## How to Reproduce
1. Clone repository  
2. Configure GCP credentials  
3. Run Terraform to provision infrastructure  
4. Deploy Kestra workflows  
5. Start Kafka + Flink streaming jobs  
6. Execute dbt transformations in Kestra
7. Connect Looker Studio to BigQuery  
8. Explore the **2-tier dashboard**
