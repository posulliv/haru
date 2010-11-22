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
        #p = FFI::MemoryPointer.new(col.raw_type, v)
        p = FFI::MemoryPointer.from_string(v)
        check_return_code(PureHailDB.ib_col_set_value(tuple_ptr,
                                                      col.num,
                                                      p,
                                                      size))

      end
      PureHailDB.ib_tuple_delete(tuple_ptr)
    end

    def read_row()
      tuple_ptr = PureHailDB.ib_clust_read_tuple_create(@cursor_ptr.read_pointer())
      check_return_code(PureHailDB.ib_cursor_read_row(@cursor_ptr.read_pointer(), tuple_ptr))
      cols = @table.columns
      row = {}
      cols.each_pair do |k,v|
        #res_ptr = FFI::MemoryPointer.new(v.raw_type, 32)
        res_ptr = FFI::MemoryPointer.new(:char, 32)
        #res_ptr = PureHailDB.ib_col_get_value(tuple_ptr, v.num)
        PureHailDB.ib_col_copy_value(tuple_ptr, v.num, res_ptr, 32)
        if res_ptr.null?
          next
        end
        if v.type == INT
          row[k] = res_ptr.read_int()
        else
          row[k] = res_ptr.read_string()
        end
      end
      PureHailDB.ib_tuple_delete(tuple_ptr)

      row
    end

    def prev_row()
      check_return_code(PureHailDB.ib_cursor_prev(@cursor_ptr.read_pointer()))
    end

    def next_row()
      check_return_code(PureHailDB.ib_cursor_next(@cursor_ptr.read_pointer()))
    end

    def first_row()
      check_return_code(PureHailDB.ib_cursor_first(@cursor_ptr.read_pointer()))
    end

    def last_row()
      check_return_code(PureHailDB.ib_cursor_last(@cursor_ptr.read_pointer()))
    end

    def reset()
      check_return_code(PureHailDB.ib_cursor_reset(@cursor_ptr.read_pointer()))
    end

    def close()
      check_return_code(PureHailDB.ib_cursor_close(@cursor_ptr.read_pointer()))
    end

  end

end
