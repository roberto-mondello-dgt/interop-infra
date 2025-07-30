
variable "data_source_arn" {
  description = "Arn of the QuickSight datasource, the object containing connection metadata"
  type        = string
}

variable "database_name" {
  description = "The datasource's database name, used for tagging"
  type        = string
}

variable "view_name" {
  description = "Name of the view wrapped by this dataset "
  type        = string
}

variable "columns" {
  description = "List view's columns, it is also possible to define some computed column. The ./scripts/quicksight_dataset_export_from_aws.sh script can help to extract this configuration from quicksight."
  type = list(
    object({
      name = string
      type = string
      computed = optional(
        object({
          expression = string
        })
      )
    })
  )
}

variable "data_set_permissions" {
  description = "Dashboard permissions see ../../10-locals-permissions-constants.tf locals for some preconfigured permissions"
  type = list(
    object({
      principal = string
      actions   = list(string)
    })
  )
}

