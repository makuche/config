#!/usr/bin/env bash
# Usage: k8s-watch <resource> <context1> [context2 ...]
# Example: k8s-watch pods dg-core-prod-k8s001 dg-core-prod-k8s002
#          k8s-watch jobs dg-core-prod-k8s001

set -euo pipefail

resource="${1:?Usage: k8s-watch <resource> <context1> [context2 ...]}"
shift
contexts=("${@:?Need at least one context}")

# First context runs in the current pane
first=true
for ctx in "${contexts[@]}"; do
  cmd="viddy -n 1 -d 'kubectl get ${resource} --all-namespaces -o wide --context=${ctx} --field-selector=status.phase=Pending'"
  if $first; then
    tmux send-keys "$cmd" Enter
    first=false
  else
    tmux split-window -v
    tmux send-keys "$cmd" Enter
    tmux select-layout even-vertical  # rebalance after each split
  fi
done
