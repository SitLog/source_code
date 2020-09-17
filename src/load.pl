:- use_module(init).
:- use_module(read_input).
:- use_module(utilities).
:- use_module(gensym).
:- use_module(bindings).
:- use_module(interp_exps).
:- use_module(interpret_input).
:- use_module(diag_manager).
:- use_module(exec_actions).
:- use_module(history_utilities).
:- use_module(kb_manager).
:- use_module('$GOLEM_IIMAS_HOME/rosagents/SitLog/knowledge_base/change_KB.pl').

:- use_module(communication).
:- use_module(in_communication).
:- use_module(out_communication).

:- use_module(messages).
:- use_module(loggin).
:- use_module(sets).

go :- 
    start_init.
