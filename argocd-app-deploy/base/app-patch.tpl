- op: replace
  path: /spec/source/path
  value: argocd-apps/${app}/overlays/${overlay}
- op: replace
  path: /spec/source/targetRevision
  value: master
- op: replace
  path: /spec/destination/server
  value: "https://${cluster_endpoint}"
- op: replace
  path: /spec/project
  value: ${overlay}-project
