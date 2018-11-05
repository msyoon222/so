INSERT INTO requestdb.infra_active_requests(REQUEST_ID, CLIENT_REQUEST_ID, ACTION, REQUEST_STATUS, STATUS_MESSAGE, PROGRESS, START_TIME, END_TIME, SOURCE, VNF_ID, VNF_NAME, VNF_TYPE, SERVICE_TYPE, AIC_NODE_CLLI, TENANT_ID, PROV_STATUS, VNF_PARAMS, VNF_OUTPUTS, REQUEST_BODY, RESPONSE_BODY, LAST_MODIFIED_BY, MODIFY_TIME, REQUEST_TYPE, VOLUME_GROUP_ID, VOLUME_GROUP_NAME, VF_MODULE_ID, VF_MODULE_NAME, VF_MODULE_MODEL_NAME, AAI_SERVICE_ID, AIC_CLOUD_REGION, CALLBACK_URL, CORRELATOR, NETWORK_ID, NETWORK_NAME, NETWORK_TYPE, REQUEST_SCOPE, REQUEST_ACTION, SERVICE_INSTANCE_ID, SERVICE_INSTANCE_NAME, REQUESTOR_ID, CONFIGURATION_ID, CONFIGURATION_NAME, OPERATIONAL_ENV_ID, OPERATIONAL_ENV_NAME, REQUEST_URL) VALUES
('00032ab7-3fb3-42e5-965d-8ea592502017', '00032ab7-3fb3-42e5-965d-8ea592502016', 'deleteInstance', 'COMPLETE', 'Vf Module has been deleted successfully.', '100', '2016-12-22 18:59:54', '2016-12-22 19:00:28', 'VID', 'b92f60c8-8de3-46c1-8dc1-e4390ac2b005', null, null, null, null, '6accefef3cb442ff9e644d589fb04107', null, null, null, '{"modelInfo":{"modelType":"vfModule","modelName":"test::base::module-0"},"requestInfo":{"source":"VID"},"cloudConfiguration":{"tenantId":"6accefef3cb442ff9e644d589fb04107","lcpCloudRegionId":"n6"}}', null, 'BPMN', '2016-12-22 19:00:28', null, null, null, 'c7d527b1-7a91-49fd-b97d-1c8c0f4a7992', null, 'test::base::module-0', null, 'n6', null, null, null, null, null, 'vfModule', 'deleteInstance', 'e3b5744d-2ad1-4cdd-8390-c999a38829bc', null, null, null, null, null, null, 'http://localhost:8080/onap/so/infra/serviceInstantiation/v7/serviceInstances'),
('00032ab7-na18-42e5-965d-8ea592502018', '00032ab7-fake-42e5-965d-8ea592502018', 'deleteInstance', 'PENDING', 'Vf Module deletion pending.', '0', '2016-12-22 18:59:54', '2016-12-22 19:00:28', 'VID', 'b92f60c8-8de3-46c1-8dc1-e4390ac2b005', null, null, null, null, '6accefef3cb442ff9e644d589fb04107', null, null, null, '{"requestDetails": {"modelInfo":{"modelType":"vfModule","modelName":"test::base::module-0"},"requestInfo":{"source":"VID"},"cloudConfiguration":{"tenantId":"6accefef3cb442ff9e644d589fb04107","lcpCloudRegionId":"n6"}}}', null, 'BPMN', '2016-12-22 19:00:28', null, null, null, 'c7d527b1-7a91-49fd-b97d-1c8c0f4a7992', null, 'test::base::module-0', null, 'n6', null, null, null, null, null, 'vfModule', 'deleteInstance', 'e3b5744d-2ad1-4cdd-8390-c999a38829bc', null, null, null, null, null, null, 'http://localhost:8080/onap/so/infra/serviceInstantiation/v7/serviceInstances'),
('00093944-bf16-4373-ab9a-3adfe730ff2d', null, 'createInstance', 'FAILED', 'Error: Locked instance - This service (MSODEV_1707_SI_v10_011-4) already has a request being worked with a status of IN_PROGRESS (RequestId - 278e83b1-4f9f-450e-9e7d-3700a6ed22f4). The existing request must finish or be cleaned up before proceeding.', '100', '2017-07-11 18:33:26', '2017-07-11 18:33:26', 'VID', null, null, null, null, null, '19123c2924c648eb8e42a3c1f14b7682', null, null, null, '{"modelInfo":{"modelInvariantId":"9647dfc4-2083-11e7-93ae-92361f002671","modelType":"service","modelName":"Infra_v10_Service","modelVersion":"1.0","modelVersionId":"5df8b6de-2083-11e7-93ae-92361f002671"},"requestInfo":{"source":"VID","instanceName":"MSODEV_1707_SI_v10_011-4","suppressRollback":false,"requestorId":"xxxxxx"},"subscriberInfo":{"globalSubscriberId":"MSO_1610_dev","subscriberName":"MSO_1610_dev"},"cloudConfiguration":{"tenantId":"19123c2924c648eb8e42a3c1f14b7682","lcpCloudRegionId":"n6"},"requestParameters":{"subscriptionServiceType":"MSO-dev-service-type","userParams":[{"name":"someUserParam","value":"someValue"}],"aLaCarte":true,"autoBuildVfModules":false,"cascadeDelete":false,"usePreload":true}}', null, 'APIH', null, null, null, null, null, null, null, null, 'n6', null, null, null, null, null, 'service', 'createInstance', null, 'MSODEV_1707_SI_v10_011-4', 'xxxxxx', null, null, null, null, 'http://localhost:8080/onap/so/infra/serviceInstantiation/v7/serviceInstances'),
('001619d2-a297-4a4b-a9f5-e2823c88458f', '001619d2-a297-4a4b-a9f5-e2823c88458f', 'CREATE_VF_MODULE', 'COMPLETE', 'COMPLETED', '100', '2016-07-01 14:11:42', '2017-05-02 16:03:34', 'PORTAL', null, 'test-vscp', 'elena_test21', null, null, '381b9ff6c75e4625b7a4182f90fc68d3', null, null, null, '{"requestDetails": {"modelInfo":{"modelType":"vfModule","modelName":"test::base::module-0"},"requestInfo":{"source":"VID"},"cloudConfiguration":{"tenantId":"6accefef3cb442ff9e644d589fb04107","lcpCloudRegionId":"n6"}}}', 'NONE', 'RDBTEST', '2016-07-01 14:11:42', 'VNF', null, null, null, 'MODULENAME1', 'moduleModelName', 'a9a77d5a-123e-4ca2-9eb9-0b015d2ee0fb', 'mtn9', null, null, null, null, null, 'vfModule', 'createInstance', null, null, null, null, null, null, null, 'http://localhost:8080/onap/so/infra/serviceInstantiation/v7/serviceInstances'),
('5ffbabd6-b793-4377-a1ab-082670fbc7ac', '5ffbabd6-b793-4377-a1ab-082670fbc7ac', 'deleteInstance', 'PENDING', 'Vf Module deletion pending.', '0', '2016-12-22 18:59:54', '2016-12-22 19:00:28', 'VID', 'b92f60c8-8de3-46c1-8dc1-e4390ac2b005', null, null, null, null, '6accefef3cb442ff9e644d589fb04107', null, null, null, '{"requestDetails": {"modelInfo": {"modelType": "vfModule","modelName": "test::base::module-0","modelVersionId": "20c4431c-246d-11e7-93ae-92361f002671","modelInvariantId": "78ca26d0-246d-11e7-93ae-92361f002671","modelVersion": "2","modelCustomizationId": "cb82ffd8-252a-11e7-93ae-92361f002671"},"cloudConfiguration": {"lcpCloudRegionId": "n6","tenantId": "0422ffb57ba042c0800a29dc85ca70f8"},"requestInfo": {"instanceName": "MSO-DEV-VF-1806BB-v10-base-it2-1","source": "VID","suppressRollback": false,"requestorId": "xxxxxx"},"relatedInstanceList": [{"relatedInstance": {"instanceId": "76fa8849-4c98-473f-b431-2590b192a653","modelInfo": {"modelType": "service","modelName": "Infra_v10_Service","modelVersionId": "5df8b6de-2083-11e7-93ae-92361f002671","modelInvariantId": "9647dfc4-2083-11e7-93ae-92361f002671","modelVersion": "1.0"}}},{"relatedInstance": {"instanceId": "d57970e1-5075-48a5-ac5e-75f2d6e10f4c","modelInfo": {"modelType": "vnf","modelName": "v10","modelVersionId": "ff2ae348-214a-11e7-93ae-92361f002671","modelInvariantId": "2fff5b20-214b-11e7-93ae-92361f002671","modelVersion": "1.0","modelCustomizationId": "68dc9a92-214c-11e7-93ae-92361f002671","modelCustomizationName": "v10 1"}}}],"requestParameters": {"usePreload": true,"userParams": []}}}', null, 'BPMN', '2016-12-22 19:00:28', null, null, null, 'c7d527b1-7a91-49fd-b97d-1c8c0f4a7992', null, 'test::base::module-0', null, 'n6', null, null, null, null, null, 'vfModule', 'deleteInstance', 'e3b5744d-2ad1-4cdd-8390-c999a38829bc', null, null, null, null, null, null, 'http://localhost:8080/onap/so/infra/serviceInstantiation/v7/serviceInstances');
INSERT INTO requestdb.infra_active_requests(REQUEST_ID, CLIENT_REQUEST_ID, ACTION, REQUEST_STATUS, STATUS_MESSAGE, PROGRESS, START_TIME, END_TIME, SOURCE, VNF_ID, VNF_NAME, VNF_TYPE, SERVICE_TYPE, AIC_NODE_CLLI, TENANT_ID, PROV_STATUS, VNF_PARAMS, VNF_OUTPUTS, REQUEST_BODY, RESPONSE_BODY, LAST_MODIFIED_BY, MODIFY_TIME, REQUEST_TYPE, VOLUME_GROUP_ID, VOLUME_GROUP_NAME, VF_MODULE_ID, VF_MODULE_NAME, VF_MODULE_MODEL_NAME, AAI_SERVICE_ID, AIC_CLOUD_REGION, CALLBACK_URL, CORRELATOR, NETWORK_ID, NETWORK_NAME, NETWORK_TYPE, REQUEST_SCOPE, REQUEST_ACTION, SERVICE_INSTANCE_ID, SERVICE_INSTANCE_NAME, REQUESTOR_ID, CONFIGURATION_ID, CONFIGURATION_NAME, OPERATIONAL_ENV_ID, OPERATIONAL_ENV_NAME, REQUEST_URL) VALUES
('00164b9e-784d-48a8-8973-bbad6ef818ed', null, 'createInstance', 'COMPLETE', 'Service Instance was created successfully.', '100', '2017-09-28 12:45:51', '2017-09-28 12:45:53', 'VID', null, null, null, null, null, '19123c2924c648eb8e42a3c1f14b7682', null, null, null, '{"modelInfo":{"modelCustomizationName":null,"modelInvariantId":"52b49b5d-3086-4ffd-b5e6-1b1e5e7e062f","modelType":"service","modelNameVersionId":null,"modelName":"MSO Test Network","modelVersion":"1.0","modelCustomizationUuid":null,"modelVersionId":"aed5a5b7-20d3-44f7-90a3-ddbd16f14d1e","modelCustomizationId":null,"modelUuid":null,"modelInvariantUuid":null,"modelInstanceName":null},"requestInfo":{"billingAccountNumber":null,"callbackUrl":null,"correlator":null,"orderNumber":null,"productFamilyId":null,"orderVersion":null,"source":"VID","instanceName":"DEV-n6-3100-0927-1","suppressRollback":false,"requestorId":"xxxxxx"},"relatedInstanceList":null,"subscriberInfo":{"globalSubscriberId":"MSO_1610_dev","subscriberName":"MSO_1610_dev"},"cloudConfiguration":{"aicNodeClli":null,"tenantId":"19123c2924c648eb8e42a3c1f14b7682","lcpCloudRegionId":"n6"},"requestParameters":{"subscriptionServiceType":"MSO-dev-service-type","userParams":[{"name":"someUserParam","value":"someValue"}],"aLaCarte":true,"autoBuildVfModules":false,"cascadeDelete":false,"usePreload":true},"project":null,"owningEntity":null,"platform":null,"lineOfBusiness":null}', null, 'CreateGenericALaCarteServiceInstance', '2017-09-28 12:45:52', null, null, null, null, null, null, null, 'n6', null, null, null, null, null, 'service', 'createInstance', 'b2f59173-b7e5-4e0f-8440-232fd601b865', 'DEV-n6-3100-0927-1', 'xxxxxx', null, null, null, null, 'http://localhost:8080/onap/so/infra/serviceInstantiation/v7/serviceInstances'),
('00173cc9-5ce2-4673-a810-f87fefb2829e', null, 'createInstance', 'FAILED', 'Error parsing request.  No valid instanceName is specified', '100', '2017-04-14 21:08:46', '2017-04-14 21:08:46', 'VID', null, null, null, null, null, 'a259ae7b7c3f493cb3d91f95a7c18149', null, null, null, '{"modelInfo":{"modelInvariantId":"ff6163d4-7214-459e-9f76-507b4eb00f51","modelType":"service","modelName":"ConstraintsSrvcVID","modelVersion":"2.0","modelVersionId":"722d256c-a374-4fba-a14f-a59b76bb7656"},"requestInfo":{"productFamilyId":"LRSI-OSPF","source":"VID","requestorId":"xxxxxx"},"subscriberInfo":{"globalSubscriberId":"a9a77d5a-123e-4ca2-9eb9-0b015d2ee0fb"},"cloudConfiguration":{"tenantId":"a259ae7b7c3f493cb3d91f95a7c18149","lcpCloudRegionId":"mtn16"},"requestParameters":{"subscriptionServiceType":"Mobility","userParams":[{"name":"neutronport6_name","value":"8"},{"name":"neutronnet5_network_name","value":"8"},{"name":"contrailv2vlansubinterface3_name","value":"false"}]}}', null, 'APIH', null, null, null, null, null, null, null, null, 'mtn16', null, null, null, null, null, 'service', 'createInstance', null, null, null, null, null, null, null, 'http://localhost:8080/onap/so/infra/serviceInstantiation/v7/serviceInstances'),
('0017f68c-eb2d-45bb-b7c7-ec31b37dc349', null, 'activateInstance', 'UNLOCKED', null, '20', '2017-09-26 16:09:29', null, 'VID', null, null, null, null, null, null, null, null, null, '{"modelInfo":{"modelCustomizationName":null,"modelInvariantId":"1587cf0e-f12f-478d-8530-5c55ac578c39","modelType":"configuration","modelNameVersionId":null,"modelName":null,"modelVersion":null,"modelCustomizationUuid":null,"modelVersionId":"36a3a8ea-49a6-4ac8-b06c-89a545444455","modelCustomizationId":"68dc9a92-214c-11e7-93ae-92361f002671","modelUuid":null,"modelInvariantUuid":null,"modelInstanceName":null},"requestInfo":{"billingAccountNumber":null,"callbackUrl":null,"correlator":null,"orderNumber":null,"productFamilyId":null,"orderVersion":null,"source":"VID","instanceName":null,"suppressRollback":false,"requestorId":"xxxxxx"},"relatedInstanceList":[{"relatedInstance":{"instanceName":null,"instanceId":"9e15a443-af65-4f05-9000-47ae495e937d","modelInfo":{"modelCustomizationName":null,"modelInvariantId":"de19ae10-9a25-11e7-abc4-cec278b6b50a","modelType":"service","modelNameVersionId":null,"modelName":"Infra_Configuration_Service","modelVersion":"1.0","modelCustomizationUuid":null,"modelVersionId":"ee938612-9a25-11e7-abc4-cec278b6b50a","modelCustomizationId":null,"modelUuid":null,"modelInvariantUuid":null,"modelInstanceName":null},"instanceDirection":null}}],"subscriberInfo":null,"cloudConfiguration":{"aicNodeClli":null,"tenantId":null,"lcpCloudRegionId":"n6"},"requestParameters":{"subscriptionServiceType":null,"userParams":[],"aLaCarte":false,"autoBuildVfModules":false,"cascadeDelete":false,"usePreload":true},"project":null,"owningEntity":null,"platform":null,"lineOfBusiness":null}', null, 'APIH', '2017-09-26 16:09:29', null, null, null, null, null, null, null, 'n6', null, null, null, null, null, 'configuration', 'activateInstance', '9e15a443-af65-4f05-9000-47ae495e937d', null, 'xxxxxx', '26ef7f15-57bb-48df-8170-e59edc26234c', null, null, null, 'http://localhost:8080/onap/so/infra/serviceInstantiation/v7/serviceInstances'),
('0017f68c-eb2d-45bb-b7c7-ec31b37dc350', null, 'createInstance', 'IN_PROGRESS', 'Error parsing request.
    No valid instanceName is specified', null, '2017-04-14 21:08:46', '2017-04-14 21:08:46', 'VID',
    '1882938', null, null, null, null, 'a259ae7b7c3f493cb3d91f95a7c18149', null, null, null,          
    '{"serviceInstanceId":"1882939","vnfInstanceId":"1882938","networkInstanceId":"1882937","volumeGroupInstanceId":"1882935","vfModuleInstanceId":"1882934","requestDetails":{"requestInfo":{"source":"VID","requestorId":"xxxxxx","instanceName":"testService9"},"requestParameters":{"aLaCarte":true,"autoBuildVfModules":false,"subscriptionServiceType":"test"},"modelInfo":{"modelInvariantId":"f7ce78bb-423b-11e7-93f8-0050569a7965","modelVersion":"1","modelVersionId":"10","modelType":"service","modelName":"serviceModel","modelInstanceName":"modelInstanceName","modelCustomizationId":"f7ce78bb-423b-11e7-93f8-0050569a796"},"subscriberInfo":{"globalSubscriberId":"MSO_1610_dev","subscriberName":"MSO_1610_dev"}}}',
    null, 'APIH', null, null, '1882935', null, '1882934', null, null, null, 'mtn16', null, null, null, null, null, 'service', 'createInstance', '1882939', 'testService10', 'xxxxxx', 'test', null, null, null, 'http://localhost:8080/onap/so/infra/serviceInstantiation/v7/serviceInstances');
COMMIT;