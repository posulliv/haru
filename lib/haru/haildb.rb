require 'haru/ffihaildb'
require 'haru/exceptions'

module Haru

  class HailDB

    WRITE_AND_FLUSH_ONCE_PER_SECOND = 0
    WRITE_AND_FLUSH_AT_EACH_COMMIT = 1
    WRITE_AT_COMMIT_FLUSH_ONCE_PER_SECOND = 2

    def initialize()
      PureHailDB.ib_init
    end

    def startup()
      check_return_code(PureHailDB.ib_startup("BARRACUDA"))
    end

    def shutdown()
      check_return_code(PureHailDB.ib_shutdown(PureHailDB::ShutdownType[:IB_SHUTDOWN_NORMAL]))
    end

    def version()
      PureHailDB.ib_api_version
    end

    def create_database(db_name)
      PureHailDB.ib_database_create(db_name)
    end

    def drop_database(db_name)
      PureHailDB.ib_database_drop(db_name)
    end

    def enable_option(option)
      PureHailDB.ib_cfg_set(option, :bool, true)
    end

    def disable_option(option)
      PureHailDB.ib_cfg_set(option, :bool, false)
    end

    def enable_verbose_log()
      PureHailDB.ib_cfg_set("print_verbose_log", :bool, true)
    end

    def disable_verbose_log()
      PureHailDB.ib_cfg_set("print_verbose_log", :bool, false)
    end

    def enable_rollback_on_timeout()
      PureHailDB.ib_cfg_set("rollback_on_timeout", :bool, true)
    end

    def disable_rollback_on_timeout()
      PureHailDB.ib_cfg_set("rollback_on_timeout", :bool, false)
    end

    def enable_doublewrite()
      PureHailDB.ib_cfg_set("doublewrite", :bool, true)
    end

    def disable_doublewrite()
      PureHailDB.ib_cfg_set("doublewrite", :bool, false)
    end

    def enable_adaptive_hash_index()
      PureHailDB.ib_cfg_set("adaptive_hash_index", :bool, true)
    end

    def disable_adaptive_hash_index()
      PureHailDB.ib_cfg_set("adaptive_hash_index", :bool, false)
    end

    def enable_adaptive_flushing()
      PureHailDB.ib_cfg_set("adaptive_flushing", :bool, true)
    end

    def disable_adaptive_flushing()
      PureHailDB.ib_cfg_set("adaptive_flushing", :bool, false)
    end

    def enable_file_per_table()
      PureHailDB.ib_cfg_set("file_per_table", :bool, true)
    end

    def disable_file_per_table()
      PureHailDB.ib_cfg_set("file_per_table", :bool, false)
    end

    def set_log_flush_frequency(frequency)
      if frequency > WRITE_AT_COMMIT_FLUSH_ONCE_PER_SECOND
        # exception?
      end
      PureHailDB.ib_cfg_set("flush_log_at_trx_commit", :uint8, frequency)
    end

    def set_flush_method(method)
      PureHailDB.ib_cfg_set("flush_method", :string, method)
    end

    def set_data_file_path(data_file_path)
      PureHailDB.ib_cfg_set("data_file_path", :string, data_file_path)
    end

    def set_log_file_path(data_file_path)
      PureHailDB.ib_cfg_set("log_group_home_dir", :string, data_file_path)
    end

  end

  def check_return_code(ret)
    if PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_SUCCESS]
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_ERROR]
      error = DatabaseError.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_OUT_OF_MEMORY]
      error = OutOfMemory.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_OUT_OF_FILE_SPACE]
      error = OutOfFileSpace.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_LOCK_WAIT]
      error = LockWait.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_DEADLOCK]
      error = DeadLock.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_DUPLICATE_KEY]
      error = DuplicateKey.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_QUE_THR_SUSPENDED]
      error = QueueThreadSuspended.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_MISSING_HISTORY]
      error = MissingHistory.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_CLUSTER_NOT_FOUND]
      error = ClusterNotFound.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_TABLE_NOT_FOUND]
      error = TableNotFound.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_MUST_GET_MORE_FILE_SPACE]
      error = MustGetMoreFileSpace.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_TABLE_IS_BEING_USED]
      error = TableInUse.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_TOO_BIG_RECORD]
      error = RecordTooBig.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_NO_REFERENCED_ROW]
      error = NoReferencedRow.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_CANNOT_ADD_CONSTRAINT]
      error = CannotAddConstraint.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_CORRUPTION]
      error = Corruption.new
      error.no_backtrace = true
      raise error, PureHailDB.ib_strerror(ret)
    else
    end
  end

end
