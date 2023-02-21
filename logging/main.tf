
resource "oci_logging_log_group" "test_log_group" {
    #Required
    compartment_id = var.compartment_id
    display_name = var.log_group_display_name

    #Optional
    description = var.log_group_description
}

resource "oci_logging_log" "test_flow_log" {
    #Required
    display_name = var.vcn_flow_log_name
    log_group_id = oci_logging_log_group.test_log_group.id
    log_type = "SERVICE"
    configuration {
        #Required
        source {
            #Required
            category = "all"
            resource = var.vcn_subnet_id
            service = "flowlogs"
            source_type = "OCISERVICE"
        }
    }
    is_enabled = true
    retention_duration = 30
}

resource "oci_log_analytics_log_analytics_log_group" "test_log_analytics_log_group" {
    #Required
    compartment_id = var.compartment_id
    display_name = "testing_target_log_group"
    namespace = var.namespace_name

    #Optional
    description = "This the targetGroup that we need to forward our logs."
}

resource "oci_sch_service_connector" "test_service_connector" {
    #Required
    compartment_id = var.compartment_id
    display_name = var.service_connector_display_name
    source {
        #Required
        kind = "logging"
        log_sources {
          compartment_id = var.compartment_id
	  log_group_id =  oci_logging_log_group.test_log_group.id
	  log_id =  oci_logging_log.test_flow_log.id
	}
    }
   target {
   	#Required
        kind = "loggingAnalytics"
        log_group_id = oci_log_analytics_log_analytics_log_group.test_log_analytics_log_group.id
   }
}

output "source_log_group" {
  value = oci_logging_log_group.test_log_group.display_name
}

output "target_log_group" {
  value = oci_log_analytics_log_analytics_log_group.test_log_analytics_log_group.display_name
}
