require 'active_record'

module MigrationHelper

  def foreign_key(from_table, from_column, to_table)
    execute %(alter table #{from_table}
              add constraint #{constraint_name(from_table, from_column)}
              foreign key (#{from_column})
              references #{to_table}(id))
  end

  def drop_foreign_key(from_table, from_column)
    execute %(alter table #{from_table}
              drop foreign key #{constraint_name(from_table, from_column)})
  end

  def constraint_name(table, column)
    "fk_#{table}_#{column}"
  end

end

ActiveRecord::Migration.extend(MigrationHelper)
