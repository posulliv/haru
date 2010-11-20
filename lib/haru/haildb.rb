require 'haru/ffihaildb'

module Haru

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
      @ver = PureHailDB.ib_api_version
    end


  end

end
