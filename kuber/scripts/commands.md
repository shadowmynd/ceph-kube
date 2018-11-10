*access toolbox*
```kubectl -n rook-ceph exec -it rook-ceph-tools bash```

*samba*
```kubectl -n samba exec -it `kubectl -n samba get pods | grep deployment | awk '{print $1}'` -- /bin/bash```

*get qualified smb address*
```echo "smb://$(minikube ip):$(kubectl get svc -n samba -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}{{end}}')"```

*ceph status*
```kubectl -n rook-ceph exec -it $(kubectl -n rook-ceph get pod -l "app=ceph-tools" -o jsonpath='{.items[0].metadata.name}') -- ceph status```

*update pool quota*
```kubectl -n rook-ceph exec -it $(kubectl -n rook-ceph get pod -l "app=ceph-tools" -o jsonpath='{.items[0].metadata.name}') -- ceph osd pool set-quota {pool-name} max_bytes {bytes}```

*get node ips*
```kubectl describe nodes | grep IP | awk '{print $2}'```