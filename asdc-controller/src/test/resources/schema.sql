
--------START Catalog DB SCHEMA --------
use catalogdb;

create table `allotted_resource` (
  `model_uuid` varchar(200) not null,
  `model_invariant_uuid` varchar(200) not null,
  `model_version` varchar(20) not null,
  `model_name` varchar(200) not null,
  `tosca_node_type` varchar(200) default null,
  `subcategory` varchar(200) default null,
  `description` varchar(1200) default null,
  `creation_timestamp` datetime not null default current_timestamp,
  primary key (`model_uuid`)
) engine=innodb default charset=latin1;




create table `allotted_resource_customization` (
  `model_customization_uuid` varchar(200) not null,
  `model_instance_name` varchar(200) not null,
  `providing_service_model_uuid` varchar(200) default null,
  `providing_service_model_invariant_uuid` varchar(200) default null,
  `providing_service_model_name` varchar(200) default null,
  `target_network_role` varchar(200) default null,
  `nf_type` varchar(200) default null,
  `nf_role` varchar(200) default null,
  `nf_function` varchar(200) default null,
  `nf_naming_code` varchar(200) default null,
  `min_instances` int(11) default null,
  `max_instances` int(11) default null,
  `ar_model_uuid` varchar(200) not null,
  `creation_timestamp` datetime not null default current_timestamp,
  primary key (`model_customization_uuid`),
  key `fk_allotted_resource_customization__allotted_resource1_idx` (`ar_model_uuid`),
  constraint `fk_allotted_resource_customization__allotted_resource1` foreign key (`ar_model_uuid`) references `allotted_resource` (`model_uuid`) on delete cascade on update cascade
) engine=innodb default charset=latin1;




create table `heat_environment` (
  `artifact_uuid` varchar(200) not null,
  `name` varchar(100) not null,
  `version` varchar(20) not null,
  `description` varchar(1200) default null,
  `body` longtext not null,
  `artifact_checksum` varchar(200) not null default 'manual record',
  `creation_timestamp` datetime not null default current_timestamp,
  primary key (`artifact_uuid`)
) engine=innodb default charset=latin1;



create table `heat_files` (
  `artifact_uuid` varchar(200) not null,
  `name` varchar(200) not null,
  `version` varchar(20) not null,
  `description` varchar(1200) default null,
  `body` longtext not null,
  `artifact_checksum` varchar(200) not null default 'manual record',
  `creation_timestamp` datetime not null default current_timestamp,
  primary key (`artifact_uuid`)
) engine=innodb default charset=latin1;




create table `heat_template` (
  `artifact_uuid` varchar(200) not null,
  `name` varchar(200) not null,
  `version` varchar(20) not null,
  `description` varchar(1200) default null,
  `body` longtext not null,
  `timeout_minutes` int(11) default null,
  `artifact_checksum` varchar(200) not null default 'manual record',
  `creation_timestamp` datetime not null default current_timestamp,
  primary key (`artifact_uuid`)
) engine=innodb default charset=latin1;



create table `heat_nested_template` (
  `parent_heat_template_uuid` varchar(200) not null,
  `child_heat_template_uuid` varchar(200) not null,
  `provider_resource_file` varchar(100) default null,
  primary key (`parent_heat_template_uuid`,`child_heat_template_uuid`),
  key `fk_heat_nested_template__heat_template2_idx` (`child_heat_template_uuid`),
  constraint `fk_heat_nested_template__child_heat_temp_uuid__heat_template1` foreign key (`child_heat_template_uuid`) references `heat_template` (`artifact_uuid`) on delete cascade on update cascade,
  constraint `fk_heat_nested_template__parent_heat_temp_uuid__heat_template1` foreign key (`parent_heat_template_uuid`) references `heat_template` (`artifact_uuid`) on delete cascade on update cascade
) engine=innodb default charset=latin1;




create table `heat_template_params` (
  `heat_template_artifact_uuid` varchar(200) not null,
  `param_name` varchar(100) not null,
  `is_required` bit(1) not null,
  `param_type` varchar(20) default null,
  `param_alias` varchar(45) default null,
  primary key (`heat_template_artifact_uuid`,`param_name`),
  constraint `fk_heat_template_params__heat_template1` foreign key (`heat_template_artifact_uuid`) references `heat_template` (`artifact_uuid`) on delete cascade on update cascade
) engine=innodb default charset=latin1;



create table `network_recipe` (
  `id` int(11) not null auto_increment,
  `model_name` varchar(20) not null,
  `action` varchar(50) not null,
  `description` varchar(1200) default null,
  `orchestration_uri` varchar(256) not null,
  `network_param_xsd` varchar(2048) default null,
  `recipe_timeout` int(11) default null,
  `service_type` varchar(45) default null,
  `creation_timestamp` datetime not null default current_timestamp,
  `version_str` varchar(20) not null,
  primary key (`id`),
  unique key `uk_rl4f296i0p8lyokxveaiwkayi` (`model_name`,`action`,`version_str`)
) engine=innodb auto_increment=178 default charset=latin1;




create table `temp_network_heat_template_lookup` (
  `network_resource_model_name` varchar(200) not null,
  `heat_template_artifact_uuid` varchar(200) not null,
  `aic_version_min` varchar(20) not null,
  `aic_version_max` varchar(20) default null,
  primary key (`network_resource_model_name`),
  key `fk_temp_network_heat_template_lookup__heat_template1_idx` (`heat_template_artifact_uuid`),
  constraint `fk_temp_network_heat_template_lookup__heat_template1` foreign key (`heat_template_artifact_uuid`) references `heat_template` (`artifact_uuid`) on delete no action on update cascade
) engine=innodb default charset=latin1;



create table `network_resource` (
  `model_uuid` varchar(200) not null,
  `model_name` varchar(200) not null,
  `model_invariant_uuid` varchar(200) default null,
  `description` varchar(1200) default null,
  `heat_template_artifact_uuid` varchar(200) not null,
  `neutron_network_type` varchar(20) default null,
  `model_version` varchar(20) default null,
  `tosca_node_type` varchar(200) default null,
  `aic_version_min` varchar(20) not null,
  `aic_version_max` varchar(20) default null,
  `orchestration_mode` varchar(20) default 'heat',
  `resource_category` varchar(20) default null,
  `resource_sub_category` varchar(20) default null,
  `creation_timestamp` datetime not null default current_timestamp,
  primary key (`model_uuid`),
  key `fk_network_resource__temp_network_heat_template_lookup1_idx` (`model_name`),
  key `fk_network_resource__heat_template1_idx` (`heat_template_artifact_uuid`),
  constraint `fk_network_resource__heat_template1` foreign key (`heat_template_artifact_uuid`) references `heat_template` (`artifact_uuid`) on delete no action on update cascade,
  constraint `fk_network_resource__temp_network_heat_template_lookup__mod_nm1` foreign key (`model_name`) references `temp_network_heat_template_lookup` (`network_resource_model_name`) on delete no action on update no action
) engine=innodb default charset=latin1;





create table `network_resource_customization` (
  `model_customization_uuid` varchar(200) not null,
  `model_instance_name` varchar(200) not null,
  `network_technology` varchar(45) default null,
  `network_type` varchar(45) default null,
  `network_role` varchar(200) default null,
  `network_scope` varchar(45) default null,
  `creation_timestamp` datetime not null default current_timestamp,
  `network_resource_model_uuid` varchar(200) not null,
  primary key (`model_customization_uuid`),
  key `fk_network_resource_customization__network_resource1_idx` (`network_resource_model_uuid`),
  constraint `fk_network_resource_customization__network_resource1` foreign key (`network_resource_model_uuid`) references `network_resource` (`model_uuid`) on delete cascade on update cascade
) engine=innodb default charset=latin1;





create table `tosca_csar` (
  `artifact_uuid` varchar(200) not null,
  `name` varchar(200) not null,
  `version` varchar(20) not null,
  `description` varchar(1200) default null,
  `artifact_checksum` varchar(200) not null,
  `url` varchar(200) not null,
  `creation_timestamp` datetime not null default current_timestamp,
  primary key (`artifact_uuid`)
) engine=innodb default charset=latin1;




create table `service` (
  `model_uuid` varchar(200) not null,
  `model_name` varchar(200) not null,
  `model_invariant_uuid` varchar(200) not null,
  `model_version` varchar(20) not null,
  `description` varchar(1200) default null,
  `creation_timestamp` datetime not null default current_timestamp,
  `tosca_csar_artifact_uuid` varchar(200) default null,
  `service_type` varchar(200) default null,
  `service_role` varchar(200) default null,
  `environment_context` varchar(200) default null,
  `workload_context` varchar(200) default null,
  `service_category` varchar(200) default null,
  primary key (`model_uuid`),
  key `fk_service__tosca_csar1_idx` (`tosca_csar_artifact_uuid`),
  constraint `fk_service__tosca_csar1` foreign key (`tosca_csar_artifact_uuid`) references `tosca_csar` (`artifact_uuid`) on delete cascade on update cascade
) engine=innodb default charset=latin1;



create table `service_recipe` (
  `id` int(11) not null auto_increment,
  `action` varchar(50) not null,
  `version_str` varchar(20) default null,
  `description` varchar(1200) default null,
  `orchestration_uri` varchar(256) not null,
  `service_param_xsd` varchar(2048) default null,
  `recipe_timeout` int(11) default null,
  `service_timeout_interim` int(11) default null,
  `creation_timestamp` datetime not null default current_timestamp,
  `service_model_uuid` varchar(200) not null,
  primary key (`id`),
  unique key `uk_7fav5dkux2v8g9d2i5ymudlgc` (`service_model_uuid`,`action`),
  key `fk_service_recipe__service1_idx` (`service_model_uuid`),
  constraint `fk_service_recipe__service1` foreign key (`service_model_uuid`) references `service` (`model_uuid`) on delete cascade on update cascade
) engine=innodb auto_increment=86 default charset=latin1;



create table `vnf_resource` (
  `orchestration_mode` varchar(20) not null default 'heat',
  `description` varchar(1200) default null,
  `creation_timestamp` datetime not null default current_timestamp,
  `model_uuid` varchar(200) not null,
  `aic_version_min` varchar(20) default null,
  `aic_version_max` varchar(20) default null,
  `model_invariant_uuid` varchar(200) default null,
  `model_version` varchar(20) not null,
  `model_name` varchar(200) default null,
  `tosca_node_type` varchar(200) default null,
  `resource_category` varchar(200) default null,
  `resource_sub_category` varchar(200) default null,
  `heat_template_artifact_uuid` varchar(200) default null,
  primary key (`model_uuid`),
  key `fk_vnf_resource__heat_template1` (`heat_template_artifact_uuid`),
  constraint `fk_vnf_resource__heat_template1` foreign key (`heat_template_artifact_uuid`) references `heat_template` (`artifact_uuid`) on delete cascade on update cascade
) engine=innodb default charset=latin1;




create table `vf_module` (
  `model_uuid` varchar(200) not null,
  `model_invariant_uuid` varchar(200) default null,
  `model_version` varchar(20) not null,
  `model_name` varchar(200) not null,
  `description` varchar(1200) default null,
  `is_base` int(11) not null,
  `heat_template_artifact_uuid` varchar(200) default null,
  `vol_heat_template_artifact_uuid` varchar(200) default null,
  `creation_timestamp` datetime not null default current_timestamp,
  `vnf_resource_model_uuid` varchar(200) not null,
  primary key (`model_uuid`,`vnf_resource_model_uuid`),
  key `fk_vf_module__vnf_resource1_idx` (`vnf_resource_model_uuid`),
  key `fk_vf_module__heat_template_art_uuid__heat_template1_idx` (`heat_template_artifact_uuid`),
  key `fk_vf_module__vol_heat_template_art_uuid__heat_template2_idx` (`vol_heat_template_artifact_uuid`),
  constraint `fk_vf_module__heat_template_art_uuid__heat_template1` foreign key (`heat_template_artifact_uuid`) references `heat_template` (`artifact_uuid`) on delete cascade on update cascade,
  constraint `fk_vf_module__vnf_resource1` foreign key (`vnf_resource_model_uuid`) references `vnf_resource` (`model_uuid`) on delete cascade on update cascade,
  constraint `fk_vf_module__vol_heat_template_art_uuid__heat_template2` foreign key (`vol_heat_template_artifact_uuid`) references `heat_template` (`artifact_uuid`) on delete cascade on update cascade
) engine=innodb default charset=latin1;



/*!40101 set @saved_cs_client     = @@character_set_client */;
/*!40101 set character_set_client = utf8 */;
create table `vf_module_customization` (
  `model_customization_uuid` varchar(200) not null,
  `label` varchar(200) default null,
  `initial_count` int(11) default '0',
  `min_instances` int(11) default '0',
  `max_instances` int(11) default null,
  `availability_zone_count` int(11) default null,
  `heat_environment_artifact_uuid` varchar(200) default null,
  `vol_environment_artifact_uuid` varchar(200) default null,
  `creation_timestamp` datetime not null default current_timestamp,
  `vf_module_model_uuid` varchar(200) not null,
  primary key (`model_customization_uuid`),
  key `fk_vf_module_customization__vf_module1_idx` (`vf_module_model_uuid`),
  key `fk_vf_module_customization__heat_env__heat_environment1_idx` (`heat_environment_artifact_uuid`),
  key `fk_vf_module_customization__vol_env__heat_environment2_idx` (`vol_environment_artifact_uuid`),
  constraint `fk_vf_module_customization__heat_env__heat_environment1` foreign key (`heat_environment_artifact_uuid`) references `heat_environment` (`artifact_uuid`) on delete cascade on update cascade,
  constraint `fk_vf_module_customization__vf_module1` foreign key (`vf_module_model_uuid`) references `vf_module` (`model_uuid`) on delete cascade on update cascade,
  constraint `fk_vf_module_customization__vol_env__heat_environment2` foreign key (`vol_environment_artifact_uuid`) references `heat_environment` (`artifact_uuid`) on delete cascade on update cascade
) engine=innodb default charset=latin1;
/*!40101 set character_set_client = @saved_cs_client */;

--
-- table structure for table `vf_module_to_heat_files`
--


/*!40101 set @saved_cs_client     = @@character_set_client */;
/*!40101 set character_set_client = utf8 */;
create table `vf_module_to_heat_files` (
  `vf_module_model_uuid` varchar(200) not null,
  `heat_files_artifact_uuid` varchar(200) not null,
  primary key (`vf_module_model_uuid`,`heat_files_artifact_uuid`),
  key `fk_vf_module_to_heat_files__heat_files__artifact_uuid1_idx` (`heat_files_artifact_uuid`),
  constraint `fk_vf_module_to_heat_files__heat_files__artifact_uuid1` foreign key (`heat_files_artifact_uuid`) references `heat_files` (`artifact_uuid`) on delete cascade on update cascade,
  constraint `fk_vf_module_to_heat_files__vf_module__model_uuid1` foreign key (`vf_module_model_uuid`) references `vf_module` (`model_uuid`) on delete cascade on update cascade
) engine=innodb default charset=latin1 comment='il fait ce qu''il dit';
/*!40101 set character_set_client = @saved_cs_client */;

--
-- table structure for table `vnf_components`
--


/*!40101 set @saved_cs_client     = @@character_set_client */;
/*!40101 set character_set_client = utf8 */;
create table `vnf_components` (
  `vnf_id` int(11) not null,
  `component_type` varchar(20) not null,
  `heat_template_id` int(11) default null,
  `heat_environment_id` int(11) default null,
  `creation_timestamp` datetime not null default current_timestamp,
  primary key (`vnf_id`,`component_type`)
) engine=innodb default charset=latin1;
/*!40101 set character_set_client = @saved_cs_client */;

--
-- table structure for table `vnf_components_recipe`
--



create table `vnf_components_recipe` (
  `id` int(11) not null auto_increment,
  `vnf_type` varchar(200) default null,
  `vnf_component_type` varchar(45) not null,
  `action` varchar(50) not null,
  `service_type` varchar(45) default null,
  `version` varchar(20) not null,
  `description` varchar(1200) default null,
  `orchestration_uri` varchar(256) not null,
  `vnf_component_param_xsd` varchar(2048) default null,
  `recipe_timeout` int(11) default null,
  `creation_timestamp` datetime default current_timestamp,
  `vf_module_model_uuid` varchar(200) default null,
  primary key (`id`),
  unique key `uk_4dpdwddaaclhc11wxsb7h59ma` (`vf_module_model_uuid`,`vnf_component_type`,`action`,`version`)
) engine=innodb auto_increment=26 default charset=latin1;




create table `vnf_recipe` (
  `id` int(11) not null auto_increment,
  `vnf_type` varchar(200) default null,
  `action` varchar(50) not null,
  `service_type` varchar(45) default null,
  `version_str` varchar(20) not null,
  `description` varchar(1200) default null,
  `orchestration_uri` varchar(256) not null,
  `vnf_param_xsd` varchar(2048) default null,
  `recipe_timeout` int(11) default null,
  `creation_timestamp` datetime default current_timestamp,
  `vf_module_id` varchar(100) default null,
  primary key (`id`),
  unique key `uk_f3tvqau498vrifq3cr8qnigkr` (`vf_module_id`,`action`,`version_str`)
) engine=innodb auto_increment=10006 default charset=latin1;








create table `vnf_resource_customization` (
  `model_customization_uuid` varchar(200) not null,
  `model_instance_name` varchar(200) not null,
  `min_instances` int(11) default null,
  `max_instances` int(11) default null,
  `availability_zone_max_count` int(11) default null,
  `nf_type` varchar(200) default null,
  `nf_role` varchar(200) default null,
  `nf_function` varchar(200) default null,
  `nf_naming_code` varchar(200) default null,
  `creation_timestamp` datetime not null default current_timestamp,
  `vnf_resource_model_uuid` varchar(200) not null,
  `multi_stage_design` varchar(20) default null,
  primary key (`model_customization_uuid`),
  key `fk_vnf_resource_customization__vnf_resource1_idx` (`vnf_resource_model_uuid`),
  constraint `fk_vnf_resource_customization__vnf_resource1` foreign key (`vnf_resource_model_uuid`) references `vnf_resource` (`model_uuid`) on delete cascade on update cascade
) engine=innodb default charset=latin1;




create table `vnf_res_custom_to_vf_module_custom` (
  `vnf_resource_cust_model_customization_uuid` varchar(200) not null,
  `vf_module_cust_model_customization_uuid` varchar(200) not null,
  `creation_timestamp` datetime not null default current_timestamp,
  primary key (`vnf_resource_cust_model_customization_uuid`,`vf_module_cust_model_customization_uuid`),
  key `fk_vnf_res_custom_to_vf_module_custom__vf_module_customizat_idx` (`vf_module_cust_model_customization_uuid`),
  constraint `fk_vnf_res_custom_to_vf_module_custom__vf_module_customization1` foreign key (`vf_module_cust_model_customization_uuid`) references `vf_module_customization` (`model_customization_uuid`) on delete cascade on update cascade,
  constraint `fk_vnf_res_custom_to_vf_module_custom__vnf_resource_customiza1` foreign key (`vnf_resource_cust_model_customization_uuid`) references `vnf_resource_customization` (`model_customization_uuid`) on delete cascade on update cascade
) engine=innodb default charset=latin1;
 

create table if not exists external_service_to_internal_model_mapping (
id int(11) not null auto_increment, 
service_name varchar(200) not null,
product_flavor varchar(200) null,
subscription_service_type varchar(200) not null,
service_model_uuid varchar(200) not null, 
primary key (id), 
unique index uk_external_service_to_internal_model_mapping
(service_name asc, product_flavor asc, service_model_uuid asc));

create table if not exists `collection_resource` (
 model_uuid varchar(200) not null,
 model_name varchar(200) not null, 
 model_invariant_uuid varchar(200) not null,
 model_version varchar(20) not null, 
 tosca_node_type varchar(200) not null,
 description varchar(200),  
 creation_timestamp datetime not null default current_timestamp,
 primary key (`model_uuid`)
)engine=innodb default charset=latin1;

create table if not exists `collection_resource_customization` (
 model_customization_uuid varchar(200) not null,
 model_instance_name varchar(200) not null,
 role varchar(200) NULL,
 object_type varchar(200) not null, 
 function varchar(200) NULL,
 collection_resource_type varchar(200) NULL,
 creation_timestamp datetime not null default current_timestamp,
 cr_model_uuid varchar(200) not null,
 primary key (`model_customization_uuid`)
)engine=innodb default charset=latin1;

create table if not exists `instance_group` (
 model_uuid varchar(200) not null,
 model_name varchar(200) not null,
 model_invariant_uuid varchar(200) not null,
 model_version varchar(20) not null,
 tosca_node_type varchar(200) NULL,
 role varchar(200) not null,
 object_type varchar(200) not null,
 creation_timestamp datetime not null default current_timestamp,
 cr_model_uuid varchar(200) NULL,
 instance_group_type varchar(200) not null,
  primary key (`model_uuid`)
)engine=innodb default charset=latin1;

create table if not exists `collection_resource_instance_group_customization` (
  `collection_resource_customization_model_uuid` varchar(200) not null,
  `instance_group_model_uuid` varchar(200) not null,
  `function` varchar(200) null,
  `description` varchar(1200) null,
  `subinterface_network_quantity` int(11) null,
  `creation_timestamp` datetime not null default current_timestamp,
  primary key (`collection_resource_customization_model_uuid`, `instance_group_model_uuid`),
  index `fk_collection_resource_instance_group_customization__instan_idx` (`instance_group_model_uuid` asc),
  constraint `fk_collection_resource_instance_group_customization__collecti1`
    foreign key (`collection_resource_customization_model_uuid`)
    references `collection_resource_customization` (`model_customization_uuid`)
    on delete cascade
    on update cascade,
  constraint `fk_collection_resource_instance_group_customization__instance1`
    foreign key (`instance_group_model_uuid`)
    references `instance_group` (`model_uuid`)
    on delete cascade
    on update cascade)
engine = innodb
default character set = latin1;

create table if not exists `vnfc_instance_group_customization` (
  `vnf_resource_customization_model_uuid` varchar(200) not null,
  `instance_group_model_uuid` varchar(200) not null,
  `function` varchar(200) null,
  `description` varchar(1200) null,
  `creation_timestamp` datetime not null default current_timestamp,
  primary key (`vnf_resource_customization_model_uuid`, `instance_group_model_uuid`),
  index `fk_vnfc_instance_group_customization__instance_group1_idx` (`instance_group_model_uuid` asc),
  constraint `fk_vnfc_instance_group_customization__vnf_resource_customizat1`
    foreign key (`vnf_resource_customization_model_uuid`)
    references `vnf_resource_customization` (`model_customization_uuid`)
    on delete cascade
    on update cascade,
  constraint `fk_vnfc_instance_group_customization__instance_group1`
    foreign key (`instance_group_model_uuid`)
    references `instance_group` (`model_uuid`)
    on delete cascade
    on update cascade)
engine = innodb
default character set = latin1;

 create table if not exists `configuration` 
 ( `model_uuid` varchar(200) not null, 
 `model_invariant_uuid` varchar(200) not null, 
 `model_version` varchar(20) not null, 
 `model_name` varchar(200) not null, 
 `tosca_node_type` varchar(200) not null, 
 `description` varchar(1200) null, 
 `creation_timestamp` datetime not null default current_timestamp,
 primary key (`model_uuid`)) 
 engine = innodb auto_increment = 20654 
 default character set = latin1;
 
 create table if not exists `service_proxy` (
 `model_uuid` varchar(200) not null,
 `model_invariant_uuid` varchar(200) not null,
 `model_version` varchar(20) not null,
 `model_name` varchar(200) not null,
 `description` varchar(1200) null,
 `creation_timestamp` datetime not null default current_timestamp,
 primary key (`model_uuid`)) 
 engine = innodb auto_increment = 20654
 default character set = latin1;

create table if not exists `service_proxy_customization` (
`model_customization_uuid` varchar(200) not null,
`model_instance_name` varchar(200) not null,
`tosca_node_type` varchar(200) not null,
`source_service_model_uuid` varchar(200) not null,
`creation_timestamp` datetime not null default current_timestamp,
`service_proxy_model_uuid` varchar(200) not null,
primary key (`model_customization_uuid`),
index `fk_service_proxy_customization__service_proxy1_idx` (`service_proxy_model_uuid` asc),
index `fk_service_proxy_customization__service1_idx` (`source_service_model_uuid` asc), 
constraint`fk_spr_customization__service_proxy_resource1` 
foreign key (`service_proxy_model_uuid`) references `service_proxy` (`model_uuid`)
on delete cascade on update cascade,
constraint `fk_service_proxy_resource_customization__service1` 
foreign key (`source_service_model_uuid`) references `service`
(`model_uuid`) on delete cascade on update cascade) 
engine = innodb
auto_increment = 20654 
default character set = latin1;

create table if not exists `configuration_customization` (
`model_customization_uuid` varchar(200) not null, 
`model_instance_name` varchar(200) not null,
`configuration_type` varchar(200) null,
`configuration_role` varchar(200) null,
`configuration_function` varchar(200) null,
`creation_timestamp` datetime not null default current_timestamp, 
`configuration_model_uuid` varchar(200) not null,
`service_proxy_customization_model_customization_uuid` varchar(200) null, 
`configuration_customization_model_customization_uuid` varchar(200) null, 
primary key (`model_customization_uuid`), 
index `fk_configuration_customization__configuration_idx` (`configuration_model_uuid` asc), 
index `fk_configuration_customization__service_proxy_customization_idx`
(`service_proxy_customization_model_customization_uuid` asc), 
index `fk_configuration_customization__configuration_customization_idx`
(`configuration_customization_model_customization_uuid` asc), 
constraint `fk_configuration_resource_customization__configuration_resour1`
foreign key (`configuration_model_uuid`) references `configuration` (`model_uuid`)
on delete cascade on update cascade, 
constraint `fk_configuration_customization__service_proxy_customization1` foreign
key (`service_proxy_customization_model_customization_uuid`) references
`service_proxy_customization` (`model_customization_uuid`)
on delete cascade on update cascade, constraint
`fk_configuration_customization__configuration_customization1` foreign
key (`configuration_customization_model_customization_uuid`) references
`configuration_customization` (`model_customization_uuid`)
on delete cascade on update cascade)
engine = innodb
auto_increment =20654 
default character set = latin1;


create table `service_proxy_customization_to_service` (
  `service_model_uuid` varchar(200) not null,
  `resource_model_customization_uuid` varchar(200) not null,
  primary key (`service_model_uuid`,`resource_model_customization_uuid`)
)engine=innodb default charset=latin1;


create table `configuration_customization_to_service` (
  `service_model_uuid` varchar(200) not null,
  `resource_model_customization_uuid` varchar(200) not null,
  primary key (`service_model_uuid`,`resource_model_customization_uuid`)
)engine=innodb default charset=latin1;


create table if not exists `collection_resource_customization_to_service` (
  `service_model_uuid` varchar(200) not null,
  `resource_model_customization_uuid` varchar(200) not null,
  primary key (`service_model_uuid`,`resource_model_customization_uuid`)
)engine=innodb default charset=latin1;


create table `network_resource_customization_to_service` (
  `service_model_uuid` varchar(200) not null,
  `resource_model_customization_uuid` varchar(200) not null,
  primary key (`service_model_uuid`,`resource_model_customization_uuid`)
)engine=innodb default charset=latin1;

create table `vnf_resource_customization_to_service` (
  `service_model_uuid` varchar(200) not null,
  `resource_model_customization_uuid` varchar(200) not null,
  primary key (`service_model_uuid`,`resource_model_customization_uuid`)
)engine=innodb default charset=latin1;

create table `allotted_resource_customization_to_service` (
  `service_model_uuid` varchar(200) not null,
  `resource_model_customization_uuid` varchar(200) not null,
  primary key (`service_model_uuid`,`resource_model_customization_uuid`)
)engine=innodb default charset=latin1;




create table ar_recipe (
    ID INT(11) not null auto_increment,
    MODEL_NAME VARCHAR(200) NOT NULL,
    `ACTION` VARCHAR(200) NOT NULL,
    VERSION_STR VARCHAR(200) NOT NULL,
    SERVICE_TYPE VARCHAR(200),
    DESCRIPTION VARCHAR(200),
    ORCHESTRATION_URI VARCHAR(200) NOT NULL,
    AR_PARAM_XSD VARCHAR(200),
    RECIPE_TIMEOUT INT(10),
    CREATION_TIMESTAMP DATETIME NOT NULL default current_timestamp,
    primary key (ID),
    unique key `uk_ar_recipe` (`model_name`,`action`,`version_str`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

alter table collection_resource_customization
add foreign key ( cr_model_uuid)
references collection_resource(model_uuid)
on delete cascade;

alter table vnf_resource_customization 
add column 
instance_group_model_uuid varchar(200);

alter table network_resource_customization 
add column 
instance_group_model_uuid varchar(200);


alter table network_resource_customization 
add foreign key ( instance_group_model_uuid) 
references instance_group(model_uuid)
on delete cascade;

alter table collection_resource_customization_to_service 
add foreign key (service_model_uuid) 
references service(model_uuid)
on delete cascade;

alter table allotted_resource_customization_to_service 
add foreign key (service_model_uuid) 
references service(model_uuid)
on delete cascade;


alter table vnf_resource_customization_to_service 
add foreign key (service_model_uuid) 
references service(model_uuid)
on delete cascade;


alter table network_resource_customization_to_service 
add foreign key (service_model_uuid) 
references service(model_uuid)
on delete cascade;


alter table network_resource_customization_to_service 
add foreign key (resource_model_customization_uuid) 
references network_resource_customization(model_customization_uuid)
on delete cascade;

alter table vnf_resource_customization_to_service 
add foreign key (resource_model_customization_uuid) 
references vnf_resource_customization(model_customization_uuid)
on delete cascade;

alter table allotted_resource_customization_to_service 
add foreign key (resource_model_customization_uuid) 
references allotted_resource_customization(model_customization_uuid)
on delete cascade;  

alter table collection_resource_customization_to_service 
add foreign key (resource_model_customization_uuid) 
references collection_resource_customization(model_customization_uuid)
on delete cascade;


create table if not exists `collection_network_resource_customization` (
`model_customization_uuid` varchar(200) not null,
`model_instance_name` varchar(200) not null,
`network_technology` varchar(45) null,
`network_type` varchar(45) null,
`network_role` varchar(200) null,
`network_scope` varchar(45) null,
`creation_timestamp` datetime not null default current_timestamp, 
`network_resource_model_uuid` varchar(200) not null, `instance_group_model_uuid` varchar(200) null,
`crc_model_customization_uuid` varchar(200) not null, primary key
(`model_customization_uuid`, `crc_model_customization_uuid`),
index `fk_collection_net_resource_customization__network_resource1_idx`
(`network_resource_model_uuid` asc), index
`fk_collection_net_resource_customization__instance_group1_idx`
(`instance_group_model_uuid` asc), index
`fk_col_net_res_customization__collection_res_customization_idx`
(`crc_model_customization_uuid` asc), constraint
`fk_collection_net_resource_customization__network_resource10` foreign
key (`network_resource_model_uuid`) references
`network_resource` (`model_uuid`) on delete cascade on
update cascade, constraint
`fk_collection_net_resource_customization__instance_group10` foreign key
(`instance_group_model_uuid`) references `instance_group`
(`model_uuid`) on delete cascade on update cascade, constraint
`fk_collection_network_resource_customization__collection_reso1` foreign
key (`crc_model_customization_uuid`) references
`collection_resource_customization`
(`model_customization_uuid`) on delete cascade on update cascade) engine
= innodb default character set = latin1;

CREATE TABLE IF NOT EXISTS `rainy_day_handler_macro` (
`id` INT(11) NOT NULL AUTO_INCREMENT,
`FLOW_NAME` VARCHAR(200) NOT NULL,
`SERVICE_TYPE` VARCHAR(200) NOT NULL,
`VNF_TYPE` VARCHAR(200) NOT NULL,
`ERROR_CODE` VARCHAR(200) NOT NULL,
`WORK_STEP` VARCHAR(200) NOT NULL,
`POLICY` VARCHAR(200) NOT NULL,
PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `northbound_request_ref_lookup` (
`id` INT(11) NOT NULL AUTO_INCREMENT,
`REQUEST_SCOPE` VARCHAR(200) NOT NULL,
`ACTION` VARCHAR(200) NOT NULL,
`MACRO_ACTION` VARCHAR(200) NOT NULL,
`IS_ALACARTE` TINYINT(1) NOT NULL DEFAULT 0,
`IS_TOPLEVELFLOW` TINYINT(1) NOT NULL DEFAULT 0,
`MIN_API_VERSION` DOUBLE NOT NULL,
`MAX_API_VERSION` DOUBLE NULL,
PRIMARY KEY (`id`),
UNIQUE INDEX `UK_northbound_request_ref_lookup` (`MIN_API_VERSION` ASC, `REQUEST_SCOPE` ASC, `ACTION` ASC, `IS_ALACARTE` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `orchestration_flow_reference` (
`id` INT(11) NOT NULL AUTO_INCREMENT,
`COMPOSITE_ACTION` VARCHAR(200) NOT NULL,
`SEQ_NO` INT(11) NOT NULL,
`FLOW_NAME` VARCHAR(200) NOT NULL,
`FLOW_VERSION` DOUBLE NOT NULL,
`NB_REQ_REF_LOOKUP_ID` INT(11) NOT NULL,
PRIMARY KEY (`id`),
INDEX `fk_orchestration_flow_reference__northbound_req_ref_look_idx` (`NB_REQ_REF_LOOKUP_ID` ASC),
UNIQUE INDEX `UK_orchestration_flow_reference` (`COMPOSITE_ACTION` ASC, `FLOW_NAME` ASC, `SEQ_NO` ASC, `NB_REQ_REF_LOOKUP_ID` ASC),
CONSTRAINT `fk_orchestration_flow_reference__northbound_request_ref_look1` 
FOREIGN KEY (`NB_REQ_REF_LOOKUP_ID`) REFERENCES `northbound_request_ref_lookup` (`id`) 
ON DELETE CASCADE ON UPDATE CASCADE)
ENGINE = InnoDB DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS vnfc_customization (
`MODEL_CUSTOMIZATION_UUID` VARCHAR(200) NOT NULL,
`MODEL_INSTANCE_NAME` VARCHAR(200) NOT NULL,
`MODEL_UUID` VARCHAR(200) NOT NULL,
`MODEL_INVARIANT_UUID` VARCHAR(200) NOT NULL,
`MODEL_VERSION` VARCHAR(20) NOT NULL,
`MODEL_NAME` VARCHAR(200) NOT NULL,
`TOSCA_NODE_TYPE` VARCHAR(200) NOT NULL,
`DESCRIPTION` VARCHAR(1200) NULL DEFAULT NULL,
`CREATION_TIMESTAMP` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`MODEL_CUSTOMIZATION_UUID`))
ENGINE = InnoDB
AUTO_INCREMENT = 20654
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS cvnfc_customization (
`ID` INT(11) NOT NULL AUTO_INCREMENT,
`MODEL_CUSTOMIZATION_UUID` VARCHAR(200) NOT NULL,
`MODEL_INSTANCE_NAME` VARCHAR(200) NOT NULL,
`MODEL_UUID` VARCHAR(200) NOT NULL,
`MODEL_INVARIANT_UUID` VARCHAR(200) NOT NULL,
`MODEL_VERSION` VARCHAR(20) NOT NULL,
`MODEL_NAME` VARCHAR(200) NOT NULL,
`TOSCA_NODE_TYPE` VARCHAR(200) NOT NULL,
`DESCRIPTION` VARCHAR(1200) NULL DEFAULT NULL,
`NFC_FUNCTION` VARCHAR(200) NULL,
`NFC_NAMING_CODE` VARCHAR(200) NULL,
`CREATION_TIMESTAMP` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
`VNF_RESOURCE_CUST_MODEL_CUSTOMIZATION_UUID` VARCHAR(200) NOT NULL,
`VF_MODULE_CUST_MODEL_CUSTOMIZATION_UUID` VARCHAR(200) NOT NULL,
`VNFC_CUST_MODEL_CUSTOMIZATION_UUID` VARCHAR(200) NOT NULL, PRIMARY KEY (`ID`), INDEX `fk_cvnfc_customization__vf_module_customization1_idx` (`VF_MODULE_CUST_MODEL_CUSTOMIZATION_UUID` ASC), INDEX `fk_cvnfc_customization__vnfc_customization1_idx` (`VNFC_CUST_MODEL_CUSTOMIZATION_UUID` ASC), INDEX `fk_cvnfc_customization__vnf_resource_customization1_idx` (`VNF_RESOURCE_CUST_MODEL_CUSTOMIZATION_UUID` ASC), UNIQUE INDEX `UK_cvnfc_customization` (`VNF_RESOURCE_CUST_MODEL_CUSTOMIZATION_UUID` ASC, `VF_MODULE_CUST_MODEL_CUSTOMIZATION_UUID` ASC, `MODEL_CUSTOMIZATION_UUID` ASC), INDEX `fk_cvnfc_customization__vnf_vfmod_cvnfc_config_cust1_idx` (`MODEL_CUSTOMIZATION_UUID` ASC), CONSTRAINT `fk_cvnfc_customization__vf_module_customization1` FOREIGN KEY (`VF_MODULE_CUST_MODEL_CUSTOMIZATION_UUID`) REFERENCES `vf_module_customization` (`MODEL_CUSTOMIZATION_UUID`) ON
DELETE CASCADE ON
UPDATE CASCADE, CONSTRAINT `fk_cvnfc_customization__vnfc_customization1` FOREIGN KEY (`VNFC_CUST_MODEL_CUSTOMIZATION_UUID`) REFERENCES `vnfc_customization` (`MODEL_CUSTOMIZATION_UUID`) ON
DELETE CASCADE ON
UPDATE CASCADE, CONSTRAINT `fk_cvnfc_customization__vnf_resource_customization1` FOREIGN KEY (`VNF_RESOURCE_CUST_MODEL_CUSTOMIZATION_UUID`) REFERENCES `vnf_resource_customization` (`MODEL_CUSTOMIZATION_UUID`) ON
DELETE CASCADE ON
UPDATE CASCADE) ENGINE = InnoDB AUTO_INCREMENT = 20654 DEFAULT CHARACTER SET = latin1;


CREATE TABLE IF NOT EXISTS vnf_vfmodule_cvnfc_configuration_customization (
    `ID` INT(11) NOT NULL AUTO_INCREMENT,
    `MODEL_CUSTOMIZATION_UUID` VARCHAR(200) NOT NULL,
    `VNF_RESOURCE_CUST_MODEL_CUSTOMIZATION_UUID` VARCHAR(200) NOT NULL,
    `VF_MODULE_MODEL_CUSTOMIZATION_UUID` VARCHAR(200) NOT NULL,
    `CVNFC_MODEL_CUSTOMIZATION_UUID` VARCHAR(200) NOT NULL,
    `MODEL_INSTANCE_NAME` VARCHAR(200) NOT NULL,
    `CONFIGURATION_TYPE` VARCHAR(200) NULL,
    `CONFIGURATION_ROLE` VARCHAR(200) NULL,
    `CONFIGURATION_FUNCTION` VARCHAR(200) NULL,
    `POLICY_NAME` VARCHAR(200) NULL,
    `CREATION_TIMESTAMP` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `CONFIGURATION_MODEL_UUID` VARCHAR(200) NOT NULL,
    PRIMARY KEY (`ID`),
    INDEX `fk_vnf_vfmodule_cvnfc_config_cust__configuration_idx` (`CONFIGURATION_MODEL_UUID` ASC),
    UNIQUE INDEX `UK_vnf_vfmodule_cvnfc_configuration_customization` (`VNF_RESOURCE_CUST_MODEL_CUSTOMIZATION_UUID` ASC , `VF_MODULE_MODEL_CUSTOMIZATION_UUID` ASC , `CVNFC_MODEL_CUSTOMIZATION_UUID` ASC , `MODEL_CUSTOMIZATION_UUID` ASC),
    INDEX `fk_vnf_vfmodule_cvnfc_config_cust__cvnfc_cust1_idx` (`CVNFC_MODEL_CUSTOMIZATION_UUID` ASC),
    INDEX `fk_vnf_vfmodule_cvnfc_config_cust__vf_module_cust_idx` (`VF_MODULE_MODEL_CUSTOMIZATION_UUID` ASC),
    INDEX `fk_vnf_vfmodule_cvnfc_config_cust__vnf_res_cust_idx` (`VNF_RESOURCE_CUST_MODEL_CUSTOMIZATION_UUID` ASC),
    CONSTRAINT `fk_vnf_vfmod_cvnfc_config_cust__configuration_resource` FOREIGN KEY (`CONFIGURATION_MODEL_UUID`)
        REFERENCES `configuration` (`MODEL_UUID`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_cvnfc_configuration_customization__cvnfc_customization1` FOREIGN KEY (`CVNFC_MODEL_CUSTOMIZATION_UUID`)
        REFERENCES `cvnfc_customization` (`MODEL_CUSTOMIZATION_UUID`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_vnf_configuration_cvnfc_customization__vf_module_customiza1` FOREIGN KEY (`VF_MODULE_MODEL_CUSTOMIZATION_UUID`)
        REFERENCES `vf_module_customization` (`MODEL_CUSTOMIZATION_UUID`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_vfmodule_cvnfc_configuration_customization__vnf_resource_c1` FOREIGN KEY (`VNF_RESOURCE_CUST_MODEL_CUSTOMIZATION_UUID`)
        REFERENCES `vnf_resource_customization` (`MODEL_CUSTOMIZATION_UUID`)
        ON DELETE CASCADE ON UPDATE CASCADE
)  ENGINE=INNODB AUTO_INCREMENT=20654 DEFAULT CHARACTER SET=LATIN1;

--------START Request DB SCHEMA --------
CREATE DATABASE requestdb;
USE requestdb;


CREATE TABLE `active_requests` (
  `REQUEST_ID` varchar(45) NOT NULL,
  `CLIENT_REQUEST_ID` varchar(45) DEFAULT NULL,
  `SERVICE_INSTANCE_ID` varchar(50) NOT NULL,
  `SUBSCRIBER_NAME` varchar(200) DEFAULT NULL,
  `REQUEST_URI` varchar(255) DEFAULT NULL,
  `SERVICE_TYPE` varchar(65) NOT NULL,
  `REQUEST_ACTION` varchar(45) NOT NULL,
  `NOTIFICATION_URL` varchar(255) DEFAULT NULL,
  `REQUEST_ID_IN_PROGRESS` varchar(45) DEFAULT NULL,
  `START_TIME` datetime DEFAULT NULL,
  `MODIFY_TIME` datetime DEFAULT NULL,
  `COMPLETION_TIME` datetime DEFAULT NULL,
  `RESPONSE_CODE` varchar(20) DEFAULT NULL,
  `RESPONSE_BODY` longtext,
  `STATUS` varchar(25) DEFAULT NULL,
  `SERVICE_REQUEST_TIMEOUT` datetime DEFAULT NULL,
  `FINAL_ERROR_CODE` varchar(20) DEFAULT NULL,
  `FINAL_ERROR_MESSAGE` varchar(2000) DEFAULT NULL,
  `ORDER_NUMBER` varchar(45) DEFAULT NULL,
  `SOURCE` varchar(20) DEFAULT NULL,
  `RESPONSE_STATUS` varchar(25) DEFAULT NULL,
  `ORDER_VERSION` varchar(20) DEFAULT NULL,
  `LAST_MODIFIED_BY` varchar(20) DEFAULT NULL,
  `MOCARS_TICKET_NUM` varchar(200) DEFAULT NULL,
  `REQUEST_BODY` longtext,
  `REQUEST_SUB_ACTION` varchar(45) DEFAULT NULL,
  `SDNC_CALLBACK_BPEL_URL` varchar(255) DEFAULT NULL,
  `FEATURE_TYPE` varchar(255) DEFAULT NULL,
  `FEATURE_INSTANCE_ID` varchar(255) DEFAULT NULL,
  `REQUEST_TYPE` varchar(255) DEFAULT NULL,
  `INTERIM_COMPLETION_TIME` datetime DEFAULT NULL,
  `INTERIM_STAGE_COMPLETION` int(11) DEFAULT NULL,
  `SERVICE_NAME_VERSION_ID` varchar(50) DEFAULT NULL,
  `GLOBAL_SUBSCRIBER_ID` varchar(255) DEFAULT NULL,
  `SERVICE_ID` varchar(50) DEFAULT NULL,
  `SERVICE_VERSION` varchar(10) DEFAULT NULL,
  `CORRELATOR` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`REQUEST_ID`),
  UNIQUE KEY `UK_f0hdk7xbw5mb2trnxx0fvlh3x` (`CLIENT_REQUEST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `infra_active_requests` (
  `REQUEST_ID` varchar(45) NOT NULL,
  `CLIENT_REQUEST_ID` varchar(45) DEFAULT NULL,
  `ACTION` varchar(45) DEFAULT NULL,
  `REQUEST_STATUS` varchar(20) DEFAULT NULL,
  `STATUS_MESSAGE` longtext DEFAULT NULL,
  `PROGRESS` bigint(20) DEFAULT NULL,
  `START_TIME` datetime DEFAULT NULL,
  `END_TIME` datetime DEFAULT NULL,
  `SOURCE` varchar(45) DEFAULT NULL,
  `VNF_ID` varchar(45) DEFAULT NULL,
  `VNF_NAME` varchar(80) DEFAULT NULL,
  `VNF_TYPE` varchar(200) DEFAULT NULL,
  `SERVICE_TYPE` varchar(45) DEFAULT NULL,
  `AIC_NODE_CLLI` varchar(11) DEFAULT NULL,
  `TENANT_ID` varchar(45) DEFAULT NULL,
  `PROV_STATUS` varchar(20) DEFAULT NULL,
  `VNF_PARAMS` longtext,
  `VNF_OUTPUTS` longtext,
  `REQUEST_BODY` longtext,
  `RESPONSE_BODY` longtext,
  `LAST_MODIFIED_BY` varchar(100) DEFAULT NULL,
  `MODIFY_TIME` datetime DEFAULT NULL,
  `REQUEST_TYPE` varchar(20) DEFAULT NULL,
  `VOLUME_GROUP_ID` varchar(45) DEFAULT NULL,
  `VOLUME_GROUP_NAME` varchar(45) DEFAULT NULL,
  `VF_MODULE_ID` varchar(45) DEFAULT NULL,
  `VF_MODULE_NAME` varchar(200) DEFAULT NULL,
  `VF_MODULE_MODEL_NAME` varchar(200) DEFAULT NULL,
  `AAI_SERVICE_ID` varchar(50) DEFAULT NULL,
  `AIC_CLOUD_REGION` varchar(11) DEFAULT NULL,
  `CALLBACK_URL` varchar(200) DEFAULT NULL,
  `CORRELATOR` varchar(80) DEFAULT NULL,
  `NETWORK_ID` varchar(45) DEFAULT NULL,
  `NETWORK_NAME` varchar(80) DEFAULT NULL,
  `NETWORK_TYPE` varchar(80) DEFAULT NULL,
  `REQUEST_SCOPE` varchar(20) NOT NULL DEFAULT 'unknown',
  `REQUEST_ACTION` varchar(45) NOT NULL DEFAULT 'unknown',
  `SERVICE_INSTANCE_ID` varchar(45) DEFAULT NULL,
  `SERVICE_INSTANCE_NAME` varchar(80) DEFAULT NULL,
  `REQUESTOR_ID` varchar(50) DEFAULT NULL,
  `CONFIGURATION_ID` varchar(45) DEFAULT NULL,
  `CONFIGURATION_NAME` varchar(200) DEFAULT NULL,
  `OPERATIONAL_ENV_ID` varchar(45) DEFAULT NULL,
  `OPERATIONAL_ENV_NAME` varchar(200) DEFAULT NULL,
  `REQUEST_URL` varchar(500) DEFAULT NULL,  
  PRIMARY KEY (`REQUEST_ID`),
  UNIQUE KEY `UK_bhu6w8p7wvur4pin0gjw2d5ak` (`CLIENT_REQUEST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `archived_infra_requests` (
  `REQUEST_ID` varchar(45) NOT NULL,
  `CLIENT_REQUEST_ID` varchar(45) DEFAULT NULL,
  `ACTION` varchar(45) DEFAULT NULL,
  `REQUEST_STATUS` varchar(20) DEFAULT NULL,
  `STATUS_MESSAGE` longtext DEFAULT NULL,
  `PROGRESS` bigint(20) DEFAULT NULL,
  `START_TIME` datetime DEFAULT NULL,
  `END_TIME` datetime DEFAULT NULL,
  `SOURCE` varchar(45) DEFAULT NULL,
  `VNF_ID` varchar(45) DEFAULT NULL,
  `VNF_NAME` varchar(80) DEFAULT NULL,
  `VNF_TYPE` varchar(200) DEFAULT NULL,
  `SERVICE_TYPE` varchar(45) DEFAULT NULL,
  `AIC_NODE_CLLI` varchar(11) DEFAULT NULL,
  `TENANT_ID` varchar(45) DEFAULT NULL,
  `PROV_STATUS` varchar(20) DEFAULT NULL,
  `VNF_PARAMS` longtext,
  `VNF_OUTPUTS` longtext,
  `REQUEST_BODY` longtext,
  `RESPONSE_BODY` longtext,
  `LAST_MODIFIED_BY` varchar(100) DEFAULT NULL,
  `MODIFY_TIME` datetime DEFAULT NULL,
  `REQUEST_TYPE` varchar(20) DEFAULT NULL,
  `VOLUME_GROUP_ID` varchar(45) DEFAULT NULL,
  `VOLUME_GROUP_NAME` varchar(45) DEFAULT NULL,
  `VF_MODULE_ID` varchar(45) DEFAULT NULL,
  `VF_MODULE_NAME` varchar(200) DEFAULT NULL,
  `VF_MODULE_MODEL_NAME` varchar(200) DEFAULT NULL,
  `AAI_SERVICE_ID` varchar(50) DEFAULT NULL,
  `AIC_CLOUD_REGION` varchar(11) DEFAULT NULL,
  `CALLBACK_URL` varchar(200) DEFAULT NULL,
  `CORRELATOR` varchar(80) DEFAULT NULL,
  `NETWORK_ID` varchar(45) DEFAULT NULL,
  `NETWORK_NAME` varchar(80) DEFAULT NULL,
  `NETWORK_TYPE` varchar(80) DEFAULT NULL,
  `REQUEST_SCOPE` varchar(20) NOT NULL DEFAULT 'unknown',
  `REQUEST_ACTION` varchar(45) NOT NULL DEFAULT 'unknown',
  `SERVICE_INSTANCE_ID` varchar(45) DEFAULT NULL,
  `SERVICE_INSTANCE_NAME` varchar(80) DEFAULT NULL,
  `REQUESTOR_ID` varchar(50) DEFAULT NULL,
  `CONFIGURATION_ID` varchar(45) DEFAULT NULL,
  `CONFIGURATION_NAME` varchar(200) DEFAULT NULL,
  `OPERATIONAL_ENV_ID` varchar(45) DEFAULT NULL,
  `OPERATIONAL_ENV_NAME` varchar(200) DEFAULT NULL,
  `REQUEST_URL` varchar(500) DEFAULT NULL,  
  PRIMARY KEY (`REQUEST_ID`),
  UNIQUE KEY `UK_bhu6w8p7wvur4pin0gjw2d72h` (`CLIENT_REQUEST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `site_status` (
  `SITE_NAME` varchar(255) NOT NULL,
  `STATUS` bit(1) DEFAULT NULL,
  `CREATION_TIMESTAMP` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`SITE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `watchdog_distributionid_status` (
  `DISTRIBUTION_ID` varchar(45) NOT NULL,
  `DISTRIBUTION_ID_STATUS` varchar(45) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `MODIFY_TIME` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`DISTRIBUTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `watchdog_per_component_distribution_status` (
  `DISTRIBUTION_ID` varchar(45) NOT NULL,
  `COMPONENT_NAME` varchar(45) NOT NULL,
  `COMPONENT_DISTRIBUTION_STATUS` varchar(45) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `MODIFY_TIME` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`DISTRIBUTION_ID`,`COMPONENT_NAME`),
  CONSTRAINT `fk_watchdog_component_distribution_status_watchdog_distributi1` FOREIGN KEY (`DISTRIBUTION_ID`) REFERENCES `watchdog_distributionid_status` (`DISTRIBUTION_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `watchdog_service_mod_ver_id_lookup` (
  `DISTRIBUTION_ID` varchar(45) NOT NULL,
  `SERVICE_MODEL_VERSION_ID` varchar(45) NOT NULL,
  `CREATE_TIME` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `MODIFY_TIME` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`DISTRIBUTION_ID`,`SERVICE_MODEL_VERSION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `activate_operational_env_service_model_distribution_status` (
  `OPERATIONAL_ENV_ID` varchar(45) NOT NULL,
  `SERVICE_MODEL_VERSION_ID` varchar(45) NOT NULL,
  `REQUEST_ID` varchar(45) NOT NULL,
  `SERVICE_MOD_VER_FINAL_DISTR_STATUS` varchar(45) DEFAULT NULL,
  `RECOVERY_ACTION` varchar(30) DEFAULT NULL,
  `RETRY_COUNT_LEFT` int(11) DEFAULT NULL,
  `WORKLOAD_CONTEXT` varchar(80) NOT NULL,
  `CREATE_TIME` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `MODIFY_TIME` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`OPERATIONAL_ENV_ID`,`SERVICE_MODEL_VERSION_ID`,`REQUEST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `activate_operational_env_per_distributionid_status` (
  `DISTRIBUTION_ID` varchar(45) NOT NULL,
  `DISTRIBUTION_ID_STATUS` varchar(45) DEFAULT NULL,
  `DISTRIBUTION_ID_ERROR_REASON` varchar(250) DEFAULT NULL,
  `CREATE_TIME` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `MODIFY_TIME` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `OPERATIONAL_ENV_ID` varchar(45) NOT NULL,
  `SERVICE_MODEL_VERSION_ID` varchar(45) NOT NULL,
  `REQUEST_ID` varchar(45) NOT NULL,
  PRIMARY KEY (`DISTRIBUTION_ID`),
  KEY `fk_activate_op_env_per_distributionid_status__aoesmds1_idx` (`OPERATIONAL_ENV_ID`,`SERVICE_MODEL_VERSION_ID`,`REQUEST_ID`),
  CONSTRAINT `fk_activate_op_env_per_distributionid_status__aoesmds1` FOREIGN KEY (`OPERATIONAL_ENV_ID`, `SERVICE_MODEL_VERSION_ID`, `REQUEST_ID`) REFERENCES `activate_operational_env_service_model_distribution_status` (`OPERATIONAL_ENV_ID`, `SERVICE_MODEL_VERSION_ID`, `REQUEST_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table operation_status (
  SERVICE_ID varchar(255) not null,
  OPERATION_ID varchar(255) not null,
  SERVICE_NAME varchar(255),
  OPERATION_TYPE varchar(255),
  USER_ID varchar(255),
  RESULT varchar(255),
  OPERATION_CONTENT varchar(255),
  PROGRESS varchar(255),
  REASON varchar(255),
  OPERATE_AT datetime NOT NULL,
  FINISHED_AT datetime NOT NULL,
  primary key (SERVICE_ID,OPERATION_ID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
    
create table resource_operation_status (
  SERVICE_ID varchar(255) not null,
  OPERATION_ID varchar(255) not null,
  RESOURCE_TEMPLATE_UUID varchar(255) not null,
  OPER_TYPE varchar(255),
  RESOURCE_INSTANCE_ID varchar(255),
  JOB_ID varchar(255),
  STATUS varchar(255),
  PROGRESS varchar(255),
  ERROR_CODE varchar(255) ,
  STATUS_DESCRIPOTION varchar(255) ,
  primary key (SERVICE_ID,OPERATION_ID,RESOURCE_TEMPLATE_UUID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table if not exists model_recipe (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`MODEL_ID` INT(11),
	`ACTION` VARCHAR(40),
	`SCHEMA_VERSION` VARCHAR(40),
	`DESCRIPTION` VARCHAR(40),
	`ORCHESTRATION_URI` VARCHAR(20),
	`MODEL_PARAM_XSD` VARCHAR(20),
	`RECIPE_TIMEOUT` INT(11),
	`CREATION_TIMESTAMP` datetime not null default current_timestamp,
	PRIMARY KEY (`ID`),
	CONSTRAINT uk1_model_recipe UNIQUE (`MODEL_ID`, `ACTION`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table if not exists model (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`MODEL_CUSTOMIZATION_ID` VARCHAR(40),
	`MODEL_CUSTOMIZATION_NAME` VARCHAR(40),
	`MODEL_INVARIANT_ID` VARCHAR(40),
	`MODEL_NAME` VARCHAR(40),
	`MODEL_TYPE` VARCHAR(20),
	`MODEL_VERSION` VARCHAR(20),
	`MODEL_VERSION_ID` VARCHAR(40),
	`CREATION_TIMESTAMP` datetime not null default current_timestamp,
	`RECIPE` INT(11),
	PRIMARY KEY (`ID`),
	CONSTRAINT uk1_model UNIQUE (`MODEL_TYPE`, `MODEL_VERSION_ID`),
	FOREIGN KEY (`RECIPE`) REFERENCES `model_recipe` (`MODEL_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `catalogdb`.`vnf_recipe` 
CHANGE COLUMN `VNF_TYPE` `NF_ROLE` VARCHAR(200) NULL DEFAULT NULL ;
