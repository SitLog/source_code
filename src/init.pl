/*******************************************************************************
    Sitlog (Situation and Logic) 

    Copyright (C) 2012 UNAM (Universidad Nacional Autónoma de México)
    Copyright (C) 2012 Luis Pineda (http://turing.iimas.unam.mx/~lpineda/)
    Copyright (C) 2012 Ivan Meza (http://turing.iimas.unam.mx/~ivanvladimir)
    Copyright (C) 2012 Lisset Salinas (http://turing.iimas.unam.mx/~liz)

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

:- style_check(-singleton).

:- op(600,xfx,':').
:- op(800,xfx,'=>').
:- op(850,xfx,'=>>').
:- op(900,xfx,'==>').


%:- use_module(library(terms),all).
%:- use_module(library(system)).
%:- use_module(library(lists)).
%:- use_module(library(clpfd)).
%:- use_module(library(random)).

%%%%%%%%%%%%%%%%%%%%%%%%% Executable setting %%%%%%%%%%%%%%%%%%%%%%%%%
dm_version('ene_051012').

%%%%%%%%%%%%%%%%%%%%%%%%% Loading local libraries %%%%%%%%%%%%%%%%%%%%%%%%%%

% Interpreter for Dialogue Models 
:- consult(diag_manager).

% Extra system calls
:- consult(read_input).
:- consult(utilities).
:- consult(gensym).
:- consult(bindings).
:- consult(interp_exps).
:- consult(interpret_input).
:- consult(exec_actions).
:- consult(history_utilities).
:- consult(kb_manager).
:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/knowledge_base/change_KB.pl').
:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/knowledge_base/parser.pl').
:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/knowledge_base/cognitive_model.pl').
:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/knowledge_base/diagnostician.pl').
:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/knowledge_base/decision_maker.pl').
:- consult('$GOLEM_IIMAS_HOME/rosagents/SitLog/knowledge_base/planner.pl').

%% % File with connection information to execute communicate models with algorithms
:- consult(communication). 
:- consult(in_communication).
:- consult(out_communication).
:- consult(json_to_ioca).

% Files for making and saving logs
:- consult(messages).   
:- consult(loggin).
:- consult(sets).

%%%%%%%%%%%%%%%%%%%%%%%%% Description for command line options %%%%%%%%%%%%%%%%%%%%%%%%%%
option_spec(
	[ 
	    [
	    	opt(basic_actions), 
	    	meta('FILE'), 
	    	type(atom), 
	    	default('basic_actions.pl'),
	    	shortflags([b]), 
	    	longflags(['basic-actions'] ),
	    	help(['Basic actions to execute    (basic_actions.pl)'])
	    ],
	    [
	    	opt(templates), 
	    	meta('FILE'), 
	    	type(atom), 
	    	default('templates.pl'),
	    	shortflags([t]), 
	    	longflags(['templates'] ),
	    	help(['Templates to use      (templates.pl)'])
	    ],
	    [
	    	opt(user_functions), 
	    	meta('FILE'), 
	    	type(atom), 
	    	default('user_functions.pl'),
	    	shortflags([u]), 
	    	longflags(['user-functions'] ),
	    	help(['User functions        (user_functions.pl)'])
	    ],
	    [
	    	opt(global_vars), 
	    	meta('FILE'), 
	    	type(atom), 
	    	default('global_vars.pl'),
	    	shortflags([g]), 
	    	longflags(['global-vars'] ),
	    	help(['Global vars       (global_vars.pl)'])
	    ],
	    [
		opt(expectation_types), 
	    	meta('FILE'), 
	    	type(atom), 
	    	default('expectation_types.pl'),
	    	shortflags([e]), 
	    	longflags(['expectation_types'] ),
	    	help(['Expectation types        (expectation_types.pl)'])
	    ],
	    [
	    	opt(mode), 
	    	type(atom), 
	    	default(true),
	    	shortflags([m]), 
	    	longflags(['mode'] ),
	    	help(['Mode of executing\n\t\trun - OAA\n\t\ttest - Not OAA'])
	    ],
	    [
	    	opt(no_save), 
	    	type(boolean),
	    	default(false),
	    	shortflags([n]), 
	    	longflags(['no-save'] ),
	    	help(['Mode of executing\n\t\trun - OAA\n\t\ttest - Not OAA'])
	    ],
	    [
		opt(save_dir), 
		meta('FILE'),
		type(atom), 
		default('./log'),
		shortflags([s]), 
		longflags(['save-dir'] ),
		help('Directory for saving logs (./log)')
	    ],
	    [
	    	opt(label_sys), 
	    	type(atom), 
	    	default('dm_'),
	    	shortflags([a]), 
	    	longflags(['label-sys'] ),
	    	help(['System prefix for logfile'])
	    ],
	    [
	    	opt(debugging),
 	    	meta('FILE'), 
	    	type(atom), 
	    	default('dm.log'),
	    	shortflags([d]), 
	    	longflags(['debugging']),
	    	help(['Log file to save information (dm.log)'])
	    ],
	    [
	    	opt(verbose), 
	    	type(boolean), 
	    	default(true),
	    	shortflags([v]), 
	    	longflags(['verbose'] ),
	    	help(['Verbose mode, [debug,info] (info)'])
	    ],
	    [
	    	opt(copyright), 
	    	type(boolean),
	    	default(false),
	    	shortflags([c]), 
	    	longflags(['copyright'] ),
	    	help(['Prints copyright'])
	    ],
	    [
	    	opt(license), 
	    	type(boolean), 
	    	default(false),
	    	shortflags([i]), 
	    	longflags(['license'] ),
	    	help(['Prints license'])
	    ],
	    [
	    	opt(version), 
	    	type(boolean), 
	    	default(false),
	    	shortflags([o]), 
	    	longflags(['version'] ),
	    	help(['Prints version'])
	    ],
	    [
	    	opt(help), 
	    	type(boolean), 
	    	default(false),
	    	shortflags([h]), 
	    	longflags(['help'] ),
	    	help(['Prints help'])
	    ]
	]
    ).

get_option_value(Opts, Val) :- 
    unify_option(Opts, Val).

unify_option([], Val).

unify_option([Val|RestOpts], Val).

unify_option([_|RestOpts], Val) :- unify_option(RestOpts, Val).


dm_version('0.0.2').

copyright('\n
-------------------------------------------------------------------------------
Copyright (C) 2012 UNAM (Universidad Nacional Autónoma de México)
Copyright (C) 2012  Luis Pineda (http://turing.iimas.unam.mx/~lpineda/)
Copyright (C) 2012  Golem Group (http://golem.iimas.unam.mx)
-------------------------------------------------------------------------------
').

license('\n\c
-------------------------------------------------------------------------------\c
    This program is free software: you can redistribute it and/or modify\c
    it under the terms of the GNU General Public License as published by\c
    the Free Software Foundation, either version 3 of the License, or\c
    any later version.\c
    \c
    This program is distributed in the hope that it will be useful,\c
    but WITHOUT ANY WARRANTY; without even the implied warranty of\c
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\c
    GNU General Public License for more details.\c
    You should have received a copy of the GNU General Public License\c
    along with this program.  If not, see <http://www.gnu.org/licenses/>.\c
-------------------------------------------------------------------------------\c
').

print_sitlog_info(Text, true) :-
    print(Text), 
    nl, 
    halt.

print_sitlog_info(_, _).

start_init :-
    % Parsing command line options
    option_spec(OptsSpec),
    opt_arguments(OptsSpec, Opts, [ProjDir, MainDM, In_Arg, ModelFiles, KBFile, SitLogDir]),
    get_option_value(Opts,basic_actions(Basic_ActionsF)), 
    get_option_value(Opts,templates(TemplatesFile)), 
    get_option_value(Opts,global_vars(In_Global_VarsF)), 
    get_option_value(Opts,user_functions(UserFunctionsFile)), 
    get_option_value(Opts,expectation_types(ExpectationTypes)), 
    get_option_value(Opts,state(State_file)), 
    get_option_value(Opts,mode(Mode)), 
    get_option_value(Opts,no_save(NoSave)), 
    get_option_value(Opts,save_dir(SaveDir)), 
    get_option_value(Opts,debugging(LogFile)), 
    get_option_value(Opts,verbose(Verbose)),
    get_option_value(Opts,copyright(CopyrightFlag)),
    get_option_value(Opts,license(LicenseFlag)),
    get_option_value(Opts,version(VersionFlag)),
    get_option_value(Opts,help(HelpFlag)),

    copyright(TextCopyright),
    print_sitlog_info(TextCopyright,CopyrightFlag),
    copyright(TextLicense),
    print_sitlog_info(TextLicense,LicenseFlag),
    copyright(TextVersion),
    print_sitlog_info(TextVersin,VersionFlag),
    copyright(TextHelp),
    print_sitlog_info(TextHelp,HelpFlag),

    ( NoSave ->
	assert(save(false))
    | otherwise ->
	assert(save(true))
    ),

    assert(mode_exe(Mode)),
    ( mode_exe(test) ->
	  print('Executing in test mode '), nl
    | otherwise ->
	  start_com,
	  print('Executing in run mode '), nl
    ),
    
    create_log_file(ProjDir,Verbose,LogFile),
    create_dialogue(SaveDir,dm),
    write_log(inflog,'Running models from     : ~w',[ModelFiles]),
    write_log(inflog,'Project directory       : ~w',[ProjDir]),
    write_log(inflog,'Knowledge base          : ~w',[KBFile]),
    write_log(inflog,'User Functions          : ~w',[UserFunctionsFile]),
    write_log(inflog,'Expectation Types       : ~w',[ExpectationTypes]),
    write_log(inflog,'Basic acts              : ~w',[Basic_ActionsF]),
    write_log(inflog,'Templates               : ~w',[TemplatesFile]),
    write_log(inflog,'Running dialogue        : ~w',[MainDM]),
    write_log(inflog,'Writing debug file to   : ~w',[LogFile]),
    write_log(inflog,'Saving log file to      : ~w',[SaveDir]),

    assert(user:file_search_path(sictusdir,SitLogDir)),
    assert(user:file_search_path(projdir,ProjDir)),
    assert(int_arg(In_Arg)),
    assert(models(ModelFiles)),
    assert(global_varsf(In_Global_VarsF)),
    assert(basic_actions(Basic_ActionsF)),
    assert(templates(TemplatesFile)),
    assert(userfunctions(UserFunctionsFile)),
    assert(expectationtypes(ExpectationTypes)),
    assert(knowledge_base(KBFile)),
    assert(main(MainDM)),

    load,


    write_log(inflog,'Starting dialogue: ~w',[MainDM]),
    
    save_info(first_level,'HEADER',[]),
    save_info(feat,'TIME',[]),
    save_info(feat,'VERSION',[VER]),
    save_info(feat,'PROJDIR',[ProjDir]),
    save_info(feat,'IN ARG',[In_Arg]),
    save_info(feat,'KB',[KBFile]),
    save_info(feat,'USERFUNC',[UserFunctionsFile]),
    save_info(feat,'BASACTS',[Basic_ActionsF]),
    save_info(feat,'TEMPLATE',[TemplatesFile]),
    save_info(feat,'GLOBAL VARS',[In_Global_VarsF]),
    write_log(inflog,'Saving log in: ~w/~w.txt',[SaveDir,'dm']),
    repeat,
    
    % Executes Dialogue Model
    main,

    write_log(inflog,'History: ~w.',[Out_History]),
    end_dm.

