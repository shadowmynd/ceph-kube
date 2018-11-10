- Add available space daemon
    - Account for cluster scale-out
        - Run as node/cluster daemon?
            - Run as systemd
        - Run as pod
            - highly restrictive runtime
            - Breaks kube contract w/re RBAC?
- Add monitoring daemon
- Add scale daemon
- Repair 'rook-ceph-mon-endpoints' ConfigMap generation
    - remove 'a=...;b=...c=...'
- Create Helm Charts
    - New Tenant
    - New Cluster

### Questions
---
- Can we use azure functions to drive metric capturing/eventing?
