
module Haru

  # 
  # Column types
  #
  VARCHAR = 1
  CHAR = 2
  BINARY = 3
  VARBINARY = 4
  BLOB = 5
  INT = 6
  SYS = 8
  FLOAT = 9
  DOUBLE = 10
  DECIMAL = 11
  VARCHAR_ANYCHARSET = 12
  CHAR_ANYCHARSET = 13

  # 
  # Column attributes
  #
  NONE = 0
  NOT_NULL = 1
  UNSIGNED = 2
  NOT_USED = 4
  CUSTOM1 = 8
  CUSTOM2 = 16
  CUSTOM3 = 32

  #
  # constants related to flush frequency
  #
  WRITE_AND_FLUSH_ONCE_PER_SECOND = 0
  WRITE_AND_FLUSH_AT_EACH_COMMIT = 1
  WRITE_AT_COMMIT_FLUSH_ONCE_PER_SECOND = 2

  #
  # transaction isolation levels
  #
  READ_UNCOMMITTED = 0
  READ_COMMITTED = 1
  REPEATABLE_READ = 2
  SERIALIZABLE = 3

end
