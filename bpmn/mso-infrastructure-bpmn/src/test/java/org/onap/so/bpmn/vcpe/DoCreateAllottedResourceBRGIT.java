/*
 * ============LICENSE_START=======================================================
 * ONAP - SO
 * ================================================================================
 * Copyright (C) 2017 AT&T Intellectual Property. All rights reserved.
 * ================================================================================
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============LICENSE_END=========================================================
 */

package org.onap.so.bpmn.vcpe;

import static org.junit.Assert.*;
import static org.onap.so.bpmn.common.BPMNUtil.waitForWorkflowToFinish;
import static org.onap.so.bpmn.mock.StubResponseAAI.MockGetAllottedResource;
import static org.onap.so.bpmn.mock.StubResponseAAI.MockGetServiceInstance;
import static org.onap.so.bpmn.mock.StubResponseAAI.MockNodeQueryServiceInstanceById;
import static org.onap.so.bpmn.mock.StubResponseAAI.MockPatchAllottedResource;
import static org.onap.so.bpmn.mock.StubResponseAAI.MockPutAllottedResource;
import static org.onap.so.bpmn.mock.StubResponseDatabase.mockUpdateRequestDB;
import static org.onap.so.bpmn.mock.StubResponseSDNCAdapter.mockSDNCAdapter;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;
import org.onap.so.bpmn.common.BPMNUtil;
import org.onap.so.bpmn.mock.FileUtil;


public class DoCreateAllottedResourceBRGIT extends AbstractTestBase {

	private static final String PROCNAME = "DoCreateAllottedResourceBRG";
	private final CallbackSet callbacks = new CallbackSet();

	public DoCreateAllottedResourceBRGIT() {
		callbacks.put("assign", FileUtil.readResourceFile("__files/VfModularity/SDNCTopologyAssignCallback.xml"));
		callbacks.put("create", FileUtil.readResourceFile("__files/VfModularity/SDNCTopologyCreateCallback.xml"));
		callbacks.put("activate", FileUtil.readResourceFile("__files/VfModularity/SDNCTopologyActivateCallback.xml"));
		callbacks.put("query", FileUtil.readResourceFile("__files/VCPE/DoCreateAllottedResourceBRG/SDNCTopologyQueryCallback.xml"));
	}
	
	@Test
	public void testDoCreateAllottedResourceBRG_Success() throws InterruptedException {
		logStart();

		// TODO: use INST instead of DEC_INST
		/*
		 * should be INST instead of DEC_INST, but AAI utilities appear to
		 * have a bug in that they don't URL-encode the SI id before using
		 * it in the query
		 */
		MockNodeQueryServiceInstanceById(DEC_INST, "GenericFlows/getSIUrlById.xml");
		MockNodeQueryServiceInstanceById(DEC_PARENT_INST, "GenericFlows/getParentSIUrlById.xml");

		MockGetServiceInstance(CUST, SVC, INST, "GenericFlows/getServiceInstance.xml");
		MockGetServiceInstance(CUST, SVC, PARENT_INST, "GenericFlows/getParentServiceInstance.xml");
		MockPutAllottedResource(CUST, SVC, PARENT_INST, ARID);
		MockPatchAllottedResource(CUST, SVC, PARENT_INST, ARID);
		mockSDNCAdapter(200);
		mockUpdateRequestDB(200, "Database/DBUpdateResponse.xml");

		Map<String, Object> variables = new HashMap<>();
		setVariablesSuccess(variables,"testRequestId123");

		String processId = invokeSubProcess(PROCNAME, variables);
		
		injectSDNCCallbacks(callbacks, "assign");
		injectSDNCCallbacks(callbacks, "create");
		injectSDNCCallbacks(callbacks, "activate");
		injectSDNCCallbacks(callbacks, "query");

		waitForWorkflowToFinish(processEngine,processId);

		assertTrue(isProcessEndedByProcessInstanceId(processId));
		String workflowException = BPMNUtil.getVariable(processEngine, PROCNAME, VAR_WFEX,processId);
		assertNull(workflowException);
		
		assertEquals("namefromrequest", BPMNUtil.getVariable(processEngine, PROCNAME, "allotedResourceName",processId));
		logEnd();
	}
	
	@Test
	public void testDoCreateAllottedResourceBRG_NoSI() throws Exception{
		logStart();
		// TODO: use INST instead of DEC_INST
		/*
		 * should be INST instead of DEC_INST, but AAI utilities appear to
		 * have a bug in that they don't URL-encode the SI id before using
		 * it in the query
		 */
		MockNodeQueryServiceInstanceById(DEC_INST, "GenericFlows/getNotFound.xml");
		MockNodeQueryServiceInstanceById(DEC_PARENT_INST, "GenericFlows/getParentSIUrlById.xml");

		MockGetServiceInstance(CUST, SVC, INST, "GenericFlows/getServiceInstance.xml");
		MockGetServiceInstance(CUST, SVC, PARENT_INST, "GenericFlows/getParentServiceInstance.xml");
		MockPutAllottedResource(CUST, SVC, PARENT_INST, ARID);
		MockPatchAllottedResource(CUST, SVC, PARENT_INST, ARID);
		mockSDNCAdapter(200);
		mockUpdateRequestDB(200, "Database/DBUpdateResponse.xml");
		
		Map<String, Object> variables = new HashMap<>();
		setVariablesSuccess(variables,"testRequestId124");
		
		String processId = invokeSubProcess(PROCNAME, variables);

		waitForWorkflowToFinish(processEngine,processId);

		assertTrue(isProcessEndedByProcessInstanceId(processId));
		String workflowException = BPMNUtil.getVariable(processEngine, PROCNAME, VAR_WFEX,processId);
		assertNotNull(workflowException);
		
		assertNull(BPMNUtil.getVariable(processEngine, PROCNAME, "allotedResourceName",processId));
		logEnd();
	}
	
	@Test
	public void testDoCreateAllottedResourceBRG_ActiveAr() throws Exception{
		logStart();
		// TODO: use INST instead of DEC_INST
		/*
		 * should be INST instead of DEC_INST, but AAI utilities appear to
		 * have a bug in that they don't URL-encode the SI id before using
		 * it in the query
		 */
		MockNodeQueryServiceInstanceById(DEC_INST, "GenericFlows/getSIUrlById.xml");
		MockNodeQueryServiceInstanceById(DEC_PARENT_INST, "GenericFlows/getParentSIUrlById.xml");
		
		MockGetServiceInstance(CUST, SVC, INST, "VCPE/DoCreateAllottedResourceBRG/getSIandAR.xml");
		MockGetAllottedResource(CUST, SVC, INST, ARID, "VCPE/DoCreateAllottedResourceBRG/getArBrg2.xml");
		MockGetServiceInstance(CUST, SVC, PARENT_INST, "GenericFlows/getParentServiceInstance.xml");
		MockPutAllottedResource(CUST, SVC, PARENT_INST, ARID);
		MockPatchAllottedResource(CUST, SVC, PARENT_INST, ARID);
		mockSDNCAdapter(200);
		mockUpdateRequestDB(200, "Database/DBUpdateResponse.xml");

		Map<String, Object> variables = new HashMap<>();
		setVariablesSuccess(variables,"testRequestId125");

		variables.put("failExists", "false");

		String processId = invokeSubProcess(PROCNAME, variables);

		
		
		injectSDNCCallbacks(callbacks, "query");

		waitForWorkflowToFinish(processEngine,processId);

		assertTrue(isProcessEndedByProcessInstanceId(processId));
		String workflowException = BPMNUtil.getVariable(processEngine, PROCNAME, VAR_WFEX,processId);
		assertNull( workflowException);
		
		assertEquals("namefromrequest", BPMNUtil.getVariable(processEngine, PROCNAME, "allotedResourceName",processId));
		logEnd();
	}
	
	@Test
	public void testDoCreateAllottedResourceBRG_NoParentSI() throws Exception{
		logStart();
		// TODO: use INST instead of DEC_INST
		/*
		 * should be INST instead of DEC_INST, but AAI utilities appear to
		 * have a bug in that they don't URL-encode the SI id before using
		 * it in the query
		 */
		MockNodeQueryServiceInstanceById(DEC_INST, "GenericFlows/getSIUrlById.xml");
		MockNodeQueryServiceInstanceById(DEC_PARENT_INST, "GenericFlows/getNotFound.xml");

		MockGetServiceInstance(CUST, SVC, INST, "GenericFlows/getServiceInstance.xml");
		MockGetServiceInstance(CUST, SVC, PARENT_INST, "GenericFlows/getParentServiceInstance.xml");
		MockPutAllottedResource(CUST, SVC, PARENT_INST, ARID);
		MockPatchAllottedResource(CUST, SVC, PARENT_INST, ARID);
		mockSDNCAdapter(200);
		mockUpdateRequestDB(200, "Database/DBUpdateResponse.xml");

		Map<String, Object> variables = new HashMap<>();
		setVariablesSuccess(variables,"testRequestId126");

		String processId = invokeSubProcess(PROCNAME, variables);

		waitForWorkflowToFinish(processEngine,processId);

		assertTrue(isProcessEndedByProcessInstanceId(processId));
		String workflowException = BPMNUtil.getVariable(processEngine, PROCNAME, VAR_WFEX,processId);
		assertNotNull(workflowException);
		
		assertNull(BPMNUtil.getVariable(processEngine, PROCNAME, "allotedResourceName",processId));
		logEnd();
	}
	
	@Test
	public void testDoCreateAllottedResourceBRG_SubProcessError() throws Exception{
		logStart();
		// TODO: use INST instead of DEC_INST
		/*
		 * should be INST instead of DEC_INST, but AAI utilities appear to
		 * have a bug in that they don't URL-encode the SI id before using
		 * it in the query
		 */
		MockNodeQueryServiceInstanceById(DEC_INST, "GenericFlows/getSIUrlById.xml");
		MockNodeQueryServiceInstanceById(DEC_PARENT_INST, "GenericFlows/getParentSIUrlById.xml");
		
		MockGetServiceInstance(CUST, SVC, INST, "GenericFlows/getServiceInstance.xml");
		MockGetServiceInstance(CUST, SVC, PARENT_INST, "GenericFlows/getParentServiceInstance.xml");
		MockPutAllottedResource(CUST, SVC, PARENT_INST, ARID);
		MockPatchAllottedResource(CUST, SVC, PARENT_INST, ARID);
		mockSDNCAdapter(404);
		mockUpdateRequestDB(200, "Database/DBUpdateResponse.xml");

		Map<String, Object> variables = new HashMap<>();
		setVariablesSuccess(variables,"testRequestId127");

		String processId = invokeSubProcess(PROCNAME, variables);

		waitForWorkflowToFinish(processEngine,processId);

		assertTrue(isProcessEndedByProcessInstanceId(processId));
		String workflowException = BPMNUtil.getVariable(processEngine, PROCNAME, VAR_WFEX,processId);
		assertNotNull(workflowException);

		assertNull(BPMNUtil.getVariable(processEngine, PROCNAME, "allotedResourceName",processId));
		logEnd();
	}

	private void setVariablesSuccess(Map<String, Object> variables, String requestId) {
		variables.put("isDebugLogEnabled", "true");
		variables.put("failExists", "true");
		variables.put("disableRollback", "true");
		variables.put("msoRequestId", requestId);
		variables.put("mso-request-id", "requestId");
		variables.put("sourceNetworkId", "snId");
		variables.put("sourceNetworkRole", "snRole");
		variables.put("allottedResourceRole", "txc");
		variables.put("allottedResourceType", "BRG");
		variables.put("allottedResourceId", ARID);
		variables.put("vni", "BRG");
		variables.put("vgmuxBearerIP", "bearerip");
		variables.put("brgWanMacAddress", "wanmac");

		variables.put("serviceInstanceId", DEC_INST);
		variables.put("parentServiceInstanceId", DEC_PARENT_INST);
		
		variables.put("serviceChainServiceInstanceId", "scsiId");
		
		String arModelInfo = "{ "+ "\"modelType\": \"allotted-resource\"," +
				"\"modelInvariantUuid\": \"ff5256d2-5a33-55df-13ab-12abad84e7ff\"," +
				"\"modelUuid\": \"fe6478e5-ea33-3346-ac12-ab121484a3fe\"," +
				"\"modelName\": \"vSAMP12\"," +
				"\"modelVersion\": \"1.0\"," +
				"\"modelCustomizationUuid\": \"MODEL-ID-1234\"," +
				"}";
		variables.put("allottedResourceModelInfo", arModelInfo);
	}

}
