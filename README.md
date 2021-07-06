# Rasa Helm Charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/rasa)](https://artifacthub.io/packages/search?repo=rasa)

Official Helm charts for Rasa products:

- [Rasa Open Source](charts/rasa)
- [Rasa Action Server](charts/rasa-action-server)

Helm charts for components used by Rasa:

- [Duckling](charts/duckling)

## Prerequisites

- [Helm 3](https://helm.sh/) (>= 3.5 )
- Kubernetes 1.14+

## How to use Rasa Helm repository?

You need to add this repository to your Helm repositories:

```shell
helm repo add rasa https://helm.rasa.com
helm repo update
```

## Where to get help

- If you encounter bugs or have suggestions for this Helm chart, please create an issue in this repository.
- If you have general questions about usage, please create a thread in the [Rasa Forum](https://forum.rasa.com/).

## How to contribute

We are very happy to receive your contributions. You can
find more information about how to contribute to Rasa (in lots of
different ways!) [here](http://rasa.com/community/contribute).

To contribute via pull request, follow these steps:

1. Create an issue describing the feature you want to work on
2. Create a pull request describing your changes

Remember that your PR should include:

1. Details about the changes introduced by a given chart version (use the `artifacthub.io/changes` annotation in the `Chart.yaml` file)
2. Update the chart version
3. Add additional annotations that indicate your changes (see: https://artifacthub.io/docs/topics/annotations/helm/#supported-annotations)

## License

Licensed under the Apache License, Version 2.0. Copyright 2021 Rasa Technologies GmbH. Copy of the license.
