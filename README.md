# devops-stack-module-application

A [DevOps Stack](https://devops-stack.io) module to deploy a simple Application in Argo CD.

The module creates an Argo CD AppProject using the name given on instanciation and then creates an Argo CD Application using the chart that is inside the path for the Git repository that is declared.

Inside that folder, the module expects an Helm chart with a folder structure similar to the following (as is standard practice):

```
application_folder
  ├── Chart.yaml
  ├── charts
  │   ├── dependency1.tar.gz
  │   └── dependency2.tar.gz
  ├── secrets.yaml
  ├── templates
  │   ├── template1.yaml
  │   ├── template2.yaml
  │   ├── template3.yaml
  │   └── _helpers.tpl
  └── values.yaml
```

By default, the created AppProject can only create an Application within a Namespace of the same name or within a Namespace declared on instanciation. Besides that, the AppProject has the permission to create any kind of Kubernetes resources inside the destination cluster, but you can restrict the allowed resources if you need to.

## Usage

This module can be instanciated by adding the following block on your Terraform configuration:

```hcl
module "module_name" {
  source = "git::https://github.com/camptocamp/devops-stack-module-application.git?ref=<RELEASE>"

  name = "application-name"
  argocd_namespace = local.argocd_namespace

  source_repo = "https://github.com/owner/repository.git"
  source_repo_path = "path/to/chart"
  source_target_revision = "branch"

  depends_on = [module.argocd]
}
```

A more complex instanciation, that defines the Namespace and also the AppProject allowed resources, would look like this:

```hcl
module "module_name" {
  source = "git::https://github.com/camptocamp/devops-stack-module-application.git?ref=<RELEASE>"

  name = "application-name"
  argocd_namespace = local.argocd_namespace

  source_repo = "https://github.com/owner/repository.git"
  source_repo_path = "path/to/chart"
  source_target_revision = "branch"

  destination_namespace = "namespace" # Optional

  project_cluster_resource_whitelist = [ 
    {
      group = "*"
      kind = "Namespace"
    },
  ]

  project_namespace_resource_whitelist = [
    {
      group = "apps"
      kind = "Deployment"
    },
    {
      group = "*"
      kind = "Service"
    },
  ]

  depends_on = [module.argocd]
}
```

Furthermore, you can customize the chart's `values.yaml` by adding an Helm configuration as an HCL structure:

```hcl
module "module_name" {
  source = "git::https://github.com/camptocamp/devops-stack-module-application.git?ref=<RELEASE>"

  name = "application-name"
  argocd_namespace = local.argocd_namespace

  source_repo = "https://github.com/owner/repository.git"
  source_repo_path = "path/to/chart"
  source_target_revision = "branch"

  helm_values = [
    map = {
      string = "string"
      bool = true
    }
    sequence = [
      {
        key1 = "value1"
        key2 = "value2"
      },
      {
        key1 = "value1"
        key2 = "value2"
      },
    ]
    sequence2 = [
      "string1",
      "string2"
    ]
  ]
  
  depends_on = [module.argocd]
}
```

## Technical Reference

### Dependencies

#### `depends_on = [module.argocd]`

As this is an application, it needs to be deployed after the deployment of Argo CD and consequently this module needs to have this explicit dependency.

<!-- BEGIN_TF_DOCS -->
### Requirements

No requirements.

### Providers

The following providers are used by this module:

- <a name="provider_argocd"></a> [argocd](#provider\_argocd)

- <a name="provider_null"></a> [null](#provider\_null)

- <a name="provider_utils"></a> [utils](#provider\_utils)

### Modules

No modules.

### Resources

The following resources are used by this module:

- [argocd_application.this](https://registry.terraform.io/providers/oboukili/argocd/latest/docs/resources/application) (resource)
- [argocd_project.this](https://registry.terraform.io/providers/oboukili/argocd/latest/docs/resources/project) (resource)
- [null_resource.this](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) (resource)
- [utils_deep_merge_yaml.values](https://registry.terraform.io/providers/cloudposse/utils/latest/docs/data-sources/deep_merge_yaml) (data source)

### Required Inputs

The following input variables are required:

#### <a name="input_argocd_namespace"></a> [argocd\_namespace](#input\_argocd\_namespace)

Description: n/a

Type: `string`

#### <a name="input_name"></a> [name](#input\_name)

Description: Name to give the to the AppProject and Application

Type: `string`

#### <a name="input_source_repo"></a> [source\_repo](#input\_source\_repo)

Description: Repository where the application chart is located

Type: `string`

#### <a name="input_source_repo_path"></a> [source\_repo\_path](#input\_source\_repo\_path)

Description: Path for the application charts in the source repository

Type: `string`

#### <a name="input_source_target_revision"></a> [source\_target\_revision](#input\_source\_target\_revision)

Description: Git target revision for the application

Type: `string`

### Optional Inputs

The following input variables are optional (have default values):

#### <a name="input_dependency_ids"></a> [dependency\_ids](#input\_dependency\_ids)

Description: n/a

Type: `map(string)`

Default: `{}`

#### <a name="input_destination_namespace"></a> [destination\_namespace](#input\_destination\_namespace)

Description: Namespace where the application will be deployed

Type: `string`

Default: `null`

#### <a name="input_helm_values"></a> [helm\_values](#input\_helm\_values)

Description: Helm values, passed as a list of HCL structures.

Type: `any`

Default: `[]`

#### <a name="input_project_cluster_resource_whitelist"></a> [project\_cluster\_resource\_whitelist](#input\_project\_cluster\_resource\_whitelist)

Description: Cluster-scoped resources allowed to be managed by the project applications

Type:

```hcl
list(object({
    group = string
    kind = string
  }))
```

Default:

```json
[
  {
    "group": "*",
    "kind": "*"
  }
]
```

#### <a name="input_project_namespace_resource_whitelist"></a> [project\_namespace\_resource\_whitelist](#input\_project\_namespace\_resource\_whitelist)

Description: Namespaced-scoped resources allowed to be managed by the project applications

Type:

```hcl
list(object({
    group = string
    kind = string
  }))
```

Default:

```json
[
  {
    "group": "*",
    "kind": "*"
  }
]
```

### Outputs

The following outputs are exported:

#### <a name="output_id"></a> [id](#output\_id)

Description: n/a
<!-- END_TF_DOCS -->