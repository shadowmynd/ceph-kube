## Scaler
---
### Reporter (runs every 10-30m)
- Queries available space for:
    - Cluster
    - Pool/FS
- Reports available space to shared cosmosdb
    - Reporting utilizes cosmosdb
### Scaler
- Queries cosmosdb
    - Checks for cluster available threshold
    - Executes scale-out if threshold is satisfied


## Health Monitor
---
- Queries 
    - pg/pgp configuration
    - cluster health
    - replication health
- Reports
    - Lucid
    - MaaS
    - NR
    - Tableau


## Tenant Onboarding
---
*use helm chart for deployment management*
- Create Pools
    - Active
        - Billable
        - Guaranteed performance
    - Staging 
        - Non-billable
        - No performance guarantee
- Create Users
    - Create AAD user

