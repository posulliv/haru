require 'haru/ffihaildb'

module Haru

  class HailDB

    WRITE_AND_FLUSH_ONCE_PER_SECOND = 0
    WRITE_AND_FLUSH_AT_EACH_COMMIT = 1
    WRITE_AT_COMMIT_FLUSH_ONCE_PER_SECOND = 2

    def initialize()
      PureHailDB.ib_init
    end

    def startup()
      PureHailDB.ib_startup("BARRACUDA")
    end

    def shutdown()
      PureHailDB.ib_shutdown(PureHailDB::ShutdownType[:IB_SHUTDOWN_NORMAL])
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

end
