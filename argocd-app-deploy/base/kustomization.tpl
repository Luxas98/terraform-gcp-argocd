apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

bases:
  - apps/${app}/overlays/${overlay}

patchesJson6902:
  - target:
      group: argoproj.io
      version: v1alpha1
      kind: Application
      name: app
    path: ./app-patch.yaml