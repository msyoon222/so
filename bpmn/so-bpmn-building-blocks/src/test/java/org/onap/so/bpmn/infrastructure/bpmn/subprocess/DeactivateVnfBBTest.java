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

package org.onap.so.bpmn.infrastructure.bpmn.subprocess;
import static org.camunda.bpm.engine.test.assertions.ProcessEngineTests.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doThrow;

import java.io.IOException;

import org.camunda.bpm.engine.delegate.BpmnError;
import org.camunda.bpm.engine.runtime.ProcessInstance;
import org.junit.Test;
import org.onap.so.bpmn.BaseBPMNTest;
import org.onap.so.bpmn.common.BuildingBlockExecution;

public class DeactivateVnfBBTest extends BaseBPMNTest{
	@Test
	public void sunnyDay() throws InterruptedException, IOException {
		mockSubprocess("SDNCHandler", "My Mock Process Name", "GenericStub");
		ProcessInstance pi = runtimeService.startProcessInstanceByKey("DeactivateVnfBB", variables);
		assertThat(pi).isNotNull();
		assertThat(pi).isStarted().hasPassedInOrder("Start_DeactivateVnfBB","Task_SDNCAdapterVnfTopologyDeactivate",
				"CallActivity_sdncHandler", "Task_DeactivateOrchestrationStatusVnf", "End_DeactivateVnfBB");
		assertThat(pi).isEnded();
	}

	@Test
	public void rainyDayDeactivateVnfSDNCError_Test() throws Exception {
		doThrow(new BpmnError("7000", "TESTING ERRORS")).when(sdncDeactivateTasks).deactivateVnf(any(BuildingBlockExecution.class));
		ProcessInstance pi = runtimeService.startProcessInstanceByKey("DeactivateVnfBB", variables);
		assertThat(pi).isNotNull();
		assertThat(pi).isStarted()
		.hasPassedInOrder("Start_DeactivateVnfBB", "Task_SDNCAdapterVnfTopologyDeactivate")
		.hasNotPassed("Task_DeactivateOrchestrationStatusVnf", "End_DeactivateVnfBB");
		assertThat(pi).isEnded();
	}

	@Test
	public void rainyDayDeactivateVnfAAIError_Test() throws Exception {
		mockSubprocess("SDNCHandler", "My Mock Process Name", "GenericStub");
		doThrow(new BpmnError("7000", "TESTING ERRORS")).when(aaiUpdateTasks).updateOrchestrationStatusAssignedVnf(any(BuildingBlockExecution.class));
		ProcessInstance pi = runtimeService.startProcessInstanceByKey("DeactivateVnfBB", variables);
		assertThat(pi).isNotNull();
		assertThat(pi).isStarted()
		.hasPassedInOrder("Start_DeactivateVnfBB", "Task_SDNCAdapterVnfTopologyDeactivate","Task_DeactivateOrchestrationStatusVnf")
		.hasNotPassed("End_DeactivateVnfBB");
		assertThat(pi).isEnded();
	}
}
