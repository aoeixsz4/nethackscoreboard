-- === logfiles table ===
--
-- logfiles_i
-- Integer used to reference the logfiles entry; note that it is
-- also referenced from nhdb configuration (nhdb-def.json)! Don't
-- change this, preferably. Also, for /dev/null games, this id
-- MUST be the year of the tournament. See function process_streaks()
-- in nhdb-stats.pl.
--
-- descr
-- Description of the entry; only shown on the About page
--
-- server
-- Three letter server acronym in lowercase (such as "nao" for
-- nethack.alt.org, "ade" for acehack.de etc.).
--
-- variant
-- Variant acronym in lowercase (such as "nh" for vanilla NetHack,
-- "ace" for AceHack, "nh4" for NetHack4 etc.)
--
-- version
-- This is used as an additional distinguisher that can be acted upon
-- (primarily by the feeder to modify its parsing behaviour).
--
-- logurl
-- Fully qualified URL of xlogfile.
--
-- localfile
-- Filename of a logfile on local filesystem.
--
-- dumpurl
-- Determines location of the game dumps
--
-- rcfileurl
-- Determines location of player rc files
--
-- options
-- Defines options for the logfile, usually some special handling. Currently
-- defined options are:
--
--  * bug360duration - do not show the duration to the user, this exists
--      because NetHack 3.6.0 was recording bogus 'realtime' field into
--      xlogfile
--
--  * base64xlog - this allows using base64 encoded data in xlogfile, the
--      fields should have same name with '64' appended; if such encoded
--      field exists, it is preferred to plain unencoded field
--
--  * devnull - this marks logfile as being from the /dev/null/nethack
--      tournament, which means that it has slightly different format that
--      needs to be accommodated
-- 
-- oper
-- If true, the feeder will process this entry; if false the logfile
-- will not be processed, essentially it won't exist for the feeder.
-- This has no effect on games alread in the database and stats
-- generator will still load all logfiles and process all games in db.
-- Note, that if a full db reload is needed, oper must be set to true
-- for the logfile to be reloaded! 
--
-- static
-- If true, the feeder will not try to download the file from logurl,
-- even if it is defined. This allows static logfiles to be part of the
-- dataset (such as devnull logfiles, logfiles from discontinued sites etc.)
-- In general, if you want to use static file, you probably also want 
-- to set 'oper' to false.
--
-- tz
-- Time zone used for this logfile
--
-- fpos
-- Last file position; this is the file position the feeder will
-- read the file from on the next run. After the feeder has run and
-- processed the logfile, it is set to the log's filesize. By resetting
-- this field, one forces the whole logfile to be parsed and fed into
-- db again (but that won't erase the redundant db entries!)
--
-- lines
-- Number of lines read so far. This is used to number the entries in the
-- games table. This doesn't need to be the number of entries in the database,
-- as some lines could possibly be rejected.
--
-- lastchk
-- Time of last processing of the logfile.


DROP TABLE IF EXISTS logfiles;

CREATE TABLE logfiles (
  logfiles_i  int,
  descr       varchar(64),
  server      varchar(3) NOT NULL,
  variant     varchar(3) NOT NULL,
  logurl      varchar(128),
  localfile   varchar(128) NOT NULL UNIQUE,
  dumpurl     varchar(128),
  rcfileurl   varchar(128),
  options     varchar(16) ARRAY,
  oper        boolean DEFAULT TRUE,
  static      boolean DEFAULT FALSE,
  tz          varchar(32) DEFAULT 'UTC',
  fpos        bigint,
  lines       int,
  lastchk     timestamp with time zone,
  PRIMARY KEY (logfiles_i)
);

GRANT SELECT, UPDATE ON logfiles TO nhdbfeeder;
GRANT SELECT ON logfiles TO nhdbstats;



