---
title: Running a PostgreSQL Database on OpenBSD
date: "2025-05-19 19:02:10 +0100"
updated: "2025-05-19 19:02:10 +0100"
id: running-postgresql-database-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: DataBase
background: /img/oct-25/postgreSQL-Database-Openbsd.jpg
toc: true
comments: true
published: true
excerpt: OpenBSD is a very robust, very secure and original Unix operating system, while PostgreSQL is a very stable, powerful, enterprise-grade, modern and full-featured relational database.
keywords: postgresql, sql, database, openbsd, command, installation, running, mariadb
---

OpenBSD is a very robust, very secure and original Unix operating system, while PostgreSQL is a very stable, powerful, enterprise-grade, modern and full-featured relational database. Is it possible to combine the two to create a great database on the OpenBSD operating system? The answer is Yes, of course!. All of this can be done easily by OpenBSD.

OpenBSD has a packaging system that is somehow different from many other operating systems; in particular, packages are thoroughly checked before being installed, so that the installation process will only run if it is absolutely certain that the installation will succeed.

Furthermore, the OpenBSD operating system provides a simple and flexible way to manage the PostgreSQL daemon service.

In this short article, I will show you how you can start working with PostgreSQL on `OpenBSD`.

<br/>
{% lazyload data-src="/img/oct-25/postgreSQL-Database-Openbsd.jpg" src="/img/oct-25/postgreSQL-Database-Openbsd.jpg" alt="postgreSQL Database Openbsd" %}
<br/>

## 1. System Specifications:

- OS: OpenBSD 7.6 amd64
- Host: Acer Aspire M1800
- Uptime: 17 mins
- Packages: 102 (pkg_info)
- Shell: ksh v5.2.14 99/07/13.2
- Terminal: /dev/ttyp0
- CPU: Intel Core 2 Duo E8400 (2) @ 3.000GHz
- Memory: 55MiB / 1775MiB
- Hostname: ns2
- IP Address: 192.168.5.3
- Domain: inchimediatama.org
- Versi PostgreSQL: postgresql-server-16.4p0
- Versi PHP: php-8.2.27p0

## 2. Install PostgreSQL Dependencies

Dependencies play an important role in PostgreSQL applications. With dependencies, PostgreSQL can run normally on OpenBSD. PHP dependencies are the most dependencies that you must install.

Before you install dependencies, make sure the PHP and PHP-FPM applications have been installed. For the PHP installation process, you can read the previous article.

Below are the commands that you can use to install `PostgreSQL` dependencies.

```console
ns2# pkg_add php-curl-8.2.27 php-gd-8.2.27 php-intl-8.2.27 php-pdo_pgsql-8.2.27 php-zip-8.2.27 redis pecl82-redis
```

## 3. Install PostgreSQL Database

Once PHP, PHP-FPM and the PostgreSQL dependencies are perfectly installed, you can proceed with the PostgreSQL database installation process. OpenBSD uses the pkg package that handles all the packaging mechanisms for installing each application.

While it is true that you can install applications from ports, like other BSD systems, OpenBSD recommends installing via packages because the system can easily keep track of what you have installed so far, and as a result can easily perform updates.

Therefore, the first thing to do is to perform the OpenBSD pkg package update process.

```console
ns2# pkg_add -uvi
ns2# pkg_add postgresql-server
```

## 4. Init PostgreSQL database

It is very important to understand the initdb command before setting up PostgreSQL manually. If PostgreSQL is not set up properly in the initial stage, it will not execute queries in the later stages. Users can set up the PostgreSQL server manually using different commands. In the worst case, the PostgreSQL server may not be able to detect the data directory path and fail to start.

The initdb command is used in the initialization process of a database cluster. After the initialization process using the initdb command, a database named postgres will be created inside the database cluster.

Postgres serves as the default database used by users, utilities, and third-party applications. In addition to creating the postgres database inside the cluster, another database named template1 is also created inside each cluster.

The template1 database serves as a template for databases created later in the cluster. Remember, the database cluster is the data directory under the file system. To start the initdb process, you can follow the following command.

```yml
ns2# rm -rf /var/postgresql/data
ns2# su - _postgresql
$ initdb -D /var/postgresql/data/ -U postgres -k -E UTF-8 -A md5 -W
The files belonging to this database system will be owned by user "_postgresql".
This user must also own the server process.

The database cluster will be initialized with locale "C".
The default text search configuration will be set to "english".

Data page checksums are enabled.

Enter new superuser password:
Enter it again:

creating directory /var/postgresql/data ... ok
creating subdirectories ... ok
selecting dynamic shared memory implementation ... posix
selecting default max_connections ... 20
selecting default shared_buffers ... 128MB
selecting default time zone ... Asia/Jakarta
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok

Success. You can now start the database server using:

    pg_ctl -D /var/postgresql/data/ -l logfile start

$
```

After that, you can start the postgresql service.

```yml
$ pg_ctl -D /var/postgresql/data/ -l logfile start
waiting for server to start.... done
server started
$ exit
```

<br/>
## 5. Activating PostgreSQL

After you have completed the database initiation process (initdb), you can immediately start activating PostgreSQL.

```console
ns2# rcctl enable postgresql
ns2# rcctl restart postgresql
postgresql(ok)
postgresql(ok)
```

To further ensure that the postgresql daemon is running properly, run the following command.

```console
ns2# rcctl check postgresql
postgresql(ok)
```

All databases and configuration files can be found in the `/var/postgresql/data` directory. You can change the contents of the script file **"/var/postgresql/data/postgresql.conf"**, for example you want to use a private IP Address or you can also use localhost.

```console
# -----------------------------
# PostgreSQL configuration file
# -----------------------------
#
# This file consists of lines of the form:
#
#   name = value
#
# (The "=" is optional.)  Whitespace may be used.  Comments are introduced with
# "#" anywhere on a line.  The complete list of parameter names and allowed
# values can be found in the PostgreSQL documentation.
#
# The commented-out settings shown in this file represent the default values.
# Re-commenting a setting is NOT sufficient to revert it to the default value;
# you need to reload the server.
#
# This file is read on server startup and when the server receives a SIGHUP
# signal.  If you edit the file on a running system, you have to SIGHUP the
# server for the changes to take effect, run "pg_ctl reload", or execute
# "SELECT pg_reload_conf()".  Some parameters, which are marked below,
# require a server shutdown and restart to take effect.
#
# Any parameter can also be given as a command-line option to the server, e.g.,
# "postgres -c log_connections=on".  Some parameters can be changed at run time
# with the "SET" SQL command.
#
# Memory units:  B  = bytes            Time units:  us  = microseconds
#                kB = kilobytes                     ms  = milliseconds
#                MB = megabytes                     s   = seconds
#                GB = gigabytes                     min = minutes
#                TB = terabytes                     h   = hours
#                                                   d   = days


#------------------------------------------------------------------------------
# FILE LOCATIONS
#------------------------------------------------------------------------------

# The default values of these variables are driven from the -D command-line
# option or PGDATA environment variable, represented here as ConfigDir.

#data_directory = 'ConfigDir'		# use data in another directory
					# (change requires restart)
#hba_file = 'ConfigDir/pg_hba.conf'	# host-based authentication file
					# (change requires restart)
#ident_file = 'ConfigDir/pg_ident.conf'	# ident configuration file
					# (change requires restart)

# If external_pid_file is not explicitly set, no extra PID file is written.
#external_pid_file = ''			# write an extra PID file
					# (change requires restart)


#------------------------------------------------------------------------------
# CONNECTIONS AND AUTHENTICATION
#------------------------------------------------------------------------------

# - Connection Settings -

listen_addresses = '192.168.5.3'		# what IP address(es) to listen on;
					# comma-separated list of addresses;
					# defaults to 'localhost'; use '*' for all
					# (change requires restart)
port = 5432				# (change requires restart)
max_connections = 20			# (change requires restart)
#reserved_connections = 0		# (change requires restart)
#superuser_reserved_connections = 3	# (change requires restart)
#unix_socket_directories = '/tmp'	# comma-separated list of directories
					# (change requires restart)
#unix_socket_group = ''			# (change requires restart)
#unix_socket_permissions = 0777		# begin with 0 to use octal notation
					# (change requires restart)
#bonjour = off				# advertise server via Bonjour
					# (change requires restart)
#bonjour_name = ''			# defaults to the computer name
					# (change requires restart)

# - TCP settings -
# see "man tcp" for details

#tcp_keepalives_idle = 0		# TCP_KEEPIDLE, in seconds;
					# 0 selects the system default
#tcp_keepalives_interval = 0		# TCP_KEEPINTVL, in seconds;
					# 0 selects the system default
#tcp_keepalives_count = 0		# TCP_KEEPCNT;
					# 0 selects the system default
#tcp_user_timeout = 0			# TCP_USER_TIMEOUT, in milliseconds;
					# 0 selects the system default

#client_connection_check_interval = 0	# time between checks for client
					# disconnection while running queries;
					# 0 for never

# - Authentication -

#authentication_timeout = 1min		# 1s-600s
password_encryption = md5		# scram-sha-256 or md5
#scram_iterations = 4096
#db_user_namespace = off

# GSSAPI using Kerberos
#krb_server_keyfile = 'FILE:${sysconfdir}/krb5.keytab'
#krb_caseins_users = off
#gss_accept_delegation = off

# - SSL -

#ssl = off
#ssl_ca_file = ''
#ssl_cert_file = 'server.crt'
#ssl_crl_file = ''
#ssl_crl_dir = ''
#ssl_key_file = 'server.key'
#ssl_ciphers = 'HIGH:MEDIUM:+3DES:!aNULL' # allowed SSL ciphers
#ssl_prefer_server_ciphers = on
#ssl_ecdh_curve = 'prime256v1'
#ssl_min_protocol_version = 'TLSv1.2'
#ssl_max_protocol_version = ''
#ssl_dh_params_file = ''
#ssl_passphrase_command = ''
#ssl_passphrase_command_supports_reload = off


#------------------------------------------------------------------------------
# RESOURCE USAGE (except WAL)
#------------------------------------------------------------------------------

# - Memory -

shared_buffers = 128MB			# min 128kB
					# (change requires restart)
#huge_pages = try			# on, off, or try
					# (change requires restart)
#huge_page_size = 0			# zero for system default
					# (change requires restart)
#temp_buffers = 8MB			# min 800kB
#max_prepared_transactions = 0		# zero disables the feature
					# (change requires restart)
# Caution: it is not advisable to set max_prepared_transactions nonzero unless
# you actively intend to use prepared transactions.
#work_mem = 4MB				# min 64kB
#hash_mem_multiplier = 2.0		# 1-1000.0 multiplier on hash table work_mem
#maintenance_work_mem = 64MB		# min 1MB
#autovacuum_work_mem = -1		# min 1MB, or -1 to use maintenance_work_mem
#logical_decoding_work_mem = 64MB	# min 64kB
#max_stack_depth = 2MB			# min 100kB
#shared_memory_type = mmap		# the default is the first option
					# supported by the operating system:
					#   mmap
					#   sysv
					#   windows
					# (change requires restart)
dynamic_shared_memory_type = posix	# the default is usually the first option
					# supported by the operating system:
					#   posix
					#   sysv
					#   windows
					#   mmap
					# (change requires restart)
#min_dynamic_shared_memory = 0MB	# (change requires restart)
#vacuum_buffer_usage_limit = 256kB	# size of vacuum and analyze buffer access strategy ring;
					# 0 to disable vacuum buffer access strategy;
					# range 128kB to 16GB

# - Disk -

#temp_file_limit = -1			# limits per-process temp file space
					# in kilobytes, or -1 for no limit

# - Kernel Resources -

#max_files_per_process = 1000		# min 64
					# (change requires restart)

# - Cost-Based Vacuum Delay -

#vacuum_cost_delay = 0			# 0-100 milliseconds (0 disables)
#vacuum_cost_page_hit = 1		# 0-10000 credits
#vacuum_cost_page_miss = 2		# 0-10000 credits
#vacuum_cost_page_dirty = 20		# 0-10000 credits
#vacuum_cost_limit = 200		# 1-10000 credits

# - Background Writer -

#bgwriter_delay = 200ms			# 10-10000ms between rounds
#bgwriter_lru_maxpages = 100		# max buffers written/round, 0 disables
#bgwriter_lru_multiplier = 2.0		# 0-10.0 multiplier on buffers scanned/round
#bgwriter_flush_after = 0		# measured in pages, 0 disables

# - Asynchronous Behavior -

#backend_flush_after = 0		# measured in pages, 0 disables
#effective_io_concurrency = 0		# 1-1000; 0 disables prefetching
#maintenance_io_concurrency = 10	# 1-1000; 0 disables prefetching
#max_worker_processes = 8		# (change requires restart)
#max_parallel_workers_per_gather = 2	# limited by max_parallel_workers
#max_parallel_maintenance_workers = 2	# limited by max_parallel_workers
#max_parallel_workers = 8		# number of max_worker_processes that
					# can be used in parallel operations
#parallel_leader_participation = on
#old_snapshot_threshold = -1		# 1min-60d; -1 disables; 0 is immediate
					# (change requires restart)


#------------------------------------------------------------------------------
# WRITE-AHEAD LOG
#------------------------------------------------------------------------------

# - Settings -

#wal_level = replica			# minimal, replica, or logical
					# (change requires restart)
#fsync = on				# flush data to disk for crash safety
					# (turning this off can cause
					# unrecoverable data corruption)
#synchronous_commit = on		# synchronization level;
					# off, local, remote_write, remote_apply, or on
#wal_sync_method = fsync		# the default is the first option
					# supported by the operating system:
					#   open_datasync
					#   fdatasync (default on Linux and FreeBSD)
					#   fsync
					#   fsync_writethrough
					#   open_sync
#full_page_writes = on			# recover from partial page writes
#wal_log_hints = off			# also do full page writes of non-critical updates
					# (change requires restart)
#wal_compression = off			# enables compression of full-page writes;
					# off, pglz, lz4, zstd, or on
#wal_init_zero = on			# zero-fill new WAL files
#wal_recycle = on			# recycle WAL files
#wal_buffers = -1			# min 32kB, -1 sets based on shared_buffers
					# (change requires restart)
#wal_writer_delay = 200ms		# 1-10000 milliseconds
#wal_writer_flush_after = 1MB		# measured in pages, 0 disables
#wal_skip_threshold = 2MB

#commit_delay = 0			# range 0-100000, in microseconds
#commit_siblings = 5			# range 1-1000

# - Checkpoints -

#checkpoint_timeout = 5min		# range 30s-1d
#checkpoint_completion_target = 0.9	# checkpoint target duration, 0.0 - 1.0
#checkpoint_flush_after = 0		# measured in pages, 0 disables
#checkpoint_warning = 30s		# 0 disables
max_wal_size = 1GB
min_wal_size = 80MB

# - Prefetching during recovery -

#recovery_prefetch = try		# prefetch pages referenced in the WAL?
#wal_decode_buffer_size = 512kB		# lookahead window used for prefetching
					# (change requires restart)

# - Archiving -

#archive_mode = off		# enables archiving; off, on, or always
				# (change requires restart)
#archive_library = ''		# library to use to archive a WAL file
				# (empty string indicates archive_command should
				# be used)
#archive_command = ''		# command to use to archive a WAL file
				# placeholders: %p = path of file to archive
				#               %f = file name only
				# e.g. 'test ! -f /mnt/server/archivedir/%f && cp %p /mnt/server/archivedir/%f'
#archive_timeout = 0		# force a WAL file switch after this
				# number of seconds; 0 disables

# - Archive Recovery -

# These are only used in recovery mode.

#restore_command = ''		# command to use to restore an archived WAL file
				# placeholders: %p = path of file to restore
				#               %f = file name only
				# e.g. 'cp /mnt/server/archivedir/%f %p'
#archive_cleanup_command = ''	# command to execute at every restartpoint
#recovery_end_command = ''	# command to execute at completion of recovery

# - Recovery Target -

# Set these only when performing a targeted recovery.

#recovery_target = ''		# 'immediate' to end recovery as soon as a
                                # consistent state is reached
				# (change requires restart)
#recovery_target_name = ''	# the named restore point to which recovery will proceed
				# (change requires restart)
#recovery_target_time = ''	# the time stamp up to which recovery will proceed
				# (change requires restart)
#recovery_target_xid = ''	# the transaction ID up to which recovery will proceed
				# (change requires restart)
#recovery_target_lsn = ''	# the WAL LSN up to which recovery will proceed
				# (change requires restart)
#recovery_target_inclusive = on # Specifies whether to stop:
				# just after the specified recovery target (on)
				# just before the recovery target (off)
				# (change requires restart)
#recovery_target_timeline = 'latest'	# 'current', 'latest', or timeline ID
				# (change requires restart)
#recovery_target_action = 'pause'	# 'pause', 'promote', 'shutdown'
				# (change requires restart)


#------------------------------------------------------------------------------
# REPLICATION
#------------------------------------------------------------------------------

# - Sending Servers -

# Set these on the primary and on any standby that will send replication data.

#max_wal_senders = 10		# max number of walsender processes
				# (change requires restart)
#max_replication_slots = 10	# max number of replication slots
				# (change requires restart)
#wal_keep_size = 0		# in megabytes; 0 disables
#max_slot_wal_keep_size = -1	# in megabytes; -1 disables
#wal_sender_timeout = 60s	# in milliseconds; 0 disables
#track_commit_timestamp = off	# collect timestamp of transaction commit
				# (change requires restart)

# - Primary Server -

# These settings are ignored on a standby server.

#synchronous_standby_names = ''	# standby servers that provide sync rep
				# method to choose sync standbys, number of sync standbys,
				# and comma-separated list of application_name
				# from standby(s); '*' = all

# - Standby Servers -

# These settings are ignored on a primary server.

#primary_conninfo = ''			# connection string to sending server
#primary_slot_name = ''			# replication slot on sending server
#hot_standby = on			# "off" disallows queries during recovery
					# (change requires restart)
#max_standby_archive_delay = 30s	# max delay before canceling queries
					# when reading WAL from archive;
					# -1 allows indefinite delay
#max_standby_streaming_delay = 30s	# max delay before canceling queries
					# when reading streaming WAL;
					# -1 allows indefinite delay
#wal_receiver_create_temp_slot = off	# create temp slot if primary_slot_name
					# is not set
#wal_receiver_status_interval = 10s	# send replies at least this often
					# 0 disables
#hot_standby_feedback = off		# send info from standby to prevent
					# query conflicts
#wal_receiver_timeout = 60s		# time that receiver waits for
					# communication from primary
					# in milliseconds; 0 disables
#wal_retrieve_retry_interval = 5s	# time to wait before retrying to
					# retrieve WAL after a failed attempt
#recovery_min_apply_delay = 0		# minimum delay for applying changes during recovery

# - Subscribers -

# These settings are ignored on a publisher.

#max_logical_replication_workers = 4	# taken from max_worker_processes
					# (change requires restart)
#max_sync_workers_per_subscription = 2	# taken from max_logical_replication_workers
#max_parallel_apply_workers_per_subscription = 2	# taken from max_logical_replication_workers


#------------------------------------------------------------------------------
# QUERY TUNING
#------------------------------------------------------------------------------

# - Planner Method Configuration -

#enable_async_append = on
#enable_bitmapscan = on
#enable_gathermerge = on
#enable_hashagg = on
#enable_hashjoin = on
#enable_incremental_sort = on
#enable_indexscan = on
#enable_indexonlyscan = on
#enable_material = on
#enable_memoize = on
#enable_mergejoin = on
#enable_nestloop = on
#enable_parallel_append = on
#enable_parallel_hash = on
#enable_partition_pruning = on
#enable_partitionwise_join = off
#enable_partitionwise_aggregate = off
#enable_presorted_aggregate = on
#enable_seqscan = on
#enable_sort = on
#enable_tidscan = on

# - Planner Cost Constants -

#seq_page_cost = 1.0			# measured on an arbitrary scale
#random_page_cost = 4.0			# same scale as above
#cpu_tuple_cost = 0.01			# same scale as above
#cpu_index_tuple_cost = 0.005		# same scale as above
#cpu_operator_cost = 0.0025		# same scale as above
#parallel_setup_cost = 1000.0	# same scale as above
#parallel_tuple_cost = 0.1		# same scale as above
#min_parallel_table_scan_size = 8MB
#min_parallel_index_scan_size = 512kB
#effective_cache_size = 4GB

#jit_above_cost = 100000		# perform JIT compilation if available
					# and query more expensive than this;
					# -1 disables
#jit_inline_above_cost = 500000		# inline small functions if query is
					# more expensive than this; -1 disables
#jit_optimize_above_cost = 500000	# use expensive JIT optimizations if
					# query is more expensive than this;
					# -1 disables

# - Genetic Query Optimizer -

#geqo = on
#geqo_threshold = 12
#geqo_effort = 5			# range 1-10
#geqo_pool_size = 0			# selects default based on effort
#geqo_generations = 0			# selects default based on effort
#geqo_selection_bias = 2.0		# range 1.5-2.0
#geqo_seed = 0.0			# range 0.0-1.0

# - Other Planner Options -

#default_statistics_target = 100	# range 1-10000
#constraint_exclusion = partition	# on, off, or partition
#cursor_tuple_fraction = 0.1		# range 0.0-1.0
#from_collapse_limit = 8
#jit = on				# allow JIT compilation
#join_collapse_limit = 8		# 1 disables collapsing of explicit
					# JOIN clauses
#plan_cache_mode = auto			# auto, force_generic_plan or
					# force_custom_plan
#recursive_worktable_factor = 10.0	# range 0.001-1000000


#------------------------------------------------------------------------------
# REPORTING AND LOGGING
#------------------------------------------------------------------------------

# - Where to Log -

#log_destination = 'stderr'		# Valid values are combinations of
					# stderr, csvlog, jsonlog, syslog, and
					# eventlog, depending on platform.
					# csvlog and jsonlog require
					# logging_collector to be on.

# This is used when logging to stderr:
#logging_collector = off		# Enable capturing of stderr, jsonlog,
					# and csvlog into log files. Required
					# to be on for csvlogs and jsonlogs.
					# (change requires restart)

# These are only used if logging_collector is on:
#log_directory = 'log'			# directory where log files are written,
					# can be absolute or relative to PGDATA
#log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'	# log file name pattern,
					# can include strftime() escapes
#log_file_mode = 0600			# creation mode for log files,
					# begin with 0 to use octal notation
#log_rotation_age = 1d			# Automatic rotation of logfiles will
					# happen after that time.  0 disables.
#log_rotation_size = 10MB		# Automatic rotation of logfiles will
					# happen after that much log output.
					# 0 disables.
#log_truncate_on_rotation = off		# If on, an existing log file with the
					# same name as the new log file will be
					# truncated rather than appended to.
					# But such truncation only occurs on
					# time-driven rotation, not on restarts
					# or size-driven rotation.  Default is
					# off, meaning append to existing files
					# in all cases.

# These are relevant when logging to syslog:
#syslog_facility = 'LOCAL0'
#syslog_ident = 'postgres'
#syslog_sequence_numbers = on
#syslog_split_messages = on

# This is only relevant when logging to eventlog (Windows):
# (change requires restart)
#event_source = 'PostgreSQL'

# - When to Log -

#log_min_messages = warning		# values in order of decreasing detail:
					#   debug5
					#   debug4
					#   debug3
					#   debug2
					#   debug1
					#   info
					#   notice
					#   warning
					#   error
					#   log
					#   fatal
					#   panic

#log_min_error_statement = error	# values in order of decreasing detail:
					#   debug5
					#   debug4
					#   debug3
					#   debug2
					#   debug1
					#   info
					#   notice
					#   warning
					#   error
					#   log
					#   fatal
					#   panic (effectively off)

#log_min_duration_statement = -1	# -1 is disabled, 0 logs all statements
					# and their durations, > 0 logs only
					# statements running at least this number
					# of milliseconds

#log_min_duration_sample = -1		# -1 is disabled, 0 logs a sample of statements
					# and their durations, > 0 logs only a sample of
					# statements running at least this number
					# of milliseconds;
					# sample fraction is determined by log_statement_sample_rate

#log_statement_sample_rate = 1.0	# fraction of logged statements exceeding
					# log_min_duration_sample to be logged;
					# 1.0 logs all such statements, 0.0 never logs


#log_transaction_sample_rate = 0.0	# fraction of transactions whose statements
					# are logged regardless of their duration; 1.0 logs all
					# statements from all transactions, 0.0 never logs

#log_startup_progress_interval = 10s	# Time between progress updates for
					# long-running startup operations.
					# 0 disables the feature, > 0 indicates
					# the interval in milliseconds.

# - What to Log -

#debug_print_parse = off
#debug_print_rewritten = off
#debug_print_plan = off
#debug_pretty_print = on
#log_autovacuum_min_duration = 10min	# log autovacuum activity;
					# -1 disables, 0 logs all actions and
					# their durations, > 0 logs only
					# actions running at least this number
					# of milliseconds.
#log_checkpoints = on
#log_connections = off
#log_disconnections = off
#log_duration = off
#log_error_verbosity = default		# terse, default, or verbose messages
#log_hostname = off
#log_line_prefix = '%m [%p] '		# special values:
					#   %a = application name
					#   %u = user name
					#   %d = database name
					#   %r = remote host and port
					#   %h = remote host
					#   %b = backend type
					#   %p = process ID
					#   %P = process ID of parallel group leader
					#   %t = timestamp without milliseconds
					#   %m = timestamp with milliseconds
					#   %n = timestamp with milliseconds (as a Unix epoch)
					#   %Q = query ID (0 if none or not computed)
					#   %i = command tag
					#   %e = SQL state
					#   %c = session ID
					#   %l = session line number
					#   %s = session start timestamp
					#   %v = virtual transaction ID
					#   %x = transaction ID (0 if none)
					#   %q = stop here in non-session
					#        processes
					#   %% = '%'
					# e.g. '<%u%%%d> '
#log_lock_waits = off			# log lock waits >= deadlock_timeout
#log_recovery_conflict_waits = off	# log standby recovery conflict waits
					# >= deadlock_timeout
#log_parameter_max_length = -1		# when logging statements, limit logged
					# bind-parameter values to N bytes;
					# -1 means print in full, 0 disables
#log_parameter_max_length_on_error = 0	# when logging an error, limit logged
					# bind-parameter values to N bytes;
					# -1 means print in full, 0 disables
#log_statement = 'none'			# none, ddl, mod, all
#log_replication_commands = off
#log_temp_files = -1			# log temporary files equal or larger
					# than the specified size in kilobytes;
					# -1 disables, 0 logs all temp files
log_timezone = 'Asia/Jakarta'

# - Process Title -

#cluster_name = ''			# added to process titles if nonempty
					# (change requires restart)
#update_process_title = on


#------------------------------------------------------------------------------
# STATISTICS
#------------------------------------------------------------------------------

# - Cumulative Query and Index Statistics -

#track_activities = on
#track_activity_query_size = 1024	# (change requires restart)
#track_counts = on
#track_io_timing = off
#track_wal_io_timing = off
#track_functions = none			# none, pl, all
#stats_fetch_consistency = cache	# cache, none, snapshot


# - Monitoring -

#compute_query_id = auto
#log_statement_stats = off
#log_parser_stats = off
#log_planner_stats = off
#log_executor_stats = off


#------------------------------------------------------------------------------
# AUTOVACUUM
#------------------------------------------------------------------------------

#autovacuum = on			# Enable autovacuum subprocess?  'on'
					# requires track_counts to also be on.
#autovacuum_max_workers = 3		# max number of autovacuum subprocesses
					# (change requires restart)
#autovacuum_naptime = 1min		# time between autovacuum runs
#autovacuum_vacuum_threshold = 50	# min number of row updates before
					# vacuum
#autovacuum_vacuum_insert_threshold = 1000	# min number of row inserts
					# before vacuum; -1 disables insert
					# vacuums
#autovacuum_analyze_threshold = 50	# min number of row updates before
					# analyze
#autovacuum_vacuum_scale_factor = 0.2	# fraction of table size before vacuum
#autovacuum_vacuum_insert_scale_factor = 0.2	# fraction of inserts over table
					# size before insert vacuum
#autovacuum_analyze_scale_factor = 0.1	# fraction of table size before analyze
#autovacuum_freeze_max_age = 200000000	# maximum XID age before forced vacuum
					# (change requires restart)
#autovacuum_multixact_freeze_max_age = 400000000	# maximum multixact age
					# before forced vacuum
					# (change requires restart)
#autovacuum_vacuum_cost_delay = 2ms	# default vacuum cost delay for
					# autovacuum, in milliseconds;
					# -1 means use vacuum_cost_delay
#autovacuum_vacuum_cost_limit = -1	# default vacuum cost limit for
					# autovacuum, -1 means use
					# vacuum_cost_limit


#------------------------------------------------------------------------------
# CLIENT CONNECTION DEFAULTS
#------------------------------------------------------------------------------

# - Statement Behavior -

#client_min_messages = notice		# values in order of decreasing detail:
					#   debug5
					#   debug4
					#   debug3
					#   debug2
					#   debug1
					#   log
					#   notice
					#   warning
					#   error
#search_path = '"$user", public'	# schema names
#row_security = on
#default_table_access_method = 'heap'
#default_tablespace = ''		# a tablespace name, '' uses the default
#default_toast_compression = 'pglz'	# 'pglz' or 'lz4'
#temp_tablespaces = ''			# a list of tablespace names, '' uses
					# only default tablespace
#check_function_bodies = on
#default_transaction_isolation = 'read committed'
#default_transaction_read_only = off
#default_transaction_deferrable = off
#session_replication_role = 'origin'
#statement_timeout = 0			# in milliseconds, 0 is disabled
#lock_timeout = 0			# in milliseconds, 0 is disabled
#idle_in_transaction_session_timeout = 0	# in milliseconds, 0 is disabled
#idle_session_timeout = 0		# in milliseconds, 0 is disabled
#vacuum_freeze_table_age = 150000000
#vacuum_freeze_min_age = 50000000
#vacuum_failsafe_age = 1600000000
#vacuum_multixact_freeze_table_age = 150000000
#vacuum_multixact_freeze_min_age = 5000000
#vacuum_multixact_failsafe_age = 1600000000
#bytea_output = 'hex'			# hex, escape
#xmlbinary = 'base64'
#xmloption = 'content'
#gin_pending_list_limit = 4MB
#createrole_self_grant = ''		# set and/or inherit

# - Locale and Formatting -

datestyle = 'iso, mdy'
#intervalstyle = 'postgres'
timezone = 'Asia/Jakarta'
#timezone_abbreviations = 'Default'     # Select the set of available time zone
					# abbreviations.  Currently, there are
					#   Default
					#   Australia (historical usage)
					#   India
					# You can create your own file in
					# share/timezonesets/.
#extra_float_digits = 1			# min -15, max 3; any value >0 actually
					# selects precise output mode
#client_encoding = sql_ascii		# actually, defaults to database
					# encoding

# These settings are initialized by initdb, but they can be changed.
lc_messages = C				# locale for system error message
					# strings
lc_monetary = C				# locale for monetary formatting
lc_numeric = C				# locale for number formatting
lc_time = C				# locale for time formatting

#icu_validation_level = warning		# report ICU locale validation
					# errors at the given level

# default configuration for text search
default_text_search_config = 'pg_catalog.english'

# - Shared Library Preloading -

#local_preload_libraries = ''
#session_preload_libraries = ''
#shared_preload_libraries = ''	# (change requires restart)
#jit_provider = 'llvmjit'		# JIT library to use

# - Other Defaults -

#dynamic_library_path = '$libdir'
#gin_fuzzy_search_limit = 0


#------------------------------------------------------------------------------
# LOCK MANAGEMENT
#------------------------------------------------------------------------------

#deadlock_timeout = 1s
#max_locks_per_transaction = 64		# min 10
					# (change requires restart)
#max_pred_locks_per_transaction = 64	# min 10
					# (change requires restart)
#max_pred_locks_per_relation = -2	# negative values mean
					# (max_pred_locks_per_transaction
					#  / -max_pred_locks_per_relation) - 1
#max_pred_locks_per_page = 2            # min 0


#------------------------------------------------------------------------------
# VERSION AND PLATFORM COMPATIBILITY
#------------------------------------------------------------------------------

# - Previous PostgreSQL Versions -

#array_nulls = on
#backslash_quote = safe_encoding	# on, off, or safe_encoding
#escape_string_warning = on
#lo_compat_privileges = off
#quote_all_identifiers = off
#standard_conforming_strings = on
#synchronize_seqscans = on

# - Other Platforms and Clients -

#transform_null_equals = off


#------------------------------------------------------------------------------
# ERROR HANDLING
#------------------------------------------------------------------------------

#exit_on_error = off			# terminate session on any error?
#restart_after_crash = on		# reinitialize after backend crash?
#data_sync_retry = off			# retry or panic on failure to fsync
					# data?
					# (change requires restart)
#recovery_init_sync_method = fsync	# fsync, syncfs (Linux 5.8+)


#------------------------------------------------------------------------------
# CONFIG FILE INCLUDES
#------------------------------------------------------------------------------

# These options allow settings to be loaded from files other than the
# default postgresql.conf.  Note that these are directives, not variable
# assignments, so they can usefully be given more than once.

#include_dir = '...'			# include files ending in '.conf' from
					# a directory, e.g., 'conf.d'
#include_if_exists = '...'		# include file only if it exists
#include = '...'			# include file


#------------------------------------------------------------------------------
# CUSTOMIZED OPTIONS
#------------------------------------------------------------------------------

# Add settings for extensions here
```

You have to adjust the IP for `"listen_addresses"` with your OpenBSD server IP Address. In writing this article our OpenBSD server uses the IP "192.168.5.3". After that you change a little script from the file **"/var/postgresql/data/pg_hba.conf"**, so that it can connect to the OpenBSD server IP Address.

```console
host    all             all             192.168.5.0/24            trust
host    replication     all             192.168.5.0/24            trust
```

## 6. Running PostgreSQL

After you have set everything according to the instructions above, now we try to run PostgreSQL by creating a new database.

```yml
ns2# psql -U postgres
Password for user postgres:
psql (16.4)
Type "help" for help.

postgres=#
```

When you have successfully logged into the PostgreSQL database system, you can create users, databases or anything else related to the database.

```yml
postgres=# CREATE ROLE bromo SUPERUSER;
postgres=# ALTER ROLE bromo PASSWORD 'ranupani1234'
postgres-# ALTER USER bromo PASSWORD 'ranupani1234' LOGIN;
postgres=# \q
```

After you exit the PostgreSQL database, now you log in with the user `"bromo"`.

```yml
ns2# psql postgres bromo
Password for user bromo:
psql (16.4)
Type "help" for help.

postgres=# select user;
 user
-------
 bromo
(1 row)
```

After that, try creating a database named `"oroombo"`.

```yml
postgres=# CREATE DATABASE oroombo;
CREATE DATABASE
```

Of course, PostgreSQL can run fine on OpenBSD systems. PostgreSQL can also be managed via the integrated service handler, named rcctl and its rc scripts, as well as manually via PostgreSQL utilities (e.g., pg_ctl).
