ACX.ConVars = {}

ACX.ConVars["cycle"] = CreateConVar("acx_cycle", "2", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Cycle mode. 0 - release. 1 - click. 2 - drag down.", 0, 2)
ACX.ConVars["autoaim"] = CreateConVar("acx_autoaim", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Autoaim mode. 0 - off. 1 - on.", 0, 1)
ACX.ConVars["dynamic_reload"] = CreateConVar("acx_dynamic_reload", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Dynamic reload mode. 0 - off. 1 - on.", 0, 1)
ACX.ConVars["akimbo"] = CreateConVar("acx_akimbo", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Akimbo mode. 0 - off. 1 - on. Why would you turn this off?", 0, 1)