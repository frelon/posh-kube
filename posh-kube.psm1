function Set-Context {
    param([string] $context="")

    kubectl config use-context $context
}

function Set-Namespace {
    param([string] $namespace="")

    $CurrentContext = kubectl config current-context

    kubectl config set-context $CurrentContext --namespace $namespace
}

function Get-CurrentContext {
    kubectl config current-context
}

function Get-CurrentNamespace {
    $context = Get-CurrentContext
    kubectl config view -o jsonpath="{.contexts[?(@.name=='$context')].context.namespace}"
}

$PoshKubePrompt = {
    try {
        $context = Get-CurrentContext
        $namespace = Get-CurrentNamespace 

        $prompt = "[$context/$namespace]"

        Write-Prompt $prompt
    }
    catch {
        Write-Prompt $errorText = "PoshKubePrompt error: $_"
    }
}

$global:VcsPromptStatuses += $PoshKubePrompt