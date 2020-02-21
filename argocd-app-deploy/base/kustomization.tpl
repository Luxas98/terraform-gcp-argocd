apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

bases:
  - git@gitlab.com:healthplusai/gitops/platform//argocd/apps/${app}/overlays/${overlay}?ref=argocd

patchesJson6902:
  - target:
      group: argoproj.io
      version: v1alpha1
      kind: Application
      name: app
    path: ./app-patch.yaml