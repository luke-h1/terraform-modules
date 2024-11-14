variable "name" {
  type        = string
  description = "Name of the database"
}

variable "env" {
  type        = string
  description = "The environment to deploy to"
}

variable "db_type" {
  type = string
  validation {
    condition     = contains(["rds", "aurora", "serverless"], var.db_type)
    error_message = "Invalid database type"
  }
}

variable "iam_database_authentication_enable" {
  type        = bool
  default     = false
  description = "Whether to enable IAM database authentication"
}

variable "allow_security_group_ids" {
  type = list(object({
    security_group_id = string
    description       = string
    name              = string
  }))
  description = "List of security group IDs to allow connections to the database"
  default     = []
}

variable "allow_security_group_ids_replica" {
  type = list(object({
    security_group_id = string
    description       = string
    name              = string
  }))
  description = "List of security group IDs to allow connections to the read-replica"
  default     = []
}

variable "allow_cidrs" {
  type        = list(string)
  default     = []
  description = "List of CIDRs to allow connections to this DB"
}

variable "allow_cidrs_replica" {
  type        = list(string)
  default     = []
  description = "List of CIDRs to allow connections to the read-replica"
}

variable "user" {
  type        = string
  description = "The DB user"
}

variable "retention" {
  type        = string
  description = "The snapshot retention period in days"
}

variable "instance_class" {
  type        = string
  description = "The instance class to use. see https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html"
}


variable "engine" {
  type        = string
  description = "The database engine to use"
}

variable "engine_version" {
  type        = string
  description = "The database engine version to use"
}

variable "port" {
  type        = number
  description = "Port number of the database"
}

variable "apply_immediately" {
  type        = bool
  default     = true
  description = "Whether to apply changes immediately or wait for the maintenance window"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Skips the final snapshot if the database is destroyed programatically"
}

variable "snapshot_identifier" {
  type        = string
  description = "Pass a snapshot identifier for the database to be created from this snapshot"
}

variable "final_snapshot_identifier" {
  type        = string
  description = "Pass the final snapshot identifier for the final snapshot to be created after the database is destroyed."
}


variable "identifier" {
  type        = string
  description = "Optional identifier for DB. If not passed, {environment_name}-{name} will be used"
}

variable "database_name" {
  description = "Database Name"
  type        = string
}

variable "storage_type" {
  type        = string
  description = "The instance storage type"
  default     = "gp2"
}

variable "iops" {
  type        = number
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of io1"
  default     = null
}

variable "allocated_storage" {
  type        = number
  description = "Storage size in GB"
  default     = null
}

variable "storage_encrypted" {
  type        = bool
  description = "Enables storage encryption"
  default     = true
}

variable "kms_key_arn" {
  type        = string
  default     = ""
  description = "KMS Key ARN to use a CMK instead of default shared key, when storage_encrypted is true"
}

variable "ssm_kms_key_id" {
  type        = string
  default     = ""
  description = "KMS Key Id to use a CMK instead of default shared key for SSM parameters"
}

variable "backup" {
  type        = bool
  description = "Enables automatic backup with AWS Backup"
}

variable "vpc_id" {
  type = string
}


variable "create_db_subnet_group" {
  description = "Create a Subnet group?"
  default     = false
}

variable "db_subnet_group_id" {
  description = "RDS Subnet Group Name"
  type        = string
}

variable "db_subnet_group_replica_id" {
  description = "RDS Subnet Group Name"
  type        = string
}

variable "db_subnet_group_subnet_ids" {
  description = "List of Subnet IDs for the RDS Subnet Group"
  default     = []
}

variable "preferred_backup_window" {
  description = "(Aurora Only) The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = "07:00-09:00"
}

variable "count_aurora_instances" {
  description = "The number of Aurora Instances to provision"
  type        = number
  default     = "1"
}


# DB and Cluster parameter group
variable "create_cluster_parameter_group" {
  description = "Whether to create a cluster parameter group"
  type        = bool
  default     = false
}

variable "cluster_parameters" {
  description = "A list of Cluster parameters (map) to apply"
  type        = list(map(string))
  default     = []
}

variable "create_db_parameter_group" {
  description = "Whether to create a database parameter group"
  type        = bool
  default     = false
}

variable "db_parameters" {
  description = "A list of DB parameters (map) to apply"
  type        = list(map(string))
  default     = []
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate or create"
  type        = string
  default     = null
}


variable "parameter_group_description" {
  description = "The description of the DB parameter group"
  type        = string
  default     = "Managed by Terraform"
}

variable "family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = ""
}

# DB option group
variable "create_db_option_group" {
  description = "(Optional) Create a database option group"
  type        = bool
  default     = false
}

variable "option_group_name" {
  description = "Name of the option group"
  type        = string
  default     = null
}

variable "option_group_use_name_prefix" {
  description = "Determines whether to use `option_group_name` as is or create a unique name beginning with the `option_group_name` as the prefix"
  type        = bool
  default     = true
}

variable "option_group_description" {
  description = "The description of the option group"
  type        = string
  default     = "Managed by Terraform"
}

variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = ""
}

variable "options" {
  description = "A list of Options to apply."
  type        = any
  default     = []
}


variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  type        = bool
  default     = false
}

variable "parameter_group_description" {
  description = "The description of the DB parameter group"
  type        = string
}

variable "family" {
  description = "The family of the DB parameter group"
  type        = string
}

# DB option group
variable "create_db_option_group" {
  description = "(Optional) Create a database option group"
  type        = bool
  default     = false
}

variable "option_group_name" {
  description = "Name of the option group"
  type        = string
  default     = null
}

variable "option_group_use_name_prefix" {
  description = "Determines whether to use `option_group_name` as is or create a unique name beginning with the `option_group_name` as the prefix"
  type        = bool
  default     = true
}

variable "option_group_description" {
  description = "The description of the option group"
  type        = string
}

variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = ""
}

variable "options" {
  description = "A list of Options to apply."
  type        = any
  default     = []
}


variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Deploy multi-az instance database"
  type        = bool
  default     = false
}


variable "performance_insights_enabled" {
  description = "Enable performance insights on instance"
  type        = bool
  default     = false
}

variable "max_allocated_storage" {
  type        = number
  description = "Argument higher than the allocated_storage to enable Storage Autoscaling, size in GB. 0 to disable Storage Autoscaling"
  default     = 0
}

variable "secret_method" {
  description = "Use ssm for SSM parameters store which is the default option, or secretsmanager for AWS Secrets Manager"
  type        = string
  default     = "ssm"
}

variable "enabled_cloudwatch_logs_exports" {
  description = "(Optional) Set of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine)"
  default     = null
}

variable "option_name" {
  description = "(Required) The Name of the Option"
  type        = string
}

variable "publicly_accessible" {
  description = "(Optional) Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "publicly_accessible_replica" {
  description = "(Optional) Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "license_model" {
  description = "License model information for this DB instance (Optional, but required for some DB engines, i.e. Oracle SE1 and SQL Server)"
  type        = string
  default     = null
}
variable "monitoring_interval" {
  type        = number
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance"
  default     = 0
}

variable "maintenance_window" {
  type        = string
  description = "(RDS Only) The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  default     = "Sun:04:00-Sun:05:00"
}

variable "backup_window" {
  description = "(RDS Only) The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = "03:00-03:30"
}

variable "preferred_maintenance_window" {
  type        = string
  description = "(Aurora Only) The weekly time range during which system maintenance can occur, in (UTC) e.g., wed:04:00-wed:04:30"
  default     = "Sun:04:00-Sun:05:00"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  default     = true
}

variable "enable_replica" {
  type        = bool
  description = "Enable read replica for RDS"
  default     = false
}

variable "instance_class_replica" {
  type        = string
  description = "Define instance class for read replica"
  default     = null
}

variable "iam_database_authentication_enabled" {
  type    = bool
  default = false
}