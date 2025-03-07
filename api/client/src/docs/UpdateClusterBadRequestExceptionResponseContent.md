# UpdateClusterBadRequestExceptionResponseContent

This exception is thrown when a client calls the UpdateCluster API with an invalid request. This includes an error due to invalid cluster configuration and unsupported update.

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**message** | **str** |  | [optional] 
**configuration_validation_errors** | [**[ConfigValidationMessage]**](ConfigValidationMessage.md) |  | [optional] 
**update_validation_errors** | [**[UpdateError]**](UpdateError.md) |  | [optional] 
**change_set** | [**[Change]**](Change.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


