require 'haru/ffihaildb'

module Haru

  class Cursor

    INTENTION_EXCLUSIVE_LOCK = 1
    SHARED_LOCK = 2
    EXCLUSIVE_LOCK = 3

    attr_accessor :cursor_ptr

    def initialize(crs_ptr, input_table)
      @cursor_ptr = crs_ptr
      @table = input_table
    end

    def lock(lock_type = INTENTION_EXCLUSIVE_LOCK)
      check_return_code(PureHailDB.ib_cursor_lock(@cursor_ptr.read_pointer(), PureHailDB::LockMode[lock_type]))
    end

    def close()
      check_return_code(PureHailDB.ib_cursor_close(@cursor_ptr.read_pointer()))
    end

    def insert_row(row)
      tuple_ptr = PureHailDB.ib_clust_read_tuple_create(@cursor_ptr.read_pointer())
      row.each_pair do |k,v|
        col = @table.column(k)
        size = 0
        if col.type == INT
          size = 4
        else 
          size = v.size
        end
        p = FFI::MemoryPointer.new(col.raw_type, v)
        check_return_code(PureHailDB.ib_col_set_value(tuple_ptr,
                                                      col.num,
                                                      p,
                                                      size))

      end
      PureHailDB.ib_tuple_delete(tuple_ptr)
    end

  end

end
