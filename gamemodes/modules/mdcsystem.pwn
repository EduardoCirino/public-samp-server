	// Sistema de MDC.
	// Autor: Eduardo
	// Data: 05/02/2019

//Dialog_Show(playerid, MDC_AddBoloWanted, DIALOG_STYLE_INPUT, "MDC - Adicionar BOLO / Procurado", "Menu de registro de BOLO ou Procurado.\nSiga os passos abaixos para realizar a adição no sistema:\n\t- BOLO > bolo-placa:ABC-1234\n\tpara adicionar um veículo pela placa.\n\tUse: bolo-id:VehicleID (/dl) para adicionar um veículo\n\ta partir do ID disponibilizado no /dl.\n\t- Procurado > wanted-name:Nome_Sobrenome para adicionar utilizando\n\to nome e sobrenome do cidadão.\n\t- wanted-id:PlayerID para adicionar utilizando\n\to ID no Tab.\nClique em adicionar para finalizar o procedimento.", "Adicionar", "<<");



/* Funções (stocks) */
MDC_InsertNiner(playerid, text[])
{
	new query[73+187], signal_text[144];

	format(signal_text, sizeof(signal_text), CallerApp_FormatText(playerid, text));

	mysql_format(this, query, sizeof(query), "INSERT INTO police_niners (callernumber, date, text) VALUES ('%d', '%e', '%e')", PlayerData[playerid][pCellphone], ReturnDate(), signal_text);
	mysql_tquery(this, query, "QUERY_NewNiner", "ds", playerid, signal_text);
	
	return 1;
}

/* Comandos */
CMD:mdc(playerid)
{
	if(GetFactionType(playerid) == FACTION_POLICE)
	{
		if(!PlayerData[playerid][pOnDuty])
			return SendWarningMessage(playerid, "Você não está em serviço.");

		new vehicle = GetPlayerVehicleID(playerid);

		if(VehicleData[vehicle][vehicleFaction] != PlayerData[playerid][pFactionID])
			return SendWarningMessage(playerid, "Você não está dentro de um veículo da sua facção.");

		Dialog_Show(playerid, MDC_Main, DIALOG_STYLE_LIST, "Mobile Data Computer", "Pesquisar Cidadão\nPesquisar Veículo\nPesquisar Telefone\nPesquisar Niner\nAll Points Bulletins\nÚltimos Niners", "Selecionar", "Cancelar");
	}
	else
		SendWarningMessage(playerid, "Você não faz parte de uma facção governamental.");
	
	return 1;
}

CMD:apb(playerid, params[])
{
	if(GetFactionType(playerid) != FACTION_POLICE)
		return SendWarningMessage(playerid, "Você não é um policial.");

	if(!PlayerData[playerid][pOnDuty])
		return SendWarningMessage(playerid, "Você não está em serviço.");

	new option[10], apb[126];

	if(sscanf(params, "s[10]S()[126]", option, apb))
	{
		SendSyntaxMessage(playerid, "/apb [opção]");
		return SendFormatMessage(playerid, COLOR_YELLOW, "OPÇÃO", "adicionar(add), deletar, ver");
	}

	if(!strcmp(option, "add") || !strcmp(option, "adicionar"))
	{
		if(strlen(apb) < 5)
			return SendWarningMessage(playerid, "Informe o APB corretamente.");

		new query[227];

		mysql_format(this, query, sizeof(query), "INSERT INTO police_apb (date, text) VALUES ('%e', '%e')", ReturnDate(), apb);
		mysql_tquery(this, query, "QUERY_NewAPB", "d", playerid);
	}
	else if(!strcmp(option, "deletar"))
	{
		if(!strlen(apb))
			return SendSyntaxMessage(playerid, "/apb deletar [apb id]");

		if(!IsNumber(apb))
			return SendWarningMessage(playerid, "Utilize apenas números.");

		new id = strval(apb);

		if(id < 1 || id > 9999999999)
			return SendWarningMessage(playerid, "O número do APB informado é inválido.");

		new query[50];

		mysql_format(this, query, sizeof(query), "DELETE FROM police_apb WHERE apb = '%d'", id);
		mysql_tquery(this, query);

		SendFactionMessage(PlayerData[playerid][pFaction], FactionData[PlayerData[playerid][pFaction]][factionColor], "** HQ: %s %s removeu o APB #%d do Mobile Data Computer.", Faction_GetRank(playerid), ReturnName(playerid, 0), apb);
	}
	else if(!strcmp(option, "ver"))
	{
		if(!strlen(apb))
			return SendSyntaxMessage(playerid, "/apb ver [apb id]");

		if(!IsNumber(apb))
			return SendWarningMessage(playerid, "Utilize apenas números.");

		new id = strval(apb);

		if(id < 1 || id > 9999999999)
			return SendWarningMessage(playerid, "O número do APB informado é inválido.");

		new query[51];

		mysql_format(this, query, sizeof(query), "SELECT * FROM police_apb WHERE apb = '%d'", id);
		mysql_tquery(this, query, "QUERY_LoadAPB", "d", playerid);
	}
	else
		SendWarningMessage(playerid, "Parâmetro inválido.");

	return 1;
}

/* Queries and publics */
this::QUERY_MDCLoadPlayer(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
	{
		HidePlayerFooter(playerid);
		return SendWarningMessage(playerid, "O banco de dados do MDC não encontrou um resultado para o parâmetro informado.");
	}

	new player_id, player_name[24], phonenumber;

	cache_get_value_name_int(0, "UserID", player_id);
	cache_get_value_name(0, "Name", player_name);
	cache_get_value_name_int(0, "Cellphone", phonenumber);

	new query[150], Cache:result, playerhouses[64*3], playervehicles[32*5], lastthreetickets[125*3];

	// ********** RESULT PLAYER HOUSES **********
	mysql_format(this, query, sizeof(query), "SELECT houseAddress FROM casas WHERE houseOwner = '%d'", player_id);
	result = mysql_query(this, query);
	
	if(!cache_num_rows())
		format(playerhouses, sizeof(playerhouses), "Nenhum imóvel registrado\n");
	else
	{
		new address[64];
		for(new i = 0; i < cache_num_rows(); i++)
		{
			cache_get_value_name(i, "houseAddress", address, 64);
			format(playerhouses, sizeof(playerhouses), "%s%d. %s\n", playerhouses, i + 1, address);
		}
	}
	cache_delete(result);

	// ********** RESULT PLAYER VEHICLES **********
	mysql_format(this, query, sizeof(query), "SELECT vehicleModel, vehiclePlate FROM carros WHERE ID = '%d'", player_id);
	result = mysql_query(this, query);

	if(!cache_num_rows())
		format(playervehicles, sizeof(playervehicles), "Nenhum veículo registrado\n");
	else
	{
		new model, plate[10];
		for(new i = 0; i < cache_num_rows(); i++)
		{
			cache_get_value_name_int(i, "vehicleModel", model);
			cache_get_value_name(i, "vehiclePlate", plate, 10);
			format(playervehicles, sizeof(playervehicles), "%s%d. %s - Placa Registrada: %s\n", playervehicles, i + 1, ReturnVehicleModelName(model), plate);
		}
	}
	cache_delete(result);

	// ********** RESULT PLAYER TICKETS **********
	mysql_format(this, query, sizeof(query), "SELECT ticketFee, ticketDate, ticketReason FROM multas WHERE ID = '%d' ORDER BY ticketID DESC LIMIT 3", player_id);
	result = mysql_query(this, query);

	if(!cache_num_rows())
		format(lastthreetickets, sizeof(lastthreetickets), "Nenhuma multa/ticket registrada\n");
	else
	{
		new reason[64], date[32], fee;
		for(new i = 0; i < cache_num_rows(); i++)
		{
			cache_get_value_name(i, "ticketDate", date, 32);
			cache_get_value_name(i, "ticketReason", reason, 64);
			cache_get_value_name_int(i, "ticketFee", fee);
			format(lastthreetickets, sizeof(lastthreetickets), "%s{FFFFFF}%d. {FF0000}(%s) %s [%s]\n", lastthreetickets, i + 1, date, reason, FormatNumber(fee));
		}
	}
	cache_delete(result);

	Dialog_Show(playerid, MDC_InfoPlayer, DIALOG_STYLE_MSGBOX, "MDC - Resultado da busca (Cidadão)", "{FFFFFF}\n* NOME *\n%s\n\n* NÚMERO TELEFÔNICO *\n%s\n\n* IMÓVEIS *\n%s\n* VEÍCULOS *\n%s\n* ÚLTIMAS MULTAS *\n%s", "<<", "", player_name, Phone_FormatNumber(phonenumber), playerhouses, playervehicles, lastthreetickets);

	HidePlayerFooter(playerid);

	return 1;
}

this::QUERY_MDCLoadVehicle(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
	{
		HidePlayerFooter(playerid);
		return SendWarningMessage(playerid, "O banco de dados do MDC não encontrou um resultado para o parâmetro informado.");
	}

	new ownername[24], plate[10], model;

	cache_get_value_name(0, "vehicleOwnerName", ownername, 24);
	cache_get_value_name(0, "vehiclePlate", plate, 10);
	cache_get_value_name_int(0, "vehicleModel", model);

	Dialog_Show(playerid, MDC_InfoVehicle, DIALOG_STYLE_MSGBOX, "MDC - Resultado da busca (Veículo)", "{FFFFFF}\n* MODELO *\n%s\n\n* PROPRIETÁRIO *\n%s\n\n* PLACA DE REGISTRO *\n%s", "<<", "", ReturnVehicleModelName(model), ownername, plate);

	HidePlayerFooter(playerid);

	return 1;
}

this::QUERY_MDCLoadPhone(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
	{
		HidePlayerFooter(playerid);
		return SendWarningMessage(playerid, "O banco de dados do MDC não encontrou um resultado para o parâmetro informado.");
	}

	new playername[24], phone;

	cache_get_value_name(0, "Name", playername, 24);
	cache_get_value_name_int(0, "Cellphone", phone);

	Dialog_Show(playerid, MDC_InfoPhone, DIALOG_STYLE_MSGBOX, "MDC - Resultado da busca (Número telefônico)", "{FFFFFF}\n* PROPRIETÁRIO DA LINHA *\n%s\n\n* NÚMERO *\n%s", "<<", "", playername, Phone_FormatNumber(phone));

	HidePlayerFooter(playerid);

	return 1;
}

this::QUERY_NewNiner(playerid, text[])
{
	SendFactionMessageEx(FACTION_POLICE, 0xADD1FFFF, "|___________ CENTRAL __________|");
	SendFactionMessageEx(FACTION_POLICE, 0xADD1FFFF, "Niner ID #%d - Número solicitante: #%s", cache_insert_id(), Phone_FormatNumber(PlayerData[playerid][pCellphone]));
	SendFactionMessageEx(FACTION_POLICE, 0xADD1FFFF, "Local aproximado da chamada: %s", GetPlayerLocation(playerid));
	
	if(strlen(text) > 64)
	{
		SendFactionMessageEx(FACTION_POLICE, 0xADD1FFFF, "Descrição do ocorrido: %.64s", text);
		SendFactionMessageEx(FACTION_POLICE, 0xADD1FFFF, "%s", text[64]);
	}
	else
	{
		SendFactionMessageEx(FACTION_POLICE, 0xADD1FFFF, "Descrição do ocorrido: %s", text);
	}

	SendClientMessageEx(playerid, COLOR_YELLOW, "(celular) %s: Sua solicitação foi protocolada e será atendida o mais rápido possível.", Phone_GetContact(playerid, 911));

	Phone_EndCall(playerid, "chamada_finalizada");

	return 1;
}

this::QUERY_ListNiner(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
	{
		HidePlayerFooter(playerid);
		return SendWarningMessage(playerid, "O banco de dados do MDC não encontrou um resultado para o parâmetro informado.");
	}

	new niner, callernumber, date[32], text[144];

	sz_MiscString[0] = 0;

	format(sz_MiscString, sizeof(sz_MiscString), "Niner\tData\tNúmero Solicitante\tOcorrência\n");

	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name_int(i, "callernumber", callernumber);
		cache_get_value_name_int(i, "niner", niner);
		cache_get_value_name(i, "date", date, 32);
		cache_get_value_name(i, "text", text, 144);

		if(strlen(text) > 50)
			format(sz_MiscString, sizeof(sz_MiscString), "%s#%d\t%s\t%s\t%.50s ...\n", sz_MiscString, niner, date, Phone_FormatNumber(callernumber), text);
		else
			format(sz_MiscString, sizeof(sz_MiscString), "%s#%d\t%s\t%s\t%s\n", sz_MiscString, niner, date, Phone_FormatNumber(callernumber), text);
	}

	Dialog_Show(playerid, MDC_ListNiner, DIALOG_STYLE_TABLIST_HEADERS, "MDC - Últimos 30 Niners", sz_MiscString, "<<", "");

	HidePlayerFooter(playerid);

	return 1;
}

this::QUERY_MDCLoadNiner(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
	{
		HidePlayerFooter(playerid);
		return SendWarningMessage(playerid, "O banco de dados do MDC não encontrou um resultado para o parâmetro informado.");
	}

	new callernumber, date[32], text[145];

	cache_get_value_name_int(0, "callernumber", callernumber);
	cache_get_value_name(0, "date", date, 32);
	cache_get_value_name(0, "text", text, 145);

	Dialog_Show(playerid, MDC_InfoNiner, DIALOG_STYLE_MSGBOX, "MDC - Resultado da busca (Niner)", "{FFFFFF}\n* NÚMERO SOLICITANTE *\n%s\n\n* DATA DA LIGAÇÃO *\n%s\n\n* DESCRIÇÃO DO OCORRIDO *\n%s", "<<", "", Phone_FormatNumber(callernumber), date, text);

	HidePlayerFooter(playerid);

	return 1;
}

this::QUERY_ListAPB(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
	{
		HidePlayerFooter(playerid);
		return SendWarningMessage(playerid, "O banco de dados do MDC não localizou um APB em atividade.");
	}

	new date[32], apb, text[144], count;

	sz_MiscString[0] = 0;

	format(sz_MiscString, sizeof(sz_MiscString), "APB\tData\tOcorrência\n");

	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name_int(i, "apb", apb);
		cache_get_value_name(i, "date", date, 32);
		cache_get_value_name(i, "text", text, 144);

		if(strlen(text) > 50)
			format(sz_MiscString, sizeof(sz_MiscString), "%s#%d\t%s\t%.50s ...", sz_MiscString, apb, date, text);
		else
			format(sz_MiscString, sizeof(sz_MiscString), "%s#%d\t%s\t%s", sz_MiscString, apb, date, text);

		ListedOptions[playerid][count++] = apb;
	}	

	Dialog_Show(playerid, MDC_APB, DIALOG_STYLE_TABLIST_HEADERS, "MDC - Últimos APB registrados", sz_MiscString, "Verificar", "<<");

	HidePlayerFooter(playerid);

	return 1;
}

this::QUERY_LoadAPB(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
		return SendWarningMessage(playerid, "O APB informado não está mais em atividade ou é inexistente.");

	new date[32], apb, text[144];

	cache_get_value_name_int(0, "apb", apb);
	cache_get_value_name(0, "date", date, 32);
	cache_get_value_name(0, "text", text, 144);

	SendClientMessageEx(playerid, -1, "--- APB #%d ---", apb);
	SendClientMessageEx(playerid, -1, "Data do registro: %s", date);

	if(strlen(text) > 144)
	{
		SendClientMessageEx(playerid, -1, "Ocorrência registrada: %.64s", text);
		SendClientMessageEx(playerid, -1, "...%s", text[64]);
	}
	else
	{
		SendClientMessageEx(playerid, -1, "Ocorrência registrada: %s", text);
	}

	SendClientMessageEx(playerid, -1, "--- APB #%d ---", apb);

	return 1;
}

this::QUERY_NewAPB(playerid)
{
	SendGreenMessage(playerid, "Sua solicitação para o registro de um novo APB foi processada com sucesso.");
	SendFactionMessage(PlayerData[playerid][pFaction], FactionData[PlayerData[playerid][pFaction]][factionColor], "** HQ: %s %s registrou um novo APB sob o número #%d.", Faction_GetRank(playerid), ReturnName(playerid, 0), cache_insert_id());

	return 1;
}

/* Dialogs */
Dialog:MDC_Main(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0:
				Dialog_Show(playerid, MDC_SearchPlayer, DIALOG_STYLE_INPUT, "MDC - Pesquisar Cidadão", "Digite o Nome ou ID do cidadão que você deseja pesquisar:\nSERVER: Siga os formatos para pesquisar:\n\tPara ID, id:PlayerID.\n\tPara o nome, use Nome_Sobrenome.", "Pesquisar", "<<");
			case 1:
				Dialog_Show(playerid, MDC_SearchVehicle, DIALOG_STYLE_INPUT, "MDC - Pesquisar Veículo", "Digite o ID ou Placa do veículo que você deseja pesquisar:\nSERVER: Para pesquisar o ID do Veículo siga o formato:\n\tid:VehicleID (/dl)\n\tExemplo: id:123", "Pesquisar", "<<");
			case 2:
				Dialog_Show(playerid, MDC_SearchPhone, DIALOG_STYLE_INPUT, "MDC - Pesquisar Número", "Digite o número telefônico que você deseja pesquisar:", "Pesquisar", "<<");
			case 3:
				Dialog_Show(playerid, MDC_SearchNiner, DIALOG_STYLE_INPUT, "MDC - Pesquisar Niner", "Digite o ID do Niner que você deseja pesquisar:", "Pesquisar", "<<");
			case 4:
			{
				mysql_tquery(this, "SELECT * FROM police_apb ORDER BY apb DESC", "QUERY_ListAPB", "d", playerid);
				ShowPlayerFooter(playerid, "~y~Carregando...");
			}
			case 5:
			{
				mysql_tquery(this, "SELECT * FROM police_niners ORDER BY niner DESC LIMIT 30", "QUERY_ListNiner", "d", playerid);
				ShowPlayerFooter(playerid, "~y~Carregando...");
			}
		}
	}

	return 1;
}

Dialog:MDC_SearchPlayer(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(!strlen(inputtext))
			return Dialog_Show(playerid, MDC_SearchPlayer, DIALOG_STYLE_INPUT, "MDC - Pesquisar Cidadão", "Informe algo para pesquisar!\n\nDigite o Nome ou ID do cidadão que você deseja pesquisar:\nSERVER: Siga os formatos para pesquisar:\n\tPara ID, id:PlayerID.\n\tPara o nome, use Nome_Sobrenome.", "Pesquisar", "<<");
	
		new used_id = strfind(inputtext, "id:"), query[74];
		if(used_id != -1)
		{
			if(!IsNumber(inputtext[used_id + 3]))
				return Dialog_Show(playerid, MDC_SearchPlayer, DIALOG_STYLE_INPUT, "MDC - Pesquisar Cidadão", "Digite apenas números no modo de uso por ID.\n\nDigite o Nome ou ID do cidadão que você deseja pesquisar:\nSERVER: Siga os formatos para pesquisar:\n\tPara ID, id:PlayerID.\n\tPara o nome, use Nome_Sobrenome.", "Pesquisar", "<<");
			
			new id = strval(inputtext[used_id + 3]);

			if(!IsPlayerConnected(id))
				return Dialog_Show(playerid, MDC_SearchPlayer, DIALOG_STYLE_INPUT, "MDC - Pesquisar Cidadão", "ID informado é inválido ou está off-line.\n\nDigite o Nome ou ID do cidadão que você deseja pesquisar:\nSERVER: Siga os formatos para pesquisar:\n\tPara ID, id:PlayerID.\n\tPara o nome, use Nome_Sobrenome.", "Pesquisar", "<<");
			
			mysql_format(this, query, sizeof(query), "SELECT * FROM players WHERE UserID = '%d'", PlayerData[id][pID]);
			mysql_tquery(this, query, "QUERY_MDCLoadPlayer", "d", playerid);
		}
		else
		{
			if(!IsValidRoleplayName(inputtext))
				return Dialog_Show(playerid, MDC_SearchPlayer, DIALOG_STYLE_INPUT, "MDC - Pesquisar Cidadão", "Utilize o formato Nome_Sobrenome.\n\nDigite o Nome ou ID do cidadão que você deseja pesquisar:\nSERVER: Siga os formatos para pesquisar:\n\tPara ID, id:PlayerID.\n\tPara o nome, use Nome_Sobrenome.", "Pesquisar", "<<");
		
			mysql_format(this, query, sizeof(query), "SELECT * FROM players WHERE Name = '%e'", inputtext);
			mysql_tquery(this, query, "QUERY_MDCLoadPlayer", "d", playerid);
		}
		ShowPlayerFooter(playerid, "~y~Carregando...");
	}
	else
	{
		callcmd::mdc(playerid);
	}

	return 1;
}

Dialog:MDC_InfoPlayer(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		Dialog_Show(playerid, MDC_SearchPlayer, DIALOG_STYLE_INPUT, "MDC - Pesquisar Cidadão", "Digite o Nome ou ID do cidadão que você deseja pesquisar:\nSERVER: Siga os formatos para pesquisar:\n\tPara ID, id:PlayerID.\n\tPara o nome, use Nome_Sobrenome.", "Pesquisar", "<<");
	}

	return 1;
}

Dialog:MDC_SearchVehicle(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(!strlen(inputtext))
			return Dialog_Show(playerid, MDC_SearchVehicle, DIALOG_STYLE_INPUT, "MDC - Pesquisar Veículo", "Informe algo para pesquisar!\n\nDigite o ID ou Placa do veículo que você deseja pesquisar:\nSERVER: Para pesquisar o ID do Veículo siga o formato:\n\tid:VehicleID (/dl)\n\tExemplo: id:123", "Pesquisar", "<<");
	
		new used_id = strfind(inputtext, "id:"), query[110];

		if(used_id != -1)
		{
			if(!IsNumber(inputtext[used_id + 3]))
				return Dialog_Show(playerid, MDC_SearchVehicle, DIALOG_STYLE_INPUT, "MDC - Pesquisar Veículo", "Digite apenas números no modo de uso por ID.\n\nDigite o ID ou Placa do veículo que você deseja pesquisar:\nSERVER: Para pesquisar o ID do Veículo siga o formato:\n\tid:VehicleID (/dl)\n\tExemplo: id:123", "Pesquisar", "<<");
		
			new id = strval(inputtext[used_id + 3]);

			if(!IsValidVehicle(id))
				return Dialog_Show(playerid, MDC_SearchVehicle, DIALOG_STYLE_INPUT, "MDC - Pesquisar Veículo", "ID informado é inválido ou veículo não existe.\n\nDigite o ID ou Placa do veículo que você deseja pesquisar:\nSERVER: Para pesquisar o ID do Veículo siga o formato:\n\tid:VehicleID (/dl)\n\tExemplo: id:123", "Pesquisar", "<<");
		
			mysql_format(this, query, sizeof(query), "SELECT * FROM carros WHERE vehiclePlate = '%e' AND vehicleFaction = '0' AND vehicleJob = '-1'", VehicleData[id][vehiclePlate]);
			mysql_tquery(this, query, "QUERY_MDCLoadVehicle", "d", playerid);
		}
		else
		{
			if(inputtext[3] != '-')
				return Dialog_Show(playerid, MDC_SearchVehicle, DIALOG_STYLE_INPUT, "MDC - Pesquisar Veículo", "Utilize o formato ABC-1234.\n\nDigite o ID ou Placa do veículo que você deseja pesquisar:\nSERVER: Para pesquisar o ID do Veículo siga o formato:\n\tid:VehicleID (/dl)\n\tExemplo: id:123", "Pesquisar", "<<");
			
			mysql_format(this, query, sizeof(query), "SELECT * FROM carros WHERE vehiclePlate = '%e' AND vehicleFaction = '0' AND vehicleJob = '-1'", inputtext);
			mysql_tquery(this, query, "QUERY_MDCLoadVehicle", "d", playerid);
		}
		ShowPlayerFooter(playerid, "~y~Carregando...");
	}
	else
	{
		callcmd::mdc(playerid);
	}

	return 1;
}

Dialog:MDC_InfoVehicle(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		Dialog_Show(playerid, MDC_SearchVehicle, DIALOG_STYLE_INPUT, "MDC - Pesquisar Veículo", "Digite o ID ou Placa do veículo que você deseja pesquisar:\nSERVER: Para pesquisar o ID do Veículo siga o formato:\n\tid:VehicleID (/dl)\n\tExemplo: id:123", "Pesquisar", "<<");
	}

	return 1;
}

Dialog:MDC_SearchPhone(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new phone;

		if(sscanf(inputtext, "d", phone))
			return Dialog_Show(playerid, MDC_SearchPhone, DIALOG_STYLE_INPUT, "MDC - Pesquisar Número", "Informe algo para pesquisar!\n\nDigite o número telefônico que você deseja pesuisar:", "Pesquisar", "<<");

		if(phone < 10000 || phone > 9999999)
			return Dialog_Show(playerid, MDC_SearchPhone, DIALOG_STYLE_INPUT, "MDC - Pesquisar Número", "Número telefônico inválido ou inexistente.\n\nDigite o número telefônico que você deseja pesuisar:", "Pesquisar", "<<");
	
		new query[70];

		mysql_format(this, query, sizeof(query), "SELECT Cellphone, Name FROM players WHERE Cellphone = '%d'", phone);
		mysql_tquery(this, query, "QUERY_MDCLoadPhone", "d", playerid);

		ShowPlayerFooter(playerid, "~y~Carregando...");
	}
	else
	{
		callcmd::mdc(playerid);
	}

	return 1;
}

Dialog:MDC_InfoPhone(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		Dialog_Show(playerid, MDC_SearchPhone, DIALOG_STYLE_INPUT, "MDC - Pesquisar Número", "Digite o número telefônico que você deseja pesuisar:", "Pesquisar", "<<");
	}

	return 1;
}

Dialog:MDC_SearchNiner(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new ninerid;

		if(sscanf(inputtext, "d", ninerid))
			return Dialog_Show(playerid, MDC_SearchNiner, DIALOG_STYLE_INPUT, "MDC - Pesquisar Niner", "Informe algo para pesquisar!\n\nDigite o ID do Niner que você deseja pesquisar:", "Pesquisar", "<<");
	
		if(ninerid < 1 || ninerid > 9999999999)
			return Dialog_Show(playerid, MDC_SearchNiner, DIALOG_STYLE_INPUT, "MDC - Pesquisar Niner", "Niner ID informado é inválido ou inexistente.\n\nDigite o ID do Niner que você deseja pesquisar:", "Pesquisar", "<<");
	
		new query[57];

		mysql_format(this, query, sizeof(query), "SELECT * FROM police_niners WHERE niner = '%d'", ninerid);
		mysql_tquery(this, query, "QUERY_MDCLoadNiner", "d", playerid);

		ShowPlayerFooter(playerid, "~y~Carregando...");
	}
	else
	{
		callcmd::mdc(playerid);
	}

	return 1;
}

Dialog:MDC_InfoNiner(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		Dialog_Show(playerid, MDC_SearchNiner, DIALOG_STYLE_INPUT, "MDC - Pesquisar Niner", "Digite o ID do Niner que você deseja pesquisar:", "Pesquisar", "<<");
	}

	return 1;
}

Dialog:MDC_APB(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new id = ListedOptions[playerid][listitem], call_cmd[17];

		format(call_cmd, sizeof(call_cmd), "ver %d", id);

		callcmd::apb(playerid, call_cmd);
	}
	else
	{
		callcmd::mdc(playerid);
	}
	return 1;
}

Dialog:MDC_ListNiner(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		callcmd::mdc(playerid);
	}

	return 1;
}