# Rafay Publish Workload Action


This action Creates a new Rafay workload, Updates if workload already exists and publishes to the clusters that is configured.

## Inputs

### `Rafay API Key` (required) configured as secrets in github repo
### `Rafay API Secret`(required) configured as secrets in github repo
### `Rafay Console endpoint` configured as secrets in github repo defaults to "console.rafay.dev"
### `Rafay Project` configured as secrets in github repo defaults to "defaultproject"
### `Name of the workload` (required) that you want to create or update
### `Name of the namespace` (required) where workload needs to be created
### `Path to the workload definition file` (required)

**Required**  All the above inputs are mandatory except for Rafay Console and Rafay project. If not using default project, Rafay Project also needs to be specified.

## Outputs

### `workload_status`

status of the workload after publish

## Example usage
```yaml
uses: actions/rafay-publish-workload@v1.2
with:
  rafay-api-key: ${{ secrets.RAFAY_API_KEY }}
  rafay-api-secret: ${{ secrets.RAFAY_API_SECRET }}
  rafay-endpoint: ${{ secrets.RAFAY_ENDPOINT }}
  rafay-project: ${{ secrets.RAFAY_PROJECT }}
  workload-name: demo-workload
  namespace-name: demo
  workload-spec-path: workload-spec.yaml
```
  
