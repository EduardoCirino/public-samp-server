/*
	
	Discord system.
	Autor: Eduardo
	Contribuições: -
	Data: 13/01/2019
	Comandos: !serverinfo, !anuncio, !verificarlog, !checarcasa, !checarveiculos

*/

/* Discord Command Performed */
this::DCC_CommandPerformed(command[], DCC_Channel:channel, success)
{
	if(!success)
		return SendDiscordMessage(channel, "Você digitou o comando **!%s** que é inválido.\nVocê pode conferir a lista completa dos comandos nas **mensagens fixadas** do canal <#534070711636066304>.", command);

	return 1;
}

/* Comandos */
DDCMD:stresstest(DCC_Channel:channel, DCC_User:userid, params[])
{
	if(!Discord_IsStaffTeam(userid))
		return SendDiscordMessage(channel, "Apenas usuários com o cargo **Staff Team** podem executar este comando.");

	if(strcmp(Discord_GetID(userid), "292139809541980160"))
		return SendDiscordMessage(channel, "Comando restrito apenas para **Developer**.");

	new loop;

	if(sscanf(params, "d", loop))
		return SendDiscordMessage(channel, "<@%s> -> Use: !stresstest [loop quantity]", Discord_GetID(userid));

	new count, initial_tick = GetTickCount(), end_tick;

	for(new i = 0; i < loop; i++)
	{
		if(SendDiscordMessage(channel, "Stress Number: %d", i + 1))
			count++;
	}

	end_tick = GetTickCount() - initial_tick;

	SendDiscordMessage(channel, "<@%s> -> STRESS TESTE - Resultado final: %d de %d mensagens enviadas. (Code response time: %d)", Discord_GetID(userid), count, loop, end_tick);

	return 1;
}

DDCMD:serverinfo(DCC_Channel:channel, DCC_User:userid, params[])
{
	if(!Discord_IsStaffTeam(userid))
		return SendDiscordMessage(channel, "Apenas usuários com o cargo **Staff Team** podem executar este comando.");

	new count, admins, working;

	foreach(new i : Player) if(PlayerData[i][pLogged])
	{
		if(PlayerData[i][pAdmin])
		{
			admins++;

			if(PlayerData[i][pAdminStatus])
				working++;
		}
		count++;
	}

	SendDiscordMessage(channel, "```js\n**Informações atuais do servidor**\n\nEndereço de IP:          %s:7777\nJogadores online:        %d\nAdministratores:         %d (%d em trabalho)```", SERVER_IP, count, admins, working);
	
	count = 0;
	DCC_GetGuildMemberCount(MeioTermo_Discord, count);

	SendDiscordMessage(channel, "```js\n**Informações atuais do discord**\n\nNúmero total de usuários:      %d\n```", count);

	SendDiscordMessage(channel, "Comando requisitado por: <@%s>", Discord_GetID(userid));

	return 1;
}

DDCMD:verificarlog(DCC_Channel:channel, DCC_User:userid, params[])
{
	if(!Discord_IsStaffTeam(userid))
		return SendDiscordMessage(channel, "Apenas usuários com o cargo **Staff Team** podem executar este comando.");

	new username[24], search[64];

	if(sscanf(params, "s[24]s[64]", username, search))
		return SendDiscordMessage(channel, "<@%s> -> Use: !verificarlog [nome completo] [registro|data] // Exemplo: !verificarlog Terrell_Torres Kick|13/01/2019", Discord_GetID(userid));

	if(!IsValidRoleplayName(username))
		return SendDiscordMessage(channel, "<@%s> -> Erro: Nome inválido, por favor siga o formato: Nome_Sobrenome.", Discord_GetID(userid));

	new opt[2][32];
	sscanf(search, "p<|>s[32]s[32]", opt[0], opt[1]);

	new query[183];
	mysql_format(this, query, sizeof(query), "SELECT * FROM player_log WHERE PlayerID = '%d' AND Log LIKE '%%%s%%' AND Log LIKE '%%%s%%' ORDER BY LogID DESC LIMIT 15", ReturnIDByName(username), opt[0], opt[1]);
	mysql_tquery(this, query, "Discord_RequestPlayerLog", "ddss", _:channel, _:userid, username, search);

	return 1;
}

this::Discord_RequestPlayerLog(DCC_Channel:channel, DCC_User:userid, username[], search[])
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
		return SendDiscordMessage(channel, "<@%s> -> Erro: Nenhum resultado para %s e critério de busca \"%s\".", Discord_GetID(userid), username, search);

	new log[200], count;

	sz_MiscString[0] = 0;

	format(sz_MiscString, sizeof(sz_MiscString), "```\n");

	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name(i, "Log", log, 200);
		format(sz_MiscString, sizeof(sz_MiscString), "%s%s\n", sz_MiscString, log);
		count++;
	}

	format(sz_MiscString, sizeof(sz_MiscString), "%s\n```", sz_MiscString);
	SendLargeEncodedMesasge(channel, sz_MiscString);

	SendDiscordMessage(channel, "Comando requisitado por: <@%s>", Discord_GetID(userid));
	
	return 1;
}

DDCMD:anuncio(DCC_Channel:channel, DCC_User:userid, params[])
{
	if(!Discord_IsStaffTeam(userid))
		return SendDiscordMessage(channel, "Apenas usuários com o cargo **Staff Team** podem executar este comando.");

	if(isnull(params))
		return SendDiscordMessage(channel, "<@%s> -> Use: !anuncio [mensagem]", Discord_GetID(userid));

	if(strlen(params) > 144)
		return SendDiscordMessage(channel, "<@%s> -> Erro: Limite de caracteres atingido (144).", Discord_GetID(userid));

	foreach(new i : Player) if(PlayerData[i][pLogged])
	{
		SendClientMessageEx(i, COLOR_YELLOW, "|__________ Anúncio Administrativo __________|");

		if(strlen(params) > 64)
		{
			SendClientMessageEx(i, COLOR_WHITE, "[Discord] %s: %.64s", Discord_GetName(userid), params);
			SendClientMessageEx(i, COLOR_WHITE, "...%s", params[64]);
		}
		else
		{
			SendClientMessageEx(i, COLOR_WHITE, "[Discord] %s: %s", Discord_GetName(userid), params);
		}
	}

	SendDiscordMessage(channel, "<@%s> -> Mensagem \"%s\" enviada para todos online.", Discord_GetID(userid), params);

	return 1;
}

DDCMD:checarcasa(DCC_Channel:channel, DCC_User:userid, params[])
{
	if(!Discord_IsStaffTeam(userid))
		return SendDiscordMessage(channel, "Apenas usuários com o cargo **Staff Team** podem executar este comando.");

	new type[9], option[32];

	if(sscanf(params, "s[9]S()[32]", type, option))
		return SendDiscordMessage(channel, "<@%s> -> Use: !checarcasa [real/unico/endereço] [id/endereço]", Discord_GetID(userid));

	if(!strcmp(type, "real", true))
	{
		new id;

		if(sscanf(option, "d", id))
			return SendDiscordMessage(channel, "<@%s> -> Use: !checarcasa real [id]", Discord_GetID(userid));

		if(id < 0 || id >= MAX_HOUSES || !HouseData[id][houseExists])
			return SendDiscordMessage(channel, "<@%s> -> Erro: **ID Real: %d** não encontrado ou é inválido.", Discord_GetID(userid), id);

		new string[444], wepstring[23 * MAX_HOUSES_WEAPON];

		for(new w = 0; w < MAX_HOUSES_WEAPON; w++)
		{
			format(wepstring, sizeof(wepstring), "%sS:%d W:%d A:%d|", wepstring, w + 1, HouseData[id][houseWeapon][w], HouseData[id][houseAmmo][w]);
		}

		format(string, sizeof(string), "```***          Informações da propriedade:          ***\n\
			Registro único:          %d\n\
			Registro real:           %d\n\
			Endereço:                %s > Pertecente a: %s (uid: %d)\n\
			Cofre:                   %s\n\
			Armazenamento de armas:  %.*s```",
			HouseData[id][houseID], id, HouseData[id][houseAddress], ReturnNameByID(HouseData[id][houseOwner]), HouseData[id][houseOwner], FormatNumber(HouseData[id][houseMoney]), strlen(wepstring) - 1, wepstring, Discord_GetID(userid));
		
		SendLargeEncodedMesasge(channel, string);
		SendDiscordMessage(channel, "Comando requisitado por: <@%s>", Discord_GetID(userid));
	}
	else if(!strcmp(type, "único", true))
	{
		new id;

		if(sscanf(option, "d", id))
			return SendDiscordMessage(channel, "<@%s> -> Use: !checarcasa único [id]", Discord_GetID(userid));

		foreach(new i : Houses)
		{
			if(HouseData[i][houseExists] && HouseData[i][houseID] == id)
			{
				new string[444], wepstring[23 * MAX_HOUSES_WEAPON];

				for(new w = 0; w < MAX_HOUSES_WEAPON; w++)
				{
					format(wepstring, sizeof(wepstring), "%sS:%d W:%d A:%d|", wepstring, w + 1, HouseData[i][houseWeapon][w], HouseData[i][houseAmmo][w]);
				}

				format(string, sizeof(string), "```***          Informações da propriedade:          ***\n\
					Registro único:          %d\n\
					Registro real:           %d\n\
					Endereço:                %s > Pertecente a: %s (uid: %d)\n\
					Cofre:                   %s\n\
					Armazenamento de armas:  %.*s```",
					HouseData[i][houseID], i, HouseData[i][houseAddress], ReturnNameByID(HouseData[i][houseOwner]), HouseData[i][houseOwner], FormatNumber(HouseData[i][houseMoney]), strlen(wepstring) - 1, wepstring, Discord_GetID(userid));
			
				SendLargeEncodedMesasge(channel, string);
				SendDiscordMessage(channel, "Comando requisitado por: <@%s>", Discord_GetID(userid));

				return 1;
			}
		}
		SendDiscordMessage(channel, "<@%s> -> Erro: **ID Uníco: %d** não encontrado ou é inválido.", Discord_GetID(userid), id);
	}
	else if(!strcmp(type, "endereço", true))
	{
		new address[32];

		if(sscanf(option, "s[32]", address))
			return SendDiscordMessage(channel, "<@%s> -> Use: !checarcasa endereço [endereço]", Discord_GetID(userid));

		foreach(new i : Houses)
		{
			if(HouseData[i][houseExists] && !strcmp(HouseData[i][houseAddress], address, true))
			{
				new string[444], wepstring[23 * MAX_HOUSES_WEAPON];

				for(new w = 0; w < MAX_HOUSES_WEAPON; w++)
				{
					format(wepstring, sizeof(wepstring), "%sS:%d W:%d A:%d|", wepstring, w + 1, HouseData[i][houseWeapon][w], HouseData[i][houseAmmo][w]);
				}

				format(string, sizeof(string), "```***          Informações da propriedade:          ***\n\
					Registro único:          %d\n\
					Registro real:           %d\n\
					Endereço:                %s > Pertecente a: %s (uid: %d)\n\
					Cofre:                   %s\n\
					Armazenamento de armas:  %.*s```",
					HouseData[i][houseID], i, HouseData[i][houseAddress], ReturnNameByID(HouseData[i][houseOwner]), HouseData[i][houseOwner], FormatNumber(HouseData[i][houseMoney]), strlen(wepstring) - 1, wepstring, Discord_GetID(userid));
			
				SendLargeEncodedMesasge(channel, string);
				SendDiscordMessage(channel, "Comando requisitado por: <@%s>", Discord_GetID(userid));

				return 1;
			}
		}
		SendDiscordMessage(channel, "<@%s> -> Erro: **Endereço: %s** não encontrado.", Discord_GetID(userid), address);
	}
	else
		SendDiscordMessage(channel, "<@%s> -> Opção inválida, use **real**, **único** ou **endereço**.", Discord_GetID(userid));

	return 1;
}

DDCMD:checarveiculos(DCC_Channel:channel, DCC_User:userid, params[])
{
	if(!Discord_IsStaffTeam(userid))
		return SendDiscordMessage(channel, "Apenas usuários com o cargo **Staff Team** podem executar este comando.");

	if(isnull(params))
		return SendDiscordMessage(channel, "<@%s> -> Use: !checarveiculos [nome_completo] Exemplo: !checarveiculos Terrell_Torres", Discord_GetID(userid));

	if(!IsValidRoleplayName(params))
		return SendDiscordMessage(channel, "<@%s> -> Erro: Nome inválido, por favor siga o formato: Nome_Sobrenome.", Discord_GetID(userid));

	new query[100];

	mysql_format(this, query, sizeof(query), "SELECT * FROM carros WHERE ID = (SELECT UserID FROM players WHERE Name = '%e')", params);
	mysql_tquery(this, query, "Discord_RequestPlayerVehicles", "dds",  _:channel, _:userid, params);

	return 1;
}

this::Discord_RequestPlayerVehicles(DCC_Channel:channel, DCC_User:userid, username[])
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
		return SendDiscordMessage(channel, "<@%s> -> Erro: Nenhum resultado encontrado para: \"%s\".", Discord_GetID(userid), username);

	new 
		uid,
		vehicleweapon[35], 
		vehicleinsideweapon, 
		vehicleammo[35], 
		vehicleinsideammo, 
		model, 
		parkstatus, 
		price, 
		Float:maxhealth, 
		ownerid, 
		plate[10],
		parked[20],
		count,
		wepcount
	;

	//strings
	new stringweapons[525];

	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name_int(i, "vehicleID", uid);
		cache_get_value_name_int(i, "vehicleModel", model);
		cache_get_value_name_int(i, "vehicleParked", parkstatus);
		cache_get_value_name_int(i, "vehiclePrice", price);
		cache_get_value_name_float(i, "vehicleMaxHealth", maxhealth);
		cache_get_value_name_int(i, "ID", ownerid);

		cache_get_value_name(i, "vehiclePlate", plate, 10);

		cache_get_value_name_int(i, "vehicleInteriorWeapon", vehicleinsideweapon);
		cache_get_value_name_int(i, "vehicleInteriorAmmo", vehicleinsideammo);

		cache_get_value_name(i, "vehicleWeapon", stringweapons, 525);
		sscanf(stringweapons, "p<|>dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
			vehicleweapon[0], vehicleammo[0],
			vehicleweapon[1], vehicleammo[1],
			vehicleweapon[2], vehicleammo[2],
			vehicleweapon[3], vehicleammo[3],
			vehicleweapon[4], vehicleammo[4],
			vehicleweapon[5], vehicleammo[5],
			vehicleweapon[6], vehicleammo[6],
			vehicleweapon[7], vehicleammo[7],
			vehicleweapon[8], vehicleammo[8],
			vehicleweapon[9], vehicleammo[9],
			vehicleweapon[10], vehicleammo[10],
			vehicleweapon[11], vehicleammo[11],
			vehicleweapon[12], vehicleammo[12],
			vehicleweapon[13], vehicleammo[13],
			vehicleweapon[14], vehicleammo[14],
			vehicleweapon[15], vehicleammo[15],
			vehicleweapon[16], vehicleammo[16],
			vehicleweapon[17], vehicleammo[17],
			vehicleweapon[18], vehicleammo[18],
			vehicleweapon[19], vehicleammo[19],
			vehicleweapon[20], vehicleammo[20],
			vehicleweapon[21], vehicleammo[21],
			vehicleweapon[22], vehicleammo[22],
			vehicleweapon[23], vehicleammo[23],
			vehicleweapon[24], vehicleammo[24],
			vehicleweapon[25], vehicleammo[25],
			vehicleweapon[26], vehicleammo[26],
			vehicleweapon[27], vehicleammo[27],
			vehicleweapon[28], vehicleammo[28],
			vehicleweapon[29], vehicleammo[29],
			vehicleweapon[30], vehicleammo[30],
			vehicleweapon[31], vehicleammo[31],
			vehicleweapon[32], vehicleammo[32],
			vehicleweapon[33], vehicleammo[33],
			vehicleweapon[34], vehicleammo[34]);

		stringweapons[0] = EOS;
		parked[0] = EOS;
		wepcount = 0;

		for(new w = 0; w < Car_TrunkWeaponSlots(model); w++)
		{
			if(vehicleweapon[w] != 0)
			{
				format(stringweapons, sizeof(stringweapons), "%sS:%d W:%d A:%d|", stringweapons, w + 1, vehicleweapon[w], vehicleammo[w]);
				wepcount++;
			}
		}

		if(!wepcount)
			format(stringweapons, sizeof(stringweapons), "Esse veículo não possui uma arma guardada dentro do porta-malas..");

		switch(parkstatus)
		{
			case 0: parked = "Despawnado";
			case 1:
			{
				foreach(new v : Vehicles) if(VehicleData[v][vehicleID] == uid)
				{
					format(parked, sizeof(parked), "Spawnado (ID: %d)", v);
					break;
				}				
			}
			case 2: parked = "Apreendido (LSPD)";
			case 3: parked = "Roubado/Furtado";
		}

		format(sz_MiscString, sizeof(sz_MiscString), "```***           Informações do Veículo           ***\n\
			ID Único:                 %d\n\
			Proprietário:             %s (uid: %d)\n\
			Situação:                 %s\n\
			Lataria máxima:           %.2f\n\
			Modelo:                   %s\n\
			Placa:                    %s\n\
			Preço (concessionária):   %s\n\
			Porta-malas (armas):      %.*s\n\
			Porta-luvas (arma):       S:1 W:%d A:%d```",
			uid, username, ownerid, parked, maxhealth, ReturnVehicleModelName(model), plate, FormatNumber(price), strlen(stringweapons) - 1, stringweapons, vehicleinsideweapon, vehicleinsideammo);

		SendLargeEncodedMesasge(channel, sz_MiscString);

		count++;
	}

	SendDiscordMessage(channel, "%d %s. Comando requisitado por: <@%s>", count, count == 1 ? "resultado" : "resultados", Discord_GetID(userid));

	return 1;
}

/* Funções */
Discord_GetID(DCC_User:userid)
{
	new id[64];

	DCC_GetUserId(userid, id);

	return id;
}

Discord_GetName(DCC_User:userid)
{
	new name[32];

	DCC_GetUserName(userid, name);

	return name;
}

SendLargeEncodedMesasge(DCC_Channel:channel, const text[])
{
	static dsz_MiscString[2000];

	dsz_MiscString[0] = 0;
	
	utf8encode(dsz_MiscString, text, sizeof(dsz_MiscString));
	
	DCC_SendChannelMessage(channel, dsz_MiscString);

	return 1;
}

Discord_IsStaffTeam(DCC_User:userid)
{
	static bool:user_is_admin;

	//Staff Team Role Check.
	DCC_HasGuildMemberRole(MeioTermo_Discord, userid, Staff_Team, user_is_admin);

	return user_is_admin;
}