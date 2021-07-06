package common

import (
	"strings"

	"github.com/gruntwork-io/terratest/modules/random"
)

// Path to the helm chart we will test
var (
	helmChartPath []string = []string{
		"../../charts/rasa",
		"../../charts/rasa-action-server",
		"../../charts/duckling",
	}
	releaseName   string = "test-release-name"
	namespaceName string = "ns-" + strings.ToLower(random.UniqueId())
)
