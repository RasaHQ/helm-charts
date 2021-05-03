package common

import (
	"fmt"
	"testing"

	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"

	"github.com/stretchr/testify/require"

	"github.com/gruntwork-io/terratest/modules/helm"
	"github.com/gruntwork-io/terratest/modules/k8s"
)

func TestTemplateRendersContainerImage(t *testing.T) {
	t.Parallel()

	// Setup the args. For this test, we will set the following input values:
	for _, chartPath := range helmChartPath {
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
		output := helm.RenderTemplate(t, options, chartPath, releaseName, []string{"templates/deployment.yaml"})

		var deployment appsv1.Deployment
		helm.UnmarshalK8SYaml(t, output, &deployment)

		// Verify the deployment pod template spec is set to the expected container image value
		deploymentSpec := deployment.Spec.Template.Spec
		msg := fmt.Sprintf("Chart path: %s", chartPath)
		require.Equal(t, len(deploymentSpec.Containers), 1)
		require.Equal(t, deploymentSpec.Containers[0].Image, "docker.io/rasa/test-image:2.0.0", msg)
		require.Equal(t, deploymentSpec.Containers[0].ImagePullPolicy, corev1.PullAlways, msg)
		require.Equal(t, deploymentSpec.ImagePullSecrets, []corev1.LocalObjectReference{corev1.LocalObjectReference{Name: "pull_secret"}}, msg)
	}
}

func TestTemplateDeploymentLabelsAndAnnotations(t *testing.T) {
	t.Parallel()

	// Setup the args. For this test, we will set the following input values:
	for _, chartPath := range helmChartPath {
		options := &helm.Options{
			SetValues: map[string]string{
				"podLabels.test-label":                  "test-label-pod",
				"deploymentLabels.test-label":           "test-label-deployment",
				"deploymentAnnotations.test-annotation": "test-annotation-annotations",
				"podAnnotations.test-annotation":        "test-annotation-pod",
			},
			KubectlOptions: k8s.NewKubectlOptions("", "", namespaceName),
		}

		// Run RenderTemplate to render the template and capture the output.
		output := helm.RenderTemplate(t, options, chartPath, releaseName, []string{"templates/deployment.yaml"})

		var deployment appsv1.Deployment
		helm.UnmarshalK8SYaml(t, output, &deployment)

		// Verify the deployment pod template spec is set to the expected container image value
		deploymentMeta := deployment.ObjectMeta
		deploymentTemplateMeta := deployment.Spec.Template.ObjectMeta
		msg := fmt.Sprintf("Chart path: %s", chartPath)
		require.Equal(t, deploymentMeta.Labels["test-label"], "test-label-deployment", msg)
		require.Equal(t, deploymentMeta.Annotations["test-annotation"], "test-annotation-annotations", msg)
		require.Equal(t, deploymentTemplateMeta.Labels["test-label"], "test-label-pod", msg)
		require.Equal(t, deploymentTemplateMeta.Annotations["test-annotation"], "test-annotation-pod", msg)
	}
}

func TestTemplateDeploymentSecurityContext(t *testing.T) {
	t.Parallel()

	// Setup the args. For this test, we will set the following input values:
	for _, chartPath := range helmChartPath {
		options := &helm.Options{
			SetValues: map[string]string{
				"podSecurityContext.fsGroup":           "200",
				"securityContext.capabilities.drop[0]": "ALL",
			},
			KubectlOptions: k8s.NewKubectlOptions("", "", namespaceName),
		}

		// Run RenderTemplate to render the template and capture the output.
		output := helm.RenderTemplate(t, options, chartPath, releaseName, []string{"templates/deployment.yaml"})

		var deployment appsv1.Deployment
		helm.UnmarshalK8SYaml(t, output, &deployment)

		// Verify the deployment pod template spec is set to the expected container image value
		deploymentTemplateSpec := deployment.Spec.Template.Spec
		msg := fmt.Sprintf("Chart path: %s", chartPath)
		require.NotEmpty(t, deploymentTemplateSpec.SecurityContext.FSGroup, msg)
		require.Equal(t, deploymentTemplateSpec.Containers[0].SecurityContext.Capabilities.Drop, []corev1.Capability{"ALL"}, msg)
	}
}

func TestTemplateDeploymentNodeSelectorAndAffinityAndTolerations(t *testing.T) {
	t.Parallel()

	// Setup the args. For this test, we will set the following input values:
	for _, chartPath := range helmChartPath {
		options := &helm.Options{
			SetValues: map[string]string{
				"nodeSelector.test":       "test",
				"tolerations[0].key":      "key1",
				"tolerations[0].operator": "Exists",
				"tolerations[0].effect":   "NoSchedule",
				"affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator": "In",
			},
			KubectlOptions: k8s.NewKubectlOptions("", "", namespaceName),
		}

		// Run RenderTemplate to render the template and capture the output.
		output := helm.RenderTemplate(t, options, chartPath, releaseName, []string{"templates/deployment.yaml"})

		var deployment appsv1.Deployment
		helm.UnmarshalK8SYaml(t, output, &deployment)

		// Verify the deployment pod template spec is set to the expected container image value
		deploymentTemplateSpec := deployment.Spec.Template.Spec
		msg := fmt.Sprintf("Chart path: %s", chartPath)
		require.Equal(t, deploymentTemplateSpec.Tolerations, []corev1.Toleration{corev1.Toleration{Key: "key1", Operator: "Exists", Value: "", Effect: "NoSchedule", TolerationSeconds: (*int64)(nil)}}, msg)
		require.Equal(t, deploymentTemplateSpec.NodeSelector, map[string]string{"test": "test"}, msg)
		require.Equal(t, deploymentTemplateSpec.Affinity.NodeAffinity.RequiredDuringSchedulingIgnoredDuringExecution.NodeSelectorTerms[0].MatchExpressions[0].Operator, corev1.NodeSelectorOperator("In"), msg)
	}
}

func TestTemplateRendersContainerArgsAndCommand(t *testing.T) {
	t.Parallel()

	// Setup the args. For this test, we will set the following input values:
	for _, chartPath := range helmChartPath {
		testCases := []struct {
			name   string
			values map[string]string
		}{
			{
				"OverrideArgsAndCommand",
				map[string]string{
					"args[0]":    "test-args",
					"command[0]": "test-command",
				},
			},
			{
				"AddExtraArgs",
				map[string]string{
					"extraArgs[0]": "extra-args",
				},
			},
		}
		for _, testCase := range testCases {
			testCase := testCase

			t.Run(testCase.name, func(subT *testing.T) {
				subT.Parallel()

				// Now we try rendering the template, but verify we get an error
				options := &helm.Options{SetValues: testCase.values}
				// Run RenderTemplate to render the template and capture the output.
				output := helm.RenderTemplate(t, options, chartPath, releaseName, []string{"templates/deployment.yaml"})
				var deployment appsv1.Deployment
				helm.UnmarshalK8SYaml(t, output, &deployment)

				// Verify the deployment pod template spec is set to the expected container image value
				deploymentSpec := deployment.Spec.Template.Spec
				msg := fmt.Sprintf("Chart path: %s, case: %s", chartPath, testCase.name)
				require.Equal(t, len(deploymentSpec.Containers), 1)

				switch testCase.name {
				case "OverrideArgsAndCommand":
					require.Equal(t, deploymentSpec.Containers[0].Command, []string{"test-command"}, msg)
					require.Equal(t, deploymentSpec.Containers[0].Args, []string{"test-args"}, msg)
				case "AddExtraArgs":
					require.Contains(t, deploymentSpec.Containers[0].Args, "extra-args", msg)
				}
			})
		}
	}
}

func TestTemplateRendersContainerImageRepository(t *testing.T) {
	t.Parallel()

	// Setup the args. For this test, we will set the following input values:
	for _, chartPath := range helmChartPath {
		options := &helm.Options{
			SetValues: map[string]string{
				"image.repository": "test-image",
			},
			KubectlOptions: k8s.NewKubectlOptions("", "", namespaceName),
		}

		// Run RenderTemplate to render the template and capture the output.
		output := helm.RenderTemplate(t, options, chartPath, releaseName, []string{"templates/deployment.yaml"})

		var deployment appsv1.Deployment
		helm.UnmarshalK8SYaml(t, output, &deployment)

		// Verify the deployment pod template spec is set to the expected container image value
		deploymentSpec := deployment.Spec.Template.Spec
		require.Equal(t, len(deploymentSpec.Containers), 1)
		require.Equal(t, deploymentSpec.Containers[0].Image, "test-image:2.4.0", "Chart path: %s", chartPath)
	}
}

func TestTemplateRendersDeploymentServiceAccount(t *testing.T) {
	t.Parallel()

	// Setup the args. For this test, we will set the following input values:
	for _, chartPath := range helmChartPath {
		options := &helm.Options{
			SetValues: map[string]string{
				"serviceAccount.create": "true",
				"serviceAccount.name":   "test-name-sa",
			},
			KubectlOptions: k8s.NewKubectlOptions("", "", namespaceName),
		}

		// Run RenderTemplate to render the template and capture the output.
		output := helm.RenderTemplate(t, options, chartPath, releaseName, []string{"templates/deployment.yaml"})

		var deployment appsv1.Deployment
		helm.UnmarshalK8SYaml(t, output, &deployment)

		// Verify the deployment pod template spec is set to the expected container image value
		deploymentSpec := deployment.Spec.Template.Spec
		require.Equal(t, deploymentSpec.ServiceAccountName, "test-name-sa", "Chart path: %s", chartPath)
	}
}
