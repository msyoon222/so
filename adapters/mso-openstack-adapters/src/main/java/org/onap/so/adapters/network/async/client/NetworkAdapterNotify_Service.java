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

package org.onap.so.adapters.network.async.client;

import java.net.URL;

import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import javax.xml.ws.WebEndpoint;
import javax.xml.ws.WebServiceClient;
import javax.xml.ws.WebServiceException;
import javax.xml.ws.WebServiceFeature;


/**
 * This class was generated by the JAX-WS RI.
 * JAX-WS RI 2.2.9-b14002
 * Generated source version: 2.2
 * 
 */
@WebServiceClient(name = "networkAdapterNotify", targetNamespace = "http://org.onap.so/networkNotify", wsdlLocation = "/NetworkAdapterNotify.wsdl")
public class NetworkAdapterNotify_Service
    extends Service
{

    private final static URL NETWORKADAPTERNOTIFY_WSDL_LOCATION;
    private final static WebServiceException NETWORKADAPTERNOTIFY_EXCEPTION;
    private final static QName NETWORKADAPTERNOTIFY_QNAME = new QName("http://org.onap.so/networkNotify", "networkAdapterNotify");

    static {
        NETWORKADAPTERNOTIFY_WSDL_LOCATION = org.onap.so.adapters.network.async.client.NetworkAdapterNotify_Service.class.getResource("/NetworkAdapterNotify.wsdl");
        WebServiceException e = null;
        if (NETWORKADAPTERNOTIFY_WSDL_LOCATION == null) {
            e = new WebServiceException("Cannot find '/NetworkAdapterNotify.wsdl' wsdl. Place the resource correctly in the classpath.");
        }
        NETWORKADAPTERNOTIFY_EXCEPTION = e;
    }

    public NetworkAdapterNotify_Service() {
        super(__getWsdlLocation(), NETWORKADAPTERNOTIFY_QNAME);
    }

    public NetworkAdapterNotify_Service(WebServiceFeature... features) {
        super(__getWsdlLocation(), NETWORKADAPTERNOTIFY_QNAME, features);
    }

    public NetworkAdapterNotify_Service(URL wsdlLocation) {
        super(wsdlLocation, NETWORKADAPTERNOTIFY_QNAME);
    }

    public NetworkAdapterNotify_Service(URL wsdlLocation, WebServiceFeature... features) {
        super(wsdlLocation, NETWORKADAPTERNOTIFY_QNAME, features);
    }

    public NetworkAdapterNotify_Service(URL wsdlLocation, QName serviceName) {
        super(wsdlLocation, serviceName);
    }

    public NetworkAdapterNotify_Service(URL wsdlLocation, QName serviceName, WebServiceFeature... features) {
        super(wsdlLocation, serviceName, features);
    }

    /**
     * 
     * @return
     *     returns NetworkAdapterNotify
     */
    @WebEndpoint(name = "MsoNetworkAdapterAsyncImplPort")
    public NetworkAdapterNotify getMsoNetworkAdapterAsyncImplPort() {
        return super.getPort(new QName("http://org.onap.so/networkNotify", "MsoNetworkAdapterAsyncImplPort"), NetworkAdapterNotify.class);
    }

    /**
     * 
     * @param features
     *     A list of {@link javax.xml.ws.WebServiceFeature} to configure on the proxy.  Supported features not in the <code>features</code> parameter will have their default values.
     * @return
     *     returns NetworkAdapterNotify
     */
    @WebEndpoint(name = "MsoNetworkAdapterAsyncImplPort")
    public NetworkAdapterNotify getMsoNetworkAdapterAsyncImplPort(WebServiceFeature... features) {
        return super.getPort(new QName("http://org.onap.so/networkNotify", "MsoNetworkAdapterAsyncImplPort"), NetworkAdapterNotify.class, features);
    }

    private static URL __getWsdlLocation() {
        if (NETWORKADAPTERNOTIFY_EXCEPTION!= null) {
            throw NETWORKADAPTERNOTIFY_EXCEPTION;
        }
        return NETWORKADAPTERNOTIFY_WSDL_LOCATION;
    }

}