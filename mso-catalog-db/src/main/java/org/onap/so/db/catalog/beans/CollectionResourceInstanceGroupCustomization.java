/*-
 * ============LICENSE_START=======================================================
 * ONAP - SO
 * ================================================================================
 * Copyright (C) 2017 - 2018 AT&T Intellectual Property. All rights reserved.
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

package org.onap.so.db.catalog.beans;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrePersist;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;

import com.openpojo.business.annotation.BusinessKey;

import uk.co.blackpepper.bowman.annotation.LinkedResource;

@Entity
@IdClass(CollectionResourceInstanceGroupCustomizationId.class)
@Table(name = "collection_resource_instance_group_customization")
public class CollectionResourceInstanceGroupCustomization implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5169990063225044265L;

	@BusinessKey
	@Id
	@Column(name = "COLLECTION_RESOURCE_CUSTOMIZATION_MODEL_UUID")
	private String modelCustomizationUUID;

	@BusinessKey
	@Id
	@Column(name = "INSTANCE_GROUP_MODEL_UUID")
	private String modelUUID;

	@ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "COLLECTION_RESOURCE_CUSTOMIZATION_MODEL_UUID", updatable = false, insertable = false)
	private CollectionResourceCustomization collectionResourceCust;

	@ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "INSTANCE_GROUP_MODEL_UUID", updatable = false, insertable = false)
	private InstanceGroup instanceGroup;

	@Column(name = "FUNCTION")
	private String function;

	@Column(name = "DESCRIPTION")
	private String description;

	@Column(name = "CREATION_TIMESTAMP", updatable = false)
	@Temporal(TemporalType.TIMESTAMP)
	private Date created;

	@Column(name = "SUBINTERFACE_NETWORK_QUANTITY")
	private Integer subInterfaceNetworkQuantity;

	@Override
	public String toString() {
		return new ToStringBuilder(this).append("modelCustomizationUUID", modelCustomizationUUID)
				.append("modelUUID", modelUUID).append("collectionResourceCust", collectionResourceCust)
				.append("instanceGroup", instanceGroup).append("function", function).append("description", description)
				.append("created", created).append("subInterfaceNetworkQuantity", subInterfaceNetworkQuantity)
				.toString();
	}

	@Override
	public boolean equals(final Object other) {
		if (!(other instanceof CollectionResourceInstanceGroupCustomization)) {
			return false;
		}
		CollectionResourceInstanceGroupCustomization castOther = (CollectionResourceInstanceGroupCustomization) other;
		return new EqualsBuilder().append(modelCustomizationUUID, castOther.modelCustomizationUUID)
				.append(modelUUID, castOther.modelUUID).append(collectionResourceCust, castOther.collectionResourceCust)
				.append(instanceGroup, castOther.instanceGroup).isEquals();
	}

	@Override
	public int hashCode() {
		return new HashCodeBuilder().append(modelCustomizationUUID).append(modelUUID).append(collectionResourceCust)
				.append(instanceGroup).toHashCode();
	}
	
	@PrePersist
	protected void onCreate() {
		this.created = new Date();
	}

	public String getModelCustomizationUUID() {
		return modelCustomizationUUID;
	}

	public void setModelCustomizationUUID(String modelCustomizationUUID) {
		this.modelCustomizationUUID = modelCustomizationUUID;
	}

	public String getModelUUID() {
		return modelUUID;
	}

	public void setModelUUID(String modelUUID) {
		this.modelUUID = modelUUID;
	}

	public String getFunction() {
		return function;
	}

	public void setFunction(String function) {
		this.function = function;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Date getCreated() {
		return created;
	}

	public Integer getSubInterfaceNetworkQuantity() {
		return subInterfaceNetworkQuantity;
	}

	public void setSubInterfaceNetworkQuantity(Integer subInterfaceNetworkQuantity) {
		this.subInterfaceNetworkQuantity = subInterfaceNetworkQuantity;
	}

	@LinkedResource
	public CollectionResourceCustomization getCollectionResourceCust() {
		return collectionResourceCust;
	}

	public void setCollectionResourceCust(CollectionResourceCustomization collectionResourceCust) {
		this.collectionResourceCust = collectionResourceCust;
	}

	@LinkedResource
	public InstanceGroup getInstanceGroup() {
		return instanceGroup;
	}

	public void setInstanceGroup(InstanceGroup instanceGroup) {
		this.instanceGroup = instanceGroup;
	}
}
