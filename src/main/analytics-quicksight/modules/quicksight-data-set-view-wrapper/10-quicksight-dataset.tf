
resource "aws_quicksight_data_set" "data_set" {

  data_set_id = format("%s-views-%s", var.database_name, var.view_name)
  import_mode = "DIRECT_QUERY"
  name        = format("%s (%s)", var.view_name, var.database_name)

  data_set_usage_configuration {
    disable_use_as_direct_query_source = false
    disable_use_as_imported_source     = false
  }

  physical_table_map {
    physical_table_map_id = replace(
      replace(
        title(format("%s-%s", var.database_name, var.view_name)),
        "_", ""
      ),
      "-", ""
    )

    relational_table {
      data_source_arn = var.data_source_arn
      schema          = "views"
      name            = var.view_name

      dynamic "input_columns" {
        for_each = [for c in var.columns : c if try(c.computed == null, true)]

        content {
          name = input_columns.value.name
          type = input_columns.value.type
        }
      }
    }
  }

  logical_table_map {
    logical_table_map_id = replace(
      replace(
        title(format("%s-%s-LTM", var.database_name, var.view_name)),
        "_", ""
      ),
      "-", ""
    )
    alias = substr(format("%s.views.%s", var.database_name, var.view_name), 0, 64)

    # In case of multiple computed columns this code block add multiple transformations.
    # To have only one transformation with multiple columns nested dynamic blocks are required; 
    #  empty columns array isn't allowed.
    # I choose simplicity over quicksight configuration perfection.
    # N.B.: computed columns could be defined into view and/or dashboards also.
    dynamic "data_transforms" {
      for_each = [for c in var.columns : c if try(c.computed, null) == null ? false : true]

      content {
        create_columns_operation {
          columns {
            column_name = data_transforms.value.name
            column_id   = data_transforms.value.name
            expression  = data_transforms.value.computed.expression
          }
        }
      }
    }

    # Project all columns
    data_transforms {
      project_operation {
        projected_columns = [for c in var.columns : c.name]
      }
    }
    source {
      physical_table_id = replace(
        replace(
          title(format("%s-%s", var.database_name, var.view_name)),
          "_", ""
        ),
        "-", ""
      )
    }
  }

  tags = {
    DatabaseName = var.database_name
  }

  dynamic "permissions" {
    for_each = var.data_set_permissions

    content {
      principal = permissions.value.principal
      actions   = permissions.value.actions
    }
  }

}

