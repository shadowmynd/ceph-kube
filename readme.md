# Multitenant data storage solution

## Purpose
Create a shared storage solution with a stateless front-end

## Description
Using a ceph cluster as a shared storage medium 

## Usage
### Setup
To deploy kubernetes instance
```
./setup.zsh -k -r <region> -d <dns_prefix>

E.g
./setup.zsh -k -r centralus -d cephtest
```

To deploy managed instance
```
./setup.zsh -m 
```

### Teardown
To destroy kubernetes instance
```
./teardown.zsh -k -r <region>

E.g
./teardown.zsh -k -r centralus
```

To destroy managed instance
```
./teardown.zsh -m 
```

## Technologies
The following technologies are used

### Ceph
Two deployment/management models are being evaluated:
#### Kuberentes
- [ACS engine](https://github.com/Azure/acs-engine) managed infrastructure
- [Rook](https://github.com/rook/rook) for ceph infrastructure configuration
- 
#### Managed
- [Pulumi](https://www.pulumi.com/) managed infrastructure
- [Ceph Ansible](http://docs.ceph.com/ceph-ansible/master/) managed ceph cluster

### Samba
- Docker Image
- User passthrough to mount at `/storage/`
- Designed to be deployed as container
- Shared passdb backend