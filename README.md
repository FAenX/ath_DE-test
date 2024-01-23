# Time-Series Model (Python Notebook)

## Objective:
Transform the provided record-level dataset into a time-series model to gain insights into the temporal patterns of vehicle listings, emphasizing inventory analysis over time, segmented by regions.

## Proposed Warehouse Structure:
### Fact Tables:
- Main time-series data table with vehicle listings, segmented by regions.
- Additional fact tables for enriched data like weather, economic indicators, and competitor information.

### Dimension Tables:
- Time dimension table for storing date and time details.
- Region dimension table for regional information.
- Vehicle type dimension table for categorizing vehicles.

## Design Considerations:
### Stakeholder Needs:
#### Delta Transaction Log:
- Delta provides a transaction log that tracks all the changes made to the data.
- Stakeholders can access historical changes, enabling data lineage and auditing.
- Analysts, executives, and marketing teams can trace the evolution of data and understand how it has changed over time.

### Democratization of Data:
#### Schema Evolution:
- Delta supports schema evolution, allowing for seamless changes to the data structure without requiring a full reload.
- Stakeholders can easily adapt to evolving data needs without disruptions, promoting flexibility for analysts and self-service analytics.

#### Time Travel Queries:
- Delta allows querying data at different points in time using time travel capabilities.
- Analysts can perform temporal analysis without relying on dedicated data engineering support, enhancing their autonomy.

### Efficient Usage:
#### Optimized Reads and Writes:
- Delta uses an optimized storage layer that significantly improves both read and write performance.
- Stakeholders experience faster queries and efficient data retrievals, ensuring a smooth and responsive analytics experience.

#### Compaction and Z-Ordering:
- Delta supports automatic file compaction and Z-ordering for better data organization.
- This results in reduced storage requirements and improved query performance, enhancing the overall efficiency of data storage and retrieval.

### Scalability:
#### ACID Transactions:
- Delta provides ACID transactions, ensuring atomicity, consistency, isolation, and durability.
- This guarantees data integrity, even in large-scale and concurrent operations, contributing to the scalability of the warehouse.

#### Partition Pruning:
- Delta leverages partition pruning techniques, allowing the warehouse to efficiently skip irrelevant data during query execution.
- This ensures that the warehouse can scale to handle growing datasets without sacrificing performance.

#### Unified Batch and Streaming:
- Delta supports both batch and streaming data processing within the same system.
- This unified approach facilitates seamless scalability as the warehouse can adapt to varying workloads and data sources.

## Data Loading:
### Steps:
#### Craigslist Vehicles Bronze Schema:
- **Delta Table: craigslist_vehicles**
  - Columns: id, region, price, year, manufacturer, model, ... (various vehicle details)
  - Purpose: Stores the raw data from Craigslist vehicle listings.

#### Facts Schema:
- **Delta Table: year_id_price**
  - Columns: year, id, price, region, state
  - Purpose: Aggregated data on vehicle prices over time, segmented by region and state.

- **Delta Table: year_id**
  - Columns: id, year, region, state
  - Purpose: Aggregated data on vehicles over time, segmented by region and state.

- **Delta Table: manufacturer_year**
  - Columns: id, manufacturer, year, region, state
  - Purpose: Aggregated data on vehicles by manufacturer over time, segmented by region and state.

- **Delta Table: region_year**
  - Columns: id, year, region, state
  - Purpose: Aggregated data on vehicles over time, segmented by region and state.

#### Dimensions Schema:
- **Delta Table: dates**
  - Columns: date, id
  - Purpose: Dimension table for date-related information.

- **Delta Table: regions**
  - Columns: region, id
  - Purpose: Dimension table for region-related information.

- **Delta Table: manufacturers**
  - Columns: manufacturer, id
  - Purpose: Dimension table for manufacturer-related information.

- **Delta Table: model**
  - Columns: model, id
  - Purpose: Dimension table for model-related information.

- **Delta Table: states**
  - Columns: state, id
  - Purpose: Dimension table for state-related information.


### Analysis and Insights, Visualization
  - Visualizing Sales Per Year:
  - Analyzing Sales and Prices:
  - Market Share Analysis:

### Data Enrichment Recommendations:

#### Areas for Additional Data:

1. **Weather Data:**
   Enrich the dataset with historical weather data. This can enable the analysis of how weather conditions impact vehicle demand and availability, especially for regions prone to seasonal weather variations.

2. **Economic Indicators:**
   Include economic indicators like GDP, unemployment rates, or consumer confidence. These can provide insights into broader economic trends influencing vehicle markets.

3. **Events and Holidays:**
   Integrate data on local events, holidays, or festivals. Understanding the impact of events on vehicle demand helps in planning inventory and marketing strategies.

4. **Competitor Data:**
   Gather data on competitors' vehicle listings. Analyzing competitors' trends can offer a benchmark for performance and identify areas for improvement.


# Notes
- This data can be cleaned more, but I was not able to do most of the cleaning due to time constraints.
- Due to time constraints, I was not able to dig in for more insights and visualizations, with more time more insights can be dug out.
