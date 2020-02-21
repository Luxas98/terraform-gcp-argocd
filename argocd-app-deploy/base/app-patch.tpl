- op: replace
  path: /spec/source/path
  value: products/${app}/overlays/${overlay}
- op: replace
  path: /spec/source/targetRevision
  value: argocd
- op: replace
  path: /spec/destination/server
  value: "https://${cluster_endpoint}"
- op: replace
  path: /spec/project
  value: ${overlay}-platform
