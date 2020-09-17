/*******************************************************************************
    SitLog (Situation and Logic) 
    
    Copyright (C) 2012 UNAM (Universidad Nacional Autónoma de México)
    Copyright (C) 2012 Luis Pineda (http://turing.iimas.unam.mx/~lpineda/)

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

%:- use_module(library(charsio)).

% Reads file with file IDs, and creates a list with all clauses in every files IDs.
load_list_of_files(Files_ids, Clause_List) :-
  load_file(Files_ids, Files_List),
  get_clauses_files(Files_List, Clause_List).

load_list_of_files(ProjDir,Files_ids, Clause_List) :-
  load_file(ProjDir,Files_ids, Files_List),
  get_clauses_files(ProjDir,Files_List, Clause_List)
.

get_clauses_files(ProjDir,[], Clauses_List).
get_clauses_files(ProjDir,[H|T], Clause_List) :-
  load_file(ProjDir,H, Clauses_File),
  get_clauses_files(ProjDir,T, Rest_Clauses),
  append(Clauses_File, Rest_Clauses, Clause_List).

get_clauses_files([], Clauses_List).
get_clauses_files([H|T], Clause_List) :-
  load_file(H, Clauses_File),
  get_clauses_files(T, Rest_Clauses),
  append(Clauses_File, Rest_Clauses, Clause_List).
  

% Reads file of clauses in a list
load_file(ProjDir,RULES,CLAUSE_LIST) :-
    %print('RULES; '),print(RULES),nl,
    %print('PROJ; '),print(ProjDir),nl,
    seeing(IN),
    absolute_file_name(RULES,RULES2,[relative_to(ProjDir)]),
    see(RULES2),
    %print('RULES2; '),print(RULES2),nl,
    read_clause([],CLAUSE_LIST),
    seen,
    see(IN),
    !.

load_file(RULES,CLAUSE_LIST) :-
  seeing(IN),
  see(RULES),
  read_clause([],CLAUSE_LIST),
  seen,
  see(IN),
  !.

read_clause(INLIST,OUTLIST) :-
  read(TERM),
  next_term(TERM,INLIST,OUTLIST).

next_term(end_of_file,L,L).

next_term(TERM,INLIST,OUTLIST) :-
  append(INLIST,[TERM],LIST),
  read_clause(LIST,OUTLIST).

update_nl(STR) :-
  build_term(TERM,STR),
  new_fact(TERM).

% Evaluation enviorment creation
create_env([]).

create_env([H|T]) :-
  assert(H),
  create_env(T),
  !.
create_env(H) :-
  assert(H),
  !.

% compile an atom string of characters as a prolog term
atom_to_term(ATOM, TERM) :-
  atom(ATOM),
  atom_to_chars(ATOM,STR),
  atom_to_chars('.',PTO),
  append(STR,PTO,STR_PTO),
  read_from_chars(STR_PTO,TERM).

% compiles a string of characters as a prolog term
build_term(TERM,STR) :-
  telling(OUT),
  seeing(IN),
  name(ATOM,STR),
  tell('/tmp/gk_junk'),
  write(ATOM),
  write('.'),
  nl,
  told,
  see('/tmp/gk_junk'),
  read(TERM),
  seen,
  see(IN),
  tell(OUT),
  rename('/tmp/gk_junk',[]),
  !.

