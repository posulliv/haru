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
      PureHailDB.ib_trx_commit(@trx_ptr)
    end

    def rollback()
      PureHailDB.ib_trx_rollback(@trx_ptr)
    end

  end

  class HailDB

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

  end

end
