/*******************************************************************************
    SitLog (Situation and Logic) 
    
    Copyright (C) 2012 UNAM (Universidad Nacional Autónoma de México)
    Copyright (C) 2010 Ivan Meza (http://turing.iimas.unam.mx/~ivanvladimir)

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
%%%%%%%%%%%%%%%%%%%%%%%%% Loads saving functions %%%%%%%%%%%%%%%%%%%%%%%%%%

create_dialogue(DirSave,Sys):-
  datime_label(Sys,DayFileName,Prefix),

  (absolute_file_name(DayFileName, AbsOutputFile,[relative_to(DirSave)]),
  atom_concat(DirSave,'_wav',DirSaveWav),
  absolute_file_name(Prefix, AbsWavPrefix,[relative_to(DirSaveWav)]),
  open(AbsOutputFile,write,Stream)) ->
    format('Saving conversation in:~n    ~w~n~n',
    [AbsOutputFile]),
    format('Saving wav logs in in:~n    ~w~n~n',
    [AbsWavPrefix]),

    user:assert(day_stream(Stream)),
    user:assert(day_prefix(Prefix)),
    user:assert(day_wavlog(AbsWavPrefix))
  | otherwise ->
    format('Specified saving dir (~w/~w)~n', [DirSave,dayFileName]),
    format('    cannot be written.  Using stderr', []),
    user:assert(day_stream(user_error)),
    user:assert(day_prefix('now'))
.

close_dialogue :-
  day_stream(Stream),
  day_prefix(Prefix),
  close(Stream),
  user:retract(day_stream(Stream)),
  user:retract(day_prefix(Prefix)).

datime_label(Sys,DayFileName,Prefix):-
    get_time(TimeStamp),
    stamp_date_time(TimeStamp,date(Year,Month,Day,Hour,Min,Sec,_,_,_), 0),
    number_chars(Year,Year_),
    atom_codes(YYear,Year_),
    number_chars(Month,Month_),
    f_0(Month_,Month__),
    atom_codes(MMonth,Month__),
    number_chars(Day,Day_),
    f_0(Day_,Day__),
    atom_codes(DDay,Day__),
    number_chars(Hour,Hour_),
    atom_codes(HHour,Hour_),
    number_chars(Min,Min_),
    atom_codes(MMin,Min_),
    atom_concat(Sys,'_',Sys_),
    atom_concat(Sys_,DDay,D),
    atom_concat(D,MMonth,DM),
    atom_concat(DM,YYear,DMY),
    atom_concat(DMY,'_',DMY_),
    atom_concat(DMY_,HHour,DMY_H),
    atom_concat(DMY_H,':',DMY_H_),
    atom_concat(DMY_H_,MMin,Prefix),
    atom_concat(Prefix,'.txt',DayFileName)
.
    
f_0([A],[B,A]) :- number_chars(0,[B]).

f_0([A,B],[A,B]).

save_info(Type,MSG,ARGS):-
  day_stream(Stream),
  ( Type == first_level ->
    save_level(1,MSG,ARGS)
  | Type == second_level ->
    save_level(2,MSG,ARGS)
  | Type == third_level ->
    save_level(3,MSG,ARGS)
  | Type == feat ->
    format(Stream,MSG,[]),
    format(Stream,':',[]),
    format(Stream,'~n',[]),
    sep(9,P),
    format(Stream,P,[]),
    save_val(MSG,ARGS)
  | otherwise ->
    format(Stream,MSG,Args)
  ),
  flush_output(Stream).

save_val(TIME,_):-
  memberchk(TIME,['TIME','INITIME','FINTIME']),
  day_stream(Stream),
    get_time(TimeStamp),
    stamp_date_time(TimeStamp,date(Year,Month,Day,Hour,Min,Sec,_,_,_), 0),
  ( Month < 10, Day < 10 ->
    format(Stream,'~w0~w0~w-~w:~w:~w',[Year,Month,Day,Hour,Min,Sec])
  | Month < 10 ->
    format(Stream,'~w0~w0~w-~w:~w:~w',[Year,Month,Day,Hour,Min,Sec])
  | Day < 10 ->
    format(Stream,'~w~w0~w-~w:~w:~w',[Year,Month,Day,Hour,Min,Sec])
  | otherwise ->
    format(Stream,'~w~w~w-~w:~w:~w',[Year,Month,Day,Hour,Min,Sec])
  ),   
  format(Stream,'~n',[]).

save_val(_,[]).

save_val(_,[VAL]):-
  day_stream(Stream),
  format(Stream,'~w',[VAL]),
  format(Stream,'~n',[]).

save_val(F,[VAL|R]):-
  day_stream(Stream),
  format(Stream,'~w, ',[VAL]),
  save_val(F,R).

save_level(L,MSG,ARGS) :-
  day_stream(Stream),
  format(Stream,'~n',[]),
  format(Stream,MSG,ARGS),
  format(Stream,'~n',[]),
  sep(L,S),
  format(Stream,S,[]),
  format(Stream,'~n',[]),
  format(Stream,'~n',[]).


sep(1,'---------------------------------------------------------------------------------').
sep(2,'=================================================================================').
sep(3,':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::').
sep(9,'    ').

test_save:-
  create_daylogue(con,file),
  save_info(first_level,'header',[]),
  save_info(feat,'time',[]),
  save_info(feat,'List',[helo,helo]),
  save_info(first_level,'utts',[]),
  save_info(second_level,'utt',[]).

