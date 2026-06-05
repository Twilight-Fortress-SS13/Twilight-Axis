/proc/byond_tracy_init()
	var/lib

	switch(world.system_type)
		if(MS_WINDOWS)
			lib = "prof.dll"
		if(UNIX)
			lib = "libprof.so"
		else
			CRASH("unsupported platform")

	var/init = call_ext(lib, "init")()
	if("0" != init)
		CRASH("[lib] init error: [init]")
