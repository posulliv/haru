require 'haru/ffihaildb'

module Haru

  class Column

    attr_accessor :num
    attr_accessor :name
    attr_accessor :type

    def initialize(col_name, col_type, col_attrs, col_size, col_num)
      @name = col_name
      @type = col_type
      @attrs = col_attrs
      @size = col_size
      @num = col_num
    end

    def raw_type()
      if @type == INT
        :int
      elsif @type == VARCHAR
        :string
      end
    end

    def insert_data(tuple_ptr, data)
      case @type
      when INT
        check_return_code(PureHailDB.ib_tuple_write_u32(tuple_ptr, 
                                                        @num,
                                                        data))
      when VARCHAR
        p = FFI::MemoryPointer.from_string(data)
        check_return_code(PureHailDB.ib_col_set_value(tuple_ptr,
                                                      @num,
                                                      p,
                                                      @size))
      end
    end

    def get_data(tuple_ptr)
      case @type
      when INT
        res_ptr = FFI::MemoryPointer.new :uint32
        check_return_code(PureHailDB.ib_tuple_read_u32(tuple_ptr, @num, res_ptr))
        res_ptr.read_int()
      when VARCHAR
        res_ptr = PureHailDB.ib_col_get_value(tuple_ptr, @num)
        res_ptr.read_string()
      end
    end

  end

  class Table

    attr_accessor :name
    attr_accessor :schema_ptr
    attr_accessor :columns

    def initialize(db_name, table_name, page_size = 0)
      @name = db_name + "/" + table_name
      @schema_ptr = FFI::MemoryPointer.new :pointer
      @columns = {}
      check_return_code(PureHailDB.ib_table_schema_create(@name, @schema_ptr, PureHailDB::TableFormat[:IB_TBL_COMPACT], page_size))
    end

    def add_column(col_name, col_type, col_attrs, col_size)
      c = Column.new(col_name, col_type, col_attrs, col_size, @columns.size)
      @columns[col_name] = c
      check_return_code(PureHailDB.ib_table_schema_add_col(@schema_ptr.read_pointer(),
                                                           col_name,
                                                           PureHailDB::ColumnType[col_type],
                                                           PureHailDB::ColumnAttr[col_attrs],
                                                           0,
                                                           col_size))
    end

    def add_index()
      @idx_ptr = FFI::MemoryPointer.new :pointer
      check_return_code(PureHailDB.ib_table_schema_add_index(@schema_ptr.read_pointer(), "PRIMARY", @idx_ptr))
    end

    def add_index_column(col_name)
      check_return_code(PureHailDB.ib_index_schema_add_col(@idx_ptr.read_pointer(), col_name, 0))
      check_return_code(PureHailDB.ib_index_schema_set_clustered(@idx_ptr.read_pointer()))
    end

    def column(col_name)
      @columns[col_name]
    end

  end

end
