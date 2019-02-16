/*

	Sistema de 'Quests/Daily'.
	Data: 06/10/2018.
	Desenvolvido por: Eduardo

*/

/* MAIN */

enum q_eDaily
{
	q_eTaskname[64],
	q_eTask,
	q_eRewardToken,
	q_eRewardMoney
}

static const q_aDaily[][q_eDaily] = 
{
	/* Caminhoneiro */
	{"Venda produtos para indústrias, empresas ou navio.", 110, 2, 5000},
	/* Mecanico */
	{"Repare a lataria ou motor de qualquer tipo de veículo.", 70, 2, 4000},
	/* Lixeiro */
	{"Recolha os lixos dos latões espalhados pela cidade.", 210, 2, 6500},
	/* Ladrão de Carros */
	{"Roube veículos particulares.", 7, 2, 11500},
	/* Advogado */
	{"Ofereça seu serviço de advogado e obtenha sucesso.", 14, 2, 7500},
	/* Pescador */
	{"Faça uma pescaria utilizando iscas.", 118, 2, 7500},
	/* Pescador */
	{"Compre ou clone mobílias para casas.", 241, 2, 6500},
	/* Minigame sys */
	{"Acerte 1000 alvos no mini-game Parrot", 300, 2, 15000}
};

/* COMMANDS OR NATIVE PUBLICS */

CMD:minhatask(playerid)
{
	SendClientMessage(playerid, COLOR_WHITE, "|___________ Resumo da sua Daily ___________|");

	if(PlayerData[playerid][pTaskID] == -1)
		return SendWarningMessage(playerid, "* Você não aceitou a sua Daily Task de hoje.");

	SendGreenMessage(playerid, "* Sua task diária é: %s", q_aDaily[PlayerData[playerid][pTaskID] - 1][q_eTaskname]);
	SendGreenMessage(playerid, "* Progresso: %d/%d", q_aDaily[PlayerData[playerid][pTaskID] - 1][q_eTask] - PlayerData[playerid][pTaskQuantity], q_aDaily[PlayerData[playerid][pTaskID] - 1][q_eTask]);

	return 1;
}

CMD:abrirpainel(playerid)
{
	Dialog_Show(playerid, DailyPanel, DIALOG_STYLE_LIST, "Daily Task", "Verificar minha Daily Task\nEntregar Daily Task", "Selecionar", "Cancelar");

	return 1;
}


/* DIALOGS */

Dialog:DailyPanel(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
				if(PlayerData[playerid][pTaskID] != -1)
					return SendWarningMessage(playerid, "Você já está em uma Daily Task, confira em: /minhatask.");

				Daily_PanelStatus(playerid, true);
			}
			case 1:
			{
				if(PlayerData[playerid][pTaskID] == -1)
					return SendWarningMessage(playerid, "Você não iniciou a sua Daily Task.");

				if(PlayerData[playerid][pTaskQuantity] != 0)
					return SendWarningMessage(playerid, "Você precisa finalizar a sua Daily Task, seu progresso é: %d/%d", q_aDaily[PlayerData[playerid][pTaskID] - 1][q_eTask] - PlayerData[playerid][pTaskQuantity], q_aDaily[PlayerData[playerid][pTaskID] - 1][q_eTask]);
			
				Inventory_Add(playerid, "Token (unique item)", 19347, q_aDaily[PlayerData[playerid][pTaskID] - 1][q_eRewardToken]);
				GiveScriptedMoney(playerid, q_aDaily[PlayerData[playerid][pTaskID] - 1][q_eRewardMoney]);

				new query[85];
				mysql_format(this, query, sizeof(query), "UPDATE dailytasks SET concluded = '1' WHERE player_id = '%d' AND accepted = '1'", PlayerData[playerid][pID]);
				mysql_tquery(this, query);

				PlayerData[playerid][pTaskID] = -1;
				PlayerData[playerid][pTaskQuantity] = 0;

				SendGreenMessage(playerid, "Você terminou a sua task de hoje, aqui está a sua recompensa. Volte amanhã para conseguir outra.");
			}
		}
	}
	return 1;
}


/* STOCKS */

Daily_PanelStatus(playerid, bool:status)
{
	if(status)
	{
		new query[64];

		mysql_format(this, query, sizeof(query), "SELECT * FROM dailytasks WHERE player_id = '%d'", PlayerData[playerid][pID]);
		mysql_tquery(this, query, "GetPlayerTask", "d", playerid);
	}
	else
	{
		CancelSelectTextDraw(playerid);

		for(new i = 0; i < 9; i++)
		{
			PlayerTextDrawHide(playerid, DailyText[playerid][i]);
		}

		Daily_Opened[playerid] = false;
	}

	return 1;
}

Daily_Check(playerid)
{
	new query[85];

	mysql_format(this, query, sizeof(query), "SELECT * FROM dailytasks WHERE player_id = '%d'", PlayerData[playerid][pID]);
	mysql_tquery(this, query, "OnPlayerCheckDaily", "d", playerid);

	return 1;
}

Daily_Save(playerid)
{
	if(PlayerData[playerid][pTaskID] == -1)
		return 0;

	new query[110];

	mysql_format(this, query, sizeof(query), "UPDATE dailytasks SET quantity = '%d' WHERE player_id ='%d' AND task_id = '%d'", PlayerData[playerid][pTaskQuantity], PlayerData[playerid][pID], PlayerData[playerid][pTaskID]);
	mysql_tquery(this, query);

	return 1;
}

Daily_SetTask(playerid)
{
	new query[85];

	mysql_format(this, query, sizeof(query), "SELECT * FROM dailytasks WHERE player_id = '%d'", PlayerData[playerid][pID]);
	mysql_tquery(this, query, "SetPlayerTask", "d", playerid);

	return 1;
}

Daily_Update(playerid, taskid, quantity = 1)
{
	if(PlayerData[playerid][pTaskID] == -1)
		return 0;

	if(PlayerData[playerid][pTaskID] == taskid)
	{
		PlayerData[playerid][pTaskQuantity] -= quantity;

		new query[85];

		if(PlayerData[playerid][pTaskQuantity] <= 0)
		{
			SendGreenMessage(playerid, "* Você concluiu a sua Daily Task, você já pode pegar a sua recompensa.");
			mysql_format(this, query, sizeof(query), "UPDATE dailytasks SET quantity = '0', concluded = '1' WHERE player_id = '%d'", PlayerData[playerid][pID]);
			PlayerData[playerid][pTaskQuantity] = 0;
		}
		else
		{
			mysql_format(this, query, sizeof(query), "UPDATE dailytasks SET quantity = '%d' WHERE player_id = '%d'", PlayerData[playerid][pTaskQuantity], PlayerData[playerid][pID]);
		}

		mysql_tquery(this, query);
	}	

	return 1;
}

Daily_CreateTD(playerid)
{	
	DailyText[playerid][0] = CreatePlayerTextDraw(playerid, 320.333251, 96.925933, "mdl-1021:daily-background");
	PlayerTextDrawLetterSize(playerid, DailyText[playerid][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, DailyText[playerid][0], 222.000000, 233.000000);
	PlayerTextDrawAlignment(playerid, DailyText[playerid][0], 1);
	PlayerTextDrawColor(playerid, DailyText[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, DailyText[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, DailyText[playerid][0], 255);
	PlayerTextDrawFont(playerid, DailyText[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, DailyText[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][0], 0);

	DailyText[playerid][1] = CreatePlayerTextDraw(playerid, 473.666809, 266.170501, "mdl-1021:daily-accept");
	PlayerTextDrawLetterSize(playerid, DailyText[playerid][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, DailyText[playerid][1], 12.000000, 13.000000);
	PlayerTextDrawAlignment(playerid, DailyText[playerid][1], 1);
	PlayerTextDrawColor(playerid, DailyText[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, DailyText[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, DailyText[playerid][1], 255);
	PlayerTextDrawFont(playerid, DailyText[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, DailyText[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][1], 0);
	PlayerTextDrawSetSelectable(playerid, DailyText[playerid][1], true);

	DailyText[playerid][2] = CreatePlayerTextDraw(playerid, 371.000000, 156.000000, FixASCII("A_sua_task_diaria_de_hoje_é:"));
	PlayerTextDrawLetterSize(playerid, DailyText[playerid][2], 0.162666, 1.060740);
	PlayerTextDrawAlignment(playerid, DailyText[playerid][2], 1);
	PlayerTextDrawColor(playerid, DailyText[playerid][2], -2139062017);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, DailyText[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, DailyText[playerid][2], -1061109505);
	PlayerTextDrawFont(playerid, DailyText[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, DailyText[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][2], 0);

	DailyText[playerid][3] = CreatePlayerTextDraw(playerid, 371.000000, 196.000366, "Recompensas:");
	PlayerTextDrawLetterSize(playerid, DailyText[playerid][3], 0.162666, 1.060740);
	PlayerTextDrawAlignment(playerid, DailyText[playerid][3], 1);
	PlayerTextDrawColor(playerid, DailyText[playerid][3], -2139062017);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, DailyText[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, DailyText[playerid][3], -1061109505);
	PlayerTextDrawFont(playerid, DailyText[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, DailyText[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][3], 0);

	DailyText[playerid][4] = CreatePlayerTextDraw(playerid, 370.000000, 267.000000, "Para_aceitar~n~clique_no_icone_ao_lado");
	PlayerTextDrawLetterSize(playerid, DailyText[playerid][4], 0.089000, 0.782813);
	PlayerTextDrawAlignment(playerid, DailyText[playerid][4], 1);
	PlayerTextDrawColor(playerid, DailyText[playerid][4], -2139062017);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, DailyText[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, DailyText[playerid][4], -1061109505);
	PlayerTextDrawFont(playerid, DailyText[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, DailyText[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][4], 0);

	DailyText[playerid][5] = CreatePlayerTextDraw(playerid, 371.000000, 169.000000, "-");//taskname
	PlayerTextDrawLetterSize(playerid, DailyText[playerid][5], 0.130333, 1.280595);
	PlayerTextDrawAlignment(playerid, DailyText[playerid][5], 1);
	PlayerTextDrawColor(playerid, DailyText[playerid][5], -1378294017);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, DailyText[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, DailyText[playerid][5], 255);
	PlayerTextDrawFont(playerid, DailyText[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, DailyText[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][5], 0);

	DailyText[playerid][6] = CreatePlayerTextDraw(playerid, 371.000000, 180.000000, "Quantidade:_-");
	PlayerTextDrawLetterSize(playerid, DailyText[playerid][6], 0.130333, 1.280595);
	PlayerTextDrawAlignment(playerid, DailyText[playerid][6], 1);
	PlayerTextDrawColor(playerid, DailyText[playerid][6], -1378294017);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, DailyText[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, DailyText[playerid][6], 255);
	PlayerTextDrawFont(playerid, DailyText[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, DailyText[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][6], 0);

	DailyText[playerid][7] = CreatePlayerTextDraw(playerid, 371.000000, 208.000000, "Tokens:_-");
	PlayerTextDrawLetterSize(playerid, DailyText[playerid][7], 0.130333, 1.280595);
	PlayerTextDrawAlignment(playerid, DailyText[playerid][7], 1);
	PlayerTextDrawColor(playerid, DailyText[playerid][7], -1378294017);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, DailyText[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, DailyText[playerid][7], 255);
	PlayerTextDrawFont(playerid, DailyText[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, DailyText[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][7], 0);

	DailyText[playerid][8] = CreatePlayerTextDraw(playerid, 371.000000, 218.000000, "Dinheiro:_$-");
	PlayerTextDrawLetterSize(playerid, DailyText[playerid][8], 0.130333, 1.280595);
	PlayerTextDrawAlignment(playerid, DailyText[playerid][8], 1);
	PlayerTextDrawColor(playerid, DailyText[playerid][8], -1378294017);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, DailyText[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, DailyText[playerid][8], 255);
	PlayerTextDrawFont(playerid, DailyText[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, DailyText[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, DailyText[playerid][8], 0);

	return 1;
}

/* PUBLICS AND QUERIES */

this::OnPlayerCheckDaily(playerid)
{
	new rows, query[118];
	cache_get_row_count(rows);

	if(!rows)
	{
		new taskid = randomEx(1,7);

		mysql_format(this, query, sizeof(query), "INSERT INTO dailytasks (player_id, task_id, quantity, accepted, concluded) VALUES ('%d', '%d', '%d', '0', '0')", PlayerData[playerid][pID], taskid, q_aDaily[taskid-1][q_eTask]);
		mysql_tquery(this, query);

		return 1;
	}

	new playeraccepted, concluded;

	cache_get_value_name_int(0, "accepted", playeraccepted);
	cache_get_value_name_int(0, "concluded", concluded);

	if(playeraccepted && !concluded)
	{
		new taskid, taskquantity;

		cache_get_value_name_int(0, "task_id", taskid);
		cache_get_value_name_int(0, "quantity", taskquantity);

		PlayerData[playerid][pTaskID] = taskid;
		PlayerData[playerid][pTaskQuantity] = taskquantity;
	}

	return 1;
}

this::GetPlayerTask(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
		return SendWarningMessage(playerid, "Não foi possível localizar a sua Daily Task, entre em contato com um administrador.");

	new taskid, string[64];

	cache_get_value_name_int(0, "task_id", taskid);

	SelectTextDraw(playerid, 0x42F4CE77);

	format(string, sizeof(string), q_aDaily[taskid - 1][q_eTaskname]);
	for(new i = 0; i < strlen(string); i++)
	{
		if(string[i] == ' ')
		{
			string[i] = '_';
		}
	}
	PlayerTextDrawSetString(playerid, DailyText[playerid][5], FixASCII(string));

	format(string, sizeof(string), "Quantidade:_%d", q_aDaily[taskid - 1][q_eTask]);
	PlayerTextDrawSetString(playerid, DailyText[playerid][6], string);

	format(string, sizeof(string), "Tokens:_%d", q_aDaily[taskid - 1][q_eRewardToken]);
	PlayerTextDrawSetString(playerid, DailyText[playerid][7], string);

	format(string, sizeof(string), "Quantidade:_%s", FormatNumber(q_aDaily[taskid - 1][q_eRewardMoney]));
	PlayerTextDrawSetString(playerid, DailyText[playerid][8], string);

	for(new i = 0; i < 9; i++)
	{
		PlayerTextDrawShow(playerid, DailyText[playerid][i]);
	}

	Daily_Opened[playerid] = true;		

	return 1;
}

this::SetPlayerTask(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(!rows)
		return SendWarningMessage(playerid, "Não foi possível localizar a sua Daily Task, entre em contato com um administrador.");

	new query[85], taskid, taskquantity, concluded;

	cache_get_value_name_int(0, "concluded", concluded);

	if(concluded)
		return SendWarningMessage(playerid, "Você já concluiu a sua Daily Task hoje, tente novamente amanhã.");

	cache_get_value_name_int(0, "task_id", taskid);
	cache_get_value_name_int(0, "quantity", taskquantity);

	PlayerData[playerid][pTaskID] = taskid;
	PlayerData[playerid][pTaskQuantity] = taskquantity;

	mysql_format(this, query, sizeof(query), "UPDATE dailytasks SET accepted = '1' WHERE player_id = '%d'", PlayerData[playerid][pID]);
	mysql_tquery(this, query);

	SendGreenMessage(playerid, "Você iniciou uma Daily Task, complete-a até o final do dia para ganhar a recompensa.");

	Daily_PanelStatus(playerid, false);

	return 1;
}
