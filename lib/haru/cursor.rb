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
        col.insert_data(tuple_ptr, v)
      end
      check_return_code(PureHailDB.ib_cursor_insert_row(@cursor_ptr.read_pointer, tuple_ptr))
      PureHailDB.ib_tuple_delete(tuple_ptr)
    end

    def read_row()
      tuple_ptr = PureHailDB.ib_clust_read_tuple_create(@cursor_ptr.read_pointer())
      check_return_code(PureHailDB.ib_cursor_read_row(@cursor_ptr.read_pointer(), tuple_ptr))
      cols = @table.columns
      row = {}
      cols.each_pair do |k,v|
        row[k] = v.get_data(tuple_ptr)
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
