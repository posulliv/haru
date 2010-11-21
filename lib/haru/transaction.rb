require 'haru/ffihaildb'

module Haru

  class Transaction

    READ_UNCOMMITTED = 0
    READ_COMMITTED = 1
    REPEATABLE_READ = 2
    SERIALIZABLE = 3

    def initialize(trx_level = READ_UNCOMMITTED)
      @trx_ptr = PureHailDB.ib_trx_begin(trx_level)
    end

    def commit()
      check_return_code(PureHailDB.ib_trx_commit(@trx_ptr))
    end

    def rollback()
      check_return_code(PureHailDB.ib_trx_rollback(@trx_ptr))
    end

    def exclusive_schema_lock()
      check_return_code(PureHailDB.ib_schema_lock_exclusive(@trx_ptr))
    end

  end

end
