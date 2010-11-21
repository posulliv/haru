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
      ret = PureHailDB.ib_database_create(db_name)
      if ret != true
        check_return_code(PureHailDB::DbError[:DB_ERROR])
      end
    end

    def drop_database(db_name)
      check_return_code(PureHailDB.ib_database_drop(db_name))
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
      raise DatabaseError, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_OUT_OF_MEMORY]
      raise OutOfMemory, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_OUT_OF_FILE_SPACE]
      raise OutOfFileSpace, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_LOCK_WAIT]
      raise LockWait, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_DEADLOCK]
      raise DeadLock, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_DUPLICATE_KEY]
      raise DuplicateKey, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_QUE_THR_SUSPENDED]
      raise QueueThreadSuspended, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_MISSING_HISTORY]
      raise MissingHistory, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_CLUSTER_NOT_FOUND]
      raise ClusterNotFound, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_TABLE_NOT_FOUND]
      raise TableNotFound, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_MUST_GET_MORE_FILE_SPACE]
      raise MustGetMoreFileSpace, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_TABLE_IS_BEING_USED]
      raise TableInUse, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_TOO_BIG_RECORD]
      raise RecordTooBig, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_NO_REFERENCED_ROW]
      raise NoReferencedRow, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_CANNOT_ADD_CONSTRAINT]
      raise CannotAddConstraint, PureHailDB.ib_strerror(ret)
    elsif PureHailDB::DbError[ret] == PureHailDB::DbError[:DB_CORRUPTION]
      raise Corruption, PureHailDB.ib_strerror(ret)
    else
    end
  end

end
