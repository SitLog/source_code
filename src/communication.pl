/*******************************************************************************
    SitLog (Situation and Logic) 
    
    Copyright (C) 2012 UNAM (Universidad Nacional Autónoma de México)
    Copyright (C) 2009 Ivan Meza (http://turing.iimas.unam.mx/~ivanvladimir)
    Copyright (C) 2014 Gibran Fuentes Pineda (http://turing.iimas.unam.mx/~gibranfp)

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

% Format is Situation_Type(Expected_Intentions,Interpretation)

%%%%%%%%%%%%%%%%%%%%%%%%% Global variables %%%%%%%%%%%%%%%%%%%%%%%%
:- dynamic name/1.
:- consult(registered_topics).
% Declaration of capabilities
initial_solvables([]).

% The entry point for agent
runtime_entry(run) :- 
  run.

% Initializes SitLog ROS node
start_com :-    
    assert(user:library_directory('$GOLEM_IIMAS_HOME/rosagents/devel/lib')),
    use_foreign_library(foreign('librosswipl.so')),
    rosswipl_init('sitlog'),
    register_all,
    thread_create(rosswipl_spin, SpinThreadID, [at_exit(rosswipl_shutdown), alias(spin_thread)]),
    at_halt(rosswipl_shutdown),
    format('Connected to roscore').

% Run dialogue manager.
app_init :-
  write('The agent did not respond.'), nl,
  current_output(Output), 
  flush_output(Output),
  halt(0).
