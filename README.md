# Rasa Helm Charts
The official Helm Charts for Rasa products can be found here. To get started, they require:
- [Helm 3](https://helm.sh/) (>= 3.5 )
- Kubernetes 1.19+

## Rasa Pro
Documentation for installing Rasa Pro with Helm can be found [here](https://rasa.com/docs/rasa-pro/deploy/introduction).

Download the Rasa Pro Helm charts with:
```
helm pull oci://europe-west3-docker.pkg.dev/rasa-releases/helm-charts/rasa
```

## Rasa Studio
Documentation for installing Rasa Studio with Helm can be found [here](https://rasa.com/docs/studio/deployment/installation-guide). 

Download the Rasa Studio Helm charts with:
```
helm pull oci://europe-west3-docker.pkg.dev/rasa-releases/helm-charts/studio
```

## Support
If you encounter bugs or have suggestions for these Helm charts:
- Community users may create a thread in the [Rasa Forum](https://forum.rasa.com/) for general questions or issues.
- Commercial customers can contact their Customer Success Manager or submit a support request by going to [Rasa Support](https://rasa.com/support/).

## Other Rasa Products
You can find our older Helm charts for other Rasa products here:
- [Rasa Open Source](https://github.com/RasaHQ/helm-charts/tree/main/charts/rasa)
- [Rasa Action Server](https://github.com/RasaHQ/helm-charts/tree/main/charts/rasa-action-server)
- [Rasa X/Enterprise](https://github.com/RasaHQ/rasa-x-helm)
- [Duckling](https://github.com/RasaHQ/helm-charts/tree/main/charts/duckling)

You need to add this repository to your Helm repositories:

```shell
helm repo add rasa https://helm.rasa.com
helm repo update
```

## License

Licensed under the Apache License, Version 2.0. Copyright 2024 Rasa Technologies GmbH. [LICENSE](https://github.com/RasaHQ/helm-charts/blob/main/LICENSE).
