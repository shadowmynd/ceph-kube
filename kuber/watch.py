#!/usr/bin/python3
import os

def get_command(namespace):
    if(len(namespace) > 0):
        return "echo 'Results for namespace: [{0}]'; kubectl -n {0} get pods; echo '\n'".format(namespace)
    else:
        return "echo 'Results for namespace: [Default]'; kubectl get pods; echo '\n'"

def main():
    namespaces = ['rook-ceph', 'rook-ceph-system', 'samba', '']
    watch_cmd = "; ".join([get_command(x) for x in namespaces])
    os.system("watch -t -n1 \"{0}\"".format(watch_cmd))

if __name__ == '__main__':
    main()