package common

import (
	"testing"

	corev1 "k8s.io/api/core/v1"

	"github.com/stretchr/testify/require"

	"github.com/gruntwork-io/terratest/modules/helm"
	"github.com/gruntwork-io/terratest/modules/k8s"
)

func TestTemplateRendersServiceAccount(t *testing.T) {
	t.Parallel()

	// Setup the args. For this test, we will set the following input values:
	for _, chartPath := range helmChartPath {
		options := &helm.Options{
			SetValues: map[string]string{
				"serviceAccount.create":                      "true",
				"serviceAccount.name":                        "test-name-sa",
				"serviceAccount.annotations.test-annotation": "test",
			},
			KubectlOptions: k8s.NewKubectlOptions("", "", namespaceName),
		}

		// Render the template and capture the output.
		output := helm.RenderTemplate(t, options, chartPath, releaseName, []string{"templates/serviceaccount.yaml"})

		var serviceAccount corev1.ServiceAccount
		helm.UnmarshalK8SYaml(t, output, &serviceAccount)

		// Verify the service account template spec is set to the expected value
		serviceAccountMeta := serviceAccount.ObjectMeta
		require.Equal(t, serviceAccountMeta.Name, "test-name-sa", "Chart path: %s", chartPath)
		require.Equal(t, serviceAccountMeta.Annotations, map[string]string{"test-annotation": "test"}, "Chart path: %s", chartPath)
	}
}
