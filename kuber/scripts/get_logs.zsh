#!/bin/zsh

rm -rf pod_logs
mkdir pod_logs
cd pod_logs

for p in $(kubectl -n rook-ceph get pods -o jsonpath='{.items[*].metadata.name}')
do
    for c in $(kubectl -n rook-ceph get pod ${p} -o jsonpath='{.spec.containers[*].name}')
    do
        echo "BEGIN logs from pod: ${p} ${c}"
        kubectl -n rook-ceph logs -c ${c} ${p} > rook-ceph-logs-${c}-${p}
        echo "END logs from pod: ${p} ${c}"
    done
done

for p in $(kubectl -n rook-ceph-system get pods -o jsonpath='{.items[*].metadata.name}')
do
    echo "BEGIN logs from pod: ${p}"
    kubectl -n rook-ceph-system logs ${p} > rook-ceph-system-logs-${p}
    echo "END logs from pod: ${p}"
done

for p in $(kubectl -n samba get pods -o jsonpath='{.items[*].metadata.name}')
do
    echo "BEGIN logs from pod: ${p}"
    kubectl -n samba logs ${p} > samba-${p}
    echo "END logs from pod: ${p}"
done
