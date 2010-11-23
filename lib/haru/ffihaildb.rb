require 'rubygems'
require 'ffi'

module PureHailDB

  extend FFI::Library
  ffi_lib 'haildb'

  # error codes
  DbError = enum( :DB_SUCCESS, 10,
                  :DB_ERROR,
                  :DB_INTERRUPTED,
                  :DB_OUT_OF_MEMORY,
                  :DB_OUT_OF_FILE_SPACE,
                  :DB_LOCK_WAIT,
                  :DB_DEADLOCK,
                  :DB_ROLLBACK,
                  :DB_DUPLICATE_KEY,
                  :DB_QUE_THR_SUSPENDED,
                  :DB_MISSING_HISTORY,
                  :DB_CLUSTER_NOT_FOUND, 30,
                  :DB_TABLE_NOT_FOUND,
                  :DB_MUST_GET_MORE_FILE_SPACE,
                  :DB_TABLE_IS_BEING_USED,
                  :DB_TOO_BIG_RECORD,
                  :DB_LOCK_WAIT_TIMEOUT,
                  :DB_NO_REFERENCED_ROW,
                  :DB_ROW_IS_REFERENCED,
                  :DB_CANNOT_ADD_CONSTRAINT,
                  :DB_CORRUPTION,
                  :DB_COL_APPEARS_TWICE_IN_INDEX,
                  :DB_CANNOT_DROP_CONSTRAINT,
                  :DB_NO_SAVEPOINT,
                  :DB_TABLESPACE_ALREADY_EXISTS,
                  :DB_TABLESPACE_DELETED,
                  :DB_LOCK_TABLE_FULL,
                  :DB_FOREIGN_DUPLICATE_KEY,
                  :DB_TOO_MANY_CONCURRENT_ROWS,
                  :DB_UNSUPPORTED,
                  :DB_PRIMARY_KEY_IS_NULL,
                  :DB_FATAL,
                  :DB_FAIL, 1000,
                  :DB_OVERFLOW,
                  :DB_UNDERFLOW,
                  :DB_STRONG_FAIL,
                  :DB_ZIP_OVERFLOW,
                  :DB_RECORD_NOT_FOUND, 1500,
                  :DB_END_OF_INDEX,
                  :DB_SCHEMA_ERROR, 2000,
                  :DB_DATA_MISMATCH,
                  :DB_SCHEMA_NOT_LOCKED,
                  :DB_NOT_FOUND,
                  :DB_READONLY,
                  :DB_INVALID_INPUT )

  ShutdownType = enum( :IB_SHUTDOWN_NORMAL, 0,
                       :IB_SHUTDOWN_NO_IBUFMERGE_PURGE,
                       :IB_SHUTDOWN_NO_BUFPOOL_FLUSH )

  TrxLevel = enum( :IB_TRX_READ_UNCOMMITTED, 0,
                   :IB_TRX_READ_COMMITTED,
                   :IB_TRX_REPEATABLE_READ,
                   :IB_TRX_SERIALIZABLE )
  
  TrxState = enum( :IB_TRX_NOT_STARTED, 0,
                   :IB_TRX_ACTIVE,
                   :IB_TRX_COMMITTED_IN_MEMORY,
                   :IB_TRX_PREPARED )

  DictOp = enum( :TRX_DICT_OP_NONE, 0,
                 :TRX_DICT_OP_TABLE,
                 :TRX_DICT_OP_INDEX )

  LockMode = enum( :IB_LOCK_IS, 0,
                   :IB_LOCK_IX,
                   :IB_LOCK_S,
                   :IB_LOCK_X,
                   :IB_LOCK_NOT_USED,
                   :IB_LOCK_NONE,
                   :IB_LOCK_NUM, :IB_LOCK_NONE )
  
  TableFormat = enum( :IB_TBL_REDUNDANT, 0,
                      :IB_TBL_COMPACT,
                      :IB_TBL_DYNAMIC,
                      :IB_TBL_COMPRESSED )

  ColumnAttr = enum( :IB_COL_NONE, 0,
                     :IB_COL_NOT_NULL,
                     :IB_COL_UNSIGNED,
                     :IB_COL_NOT_USED, 4,
                     :IB_COL_CUSTOM1, 8,
                     :IB_COL_CUSTOM2, 16,
                     :IB_COL_CUSTOM3, 32 )

  ColumnType = enum( :IB_VARCHAR, 1,
                     :IB_CHAR, 2,
                     :IB_BINARY, 3,
                     :IB_VARBINARY, 4,
                     :IB_BLOB, 5,
                     :IB_INT, 6,
                     :IB_SYS, 8,
                     :IB_FLOAT,
                     :IB_DOUBLE,
                     :IB_DECIMAL,
                     :IB_VARCHAR_ANYCHARSET,
                     :IB_CHAR_ANYCHARSET )

  # startup/shutdown functions
  attach_function :ib_init, [], DbError
  attach_function :ib_startup, [ :string ], DbError
  attach_function :ib_shutdown, [ ShutdownType ], DbError

  # configuration functions
  attach_function :ib_cfg_set, [ :string, :varargs ], DbError
  attach_function :ib_cfg_get, [ :string, :pointer ], DbError

  # database functions
  attach_function :ib_database_create, [ :string ], :bool
  attach_function :ib_database_drop, [ :string ], DbError

  # transaction functions
  attach_function :ib_trx_begin, [ TrxLevel ], :pointer
  attach_function :ib_trx_commit, [ :pointer ], DbError
  attach_function :ib_trx_rollback, [ :pointer ], DbError
  attach_function :ib_schema_lock_exclusive, [ :pointer ], DbError
  attach_function :ib_trx_state, [ :pointer ], TrxState

  # table/index functions
  attach_function :ib_table_schema_create, [ :string, :pointer, TableFormat, :int64 ], DbError
  attach_function :ib_table_schema_delete, [ :pointer ], :void
  attach_function :ib_table_schema_add_col, [ :pointer, :string, ColumnType, ColumnAttr, :uint16, :uint64 ], DbError
  attach_function :ib_table_schema_add_index, [ :pointer, :string, :pointer ], DbError
  attach_function :ib_index_schema_add_col, [ :pointer, :string, :uint64 ], DbError
  attach_function :ib_index_schema_set_clustered, [ :pointer ], DbError
  attach_function :ib_table_create, [ :pointer, :pointer, :pointer ], DbError
  attach_function :ib_table_drop, [ :pointer, :string ], DbError

  # cursor functions
  attach_function :ib_cursor_open_table, [ :string, :pointer, :pointer ], DbError
  attach_function :ib_cursor_close, [ :pointer ], DbError
  attach_function :ib_cursor_reset, [ :pointer ], DbError
  attach_function :ib_cursor_lock, [ :pointer, LockMode ], DbError
  attach_function :ib_cursor_insert_row, [ :pointer, :pointer ], DbError
  attach_function :ib_cursor_read_row, [ :pointer, :pointer ], DbError
  attach_function :ib_cursor_next, [ :pointer ], DbError
  attach_function :ib_cursor_prev, [ :pointer ], DbError
  attach_function :ib_cursor_first, [ :pointer ], DbError
  attach_function :ib_cursor_last, [ :pointer ], DbError

  # tuple functions
  attach_function :ib_clust_read_tuple_create, [ :pointer ], :pointer
  attach_function :ib_tuple_delete, [ :pointer ], :void
  attach_function :ib_tuple_clear, [ :pointer ], :pointer
  attach_function :ib_col_set_value, [ :pointer, :uint64, :pointer , :uint64 ], DbError
  attach_function :ib_col_get_value, [ :pointer, :uint64 ], :pointer
  attach_function :ib_col_copy_value, [ :pointer, :uint64, :pointer, :uint64 ], :void
  attach_function :ib_tuple_write_u32, [ :pointer, :uint64, :uint32 ], DbError
  attach_function :ib_tuple_read_u32, [ :pointer, :uint64, :pointer ], DbError

  # miscellaneous functions
  attach_function :ib_strerror, [ DbError ], :string
  attach_function :ib_api_version, [], :uint64

end

