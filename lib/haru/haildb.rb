require 'haru/ffihaildb'
require 'haru/exceptions'

module Haru

  #
  # The main HailDB class
  #
  class HailDB

    #
    # Initializes the HailDB engine. 
    #
    def initialize()
      PureHailDB.ib_init
    end

    #
    # Start the HailDB engine. If this function is called on a non-existent
    # database then based on the default or user-specified configuration
    # settings it will create all the necessary files. If the database was 
    # shut down cleanly but the user deleted the REDO log files then it will
    # recreate the REDO log files.
    #
    def startup()
      check_return_code(PureHailDB.ib_startup("BARRACUDA"))
    end

    # 
    # Shut down the HailDB engine. Closes all files and releases all memory
    # on successful completion. 
    #
    def shutdown()
      check_return_code(PureHailDB.ib_shutdown(PureHailDB::ShutdownType[:IB_SHUTDOWN_NORMAL]))
    end

    def version()
      PureHailDB.ib_api_version
    end

    #
    # create a database if it doesn't exist
    #
    # == parameters
    #
    #   * db_name   name of the database to create
    #
    def create_database(db_name)
      ret = PureHailDB.ib_database_create(db_name)
      if ret != true
        check_return_code(PureHailDB::DbError[:DB_ERROR])
      end
    end

    #
    # drop a database if it exists. All tables within the database
    # are also dropped.
    #
    # == parameters
    #
    #   * db_name   name of the database to drop
    #
    def drop_database(db_name)
      check_return_code(PureHailDB.ib_database_drop(db_name))
    end

    # 
    # Enables verbose logging.
    #
    def enable_verbose_log()
      PureHailDB.ib_cfg_set("print_verbose_log", :bool, true)
    end

    # 
    # disables verbose logging. Reduces the number of messages written to
    # log. This is enabled by default.
    #
    def disable_verbose_log()
      PureHailDB.ib_cfg_set("print_verbose_log", :bool, false)
    end

    # 
    # enables rollback on timeout. When enabled, the complete transaction
    # is rolled back on lock wait timeout. This is disabled by default.
    #
    def enable_rollback_on_timeout()
      PureHailDB.ib_cfg_set("rollback_on_timeout", :bool, true)
    end

    #
    # disables rollback on timeout
    #
    def disable_rollback_on_timeout()
      PureHailDB.ib_cfg_set("rollback_on_timeout", :bool, false)
    end

    # 
    # enables usage of the doublewrite buffer. It is enabled by default.
    # For more information on this buffer see:
    #
    #   http://www.mysqlperformanceblog.com/2006/08/04/innodb-double-write/
    #
    def enable_doublewrite()
      PureHailDB.ib_cfg_set("doublewrite", :bool, true)
    end

    # 
    # disables usage of the doublewrite buffer.
    #
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

    # 
    # sets the log flush frequency. Can be one of:
    #  * WRITE_AND_FLUSH_ONCE_PER_SECOND 
    #  * WRITE_AND_FLUSH_AT_EACH_COMMIT 
    #  * WRITE_AT_COMMIT_FLUSH_ONCE_PER_SECOND
    #
    def set_log_flush_frequency(frequency)
      if frequency > WRITE_AT_COMMIT_FLUSH_ONCE_PER_SECOND
        # exception?
      end
      PureHailDB.ib_cfg_set("flush_log_at_trx_commit", :uint8, frequency)
    end

    # 
    # sets the method with which to flush data.
    #
    def set_flush_method(method)
      PureHailDB.ib_cfg_set("flush_method", :string, method)
    end

    # 
    # set the path to individual data files and their sizes
    #
    def set_data_file_path(data_file_path)
      PureHailDB.ib_cfg_set("data_file_path", :string, data_file_path)
    end

    #
    # set the path to the directory where databases and tables will
    # be created.
    #
    def set_data_home_dir(data_home_dir)
      PureHailDB.ib_cfg_set("data_home_dir", :string, data_home_dir)
    end

    # 
    # Set the path to HailDB log files.
    #
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
