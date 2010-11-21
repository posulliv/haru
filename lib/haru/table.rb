require 'haru/ffihaildb'

module Haru

  class Table

    def initialize(db_name, table_name, page_size = 0)
      @name = db_name + "/" + table_name
      @schema_ptr = FFI::MemoryPointer.new :pointer
      check_return_code(PureHailDB.ib_table_schema_create(@name, @schema_ptr, PureHailDB::TableFormat[:IB_TBL_COMPACT], page_size))
    end

    def add_column(col_name, col_type, col_attrs)
      check_return_code(PureHailDB.ib_table_schema_add_col(@schema_ptr,
                                                           col_name,
                                                           col_type,
                                                           col_attrs,
                                                           0,
                                                           sizeof_col_type))
    end

    def add_index()
      @idx_ptr = FFI::MemoryPointer.new :pointer
      check_return_code(PureHailDB.ib_table_schema_add_index(@schemaPtr, "PRIMARY", @idx_ptr))
    end

    def add_index_column(col_name)
      check_return_code(PureHailDB.ib_index_schema_add_col(@idx_ptr, col_name, 0))
      check_return_code(PureHailDB.ib_index_schema_set_clustered(@idx_ptr))
    end

  end

end
