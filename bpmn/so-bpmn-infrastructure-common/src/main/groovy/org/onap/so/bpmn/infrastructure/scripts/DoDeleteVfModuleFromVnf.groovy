/*-
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

package org.onap.so.bpmn.infrastructure.scripts

import org.onap.aai.domain.yang.GenericVnf
import org.onap.aai.domain.yang.NetworkPolicies
import org.onap.aai.domain.yang.NetworkPolicy
import org.onap.aai.domain.yang.VfModule

import static org.apache.commons.lang3.StringUtils.*
import org.camunda.bpm.engine.delegate.BpmnError
import org.camunda.bpm.engine.delegate.DelegateExecution
import org.onap.so.bpmn.common.scripts.AaiUtil
import org.onap.so.bpmn.common.scripts.ExceptionUtil
import org.onap.so.bpmn.common.scripts.MsoUtils
import org.onap.so.bpmn.common.scripts.SDNCAdapterUtils
import org.onap.so.bpmn.common.scripts.VfModuleBase
import org.onap.so.bpmn.core.UrnPropertiesReader
import org.onap.so.bpmn.core.WorkflowException
import org.onap.so.bpmn.core.json.JsonUtils
import org.onap.so.client.graphinventory.entities.uri.Depth
import org.onap.so.client.aai.AAIObjectPlurals
import org.onap.so.client.aai.AAIObjectType
import org.onap.so.client.aai.entities.uri.AAIResourceUri
import org.onap.so.client.aai.entities.uri.AAIUriFactory
import org.onap.so.logger.MessageEnum
import org.onap.so.logger.MsoLogger

public class DoDeleteVfModuleFromVnf extends VfModuleBase {
	private static final MsoLogger msoLogger = MsoLogger.getMsoLogger(MsoLogger.Catalog.BPEL, DoDeleteVfModuleFromVnf.class);
	
	def Prefix="DDVFMV_"
	ExceptionUtil exceptionUtil = new ExceptionUtil()
	JsonUtils jsonUtil = new JsonUtils()

	public void initProcessVariables(DelegateExecution execution) {
		execution.setVariable("prefix",Prefix)
		execution.setVariable("DDVFMV_contrailNetworkPolicyFqdnList", null)
	}

	// parse the incoming request
	public void preProcessRequest(DelegateExecution execution) {

		initProcessVariables(execution)

		try {
			
				// Building Block-type request

				// Set mso-request-id to request-id for VNF Adapter interface
				String requestId = execution.getVariable("msoRequestId")
				execution.setVariable("mso-request-id", requestId)
				execution.setVariable("requestId", requestId)
				msoLogger.debug("msoRequestId: " + requestId)
				String tenantId = execution.getVariable("tenantId")
				msoLogger.debug("tenantId: " + tenantId)				
				String cloudSiteId = execution.getVariable("lcpCloudRegionId")
				execution.setVariable("cloudSiteId", cloudSiteId)
				msoLogger.debug("cloudSiteId: " + cloudSiteId)
				// Source is HARDCODED
				String source = "VID"
				execution.setVariable("source", source)
				// isVidRequest is hardcoded to "true"
				execution.setVariable("isVidRequest", "true")
				// SrvInstId is hardcoded to empty
				execution.setVariable("srvInstId", "")
				// ServiceId is hardcoded to empty
				execution.setVariable("serviceId", "")
				String serviceInstanceId = execution.getVariable("serviceInstanceId")
				msoLogger.debug("serviceInstanceId: " + serviceInstanceId)
				String vnfId = execution.getVariable("vnfId")
				msoLogger.debug("vnfId: " + vnfId)
				String vfModuleId = execution.getVariable("vfModuleId")
				msoLogger.debug("vfModuleId: " + vfModuleId)
				if (serviceInstanceId == null || serviceInstanceId.isEmpty()) {
					execution.setVariable(Prefix + "serviceInstanceIdToSdnc", vfModuleId)
				}
				else {
					execution.setVariable(Prefix + "serviceInstanceIdToSdnc", serviceInstanceId)
				}				
				
				String sdncVersion = execution.getVariable("sdncVersion")
				if (sdncVersion == null) {
					sdncVersion = "1707"
				}
				execution.setVariable(Prefix + "sdncVersion", sdncVersion)
				msoLogger.debug("Incoming Sdnc Version is: " + sdncVersion)				
				
				String sdncCallbackUrl = (String) UrnPropertiesReader.getVariable("mso.workflow.sdncadapter.callback",execution)
				if (sdncCallbackUrl == null || sdncCallbackUrl.trim().isEmpty()) {
					def msg = 'Required variable \'mso.workflow.sdncadapter.callback\' is missing'
					msoLogger.error(MessageEnum.BPMN_GENERAL_EXCEPTION_ARG, msg, "BPMN", MsoLogger.getServiceName(), MsoLogger.ErrorCode.UnknownError, "Exception");
					exceptionUtil.buildAndThrowWorkflowException(execution, 2000, msg)
				}
				execution.setVariable("sdncCallbackUrl", sdncCallbackUrl)
				msoLogger.debug("SDNC Callback URL: " + sdncCallbackUrl)
				msoLogger.debug("SDNC Callback URL is: " + sdncCallbackUrl)

			
			
		}catch(BpmnError b){
			throw b
		}catch(Exception e){
			msoLogger.debug("Exception is: " + e.getMessage())
			exceptionUtil.buildAndThrowWorkflowException(execution, 2000, "Internal Error encountered in PreProcess method!")
		}
	}
	
	public void queryAAIForVfModule(DelegateExecution execution) {
		def method = getClass().getSimpleName() + '.queryAAIForVfModule(' +
			'execution=' + execution.getId() +
			')'

		msoLogger.trace('Entered ' + method)

		try {
			def vnfId = execution.getVariable('vnfId')

			AAIResourceUri uri = AAIUriFactory.createResourceUri(AAIObjectType.GENERIC_VNF, vnfId).depth(Depth.ONE)
			try {
				Optional<GenericVnf> genericVnf = getAAIClient().get(GenericVnf.class,uri)

				if(genericVnf.isPresent()){
					execution.setVariable('DDVMFV_getVnfResponseCode', 200)
					execution.setVariable('DDVMFV_getVnfResponse', genericVnf.get())
				}else{
					execution.setVariable('DDVMFV_getVnfResponseCode', 404)
					execution.setVariable('DDVMFV_getVnfResponse', "Generic Vnf not found!")
				}
			} catch (Exception ex) {
				ex.printStackTrace()
				msoLogger.debug('Exception occurred while executing AAI GET:' + ex.getMessage())
				execution.setVariable('DDVMFV_getVnfResponseCode', 500)
				execution.setVariable('DDVFMV_getVnfResponse', 'AAI GET Failed:' + ex.getMessage())
			}
			msoLogger.trace('Exited ' + method)
		} catch (BpmnError e) {
			throw e;
		} catch (Exception e) {
			msoLogger.error(MessageEnum.BPMN_GENERAL_EXCEPTION_ARG, 'Caught exception in ' + method, "BPMN", MsoLogger.getServiceName(), MsoLogger.ErrorCode.UnknownError, "Exception is:\n" + e);
			exceptionUtil.buildAndThrowWorkflowException(execution, 1002, 'Error in queryAAIForVfModule(): ' + e.getMessage())
		}
	}
	
	/**
	 * Validate the VF Module.  That is, confirm that a VF Module with the input VF Module ID
	 * exists in the retrieved Generic VNF.  Then, check to make sure that if that VF Module
	 * is the base VF Module and it's not the only VF Module for this Generic VNF, that we're not
	 * attempting to delete it.
	 *
	 * @param execution The flow's execution instance.
	 */
	public void validateVfModule(DelegateExecution execution) {
		def method = getClass().getSimpleName() + '.validateVfModule(' +
			'execution=' + execution.getId() +
			')'
		def isDebugLogEnabled = execution.getVariable('isDebugLogEnabled')
		msoLogger.trace('Entered ' + method)

		try {
			GenericVnf genericVnf = execution.getVariable('DDVMFV_getVnfResponse')
			def vnfId = execution.getVariable('_vnfId')
			def vfModuleId = execution.getVariable('vfModuleId')
            Optional<VfModule> vfModule = Optional.empty()
            if(genericVnf.getVfModules()!=null && ! genericVnf.getVfModules().getVfModule().isEmpty()) {
                vfModule = genericVnf.getVfModules().getVfModule().stream().filter { v -> v.getVfModuleId().equals(vfModuleId) }.findFirst()
            }
			if (!vfModule.isPresent()) {
				String msg = 'VF Module \'' + vfModuleId + '\' does not exist in Generic VNF \'' + vnfId + '\''
				msoLogger.debug(msg)
				exceptionUtil.buildAndThrowWorkflowException(execution, 1002, msg)
			} else {
                Boolean isOnlyVfModule = (genericVnf.getVfModules().getVfModule().size() == 1)
				if (isDebugLogEnabled) {
					msoLogger.debug('VF Module \'' + vfModuleId + '\': isBaseVfModule=' + vfModule.get().isIsBaseVfModule() + ', isOnlyVfModule=' + isOnlyVfModule)
				}
				if (vfModule.get().isIsBaseVfModule() && !isOnlyVfModule) {
                    String msg = 'Cannot delete VF Module \'' + vfModuleId +
                            '\'since it is the base VF Module and it\'s not the only VF Module in Generic VNF \'' + vnfId + '\''
                    msoLogger.debug(msg)
                    exceptionUtil.buildAndThrowWorkflowException(execution, 1002,msg)
				}
				def heatStackId = vfModule.get().getHeatStackId()
				execution.setVariable('DDVMFV_heatStackId', heatStackId)
				msoLogger.debug('VF Module heatStackId retrieved from AAI: ' + heatStackId)
			}
			msoLogger.trace('Exited ' + method)
		} catch (BpmnError e) {
			throw e;
		} catch (Exception e) {
			msoLogger.error(MessageEnum.BPMN_GENERAL_EXCEPTION_ARG, 'Caught exception in ' + method, "BPMN", MsoLogger.getServiceName(), MsoLogger.ErrorCode.UnknownError, "Exception is:\n" + e);
			exceptionUtil.buildAndThrowWorkflowException(execution, 1002, 'Error in validateVfModule(): ' + e.getMessage())
		}
	}


	public void preProcessSDNCDeactivateRequest(DelegateExecution execution){

		execution.setVariable("prefix", Prefix)
		msoLogger.trace("STARTED preProcessSDNCDeactivateRequest ")
		
		def serviceInstanceId = execution.getVariable("serviceInstanceId")
	
		try{
			//Build SDNC Request
			
			String deactivateSDNCRequest = buildSDNCRequest(execution, serviceInstanceId, "deactivate")
	
			deactivateSDNCRequest = utils.formatXml(deactivateSDNCRequest)
			execution.setVariable("DDVMFV_deactivateSDNCRequest", deactivateSDNCRequest)
			msoLogger.debug("Outgoing DeactivateSDNCRequest is: \n" + deactivateSDNCRequest)
			
	
		}catch(Exception e){
			msoLogger.error(MessageEnum.BPMN_GENERAL_EXCEPTION_ARG, "Exception Occured Processing preProcessSDNCDeactivateRequest. Exception is:\n" + e, "BPMN", MsoLogger.getServiceName(), MsoLogger.ErrorCode.UnknownError, "Exception is:\n" + e);
			exceptionUtil.buildAndThrowWorkflowException(execution, 1002, "Error Occurred during preProcessSDNCDeactivateRequest Method:\n" + e.getMessage())
		}
		msoLogger.trace("COMPLETED preProcessSDNCDeactivateRequest ")
	}

	public void preProcessSDNCUnassignRequest(DelegateExecution execution) {
		def method = getClass().getSimpleName() + '.preProcessSDNCUnassignRequest(' +
			'execution=' + execution.getId() +
			')'

		msoLogger.trace('Entered ' + method)
		execution.setVariable("prefix", Prefix)
		msoLogger.trace("STARTED preProcessSDNCUnassignRequest Process ")
		try{			
			String serviceInstanceId = execution.getVariable("serviceInstanceId")
	
			String unassignSDNCRequest = buildSDNCRequest(execution, serviceInstanceId, "unassign")
	
			execution.setVariable("DDVMFV_unassignSDNCRequest", unassignSDNCRequest)
			msoLogger.debug("Outgoing UnassignSDNCRequest is: \n" + unassignSDNCRequest)
			
	
		}catch(Exception e){
			msoLogger.debug("Exception Occured Processing preProcessSDNCUnassignRequest. Exception is:\n" + e)
			exceptionUtil.buildAndThrowWorkflowException(execution, 1002, "Error Occured during  preProcessSDNCUnassignRequest Method:\n" + e.getMessage())
		}
		msoLogger.trace("COMPLETED  preProcessSDNCUnassignRequest Process ")
	}

	public String buildSDNCRequest(DelegateExecution execution, String svcInstId, String action){
	
			String uuid = execution.getVariable('testReqId') // for junits
			if(uuid==null){
				uuid = execution.getVariable("msoRequestId") + "-" +  	System.currentTimeMillis()
			}
			def callbackURL = execution.getVariable("sdncCallbackUrl")	
			def requestId = execution.getVariable("msoRequestId")
			def serviceId = execution.getVariable("serviceId")
			def serviceInstanceId = execution.getVariable("serviceInstanceId")
			def vfModuleId = execution.getVariable("vfModuleId")
			def source = execution.getVariable("source")
			def vnfId = execution.getVariable("vnfId")
				
			def sdncVersion = execution.getVariable(Prefix + "sdncVersion")
			
			String sdncRequest =
			"""<sdncadapterworkflow:SDNCAdapterWorkflowRequest xmlns:ns5="http://org.onap/so/request/types/v1"
													xmlns:sdncadapterworkflow="http://org.onap/so/workflow/schema/v1"
													xmlns:sdncadapter="http://org.onap.so/workflow/sdnc/adapter/schema/v1">
	   <sdncadapter:RequestHeader>
				<sdncadapter:RequestId>${MsoUtils.xmlEscape(uuid)}</sdncadapter:RequestId>
				<sdncadapter:SvcInstanceId>${MsoUtils.xmlEscape(svcInstId)}</sdncadapter:SvcInstanceId>
				<sdncadapter:SvcAction>${MsoUtils.xmlEscape(action)}</sdncadapter:SvcAction>
				<sdncadapter:SvcOperation>vf-module-topology-operation</sdncadapter:SvcOperation>
				<sdncadapter:CallbackUrl>${MsoUtils.xmlEscape(callbackURL)}</sdncadapter:CallbackUrl>
				<sdncadapter:MsoAction>generic-resource</sdncadapter:MsoAction>
		</sdncadapter:RequestHeader>
	<sdncadapterworkflow:SDNCRequestData>
		<request-information>
			<request-id>${MsoUtils.xmlEscape(requestId)}</request-id>
			<request-action>DeleteVfModuleInstance</request-action>
			<source>${MsoUtils.xmlEscape(source)}</source>
			<notification-url/>
			<order-number/>
			<order-version/>
		</request-information>
		<service-information>
			<service-id/>
			<subscription-service-type/>			
			<service-instance-id>${MsoUtils.xmlEscape(serviceInstanceId)}</service-instance-id>
			<global-customer-id/>
		</service-information>
		<vnf-information>
			<vnf-id>${MsoUtils.xmlEscape(vnfId)}</vnf-id>
			<vnf-type/>			
		</vnf-information>
		<vf-module-information>
			<vf-module-id>${MsoUtils.xmlEscape(vfModuleId)}</vf-module-id>
		</vf-module-information>
		<vf-module-request-input/>		
	</sdncadapterworkflow:SDNCRequestData>
	</sdncadapterworkflow:SDNCAdapterWorkflowRequest>"""
	
		msoLogger.debug("sdncRequest:  " + sdncRequest)
		return sdncRequest
	}
	
	public void validateSDNCResponse(DelegateExecution execution, String response, String method){

		execution.setVariable("prefix",Prefix)
		msoLogger.trace("STARTED ValidateSDNCResponse Process")
	
		WorkflowException workflowException = execution.getVariable("WorkflowException")
		boolean successIndicator = execution.getVariable("SDNCA_SuccessIndicator")
	
		msoLogger.debug("workflowException: " + workflowException)
	
		SDNCAdapterUtils sdncAdapterUtils = new SDNCAdapterUtils(this)
		sdncAdapterUtils.validateSDNCResponse(execution, response, workflowException, successIndicator)
	
		msoLogger.debug("SDNCResponse: " + response)
	
		String sdncResponse = response
		if(execution.getVariable(Prefix + 'sdncResponseSuccess') == true){
			msoLogger.debug("Received a Good Response from SDNC Adapter for " + method + " SDNC Call.  Response is: \n" + sdncResponse)
		}else{
			msoLogger.debug("Received a BAD Response from SDNC Adapter for " + method + " SDNC Call.")
			throw new BpmnError("MSOWorkflowException")
		}
		msoLogger.trace("COMPLETED ValidateSDNCResponse Process")
	}


	// parse the incoming DELETE_VF_MODULE request
	// and formulate the outgoing VnfAdapterDeleteV1 request
	public void prepVNFAdapterRequest(DelegateExecution execution) {

		def requestId = UUID.randomUUID().toString()
		def origRequestId = execution.getVariable('requestId')
		def srvInstId = execution.getVariable("serviceInstanceId")
		def aicCloudRegion = execution.getVariable("cloudSiteId")
		def vnfId = execution.getVariable("vnfId")
		def vfModuleId = execution.getVariable("vfModuleId")
		def vfModuleStackId = execution.getVariable('DDVMFV_heatStackId')
		def tenantId = execution.getVariable("tenantId")
		def messageId = execution.getVariable('requestId') + '-' +
			System.currentTimeMillis()
		def notificationUrl = createCallbackURL(execution, "VNFAResponse", messageId)
		def useQualifiedHostName = UrnPropertiesReader.getVariable("mso.use.qualified.host",execution)
		if ('true'.equals(useQualifiedHostName)) {
			notificationUrl = utils.getQualifiedHostNameForCallback(notificationUrl)
		}

		String request = """
			<deleteVfModuleRequest>
			    <cloudSiteId>${MsoUtils.xmlEscape(aicCloudRegion)}</cloudSiteId>
			    <tenantId>${MsoUtils.xmlEscape(tenantId)}</tenantId>
			    <vnfId>${MsoUtils.xmlEscape(vnfId)}</vnfId>
			    <vfModuleId>${MsoUtils.xmlEscape(vfModuleId)}</vfModuleId>
			    <vfModuleStackId>${MsoUtils.xmlEscape(vfModuleStackId)}</vfModuleStackId>
			    <skipAAI>true</skipAAI>
			    <msoRequest>
			        <requestId>${MsoUtils.xmlEscape(origRequestId)}</requestId>
			        <serviceInstanceId>${MsoUtils.xmlEscape(srvInstId)}</serviceInstanceId>
			    </msoRequest>
			    <messageId>${MsoUtils.xmlEscape(messageId)}</messageId>
			    <notificationUrl>${MsoUtils.xmlEscape(notificationUrl)}</notificationUrl>
			</deleteVfModuleRequest>
			""" as String

		msoLogger.debug("vnfAdapterRestV1Request: " + request)
		msoLogger.debug("deleteVfModuleRequest: " + request)
		execution.setVariable("vnfAdapterRestV1Request", request)
	}

	
	// generates a WorkflowException if
	//		-
	public void handleDoDeleteVfModuleFailure(DelegateExecution execution) {
		msoLogger.error(MessageEnum.BPMN_GENERAL_EXCEPTION_ARG, "AAI error occurred deleting the Generic Vnf: " + execution.getVariable("DDVFMV_deleteGenericVnfResponse"), "BPMN", MsoLogger.getServiceName(), MsoLogger.ErrorCode.UnknownError, "Exception");
		String processKey = getProcessKey(execution);
		WorkflowException exception = new WorkflowException(processKey, 5000,
			execution.getVariable("DDVFMV_deleteGenericVnfResponse"))
		execution.setVariable("WorkflowException", exception)
	}
	
	public void postProcessVNFAdapterRequest(DelegateExecution execution) {
		def method = getClass().getSimpleName() + '.postProcessVNFAdapterRequest(' +
			'execution=' + execution.getId() +
			')'

		msoLogger.trace('Entered ' + method)
		execution.setVariable("prefix",Prefix)
		try{
		msoLogger.trace("STARTED postProcessVNFAdapterRequest Process")
		
		String vnfResponse = execution.getVariable("DDVMFV_doDeleteVfModuleResponse")
		msoLogger.debug("VNF Adapter Response is: " + vnfResponse)
		msoLogger.debug("deleteVnfAResponse is: \n"  + vnfResponse)

		if(vnfResponse != null){

			if(vnfResponse.contains("deleteVfModuleResponse")){
				msoLogger.debug("Received a Good Response from VNF Adapter for DELETE_VF_MODULE Call.")
				execution.setVariable("DDVFMV_vnfVfModuleDeleteCompleted", true)

				// Parse vnfOutputs for contrail network polcy FQDNs
				def vfModuleOutputsXml = utils.getNodeXml(vnfResponse, "vfModuleOutputs")
				if(!isBlank(vfModuleOutputsXml)) {
					vfModuleOutputsXml = utils.removeXmlNamespaces(vfModuleOutputsXml)
					List contrailNetworkPolicyFqdnList = []
					for(Node node: utils.getMultNodeObjects(vfModuleOutputsXml, "entry")) {
						String key = utils.getChildNodeText(node, "key")
						if(key == null) {
							
						} else if (key.endsWith("contrail_network_policy_fqdn")) {
							String contrailNetworkPolicyFqdn = utils.getChildNodeText(node, "value")
							msoLogger.debug("Obtained contrailNetworkPolicyFqdn: " + contrailNetworkPolicyFqdn)
							contrailNetworkPolicyFqdnList.add(contrailNetworkPolicyFqdn)
						}
						else if (key.equals("oam_management_v4_address")) {
							String oamManagementV4Address = utils.getChildNodeText(node, "value")
							msoLogger.debug("Obtained oamManagementV4Address: " + oamManagementV4Address)
							execution.setVariable(Prefix + "oamManagementV4Address", oamManagementV4Address)
						}
						else if (key.equals("oam_management_v6_address")) {
							String oamManagementV6Address = utils.getChildNodeText(node, "value")
							msoLogger.debug("Obtained oamManagementV6Address: " + oamManagementV6Address)
							execution.setVariable(Prefix + "oamManagementV6Address", oamManagementV6Address)
						}
					}
					if (!contrailNetworkPolicyFqdnList.isEmpty()) {
						msoLogger.debug("Setting the fqdn list")
						execution.setVariable("DDVFMV_contrailNetworkPolicyFqdnList", contrailNetworkPolicyFqdnList)
					}
				}
			}else{
				msoLogger.debug("Received a BAD Response from VNF Adapter for DELETE_VF_MODULE Call.")
				exceptionUtil.buildAndThrowWorkflowException(execution, 1002, "VNF Adapter Error")
			}
		}else{
			msoLogger.debug("Response from VNF Adapter is Null for DELETE_VF_MODULE Call.")
			exceptionUtil.buildAndThrowWorkflowException(execution, 1002, "Empty response from VNF Adapter")
		}

		}catch(BpmnError b){
			throw b
		}catch(Exception e){
			msoLogger.debug("Internal Error Occured in PostProcess Method")
			exceptionUtil.buildAndThrowWorkflowException(execution, 1002, "Internal Error Occured in PostProcess Method")
		}
		msoLogger.trace("COMPLETED postProcessVnfAdapterResponse Process")
	}

	public void deleteNetworkPoliciesFromAAI(DelegateExecution execution) {
		def method = getClass().getSimpleName() + '.deleteNetworkPoliciesFromAAI(' +
		'execution=' + execution.getId() +
		')'

		msoLogger.trace('Entered ' + method)
		execution.setVariable("prefix", Prefix)
		msoLogger.trace("STARTED deleteNetworkPoliciesFromAAI ")

		try {
			// get variables
			List fqdnList = execution.getVariable("DDVFMV_contrailNetworkPolicyFqdnList")
			if (fqdnList == null) {
				msoLogger.debug("No network policies to delete")
				return
			}
			int fqdnCount = fqdnList.size()

			execution.setVariable("DDVFMV_networkPolicyFqdnCount", fqdnCount)
			msoLogger.debug("DDVFMV_networkPolicyFqdnCount - " + fqdnCount)

			AaiUtil aaiUriUtil = new AaiUtil(this)

			if (fqdnCount > 0) {
				// AII loop call over contrail network policy fqdn list
				for (i in 0..fqdnCount-1) {

					int counting = i+1
					String fqdn = fqdnList[i]

					// Query AAI for this network policy FQDN

					AAIResourceUri uri = AAIUriFactory.createResourceUri(AAIObjectPlurals.NETWORK_POLICY)
					uri.queryParam("network-policy-fqdn", fqdn)

                    try {
                        Optional<NetworkPolicies> networkPolicies = getAAIClient().get(NetworkPolicies.class, uri)

                        if (networkPolicies.isPresent() && !networkPolicies.get().getNetworkPolicy().isEmpty()) {
                            NetworkPolicy networkPolicy = networkPolicies.get().getNetworkPolicy().get(0)
                            execution.setVariable("DCVFM_aaiQueryNetworkPolicyByFqdnReturnCode", 200)
                            // This network policy FQDN exists in AAI - need to delete it now
                            // Retrieve the network policy id for this FQDN
                            def networkPolicyId = networkPolicy.getNetworkPolicyId()
                            msoLogger.debug("Deleting network-policy with network-policy-id " + networkPolicyId)

                            // Retrieve the resource version for this network policy
                            try {
                                AAIResourceUri delUri = AAIUriFactory.createResourceUri(AAIObjectType.NETWORK_POLICY, networkPolicyId)
                                getAAIClient().delete(delUri)
                                execution.setVariable("DDVFMV_aaiDeleteNetworkPolicyReturnCode", 200)
                                msoLogger.debug(" ***** AAI delete network policy Response Code, NetworkPolicy #" + counting + " : " + 200)
                                // This network policy was deleted from AAI successfully
                                msoLogger.debug(" DelAAINetworkPolicy Success REST Response, , NetworkPolicy #" + counting + " : ")
                            } catch (Exception e) {
                                // aai all errors
                                String delErrorMessage = "Unable to delete network-policy to AAI deleteNetworkPoliciesFromAAI - " + e.getMessage()
                                msoLogger.debug(delErrorMessage)
                                exceptionUtil.buildAndThrowWorkflowException(execution, 2500, delErrorMessage)
                            }
                        } else {
                            execution.setVariable("DCVFM_aaiQueryNetworkPolicyByFqdnReturnCode", 404)
                            // This network policy FQDN is not in AAI. No need to delete.
                            msoLogger.debug("This network policy FQDN is not in AAI: " + fqdn)
                            msoLogger.debug("Network policy FQDN is not in AAI")
                        }
                    } catch (Exception e) {
                        // aai all errors
                        String dataErrorMessage = "Unexpected Response from deleteNetworkPoliciesFromAAI - " + e.getMessage()
                        msoLogger.debug(dataErrorMessage)
                        exceptionUtil.buildAndThrowWorkflowException(execution, 2500, dataErrorMessage)
                    }
                } // end loop
			} else {
				   msoLogger.debug("No contrail network policies to query/create")

			}

		} catch (BpmnError e) {
			throw e;

		} catch (Exception ex) {
			String exceptionMessage = "Bpmn error encountered in DoDeletVfModule flow. deleteNetworkPoliciesFromAAI() - " + ex.getMessage()
			msoLogger.debug(exceptionMessage)
			exceptionUtil.buildAndThrowWorkflowException(execution, 7000, exceptionMessage)
		}

	}	
	
	// and formulate the outgoing DeleteAAIVfModuleRequest request
	public void prepDeleteAAIVfModule(DelegateExecution execution) {


		def vnfId = execution.getVariable("vnfId")
		def vfModuleId = execution.getVariable("vfModuleId")
		// formulate the request for UpdateAAIVfModule
		String request = """<DeleteAAIVfModuleRequest>
								<vnf-id>${MsoUtils.xmlEscape(vnfId)}</vnf-id>
								<vf-module-id>${MsoUtils.xmlEscape(vfModuleId)}</vf-module-id>
							</DeleteAAIVfModuleRequest>""" as String
		msoLogger.debug("DeleteAAIVfModuleRequest :" + request)
		
		execution.setVariable("DeleteAAIVfModuleRequest", request)
	}
}
