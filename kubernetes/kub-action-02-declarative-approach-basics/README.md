# [Autocomplete Kubernetes YAML files in VSCode](https://blog.gripdev.xyz/2017/11/09/autocomplete-kubernetes-yaml-files-in-vscode/)

It’s nice and easy to get autocomplete setup for the Kubernetes YAML using this awesome extension [YAML Support by Red Hat](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)

## Setup

- Install the Extension

- Add the following to your settings

```yaml
'yaml.schemas': { 'Kubernetes': '*.yaml' }
```

- Reload the editor

---

`apiVersion`

In **Kubernetes**, the `apiVersion` field is a required key in every object's configuration (YAML or JSON) file that specifies which version of the Kubernetes API schema should be used to create or manage that object
