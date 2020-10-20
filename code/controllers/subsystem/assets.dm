SUBSYSTEM_DEF(assets)
	name = "Assets"
	init_order = INIT_ORDER_ASSETS
	flags = SS_NO_FIRE
	var/list/cache = list()
	var/list/preload = list()
	var/datum/asset_transport/transport = new()

/datum/controller/subsystem/assets/OnConfigLoad()
	var/newtransporttype = /datum/asset_transport
	switch (CONFIG_GET(string/asset_transport))
		if ("webroot")
			newtransporttype = /datum/asset_transport/webroot
	
	if (newtransporttype == transport.type)
		return

	var/datum/asset_transport/newtransport = new newtransporttype ()
	if (newtransport.validate_config())
		transport = newtransport
	transport.Load()



/datum/controller/subsystem/assets/Initialize(timeofday)

	var/list/priority_assets = list(
		/datum/asset/simple/oui_theme_nano,
		/datum/asset/simple/goonchat
		)

	for(var/type in priority_assets)
		var/datum/asset/A = new type()
		A.register()
	
	for(var/type in typesof(/datum/asset) - (priority_assets | list(/datum/asset, /datum/asset/simple)))
		var/datum/asset/A = type
		if (type != initial(A._abstract))
			get_asset_datum(type)

	transport.Initialize(cache)

	..()
