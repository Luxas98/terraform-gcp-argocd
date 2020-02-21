apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

bases:
  - project/overlays/${overlay}


patchesJson6902:
  - target:
      group: argoproj.io
      version: v1alpha1
      kind: AppProject
      # FIX ME
      name: project
    path: ./server-patch.yaml