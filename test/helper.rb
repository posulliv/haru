require 'rubygems'

require File.join(File.dirname(__FILE__), *%w[.. lib haru])

require 'test/unit'
require 'shoulda'
require 'rr'

include Haru

class Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def dest_dir(*subdirs)
    File.join(File.dirname(__FILE__), 'dest', *subdirs)
  end

  def source_dir(*subdirs)
    File.join(File.dirname(__FILE__), 'source', *subdirs)
  end

  def clear_dest
    FileUtils.rm_rf(dest_dir)
  end

end
