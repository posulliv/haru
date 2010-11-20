require 'rubygems'

require File.join(File.dirname(__FILE__), *%w[.. lib haru])

require 'test/unit'
require 'shoulda'
require 'rr'
require 'fileutils'

include Haru

class Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def create_data_dir
    @data_dir = File.dirname(__FILE__) + '/hail_data'
    FileUtils.mkdir_p(@data_dir)
  end

  def clear_data_dir
    FileUtils.rm_rf(@data_dir)
  end

end
