/*******************************************************************************
    SitLog (Situation and Logic) 
    
    Copyright (C) 2012 UNAM (Universidad Nacional Autónoma de México)
    Copyright (C) 2009 Ivan Meza (http://turing.iimas.unam.mx/~ivanvladimir)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

*********************************************************************************/

%%%%%%%%%%%%%%%%%%%%%%%%% Loads logging functions %%%%%%%%%%%%%%%%%%%%%%%%%

create_log_file(ProjDir,ModeLabel,LogFile):-
  %print('LogFile: '),print(LogFile),nl,
  modenum(ModeLabel,Mode,_),
  (absolute_file_name(LogFile, AbsOutputFile,[relative_to(ProjDir)]),
  %print('AbsOutputFile: '),print(AbsOutputFile),nl,
  open(AbsOutputFile,write,Stream)) ->
    format('Log file:~n    ~w~n~n',
    [AbsOutputFile]),
    user:assert(log_stream(Stream,user)),
    user:assert(log_mode(Mode))
  | otherwise ->
    format('Specified log file (~w)~n', [LogFile]),
    format('    cannot be written.  Using stderr0000000', []),
    user:assert(log_stream(user_error,sys)),
    user:assert(log_mode(Mode))
  .

  modenum(errlog  ,0,'Error').
  modenum(inflog  ,1,'Info-Level 1').
  modenum(inflog2 ,2,'Info-Level 2').
  modenum(deblog  ,3,'Debug').
  modenum(structlog,4,'Structs').
  modenum(X       ,5,'All').

write_log(ModeLabel,MSG,Args):-
  log_mode(LogMode),
  modenum(ModeLabel,Mode,SLog),
  ( (Mode =< LogMode) ->
    log_stream(Stream,_),
    get_time(TimeStamp),
    stamp_date_time(TimeStamp,date(Year,Month,Day,Hour,Min,Sec,_,_,_), 0),
    format(Stream,'[~w/~w/~w,~w:~w:~w]~w: ',[Year,Month,Day,Hour,Min,Sec,SLog]),
    format(Stream,MSG,Args),
    format(Stream,'~n',[]),
    flush_output(Stream)
  | otherwise ->
    true
  ).

test_logging:-
  create_log_file(errlog,file),
  write_log(errlog,'Logged',[]),
  write_log(log,'No logged',[]).

