require 'haru/ffihaildb'

module Haru

  #
  # A transaction in HailDB
  # http://www.innodb.com/doc/embedded_innodb-1.0/#id287624881
  #
  # A short example
  #
  #   require 'rubygems'
  #   require 'haru'
  #
  #   trx = Transaction.new
  #   trx.commit
  #
  #   trx = Transaction.new(Transaction::SERIALIZABLE)
  #   trx.exclusive_schema_lock
  #   trx.commit
  #
  class Transaction

    READ_UNCOMMITTED = 0
    READ_COMMITTED = 1
    REPEATABLE_READ = 2
    SERIALIZABLE = 3

    # Creates a transaction with a specified isolation level and places
    # the transaction in the active state.
    #
    # == parameters
    #
    #   * trx_level   the isolation level to use for the transaction
    #
    def initialize(trx_level = READ_UNCOMMITTED)
      @trx_ptr = PureHailDB.ib_trx_begin(trx_level)
    end

    # Commits the transaction and releases the schema latches.
    def commit()
      check_return_code(PureHailDB.ib_trx_commit(@trx_ptr))
    end

    # Rolls back the transaction and releases the schema latches.
    def rollback()
      check_return_code(PureHailDB.ib_trx_rollback(@trx_ptr))
    end

    # Latches the HailDB data dictionary in exclusive mode
    def exclusive_schema_lock()
      check_return_code(PureHailDB.ib_schema_lock_exclusive(@trx_ptr))
    end

    def create_table(table)
      id_ptr = FFI::MemoryPointer.new :pointer
      check_return_code(PureHailDB.ib_table_create(@trx_ptr, table.schema_ptr.read_pointer(), id_ptr))
      # free the memory HailDB allocated
      PureHailDB.ib_table_schema_delete(table.schema_ptr.read_pointer())
    end

    def drop_table(db_name, table_name)
      name = db_name + "/" + table_name
      check_return_code(PureHailDB.ib_table_drop(@trx_ptr, name))
    end

  end

end
