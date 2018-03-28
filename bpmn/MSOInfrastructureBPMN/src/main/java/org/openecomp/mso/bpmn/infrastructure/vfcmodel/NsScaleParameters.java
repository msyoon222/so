/*-
 * ============LICENSE_START=======================================================
 * ONAP - SO
 * ================================================================================
 * Copyright (C) 2018 CMCC All rights reserved.
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

package org.openecomp.mso.bpmn.infrastructure.vfcmodel;

import java.util.List;

/**
 * <br>
 * <p>
 * </p>
 *
 * @author
 * @version ONAP Amsterdam Release 2017-9-26
 */
public class NsScaleParameters {

    private List<ScaleNsByStepsData> scaleNsByStepsData;

    private String scaleType;


    private String nsInstanceId;

    /**
     * @return Returns the scaleNsByStepsData.
     */
    public List<ScaleNsByStepsData> getScaleNsByStepsData() {
        return scaleNsByStepsData;
    }

    /**
     * @param scaleNsByStepsData The scaleNsByStepsData to set.
     */
    public void setScaleNsByStepsData(List<ScaleNsByStepsData> scaleNsByStepsData) {
        this.scaleNsByStepsData = scaleNsByStepsData;
    }

    /**
     * @return Returns the scale Type.
     */
    public String getScaleType() {
        return scaleType;
    }

    /**
     * @param scaleType The scaleType to set.
     */
    public void setScaleType(String scaleType) {
        this.scaleType = scaleType;
    }

    public String getNsInstanceId() {
        return nsInstanceId;
    }

    public void setNsInstanceId(String nsInstanceId) {
        this.nsInstanceId = nsInstanceId;
    }

}
