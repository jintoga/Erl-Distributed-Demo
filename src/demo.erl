%% @author DAT 
-module(demo). 
-export([make_request/2, game/0, start/0, tanker/0, startGame/0, startTanker/0]).
 
make_request(Id, Msg) -> Id ! Msg.

game() ->
	io:format("~nGame: waiting", []),
    receive
        {game_started, Tanker_Pid} -> 
			io:format("~nGame: started", []), 
			make_request(Tanker_Pid, game_started)
            
    end.

tanker() -> 
	io:format("~nTanker: waiting", []),
	receive
        game_started -> io:format("~nTanker: Making request", []),
						make_request(game_pid, game_started)
	end,
	tanker().

startTanker() ->    
	global:register_name(tanker_pid, spawn(fun() -> tanker() end)).

startGame() -> 
	global:register_name(game_pid, spawn(fun() -> game() end)).

start() -> 
	Game_Pid = global:whereis_name(game_pid),
	Tanker_Pid = global:whereis_name(tanker_pid),
	make_request(Game_Pid, {game_started, Tanker_Pid}).
