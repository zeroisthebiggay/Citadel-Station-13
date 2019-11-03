///////////////////////////////////
//////////AutoBottler Designs//////
///////////////////////////////////

/datum/design/autobottler
	name = "Machine Design (AutoBottler)"
	desc = "Allows for the construction of circuit boards used to build an Autobottler."
	id = "autobottler"
	materials = list(MAT_GLASS = 2000)
	build_path = /obj/item/circuitboard/machine/autobottler
	category = list("Misc")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO

/datum/design/bottle
	materials = list(MAT_GLASS = 1200)
	build_type = AUTOBOTTLER
	category = list("Storge")

/datum/design/bottle/wine
	name = "Bottle Design (Wine)"
	desc = "Allows for the blowing of Wine bottles."
	id = "wine"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/wine/empty

/datum/design/bottle/rum
	name = "Bottle Design (Rum)"
	desc = "Allows for the blowing of Rum bottles."
	id = "rum"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/rum/empty

/datum/design/bottle/gin
	name = "Bottle Design (Gin)"
	desc = "Allows for the blowing of Gin bottles."
	id = "gin"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/gin/empty

/datum/design/bottle/whiskey
	name = "Bottle Design (Whiskey)"
	desc = "Allows for the blowing of Whiskey bottles."
	id = "whiskey"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/whiskey/empty

/datum/design/bottle/vodka
	name = "Bottle Design (Vodka)"
	desc = "Allows for the blowing of Vodka bottles."
	id = "vodka"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/vodka/empty

/datum/design/bottle/tequila
	name = "Bottle Design (Tequila)"
	desc = "Allows for the blowing of Tequila bottles."
	id = "tequila"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/tequila/empty

/datum/design/bottle/patron
	name = "Bottle Design (Patron)"
	desc = "Allows for the blowing of Patron bottles."
	id = "patron"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/patron/empty

/datum/design/bottle/kahlua
	name = "Bottle Design (Kahlua)"
	desc = "Allows for the blowing of Kahlua bottles."
	id = "kahlua"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/kahlua/empty

/datum/design/bottle/sake
	name = "Bottle Design (Sake)"
	desc = "Allows for the blowing of Sake bottles."
	id = "sake"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/sake/empty

/datum/design/bottle/vermouth
	name = "Bottle Design (Vermouth)"
	desc = "Allows for the blowing of Vermouth bottles."
	id = "vermouth"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/vermouth/empty

/datum/design/bottle/goldschlager
	name = "Bottle Design (Goldschlager)"
	desc = "Allows for the blowing of Goldschlager bottles."
	id = "goldschlager"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/goldschlager/empty

/datum/design/bottle/hcider
	name = "Bottle Design (Cider)"
	desc = "Allows for the blowing of Cider bottles."
	id = "hcider"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/hcider/empty

/datum/design/bottle/cognac
	name = "Bottle Design (Cognac)"
	desc = "Allows for the blowing of Cognac bottles."
	id = "cognac"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/cognac/empty

/datum/design/bottle/absinthe
	name = "Bottle Design (Absinthe)"
	desc = "Allows for the blowing of Absinthe bottles."
	id = "absinthe"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/absinthe/empty

/datum/design/bottle/grappa
	name = "Bottle Design (Grappa)"
	desc = "Allows for the blowing of Grappa bottles."
	id = "grappa"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/grappa/empty

/datum/design/bottle/fernet
	name = "Bottle Design (Fernet)"
	desc = "Allows for the blowing of Fernet bottles."
	id = "fernet"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/fernet/empty

/datum/design/bottle/applejack
	name = "Bottle Design (Applejack)"
	desc = "Allows for the blowing of Applejack bottles."
	id = "applejack"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/applejack/empty

/datum/design/bottle/champagne
	name = "Bottle Design (Champagne)"
	desc = "Allows for the blowing of Champagne bottles."
	id = "champagne"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/champagne/empty

/datum/design/bottle/blazaam
	name = "Bottle Design (Blazaam)"
	desc = "Allows for the blowing of Blazaam bottles."
	id = "blazaam"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/blazaam/empty

/datum/design/bottle/trappist
	name = "Bottle Design (Trappist)"
	desc = "Allows for the blowing of Trappist bottles."
	id = "trappist"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/trappist/empty

/datum/design/bottle/grenadine
	name = "Bottle Design (Grenadine)"
	desc = "Allows for the blowing of Grenadine bottles."
	id = "grenadine"
	build_path = /obj/item/reagent_containers/food/drinks/bottle/grenadine/empty

/datum/design/bottle/export
	materials = list(MAT_GLASS = 1200)
	build_type = AUTOBOTTLER
	category = list("Brands")

/datum/design/bottle/export/wine
	name = "Export Design (Wine)"
	desc = "Allows for the blowing, and bottling of Wine bottles."
	id = "wine_export"
	reagents_list = list("wine" = 100)
	build_path = /obj/item/export/bottle/wine

/datum/design/bottle/export/rum
	name = "Export Design (Rum)"
	desc = "Allows for the blowing, and bottling of Rum bottles."
	id = "rum_export"
	reagents_list = list("rum" = 100)
	build_path = /obj/item/export/bottle/rum

/datum/design/bottle/export/gin
	name = "Export Design (Gin)"
	desc = "Allows for the blowing, and bottling of Gin bottles."
	id = "gin_export"
	reagents_list = list("gin" = 100)
	build_path = /obj/item/export/bottle/gin

/datum/design/bottle/export/whiskey
	name = "Export Design (Whiskey)"
	desc = "Allows for the blowing, and bottling of Whiskey bottles."
	id = "whiskey_export"
	reagents_list = list("whiskey" = 100)
	build_path = /obj/item/export/bottle/whiskey

/datum/design/bottle/export/vodka
	name = "Export Design (Vodka)"
	desc = "Allows for the blowing, and bottling of 99% Vodka bottles."
	id = "vodka_export"
	reagents_list = list("vodka" = 99, "water" = 1)
	build_path = /obj/item/export/bottle/vodka

/datum/design/bottle/export/tequila
	name = "Export Design (Tequila)"
	desc = "Allows for the blowing, and bottling of Tequila bottles."
	id = "tequila_export"
	reagents_list = list("tequila" = 80, "lemon _juice" = 20)
	build_path = /obj/item/export/bottle/tequila

/datum/design/bottle/export/patron
	name = "Export Design (Patron)"
	desc = "Allows for the blowing, and bottling of Patron bottles."
	id = "patron_export"
	reagents_list = list("patron" = 100)
	build_path = /obj/item/export/bottle/patron

/datum/design/bottle/export/kahlua
	name = "Export Design (Kahlua)"
	desc = "Allows for the blowing, and bottling of Kahlua bottles."
	id = "kahlua_export"
	reagents_list = list("kahlua" = 100)
	build_path = /obj/item/export/bottle/kahlua

/datum/design/bottle/export/sake
	name = "Export Design (Sake)"
	desc = "Allows for the blowing, and bottling of Sake bottles."
	id = "sake_export"
	reagents_list = list("sake" = 80, "rice" = 10, "sugar" = 10)
	build_path = /obj/item/export/bottle/sake

/datum/design/bottle/export/vermouth
	name = "Export Design (Vermouth)"
	desc = "Allows for the blowing, and bottling of Vermouth bottles."
	id = "vermouth_export"
	reagents_list = list("vermouth" = 100)
	build_path = /obj/item/export/bottle/vermouth

/datum/design/bottle/export/goldschlager
	name = "Export Design (Goldschlager)"
	desc = "Allows for the blowing, and bottling of Goldschlager bottles."
	id = "goldschlager_export"
	reagents_list = list("goldschlager" = 100)
	build_path = /obj/item/export/bottle/goldschlager

/datum/design/bottle/export/hcider
	name = "Export Design (Cider)"
	desc = "Allows for the blowing, and bottling of Cider bottles."
	id = "hcider_export"
	reagents_list = list("hcider" = 30, "water" = 20)
	build_path = /obj/item/export/bottle/hcider

/datum/design/bottle/export/cognac
	name = "Export Design (Cognac)"
	desc = "Allows for the blowing, and bottling of Cognac bottles."
	id = "cognac_export"
	reagents_list = list("cognac" = 100)
	build_path = /obj/item/export/bottle/cognac

/datum/design/bottle/export/absinthe
	name = "Export Design (Absinthe)"
	desc = "Allows for the blowing, and bottling of Absinthe bottles."
	reagents_list = list("absinthe" = 100)
	id = "absinthe_export"
	build_path = /obj/item/export/bottle/absinthe

/datum/design/bottle/export/grappa
	name = "Export Design (Grappa)"
	desc = "Allows for the blowing, and bottling of Grappa bottles."
	id = "grappa_export"
	reagents_list = list("grappa" = 100)
	build_path = /obj/item/export/bottle/grappa

/datum/design/bottle/export/fernet
	name = "Export Design (Fernet)"
	desc = "Allows for the blowing, and bottling of Fernet bottles."
	id = "fernet_export"
	reagents_list = list("fernet" = 100)
	build_path = /obj/item/export/bottle/fernet

/datum/design/bottle/export/applejack
	name = "Export Design (Applejack)"
	desc = "Allows for the blowing, and bottling of Applejack bottles."
	id = "applejack_export"
	reagents_list = list("applejack" = 50)
	build_path = /obj/item/export/bottle/applejack

/datum/design/bottle/export/champagne
	name = "Export Design (Champagne)"
	desc = "Allows for the blowing, and bottling of Champagne bottles."
	id = "champagne_export"
	reagents_list = list("champagne" = 90, "co2" = 10)
	build_path = /obj/item/export/bottle/champagne

/datum/design/bottle/export/blazaam
	name = "Export Design (Blazaam)"
	desc = "Allows for the blowing, and bottling of Blazaam bottles."
	id = "blazaam_export"
	reagents_list = list("blazaam" = 80, "holywater" = 20)
	build_path = /obj/item/export/bottle/blazaam

/datum/design/bottle/export/trappist
	name = "Export Design (Trappist)"
	desc = "Allows for the blowing, and bottling of Trappist bottles."
	id = "trappist_export"
	reagents_list = list("trappist" = 100)
	build_path = /obj/item/export/bottle/trappist

/datum/design/bottle/export/grenadine
	name = "Export Design (Grenadine)"
	desc = "Allows for the blowing, and bottling of Grenadine bottles."
	id = "grenadine_export"
	reagents_list = list("grenadine" = 100)
	build_path = /obj/item/export/bottle/grenadine

/datum/design/bottle/export/minikeg
	name = "Export Design (minikeg)"
	desc = "Allows for the fabication, and bottling of Minikeg of craft beer."
	id = "minikeg_export"
	category = list("Beers")
	reagents_list = list("beer" = 100)
	build_path = /obj/item/export/bottle/minikeg

/datum/design/bottle/export/blooddrop
	name = "Export Design (Blooddrop)"
	desc = "Allows for the blowing, and bottling of Blooddrop bottles."
	id = "blooddrop_export"
	category = list("Wines")
	reagents_list = list("champagne" = 30, "co2" = 30, "wine" = 10, "grape_juice" = 30)
	build_path = /obj/item/export/bottle/blooddrop

/datum/design/bottle/export/slim_gold
	name = "Export Design (Slim Gold)"
	desc = "Allows for the blowing, and bottling of Slim Gold bottles."
	id = "slim_gold_export"
	category = list("Beers")
	reagents_list = list("gold" = 10, "co2" = 10, "rum" = 30, "beer" = 40)
	build_path = /obj/item/export/bottle/slim_gold

/datum/design/bottle/export/white_bloodmoon
	name = "Export Design (White Bloodmoon)"
	desc = "Allows for the blowing, and bottling of White Bloodmoon bottles."
	id = "white_bloodmoon_export"
	category = list("Wines")
	reagents_list = list("synthflesh" = 50, "blood" = 50, "gib" = 10)
	build_path = /obj/item/export/bottle/white_bloodmoon

/datum/design/bottle/export/greenroad
	name = "Export Design (Greenroad)"
	desc = "Allows for the blowing, and bottling of Greenroad bottles."
	id = "greenroad_export"
	reagents_list = list("vitfro" = 50, "rum" = 50, "ash" = 10)
	category = list("Beers")
	build_path = /obj/item/export/bottle/greenroad