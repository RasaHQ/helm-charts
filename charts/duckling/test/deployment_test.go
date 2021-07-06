package tests

import (
	"strings"
	"testing"

	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"

	"github.com/stretchr/testify/require"

	"github.com/gruntwork-io/terratest/modules/helm"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/random"
)

// Path to the helm chart we will test
var helmChartPath string = "../"
var releaseName string = "duckling"
var namespaceName string = "ns-" + strings.ToLower(random.UniqueId())

func TestTemplateRendersContainerImage(t *testing.T) {
	t.Parallel()

	// Setup the args. For this test, we will set the following input values:
	options := &helm.Options{
		SetValues: map[string]string{
			"image.name":                "test-image",
			"image.tag":                 "2.0.0",
			"image.pullPolicy":          "Always",
			"image.pullSecrets[0].name": "pull_secret",
		},
		KubectlOptions: k8s.NewKubectlOptions("", "", namespaceName),
	}

	// Run RenderTemplate to render the template and capture the output.
	output := helm.RenderTemplate(t, options, helmChartPath, releaseName, []string{"templates/deployment.yaml"})

	var deployment appsv1.Deployment
	helm.UnmarshalK8SYaml(t, output, &deployment)

	// Verify the deployment pod template spec is set to the expected container image value
	deploymentSpec := deployment.Spec.Template.Spec
	require.Equal(t, len(deploymentSpec.Containers), 1)
	require.Equal(t, deploymentSpec.Containers[0].Image, "docker.io/rasa/test-image:2.0.0")
	require.Equal(t, deploymentSpec.Containers[0].ImagePullPolicy, corev1.PullAlways)
	require.Equal(t, deploymentSpec.ImagePullSecrets, []corev1.LocalObjectReference{corev1.LocalObjectReference{Name: "pull_secret"}})
}

func TestTemplateRendersContainerImageRepository(t *testing.T) {
	t.Parallel()

	// Setup the args. For this test, we will set the following input values:
	options := &helm.Options{
		SetValues: map[string]string{
			"image.repository": "test-image",
			"image.tag":        "2.4.0",
		},
		KubectlOptions: k8s.NewKubectlOptions("", "", namespaceName),
	}

	// Run RenderTemplate to render the template and capture the output.
	output := helm.RenderTemplate(t, options, helmChartPath, releaseName, []string{"templates/deployment.yaml"})

	var deployment appsv1.Deployment
	helm.UnmarshalK8SYaml(t, output, &deployment)

	// Verify the deployment pod template spec is set to the expected container image value
	deploymentSpec := deployment.Spec.Template.Spec
	require.Equal(t, len(deploymentSpec.Containers), 1)
	require.Equal(t, "test-image:2.4.0", deploymentSpec.Containers[0].Image)
}
