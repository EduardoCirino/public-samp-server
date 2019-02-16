/*

	Sistema de 'Mercadão'.
	Data: 18/09/2018.
	Desenvolvido por: Eduardo

*/

#define MARKET_X 	(1286.2146)
#define MARKET_Y 	(-1329.3779)
#define MARKET_Z 	(13.5523)

/* DIALOGS */

Dialog:MainMarket(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new query[85];

		switch(listitem)
		{
			case 0:
			{
				ShowMarketForPlayer(playerid, 1); //Parte de compra OK
			}
			case 1:
			{
				Dialog_Show(playerid, MarketSearch, DIALOG_STYLE_INPUT, "Qual o nome do produto que você deseja procurar?", "Utilize o campo abaixo como critério de busca.\nLembrando que, apenas os últimos 45 anúncios em ordem\ndecrescente serão listados.\nPara uma busca mais precisa, informe o nome completo do produto.", "Buscar", "<<");
			}
			case 2: //Inventário OK, falta acessórios!
			{
				new marketgetcount = Market_GetCount(playerid), maxoffers;
				switch(PlayerData[playerid][pVip])
				{
					case 1: maxoffers = 17; //Bronze
					case 2: maxoffers = 27; //Prata
					case 3: maxoffers = 37; //Ouro
					default: maxoffers = 7; //Normal e debug
				}

				if(marketgetcount >= maxoffers)
					return SendWarningMessage(playerid, "Você só pode ter no máximo %d anúncios ativos no mercadão.", maxoffers);

				Dialog_Show(playerid, MarketAn, DIALOG_STYLE_LIST, "Qual produto você deseja anunciar?", "Listar inventário\nListar acessórios", "Selecionar", "<<");
			}
			case 3:
			{
				mysql_format(this, query, sizeof(query), "SELECT * FROM market_history WHERE player_id = '%d' ORDER BY sql_id DESC LIMIT 30", PlayerData[playerid][pID]);
				mysql_tquery(this, query, "ShowMarketHistory", "d", playerid);
			}
			case 4:
			{
				mysql_format(this, query, sizeof(query), "SELECT * FROM market WHERE seller_id = '%d'", PlayerData[playerid][pID]);
				mysql_tquery(this, query, "ShowPlayerOffers", "d", playerid);
			}
		}
	}
	return 1;
}

Dialog:MarketNoOffers(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		Market_Show(playerid);
	}
	return 1;
}

Dialog:MarketOffers(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(!strcmp(inputtext, "<< Página Anterior", true))
			return ShowMarketForPlayer(playerid, PlayerData[playerid][pPage] - 1);

		if(!strcmp(inputtext, ">> Próxima Página", true))
			return ShowMarketForPlayer(playerid, PlayerData[playerid][pPage] + 1);

		new id = ListedOptions[playerid][listitem], query[100];

		mysql_format(this, query, sizeof(query), "SELECT * FROM market WHERE sql_id = '%d' AND item_quantity > 0 AND expires > '%d'", id, gettime());
		mysql_tquery(this, query, "ShowSelectedOffer", "dd", playerid, id);
	}
	else
	{
		Market_Show(playerid);
	}
	return 1;
}

Dialog:OfferNotAvailable(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		ShowMarketForPlayer(playerid, PlayerData[playerid][pPage]);
	}
	return 1;
}

Dialog:SelectedOffer(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new query[85];

		mysql_format(this, query, sizeof(query), "SELECT * FROM market WHERE sql_id = '%d' AND item_quantity > 0", PlayerData[playerid][pSelectedSlot]);
		mysql_tquery(this, query, "BuySelectedOffer", "dd", playerid, PlayerData[playerid][pSelectedSlot]);
	}
	else
	{
		ShowMarketForPlayer(playerid, 1);
	}
	return 1;
}

Dialog:MarketAn(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{				
				Inventory_Open(playerid);
				PlayerData[playerid][pStorageSelect] = 3;
				SetPVarInt(playerid, "marketoption", 1);
			}	
			case 1:
			{
				//Attach_Open(playerid);
				PlayerData[playerid][pStorageSelect] = 1;
				SetPVarInt(playerid, "marketoption", 2);
			}
		}
	}
	else
	{
		Market_Show(playerid);
	}
	return 1;
}

Dialog:MarketValue(playerid, response, listitem, inputtext[])//Dialog_Show(playerid, MarketValue, DIALOG_STYLE_INPUT, "Escolher preço unitário", "Digite abaixo o preço unitário para o produto:\n%s (Quantidade %d)\nQuantidade a ser vendido: %d unidade(s)", "Vender", "<<", InventoryData[playerid][id][invItem], InventoryData[playerid][listitem][invQuantity]);
{
	if(response)
	{
		new value, id = PlayerData[playerid][pInventoryItem];

		if(sscanf(inputtext, "d", value))
			return Dialog_Show(playerid, MarketValue, DIALOG_STYLE_INPUT, "Escolher preço unitário", "Quantia inválida!\n\nDigite abaixo o preço unitário para o produto:\n%s (Quantidade %d)\nA ser vendido: %d unidade(s)", "Vender", "<<", InventoryData[playerid][id][invItem], InventoryData[playerid][id][invQuantity], GetPVarInt(playerid, "marketquantity"));
		
		if(value < 0 || value > 100000000)
			return Dialog_Show(playerid, MarketValue, DIALOG_STYLE_INPUT, "Escolher preço unitário", "Não exceda os limites!\n\nDigite abaixo o preço unitário para o produto:\n%s (Quantidade %d)\nA ser vendido: %d unidade(s)", "Vender", "<<", InventoryData[playerid][id][invItem], InventoryData[playerid][id][invQuantity], GetPVarInt(playerid, "marketquantity"));

		if(strfind(InventoryData[playerid][id][invItem], "item único", true) != -1)
			return SendWarningMessage(playerid, "Itens únicos são intransferíveis para terceiros, apenas o descarte é permitido.");

		Market_Insert(playerid, value, GetPVarInt(playerid, "marketquantity"), GetPVarInt(playerid, "marketoption"));
	}
	else
	{
		Dialog_Show(playerid, MarketAn, DIALOG_STYLE_LIST, "Qual produto você deseja anunciar?", "Listar inventário\nListar acessórios", "Selecionar", "<<");
	}
	return 1;
}

Dialog:MarketDeposit(playerid, response, listitem, inputtext[])//Dialog_Show(playerid, MarketDeposit, DIALOG_STYLE_LIST, "Vender Produto", "Produto: %s (Quantidade %d)\n\nDigite a quantidade que deseja vender:", "Próximo", "<<", InventoryData[playerid][id][invItem], InventoryData[playerid][listitem][invQuantity]);
{
	if(response)
	{
		new quantity, id = PlayerData[playerid][pInventoryItem];

		if(sscanf(inputtext, "d", quantity))
			return Dialog_Show(playerid, MarketDeposit, DIALOG_STYLE_INPUT, "Vender Produto", "Quantia inválida!\n\nProduto: %s (Quantidade %d)\n\nDigite a quantidade que deseja vender:", "Próximo", "<<", InventoryData[playerid][id][invItem], InventoryData[playerid][id][invQuantity]);

		if(quantity <= 0 || quantity > InventoryData[playerid][id][invQuantity])
			return Dialog_Show(playerid, MarketDeposit, DIALOG_STYLE_INPUT, "Vender Produto", "Não exceda os limites!\n\nProduto: %s (Quantidade %d)\n\nDigite a quantidade que deseja vender:", "Próximo", "<<", InventoryData[playerid][id][invItem], InventoryData[playerid][id][invQuantity]);
	
		SetPVarInt(playerid, "marketquantity", quantity);

		Dialog_Show(playerid, MarketValue, DIALOG_STYLE_INPUT, "Escolher preço unitário", "Digite abaixo o preço unitário para o produto:\n%s (Quantidade %d)\nA ser vendido: %d unidade(s)", "Vender", "<<", InventoryData[playerid][id][invItem], InventoryData[playerid][id][invQuantity], GetPVarInt(playerid, "marketquantity"));
	}
	else
	{
		Market_Show(playerid);
	}
	return 1;
}

Dialog:MarketMyOffers(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		PlayerData[playerid][pSelectedSlot] = ListedOptions[playerid][listitem];
		new id = PlayerData[playerid][pSelectedSlot];

		new query[80];

		mysql_format(this, query, sizeof(query), "SELECT * FROM market WHERE seller_id = '%d' AND sql_id = '%d'", PlayerData[playerid][pID], id);
		mysql_tquery(this, query, "CancelSelectedOffer", "d", playerid);
	}
	else
	{
		Market_Show(playerid);
	}
	return 1;
}

Dialog:MarketCancel(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new query[90];

		mysql_format(this, query, sizeof(query), "SELECT * FROM market WHERE sql_id = '%d' AND seller_id = '%d' AND item_quantity > 0", PlayerData[playerid][pSelectedSlot], PlayerData[playerid][pID]);
		mysql_tquery(this, query, "ReturnMarketItem", "dd", playerid, PlayerData[playerid][pSelectedSlot]);
	}
	else
	{
		dlg_MainMarket(playerid, 1, 4, "\1");
	}
	return 1;
}

Dialog:MailBox(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new id = ListedOptions[playerid][listitem], query[85];
		PlayerData[playerid][pSelectedSlot] = id;

		mysql_format(this, query, sizeof(query), "SELECT * FROM market_mailbox WHERE player_id = '%d' AND sql_id = '%d'", PlayerData[playerid][pID], id);
		mysql_tquery(this, query, "OnPlayerRequestMailBox", "d", playerid);
	}

	return 1;
}

Dialog:MarketSearch(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new search[64];

		if(sscanf(inputtext, "s[64]", search))
			return Dialog_Show(playerid, MarketSearch, DIALOG_STYLE_INPUT, "Qual o nome do produto que você deseja procurar?", "É necessário informar um critério!\n\nUtilize o campo abaixo como critério de busca.\nLembrando que, apenas os últimos 45 anúncios em ordem\ndecrescente serão listados.\nPara uma busca mais precisa, informe o nome completo do produto.", "Buscar", "<<");
	
		if(strlen(search) > 64)
			return Dialog_Show(playerid, MarketSearch, DIALOG_STYLE_INPUT, "Qual o nome do produto que você deseja procurar?", "Não exceda o limite de caracteres (64)!\n\nUtilize o campo abaixo como critério de busca.\nLembrando que, apenas os últimos 45 anúncios em ordem\ndecrescente serão listados.\nPara uma busca mais precisa, informe o nome completo do produto.", "Buscar", "<<");
	
		if(strlen(search) < 2)
			return Dialog_Show(playerid, MarketSearch, DIALOG_STYLE_INPUT, "Qual o nome do produto que você deseja procurar?", "É necessário informar mais que dois (2) caracteres!\n\nUtilize o campo abaixo como critério de busca.\nLembrando que, apenas os últimos 45 anúncios em ordem\ndecrescente serão listados.\nPara uma busca mais precisa, informe o nome completo do produto.", "Buscar", "<<");

		new query[247];

		mysql_format(this, query, sizeof(query), "SELECT players.Name as player_name, market.* FROM market INNER JOIN players ON market.seller_id = players.UserID WHERE expires > '%d' AND item_name LIKE '%s%s%s' ORDER BY sql_id DESC LIMIT 45", gettime(), "%%", search, "%%");
		mysql_tquery(this, query, "MarketSearchForProduct", "ds", playerid, search);
	}
	else
	{
		Market_Show(playerid);
	}
	return 1;
}

Dialog:MarketSearchResult(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new id = ListedOptions[playerid][listitem], query[100];

		mysql_format(this, query, sizeof(query), "SELECT * FROM market WHERE sql_id = '%d' AND item_quantity > 0 AND expires > '%d'", id, gettime());
		mysql_tquery(this, query, "ShowSelectedOffer", "dd", playerid, id);
	}
	else
	{
		Dialog_Show(playerid, MarketSearch, DIALOG_STYLE_INPUT, "Qual o nome do produto que você deseja procurar?", "Utilize o campo abaixo como critério de busca.\nLembrando que, apenas os últimos 45 anúncios em ordem\ndecrescente serão listados.\nPara uma busca mais precisa, informe o nome completo do produto.", "Buscar", "<<");
	}
	return 1;
}

Dialog:MarketSearchFailed(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		Dialog_Show(playerid, MarketSearch, DIALOG_STYLE_INPUT, "Qual o nome do produto que você deseja procurar?", "Utilize o campo abaixo como critério de busca.\nLembrando que, apenas os últimos 45 anúncios em ordem\ndecrescente serão listados.\nPara uma busca mais precisa, informe o nome completo do produto.", "Buscar", "<<");
	}
	return 1;
}

Dialog:MarketMyHistory(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		Market_Show(playerid);
	}
	return 1;
}

/* STOCKS */

ShowMarketForPlayer(playerid, page)
{
	PlayerData[playerid][pPage] = page; page--;

	new query[171];

	mysql_format(this, query, sizeof(query), "SELECT players.Name as player_name, market.* FROM market INNER JOIN players ON market.seller_id = players.UserID WHERE expires > '%d' ORDER BY sql_id DESC", gettime());
	mysql_tquery(this, query, "ListOffersMarket", "dd", playerid, page);

	return 1;
}

Market_Insert(playerid, unitprice, quantity = 1, market_option = 1)
{
	new query[250], string[100], unixtime, id = PlayerData[playerid][pInventoryItem];

	unixtime = gettime() + (86400 * 3);

	mysql_format(this, query, sizeof(query), "INSERT INTO market (seller_id, item_name, item_model, item_quantity, value, expires) VALUES ('%d', '%e', '%d', '%d', '%d', '%d')",
		PlayerData[playerid][pID], InventoryData[playerid][id][invItem], InventoryData[playerid][id][invModel], quantity, unitprice, unixtime);
	mysql_tquery(this, query);

	format(string, sizeof(string), "Você anunciou o produto: %s (Quantidade: %d) por %s.", InventoryData[playerid][id][invItem], quantity, FormatNumber(unitprice * quantity));
	mysql_format(this, query, sizeof(query), "INSERT INTO market_history (player_id, log, date) VALUES ('%d', '%e', '%e')", PlayerData[playerid][pID], string, ReturnDate());
	mysql_tquery(this, query);

	SendGreenMessage(playerid, "Você anunciou o produto \"%s (unid: %d)\" no mercadão por %s.", InventoryData[playerid][id][invItem], quantity, FormatNumber(unitprice));
	
	if(market_option == 1)
	{
		Inventory_Remove(playerid, InventoryData[playerid][id][invItem], quantity);
	}

	return 1;
}

Market_History(sellerid, buyerid, itemname[], value, date[])
{
	if(!IsPlayerConnected(buyerid))
		return 0;

	new string[100], query[230];

	//Seller
	format(string, sizeof(string), "Você vendeu um(a) %s por %s.", itemname, FormatNumber(value));
	mysql_format(this, query, sizeof(query), "INSERT INTO market_history (player_id, log, date) VALUES ('%d', '%e', '%e')", sellerid, string, date);
	mysql_tquery(this, query);
	
	//Buyer
	format(string, sizeof(string), "Você comprou um(a) %s por %s.", itemname, FormatNumber(value));
	mysql_format(this, query, sizeof(query), "INSERT INTO market_history (player_id, log, date) VALUES ('%d', '%e', '%e')", PlayerData[buyerid][pID], string, date);
	mysql_tquery(this, query);

	//Notify players
	foreach(new i : Player) if(PlayerData[i][pLogged])
	{
		if(PlayerData[i][pID] == sellerid)
		{
			SendServerMessage(i, "Você vendeu um produto no mercadão, o dinheiro foi enviado para o seu MailBox.");
		}

		if(PlayerData[i][pID] == buyerid)
		{
			SendServerMessage(i, "Você possui um novo produto disponível no seu MailBox.");
		}
	}

	return 1;
}

Market_BoxBuyer(uid, item[], item_model, quantity)
{
	new query[164];

	mysql_format(this, query, sizeof(query), "INSERT INTO market_mailbox (player_id, item_name, item_model, item_quantity) VALUES ('%d', '%e', '%d', '%d')", uid, item, item_model, quantity);
	mysql_tquery(this, query);

	return 1;
}

Market_BoxSeller(uid, money)
{
	new query[130];

	mysql_format(this, query, sizeof(query), "INSERT INTO market_mailbox (player_id, item_name, item_quantity) VALUES ('%d', 'Dinheiro', '%d')", uid, money);
	mysql_tquery(this, query);

	return 1;
}

Market_Mailbox_Show(playerid)
{
	new query[85];

	mysql_format(this, query, sizeof(query), "SELECT * FROM market_mailbox WHERE player_id = '%d'", PlayerData[playerid][pID]);
	mysql_tquery(this, query, "ShowPlayerMailbox", "d", playerid);

	return 1;
}

Market_GetCount(playerid)
{
	new query[128];

	mysql_format(this, query, sizeof(query), "SELECT * FROM `market` WHERE `seller_id` = '%d'", PlayerData[playerid][pID]);
	mysql_query(this, query);

	return cache_num_rows();
}

Market_OnGameModeInit()
{
	CreateDynamicPickup(1239, 23, MARKET_X, MARKET_Y, MARKET_Z);
	CreateDynamic3DTextLabel("Mercadão\n('F' para abrir o menu)", COLOR_WHITE, MARKET_X, MARKET_Y, MARKET_Z, 7.5);
	return 1;
}

Market_Show(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 2.0, MARKET_X, MARKET_Y, MARKET_Z)) {
		Dialog_Show(playerid, MainMarket, DIALOG_STYLE_LIST, "Opções do Mercadão", "Listar produtos à venda\nProcurar por um produto\nAnunciar um produto\nVer o meu histórico\nMinhas ofertas", "Selecionar", "Cancelar");
	}
}

/* PUBLICS AND QUERIES */

this::ListOffersMarket(playerid, page)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
		return Dialog_Show(playerid, MarketNoOffers, DIALOG_STYLE_MSGBOX, "Mensagem de erro:", "Nenhum produto está sendo vendido no momento!\nRetorne mais tarde para saber se existe uma anúncio ativo.", "<<", "");

	new count, offer_id, item_name[32], item_quantity, seller[24], value;

	sz_MiscString[0] = 0;

	format(sz_MiscString, sizeof(sz_MiscString), "#\tProduto (Quantidade)\tVendedor\tPreço unitário\n");

	for(new i = page * MAX_PAGE_LOG; i < rows; i++)
	{
		if(count + 1 == MAX_PAGE_LOG + 1)
		{
			format(sz_MiscString, sizeof(sz_MiscString), "%s>> Próxima Página\n", sz_MiscString);
			break;
		}

		cache_get_value_name_int(i, "sql_id", offer_id);
		cache_get_value_name(i, "item_name", item_name, 32);
		cache_get_value_name_int(i, "item_quantity", item_quantity);
		cache_get_value_name(i, "player_name", seller, 24);
		cache_get_value_name_int(i, "value", value);

		format(sz_MiscString, sizeof(sz_MiscString), "%s%d\t%s (%d)\t%s\t%s\n", sz_MiscString, count + 1, item_name, item_quantity, seller, FormatNumber(value));

		ListedOptions[playerid][count++] = offer_id;
	}

	if((page + 1) >= 2)
	{
		format(sz_MiscString, sizeof(sz_MiscString), "%s<< Página Anterior", sz_MiscString);
	}

	Dialog_Show(playerid, MarketOffers, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Ofertas disponíveis ({00FF00}%d{FFFFFF}) - Página %d de %d", cache_num_rows(), page + 1, (cache_num_rows() / MAX_PAGE_LOG) + 1), sz_MiscString, "Inspecionar", "<<");

	return 1;
}

this::ShowSelectedOffer(playerid, offerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
		return Dialog_Show(playerid, OfferNotAvailable, DIALOG_STYLE_MSGBOX, "Não foi possível prosseguir", "O produto selecionado expirou ou compraram todas as unidades\nrestantes.", "<<", "");
	
	new seller_id, item_name[32], item_quantity, value;

	PlayerData[playerid][pSelectedSlot] = offerid;

	cache_get_value_name(0, "item_name", item_name, 32);
	cache_get_value_name_int(0, "item_quantity", item_quantity);
	cache_get_value_name_int(0, "seller_id", seller_id);
	cache_get_value_name_int(0, "value", value);

	Dialog_Show(playerid, SelectedOffer, DIALOG_STYLE_MSGBOX, "Inspecionando oferta", "{FFFFFF}Você está inspecionando a oferta do(a): %s\n\nInformações de venda:\n\t- Produto: %s\n\t- Quantidade disponível: %d unidade(s)\n\t- Preço unitário: %s\n\nPara confirmar a compra de um produto unitário\nclique no botão 'Comprar'.", "Comprar", "<<", 
		ReturnNameByID(seller_id), item_name, item_quantity, FormatNumber(value));

	return 1;
}

this::BuySelectedOffer(playerid, offerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
		return Dialog_Show(playerid, OfferNotAvailable, DIALOG_STYLE_MSGBOX, "Não foi possível prosseguir", "O produto selecionado expirou ou compraram todas as unidades\nrestantes.", "<<", "");
	
	new query[85], seller_id, item_name[32], item_quantity, item_model, value;

	cache_get_value_name(0, "item_name", item_name, 32);
	cache_get_value_name_int(0, "item_quantity", item_quantity);
	cache_get_value_name_int(0, "item_model", item_model);
	cache_get_value_name_int(0, "seller_id", seller_id);
	cache_get_value_name_int(0, "value", value);

	if(seller_id == PlayerData[playerid][pID])
		return SendWarningMessage(playerid, "Para cancelar o seu anúncio, acesse o menu 'Minhas Ofertas' no mercadão.");

	if(GetScriptedMoney(playerid) < value)
		return SendWarningMessage(playerid, "Você não possui %s em mãos.", FormatNumber(value));	

	if((item_quantity - 1) <= 0)
	{
		mysql_format(this, query, sizeof(query), "DELETE FROM market WHERE sql_id = '%d'", offerid);
		mysql_tquery(this, query);
	}
	else
	{
		mysql_format(this, query, sizeof(query), "UPDATE market SET item_quantity = item_quantity - 1 WHERE sql_id = '%d'", offerid);
		mysql_tquery(this, query);
	}

	GiveScriptedMoney(playerid, - value);

	Market_BoxSeller(seller_id, value);
	Market_BoxBuyer(PlayerData[playerid][pID], item_name, item_model, 1);

	Market_History(seller_id, playerid, item_name, value, ReturnDate());

	SendGreenMessage(playerid, "Você comprou o produto \"%s (unid: 1)\" por %s do(a) jogador(a) %s.", item_name, FormatNumber(value), ReturnNameByID(seller_id));

	return 1;
}

this::ShowMarketHistory(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
		return SendWarningMessage(playerid, "Não há registros de venda ou compra para a sua conta.");

	new log[128], date[32], uniqueid;

	sz_MiscString[0] = 0;

	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name_int(i, "player_id", uniqueid);
		cache_get_value_name(i, "log", log, 128);
		cache_get_value_name(i, "date", date);
		format(sz_MiscString, sizeof(sz_MiscString), "%s%s - %s\n", sz_MiscString, date, log);
	}

	Dialog_Show(playerid, MarketMyHistory, DIALOG_STYLE_LIST, "Últimos 30 registros", sz_MiscString, "<<", "");

	return 1;
}

this::ShowPlayerOffers(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
		return SendWarningMessage(playerid, "Você não possui um anúncio ativo.");

	new offerid, item_name[32], expires, value, item_quantity, hora, minuto, segundo, count;

	sz_MiscString[0] = 0;

	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name_int(i, "sql_id", offerid);
		cache_get_value_name(i, "item_name", item_name, 32);
		cache_get_value_name_int(i, "expires", expires);
		cache_get_value_name_int(i, "value", value);
		cache_get_value_name_int(i, "item_quantity", item_quantity);

		expires = expires - gettime();		

		if(expires > 0)
		{
			GetElapsedTime(expires, hora, minuto, segundo);
			format(sz_MiscString, sizeof(sz_MiscString), "%s%s\t%02d:%02d:%02d\t%d\t%s\n", sz_MiscString, item_name, hora, minuto, segundo, item_quantity, FormatNumber(value));
		}
		else
		{
			format(sz_MiscString, sizeof(sz_MiscString), "%s%s\tEXPIRADO\t%d\t%s\n", sz_MiscString, item_name, item_quantity, FormatNumber(value));
		}

		ListedOptions[playerid][count++] = offerid; 
	}

	Dialog_Show(playerid, MarketMyOffers, DIALOG_STYLE_TABLIST_HEADERS, "Minhas ofertas", "Produto\tValidade\tUnidades\tPreço ($)\n%s", "Cancelar", "<<", sz_MiscString);

	return 1;
}

this::CancelSelectedOffer(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
		return SendWarningMessage(playerid, "A sua oferta selecionada expirou ou compraram todas as unidades.");

	new item_name[32];

	cache_get_value_name(0, "item_name", item_name, 32);

	Dialog_Show(playerid, MarketCancel, DIALOG_STYLE_MSGBOX, "Cancelar Oferta", "{FFFFFF}Você deseja realmente cancelar a oferta do produto: \"%s\"?", "Sim", "<<", item_name);

	return 1;
}

this::ReturnMarketItem(playerid, offerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
		return SendWarningMessage(playerid, "A sua oferta selecionada expirou ou compraram todas as unidades.");
	
	new string[100], query[230], item_name[32], item_quantity, item_model, seller_id;

	cache_get_value_name_int(0, "seller_id", seller_id);
	cache_get_value_name(0, "item_name", item_name, 32);
	cache_get_value_name_int(0, "item_quantity", item_quantity);
	cache_get_value_name_int(0, "item_model", item_model);

	Market_BoxBuyer(PlayerData[playerid][pID], item_name, item_model, item_quantity);

	mysql_format(this, query, sizeof(query), "DELETE FROM market WHERE sql_id = '%d' AND seller_id = '%d' AND item_quantity > 0", offerid, PlayerData[playerid][pID]);
	mysql_tquery(this, query);

	format(string, sizeof(string), "Você cancelou o anúncio do produto: %s (Quantidade: %d).", item_name, item_quantity);
	mysql_format(this, query, sizeof(query), "INSERT INTO market_history (player_id, log, date) VALUES ('%d', '%e', '%e')", seller_id, string, ReturnDate());
	mysql_tquery(this, query);

	SendGreenMessage(playerid, "Você cancelou a oferta e o produto foi enviado para o seu MailBox.");

	return 1;
}

this::ShowPlayerMailbox(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
		return SendWarningMessage(playerid, "Não há pendências no seu Mailbox, você pode conferir o histórico no seu UCP.");

	new mailbox_id, item_name[32], item_quantity, count;

	sz_MiscString[0] = 0;

	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name_int(i, "sql_id", mailbox_id);
		cache_get_value_name(i, "item_name", item_name, 32);
		cache_get_value_name_int(i, "item_quantity", item_quantity);

		format(sz_MiscString, sizeof(sz_MiscString), "%s%s\t%d\n", sz_MiscString, item_name, item_quantity);

		ListedOptions[playerid][count++] = mailbox_id;
	}

	Dialog_Show(playerid, MailBox, DIALOG_STYLE_TABLIST_HEADERS, "Meu MailBox", "Produto\tQuantia\n%s", "Resgatar", "Cancelar", sz_MiscString);

	return 1;
}

this::OnPlayerRequestMailBox(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
		return SendWarningMessage(playerid, "Ocorreu um erro ao tentar resgatar esse produto, tente novamente mais tarde.");

	new item_name[32], item_quantity, item_model, query[80];

	cache_get_value_name(0, "item_name", item_name, 32);
	cache_get_value_name_int(0, "item_quantity", item_quantity);
	cache_get_value_name_int(0, "item_model", item_model);

	if(!strcmp(item_name, "Dinheiro"))
	{
		GiveScriptedMoney(playerid, item_quantity);

		SendGreenMessage(playerid, "Você resgatou a quantia de %s do seu MailBox.", FormatNumber(item_quantity));
	}
	else
	{
		Inventory_Add(playerid, item_name, item_model, item_quantity);

		SendGreenMessage(playerid, "Você resgatou o produto %s com %d unidade(s) do seu MailBox.", item_name, item_quantity);
		SendServerMessage(playerid, "Você possui um novo item no seu inventário (/inv).");
	}

	mysql_format(this, query, sizeof(query), "DELETE FROM market_mailbox WHERE player_id = '%d' AND sql_id = '%d'", PlayerData[playerid][pID], PlayerData[playerid][pSelectedSlot]);
	mysql_tquery(this, query);

	return 1;
}

this::MarketSearchForProduct(playerid, search[])
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
		return Dialog_Show(playerid, MarketSearchFailed, DIALOG_STYLE_MSGBOX, "Erro ao completar a solicitação:", "Nenhum produto com o critério informado: \"%s\"\nfoi encontrado no mercadão.\nTente novamente utilizando outro nome.", "<<", "", search);

	new count, offer_id, item_name[32], item_quantity, seller[24], value;

	sz_MiscString[0] = 0;

	format(sz_MiscString, sizeof(sz_MiscString), "#\tProduto (Quantidade)\tVendedor\tPreço unitário\n");
	
	for(new i = 0; i < rows; i++)
	{

		cache_get_value_name_int(i, "sql_id", offer_id);
		cache_get_value_name(i, "item_name", item_name, 32);
		cache_get_value_name_int(i, "item_quantity", item_quantity);
		cache_get_value_name(i, "player_name", seller, 24);
		cache_get_value_name_int(i, "value", value);

		format(sz_MiscString, sizeof(sz_MiscString), "%s%d\t%s (%d)\t%s\t%s\n", sz_MiscString, count + 1, item_name, item_quantity, seller, FormatNumber(value));

		ListedOptions[playerid][count++] = offer_id;
	}

	Dialog_Show(playerid, MarketOffers, DIALOG_STYLE_TABLIST_HEADERS, sprintf("Resultados para: \"%s\" ({00FF00}%d{FFFFFF})", search, rows), sz_MiscString, "Inspecionar", "<<");

	return 1;
}