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

//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.7 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2016.04.07 at 08:25:52 AM CDT 
//


package org.openecomp.mso.apihandlerinfra.serviceinstancebeans;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for anonymous complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;choice>
 *           &lt;element name="policyException" type="{http://org.openecomp/mso/request/types/v1}policyException"/>
 *           &lt;element name="serviceException" type="{http://org.openecomp/mso/request/types/v1}serviceException"/>
 *         &lt;/choice>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "policyException",
    "serviceException"
})
@XmlRootElement(name = "requestError")
public class RequestError {

    protected PolicyException policyException;
    protected ServiceException serviceException;

    /**
     * Gets the value of the policyException property.
     * 
     * @return
     *     possible object is
     *     {@link PolicyException }
     *     
     */
    public PolicyException getPolicyException() {
        return policyException;
    }

    /**
     * Sets the value of the policyException property.
     * 
     * @param value
     *     allowed object is
     *     {@link PolicyException }
     *     
     */
    public void setPolicyException(PolicyException value) {
        this.policyException = value;
    }

    /**
     * Gets the value of the serviceException property.
     * 
     * @return
     *     possible object is
     *     {@link ServiceException }
     *     
     */
    public ServiceException getServiceException() {
        return serviceException;
    }

    /**
     * Sets the value of the serviceException property.
     * 
     * @param value
     *     allowed object is
     *     {@link ServiceException }
     *     
     */
    public void setServiceException(ServiceException value) {
        this.serviceException = value;
    }

}
