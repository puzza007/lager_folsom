-module(lager_folsom_backend).

-behaviour(gen_event).

-export([init/1]).
-export([handle_event/2]).
-export([handle_call/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).

-define(DEFAULT_LEVEL, info).
-define(LEVELS, [debug, info, notice, warning, error, critical, alert, emergency]).

-record(state, {level :: lager:log_level_number()}).

init(Args) ->
    Level = arg(level, Args, ?DEFAULT_LEVEL),
    LevelNumber = lager_util:level_to_num(Level),
    [folsom_metrics:new_spiral(metric_name(M)) || M <- ?LEVELS],
    {ok, #state{level = LevelNumber}}.

arg(Name, Args, Default) ->
    case lists:keyfind(Name, 1, Args) of
        {Name, Value} -> Value;
        false         -> Default
    end.

handle_call({set_loglevel, Level}, State) ->
    LevelNumber = lager_util:level_to_num(Level),
    {ok, ok, State#state{level = LevelNumber}};
handle_call(get_loglevel, #state{level = LevelNumber} = State) ->
    Level = lager_util:num_to_level(LevelNumber),
    {ok, Level, State};
handle_call(_Request, State) ->
    {ok, ok, State}.

handle_event({log, Message}, State) ->
    _ = handle_log(Message, State),
    {ok, State};
handle_event(_Event, State) ->
    {ok, State}.

handle_log(LagerMsg, #state{level = Level}) ->
    Severity = lager_msg:severity(LagerMsg),
    case lager_util:level_to_num(Severity) =< Level of
        true ->
            Name = metric_name(Severity),
            ok = folsom_metrics:notify({Name, 1});
        false -> skip
    end.

handle_info(_Info, State) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

metric_name(debug)     -> <<"lager.debug">>;
metric_name(info)      -> <<"lager.info">>;
metric_name(notice)    -> <<"lager.notice">>;
metric_name(warning)   -> <<"lager.warning">>;
metric_name(error)     -> <<"lager.error">>;
metric_name(critical)  -> <<"lager.critical">>;
metric_name(alert)     -> <<"lager.alert">>;
metric_name(emergency) -> <<"lager.emergency">>.

