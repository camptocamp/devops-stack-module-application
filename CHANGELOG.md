# Changelog

## [4.1.0](https://github.com/camptocamp/devops-stack-module-application/compare/v4.0.0...v4.1.0) (2025-07-09)


### Features

* add a way to create Argo CD applications from Helm repositories ([#43](https://github.com/camptocamp/devops-stack-module-application/issues/43)) ([08bdd84](https://github.com/camptocamp/devops-stack-module-application/commit/08bdd84463634a49b7f21c68dfca34ad55ad5a50))

## [4.0.0](https://github.com/camptocamp/devops-stack-module-application/compare/v3.0.0...v4.0.0) (2024-10-09)


### ⚠ BREAKING CHANGES

* point the Argo CD provider to the new repository ([#41](https://github.com/camptocamp/devops-stack-module-application/issues/41))

### Features

* point the Argo CD provider to the new repository ([#41](https://github.com/camptocamp/devops-stack-module-application/issues/41)) ([85a2629](https://github.com/camptocamp/devops-stack-module-application/commit/85a2629429fca91af07406f032d02b1b26238750))

### Migrate provider source `oboukili` -> `argoproj-labs`

We've tested the procedure found [here](https://github.com/argoproj-labs/terraform-provider-argocd?tab=readme-ov-file#migrate-provider-source-oboukili---argoproj-labs) and we think the order of the steps is not exactly right. This is the procedure we recommend (**note that this should be run manually on your machine and not on a CI/CD workflow**):

1. First, make sure you are already using version 6.2.0 of the `oboukili/argocd` provider.

1. Then, check which modules you have that are using the `oboukili/argocd` provider.

```shell
$ terraform providers

Providers required by configuration:
.
├── provider[registry.terraform.io/hashicorp/helm] 2.15.0
├── (...)
└── provider[registry.terraform.io/oboukili/argocd] 6.2.0

Providers required by state:

    (...)

    provider[registry.terraform.io/oboukili/argocd]

    provider[registry.terraform.io/hashicorp/helm]
```

3. Afterwards, proceed to point **ALL*  the DevOps Stack modules to the versions that have changed the source on their respective requirements. In case you have other personal modules that also declare `oboukili/argocd` as a requirement, you will also need to update them.

4. Also update the required providers on your root module. If you've followed our examples, you should find that configuration on the `terraform.tf` file in the root folder.

5. Execute the migration  via `terraform state replace-provider`:

```bash
$ terraform state replace-provider registry.terraform.io/oboukili/argocd registry.terraform.io/argoproj-labs/argocd
Terraform will perform the following actions:

  ~ Updating provider:
    - registry.terraform.io/oboukili/argocd
    + registry.terraform.io/argoproj-labs/argocd

Changing 13 resources:

  module.argocd_bootstrap.argocd_project.devops_stack_applications
  module.secrets.module.secrets.argocd_application.this
  module.metrics-server.argocd_application.this
  module.efs.argocd_application.this
  module.loki-stack.module.loki-stack.argocd_application.this
  module.thanos.module.thanos.argocd_application.this
  module.cert-manager.module.cert-manager.argocd_application.this
  module.kube-prometheus-stack.module.kube-prometheus-stack.argocd_application.this
  module.argocd.argocd_application.this
  module.traefik.module.traefik.module.traefik.argocd_application.this
  module.ebs.argocd_application.this
  module.helloworld_apps.argocd_application.this
  module.helloworld_apps.argocd_project.this

Do you want to make these changes?
Only 'yes' will be accepted to continue.

Enter a value: yes

Successfully replaced provider for 13 resources.
```

6. Perform a `terraform init -upgrade` to upgrade your local `.terraform` folder.

7. Run a `terraform plan` or `terraform apply` and you should see that everything is OK and that no changes are necessary. 

## [3.0.0](https://github.com/camptocamp/devops-stack-module-application/compare/v2.1.0...v3.0.0) (2024-01-19)


### ⚠ BREAKING CHANGES

* remove the ArgoCD namespace variable ([#38](https://github.com/camptocamp/devops-stack-module-application/issues/38))

### Bug Fixes

* remove the ArgoCD namespace variable ([#38](https://github.com/camptocamp/devops-stack-module-application/issues/38)) ([38ada7e](https://github.com/camptocamp/devops-stack-module-application/commit/38ada7e87e44dde175f0938260e1599b22e4afd6))

## [2.1.0](https://github.com/camptocamp/devops-stack-module-application/compare/v2.0.1...v2.1.0) (2023-09-14)


### Features

* add way to define destination cluster through name or address ([3a1a59f](https://github.com/camptocamp/devops-stack-module-application/commit/3a1a59f5783f26f32dc3215366260469aab2bdd6))

## [2.0.1](https://github.com/camptocamp/devops-stack-module-application/compare/v2.0.0...v2.0.1) (2023-08-09)


### Bug Fixes

* readd support to deactivate auto-sync which was broken by [#32](https://github.com/camptocamp/devops-stack-module-application/issues/32) ([#34](https://github.com/camptocamp/devops-stack-module-application/issues/34)) ([8d68a06](https://github.com/camptocamp/devops-stack-module-application/commit/8d68a06846fe0b66a23febd38fa45f2b77755b4c))

## [2.0.0](https://github.com/camptocamp/devops-stack-module-application/compare/v1.2.3...v2.0.0) (2023-07-11)


### ⚠ BREAKING CHANGES

* add support to oboukili/argocd v5 ([#32](https://github.com/camptocamp/devops-stack-module-application/issues/32))

### Features

* add support to oboukili/argocd v5 ([#32](https://github.com/camptocamp/devops-stack-module-application/issues/32)) ([7f36ae9](https://github.com/camptocamp/devops-stack-module-application/commit/7f36ae9c4fe826d74003dd6368406faa4ff7e5fe))

## [1.2.3](https://github.com/camptocamp/devops-stack-module-application/compare/v1.2.2...v1.2.3) (2023-05-30)


### Bug Fixes

* add missing provider ([511840a](https://github.com/camptocamp/devops-stack-module-application/commit/511840afcccc493c6b772e79bdcde48760040b48))

## [1.2.2](https://github.com/camptocamp/devops-stack-module-application/compare/v1.2.1...v1.2.2) (2023-03-08)


### Bug Fixes

* change to looser versions constraints as per best practices ([6895344](https://github.com/camptocamp/devops-stack-module-application/commit/68953445ca6bbedc4e8d6acea2b50fb93b4f0568))

## [1.2.1](https://github.com/camptocamp/devops-stack-module-application/compare/v1.2.0...v1.2.1) (2023-03-02)


### Bug Fixes

* add loose version constraints to the required providers ([0b2dbac](https://github.com/camptocamp/devops-stack-module-application/commit/0b2dbac600d521f887cf171103d631c55dfd1053))
* use comparison with null instead of can() ([a75eb6c](https://github.com/camptocamp/devops-stack-module-application/commit/a75eb6cba478ea9eaa6fe674d015a9e2989a0808))

## [1.2.0](https://github.com/camptocamp/devops-stack-module-application/compare/v1.1.1...v1.2.0) (2023-01-30)


### Features

* add variable to configure auto-sync of the Argo CD Application ([#22](https://github.com/camptocamp/devops-stack-module-application/issues/22)) ([528bfc5](https://github.com/camptocamp/devops-stack-module-application/commit/528bfc521deb70c043fe05ee7c066fd2dcbe75e9))

## [1.1.1](https://github.com/camptocamp/devops-stack-module-application/compare/v1.1.0...v1.1.1) (2022-12-09)


### Documentation

* add link to repository ([#20](https://github.com/camptocamp/devops-stack-module-application/issues/20)) ([9e9fbd4](https://github.com/camptocamp/devops-stack-module-application/commit/9e9fbd4d582e6cb346292b2a8a1e8424e6298c0b))

## [1.1.0](https://github.com/camptocamp/devops-stack-module-application/compare/v1.0.1...v1.1.0) (2022-11-18)


### Features

* add variables to configure credentials for private repositories ([#18](https://github.com/camptocamp/devops-stack-module-application/issues/18)) ([07c4a09](https://github.com/camptocamp/devops-stack-module-application/commit/07c4a09486232b1398192e3d55de171fa109d17d))

## [1.0.1](https://github.com/camptocamp/devops-stack-module-application/compare/v1.0.0...v1.0.1) (2022-10-26)


### Miscellaneous Chores

* release 1.0.1 to fix docs ([#16](https://github.com/camptocamp/devops-stack-module-application/issues/16)) ([6582c59](https://github.com/camptocamp/devops-stack-module-application/commit/6582c59d473cccca6cfad83fc5a7c2d9a3332427))

## [1.0.0](https://github.com/camptocamp/devops-stack-module-application/compare/v1.0.0...v1.0.0) (2022-10-24)


### Features

* initial implementation with docs ([#1](https://github.com/camptocamp/devops-stack-module-application/issues/1)) ([dc6c274](https://github.com/camptocamp/devops-stack-module-application/commit/dc6c274e5cf87b7a6d3c1560537112520ca58bfe))


### Tests

* release as prerelease ([#9](https://github.com/camptocamp/devops-stack-module-application/issues/9)) ([9f05018](https://github.com/camptocamp/devops-stack-module-application/commit/9f05018d42e836c8e6a9d71c8c5589b4f95a86e6))


### Miscellaneous Chores

* release v1 ([#11](https://github.com/camptocamp/devops-stack-module-application/issues/11)) ([b86b5c5](https://github.com/camptocamp/devops-stack-module-application/commit/b86b5c5395f03ca23542f277c97703cc532f579a))


### Continuous Integration

* remove tag from called workflows ([#13](https://github.com/camptocamp/devops-stack-module-application/issues/13)) ([221c4e2](https://github.com/camptocamp/devops-stack-module-application/commit/221c4e2ca9bf84f014c43c4532784c7c5a69e498))

## [1.0.0](https://github.com/camptocamp/devops-stack-module-application/compare/v1.0.0-beta1...v1.0.0) (2022-10-21)


### Miscellaneous Chores

* release v1 ([#11](https://github.com/camptocamp/devops-stack-module-application/issues/11)) ([b86b5c5](https://github.com/camptocamp/devops-stack-module-application/commit/b86b5c5395f03ca23542f277c97703cc532f579a))

## 1.0.0-beta1 (2022-10-21)


### Features

* initial implementation with docs ([#1](https://github.com/camptocamp/devops-stack-module-application/issues/1)) ([dc6c274](https://github.com/camptocamp/devops-stack-module-application/commit/dc6c274e5cf87b7a6d3c1560537112520ca58bfe))


### Tests

* release as prerelease ([#9](https://github.com/camptocamp/devops-stack-module-application/issues/9)) ([9f05018](https://github.com/camptocamp/devops-stack-module-application/commit/9f05018d42e836c8e6a9d71c8c5589b4f95a86e6))
