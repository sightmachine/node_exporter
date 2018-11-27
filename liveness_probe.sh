#!/bin/sh

if [ -d /host/var/lib/kubelet/plugins/kubernetes.io ]; then
  # Exit if anything doesn't go right
  set -e
  set -o pipefail
  # This will only traverse the known sub-directory path of <provider>/mount/<name>
  EXPECTED_MOUNTS=$(find /host/var/lib/kubelet/plugins/kubernetes.io/ -mindepth 3 -maxdepth 3 -type d | wc -l)
  # The actual mounts in the container, which ends up being divergent from the host /proc/mounts... Yay.
  # https://github.com/prometheus/node_exporter/issues/66
  # https://github.com/prometheus/node_exporter/issues/502
  ACTUAL_MOUNTS=$(cat /proc/mounts | grep '/host/var/lib/kubelet/plugins/kubernetes.io/' | sort | uniq | wc -l)
  test ${EXPECTED_MOUNTS} -eq ${ACTUAL_MOUNTS} || exit 1
fi

exit 0
