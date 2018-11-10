#!/bin/zsh

echo "smbv3     =>  smb://$(minikube ip):$(kubectl get svc -n samba -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}{{end}}')"
echo "ceph dash =>  http://$(minikube ip):$(kubectl get svc -n rook-ceph -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}{{end}}')"
