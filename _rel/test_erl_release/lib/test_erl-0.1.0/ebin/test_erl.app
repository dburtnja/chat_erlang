{application, 'test_erl', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['http_handler','logins_handler','my_handler','reg','test_erl_app','test_erl_sup']},
	{registered, [test_erl_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{mod, {test_erl_app, []}},
	{env, []}
]}.