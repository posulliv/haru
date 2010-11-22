require 'haru/ffihaildb'

module Haru

  class Cursor

    INTENTION_EXCLUSIVE_LOCK = 1
    SHARED_LOCK = 2
    EXCLUSIVE_LOCK = 3

    attr_accessor :cursor_ptr

    def initialize(crs_ptr)
      @cursor_ptr = crs_ptr
    end

    def lock(lock_type = INTENTION_EXCLUSIVE_LOCK)
      check_return_code(PureHailDB.ib_cursor_lock(@cursor_ptr.read_pointer(), PureHailDB::LockMode[lock_type]))
    end

    def close()
      check_return_code(PureHailDB.ib_cursor_close(@cursor_ptr.read_pointer()))
    end

  end

end
