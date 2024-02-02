// SPIKES

new spikesmax[MAX_PLAYERS] = 0; // Проверка на кол-во установленных шипов
new spikesobj[1000]; // Объекты, привязка к иду объектов
new spikesobjslot[1000] = 0; // Пометка о занятых объектах
new spikeowner[1000][MAX_PLAYER_NAME]; // Владельцы шипов
new Text3D:spikes3d[1000]; // 3dtext к шипам
new spikewheels[1000]; // Зона пробития колёс
new spikepickup[1000]; // Сфера для возможности снятия шипов
new spikepick[MAX_PLAYERS] = -1; // Проверка на возможность снять шипы
new spiketrucks[MAX_PLAYERS] = 0; // Проверка на возможность снять шипы

// BORT

new	bortslot[160] = 0;
new	bortname[160][128];
new bortowner[160][MAX_PLAYER_NAME];
new bortobj[160];
new bortSphere[160];
new bortSphereDist[MAX_PLAYERS] = 0; // Проверка на расстояние
new bortobjid[160];
new editbortmode[MAX_PLAYERS] = 0;
new editbortmodenc[MAX_PLAYERS] = 0;
new bortactiveslot[MAX_PLAYERS] = 0;
new Text3D:bort3d[160]; // 3dtext
new bortremoveobj[MAX_PLAYERS] = 0;
new borteditobj[MAX_PLAYERS] = 0;
new Float:bortobjX[160];
new Float:bortobjY[160];
new Float:bortobjZ[160];


// Добавить в переменные к игроку:  pSpikers + учёт кол-ва шипов на акк

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	// SPIKES
 	for(new i = 0; i <= 1000; i++)
    {
		if(areaid == spikepickup[i])
		{
			spikepick[playerid] = i;
		}
		if(areaid == spikewheels[i])
		{
	        if((spikesobjslot[i] == 1) && (GetPlayerState(playerid) == PLAYER_STATE_DRIVER))
	        {
				new dcar1, dcar2, dcar3, dcar4;
				GetVehicleDamageStatus(GetPlayerVehicleID(playerid), dcar1, dcar2, dcar3, dcar4);
				UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), dcar1, dcar2, dcar3, 15);
	        	break;
        	}
		}
        continue;
    }

	// BORT
 	for(new i = 0; i <= 159; i++)
    {
		if(areaid == bortSphere[i])
		{
			bortSphereDist[playerid] = 1;
		}
        continue;
    }
	return true;
}

public OnPlayerConnect(playerid) // ЛИБО СЮДА ЛИБО В АВТОРИЗАЦИЮ ЗАСУНУТЬ
{
	// SPIKES
	spikesmax[playerid] = 0; // Проверка на кол-во установленных шипов

	// BORT
	bortSphereDist[playerid] = 0; // Проверка на расстояние
	editbortmode[playerid] = 0;
	editbortmodenc[playerid] = 0;
	bortactiveslot[playerid] = 0;
 	bortremoveobj[playerid] = 0;
	borteditobj[playerid] = 0;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		// BORT
		case 8113:
	    {
	        if(!response) return true;
	        new bortselobj = 0;
	        new tbortname[128];
   			switch(listitem)
	    	{
				case 0:	{	tbortname = "Дорожный барьер #1";	bortselobj = 1427;	}
				case 1:	{	tbortname = "Дорожный барьер #2";	bortselobj = 1422;	}
				case 2:	{	tbortname = "Дорожный барьер #3";	bortselobj = 1434;	}
				case 3:	{	tbortname = "Дорожный барьер #4";	bortselobj = 1459;	}
				case 4:	{	tbortname = "Дорожный барьер #5";	bortselobj = 1228;	}
				case 5:	{	tbortname = "Дорожный барьер #6";	bortselobj = 1423;	}
				case 6:	{	tbortname = "Дорожный барьер #7";	bortselobj = 1424;	}
				case 7:	{	tbortname = "Дорожный барьер #8";	bortselobj = 1282;	}
				case 8:	{	tbortname = "Дорожный барьер #9";	bortselobj = 1435;	}
				case 9:	{	tbortname = "Дорожный конус";	bortselobj = 1238;	}
				case 10:{	tbortname = "Водный барьер";	bortselobj = 1237;	}
				case 11:{	tbortname = "Отбойник";	bortselobj = 979;	}
				case 12:{	tbortname = "Оранжевый дорожный барьер с надписью Detour";	bortselobj = 1425;	}
				case 13:{	tbortname = "Барьер с надписью LINE CLOSED";	bortselobj = 3091;	}
				case 14:{	tbortname = "Большое ограждение WARNING! CLOSED TO TRAFFIC";	bortselobj = 981;	}
				case 15:{	tbortname = "Полицейская лента";	bortselobj = 19834;	}
			}
			new Float:x,Float:y,Float:z,Float:a;
			GetPlayerPos(playerid,x,y,z);
			new slot = 0;
			for(new i = 0; i <= 159; i++)
		    {
		        if (bortslot[i] == 0)
		        {
		        	slot = i;
		        	break;
				}
				continue;
		    }
			bortslot[slot] = PTEMP[playerid][pMember];
			bortname[slot] = tbortname;
			new sendername[MAX_PLAYER_NAME];
	     	GetPlayerName(playerid, sendername, sizeof(sendername));
			bortowner[slot] = sendername;

	        GetPlayerFacingAngle(playerid, a);
			SetPlayerPos(playerid, x,y,z+0.5);

	        x +=(1.5 * floatsin(-a, degrees));
	        y +=(1.5 * floatcos(-a, degrees));

            editbortmode[playerid] = 1;
			bortactiveslot[playerid] = slot;
			format(string, 64, "Вы начали установку ограждения '%s'",bortname[slot]);
			SendClientMessage(playerid, 0xFFFFFFFF, string);
			DestroyDynamicObject(bortobj[slot]);
			DestroyDynamicArea(bortSphere[slot]);
			bortobj[slot] = CreateDynamicObject(bortselobj,x,y,z,0,0,0);
			bortSphere[slot] = CreateDynamicSphere(x, y, z, 25, 0, 0, -1);
			bortobjid[slot] = bortselobj;
            EditDynamicObject(playerid, bortobj[slot]);
   			SetPVarInt(playerid, "bortobj[slot]", 1);
            return true;
	    }
   }
}


// SPIKES

CMD:spikes(playerid, params[])
{
    if(PTEMP[playerid][pLogin] == 0) return true;
    new param[32];
    new param2;
	if(sscanf(params, "s[16]D", param, param2))	{	return SendClientMessage(playerid, 0xFFFFFFFF, "Введите: /spikes [place/pickup/give/trunk]"); }
	if(strcmp(param,"place",true) == 0)
	{
		if(GetPVarInt(playerid,"Fraction_Duty") && ((PTEMP[playerid][pMember] == 1) || (PTEMP[playerid][pMember] == 2) || (PTEMP[playerid][pMember] == 17) || (PTEMP[playerid][pMember] == 18)))
		{
			if(PTEMP[playerid][pSpikers] == 0) return SendClientMessage(playerid, 0xFFFFFFFF, "У вас нет шипов в инвентаре");
		    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid, 0xFFFFFFFF, "Вы должны быть на улице!");
			if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFFFFFFFF, "Вы не должны быть в машине!");
			if (spikepick[playerid] >= 0) return SendClientMessage(playerid, 0xFFFFFFFF, "Рядом уже есть шипы");
		    if(spikesmax[playerid] >= 2) return SendClientMessage(playerid, 0xFFFFFFFF, "Вы установили максимальное количество шипов");
			else { spikesmax[playerid]++; }
			new spikesid;
	        for(new i = 0; i <= 1000; i++)
	        {
	            if(spikesobjslot[i] == 0)
	            {
	            	spikesobjslot[i] = 1;
                    spikesid = i;
	                break;
	            }
	            continue;
	        }
			new Float:a, Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2, Float:x3, Float:y3, Float:z3; // 1 - изначальное место. 2 - место для установки объекта и3д 3 - конец место для проколки шин
			GetPlayerPos(playerid, x1, y1, z1);
	        GetPlayerFacingAngle(playerid, a);
	        x2 = x1; x2 +=(5.2 * floatsin(-a, degrees));
	        y2 = y1; y2 +=(5.2 * floatcos(-a, degrees));
	        z2 = z1 - 1;
	    	spikesobj[spikesid] = CreateDynamicObject(2892, x2, y2, z2, 0, 0, a);
	    	spikesobjslot[spikesid] = 1;
			new playername[MAX_PLAYER_NAME];
	     	GetPlayerName(playerid, playername, sizeof(playername));
			spikeowner[spikesid] = playername;
			format(string, 128, "Шипы #%d\nУстановил: %s",spikesid,spikeowner[spikesid]);
	    	spikes3d[spikesid] = Create3DTextLabel(string, 0x80808077, x2, y2, z2+0.5, 25.0 , 0, 1);
			spikepickup[spikesid] = CreateDynamicSphere(x2, y2, z2, 7, 0, 0, -1);
	        x3 = x1; x3+=(10.2 * floatsin(-a, degrees));
	        y3 = y1; y3+=(10.2 * floatcos(-a, degrees));
			z3 = z1+1;	z1 = z1-0.5;
			spikewheels[spikesid] = CreateDynamicCube(x1, y1, z1, x3, y3, z3, 0, 0, -1);
			PTEMP[playerid][pSpikers]--;
	        SendClientMessage(playerid, 0xFFFFFFFF, "Вы установили шипы");
	        spikepick[playerid] = spikesid;
	        return true;
		}
		else return true;
	}
	else if(strcmp(param,"pickup",true) == 0)
	{
		if(GetPVarInt(playerid,"Fraction_Duty") && ((PTEMP[playerid][pMember] == 1) || (PTEMP[playerid][pMember] == 2) || (PTEMP[playerid][pMember] == 17) || (PTEMP[playerid][pMember] == 18)))
		{
	        if(spikepick[playerid] >= 0)
	        {
	        	new spikesid = spikepick[playerid];
				new playername[MAX_PLAYER_NAME];
     			GetPlayerName(playerid, playername, sizeof(playername));
     			if (strlen(spikeowner[spikesid]) != strlen(playername))
			 	{
					format(string, 128, "Вы не устанавливали шипы #%d",spikesid);
			 		SendClientMessage(playerid, 0xFFFFFFFF, string);
					return true;
				}
				DestroyDynamicArea(spikepickup[spikesid]);
				DestroyDynamicArea(spikewheels[spikesid]);
				Delete3DTextLabel(spikes3d[spikesid]);
				DestroyDynamicObject(spikesobj[spikesid]);
                spikesobjslot[spikesid] = 0;
				spikepick[playerid] = -1;
                spikeowner[spikesid] = "";
                SendClientMessage(playerid, 0xFFFFFFFF, "Вы подняли шипы с земли");
                spikesmax[playerid]--;
				PTEMP[playerid][pSpikers]++;
 	        	return true;
		    }
			return true;
		}
		else return true;
	}
	else if(strcmp(param,"give",true) == 0)
	{
		if(sscanf(params, "s[16]i", params[0], params[1]))	return SendClientMessage(playerid, 0xFFFFFFFF, "Введите: /spikes give [id]");
		if(ProxDetectorS(5.0, playerid, params[1])) {} else return SendClientMessage(playerid, COLOR_GREY, "Человек далеко от вас!");
		if(PTEMP[playerid][pSpikers] == 0) return SendClientMessage(playerid, COLOR_GREY, "У вас нет шипов в инвентаре");
		// Тут по идее нужно кинуть предложение взять шипы. Принять через /accept, как прописано у вас незнаю, думаю сами подконнектите к своему коду, я то хз чо у вас там, чо гадать :)

		// Когда игрок прописал /accept spikes туда код:

		/*
		if(((carspicks[playerid] == 1) && (PTEMP[playerid][pSpikers] >= 1)) || (PTEMP[playerid][pSpikers] => 2)) return SendClientMessage(playerid, COLOR_GREY, "У вас достигнут лимит шипов");
		PTEMP[playerid][pSpikers]++;
		// Получить ид того кто предложил взять шипы
		PTEMP[IDIDID][pSpikers]--;
		new playername[MAX_PLAYER_NAME];
		GetPlayerName(playerid, playername, sizeof(playername));
		format(string, 128, "Вы передали шипы: %s",playername);
		SendClientMessage(IDIDID, 0xFFFFFFFF, string); // Отправить тому кто отдал шипы
		*/

		return true;
	}
	else if(strcmp(param,"trunk",true) == 0)
	{
	    new carspicks;
	    // Если рядом машина с багажником, определить ид машины. ЕСЛИ НЕТ РЯДОМ МАШИНЫ ТО СООБЩЕНИЕ ИГРОКУ ЧТО РЯДОМ НЕТ МАШИНЫ
		// Есть ли в багажнике есть шипы, если есть то carspicks = 1; Если нет то carspicks = 0;
		if (carspicks == 0)
		{
			// Положить шипы в багажник
			spiketrucks[playerid] = 1;
			PTEMP[playerid][pSpikers]--;
   			SendClientMessage(playerid, 0xFFFFFFFF, "Вы положили шипы в багажник");
   			return true;
		}
		else
		{
            if (PTEMP[playerid][pSpikers] >= 2) return SendClientMessage(playerid, 0xFFFFFFFF, "У вас достигнут лимит шипов");
            // Забираем шипы из багажника
			spiketrucks[playerid] = 0;
			PTEMP[playerid][pSpikers]++;
			SendClientMessage(playerid, 0xFFFFFFFF, "Вы взяли шипы из багажника");
		}
		return true;
	}
	return SendClientMessage(playerid, 0xFFFFFFFF, "Введите: /spikes [place/pickup/give/trunk]");
}

// BORT

CMD:bort(playerid, params[])
{
    if(PTEMP[playerid][pLogin] == 0) return true;
	if(GetPVarInt(playerid,"Fraction_Duty") && ((PTEMP[playerid][pMember] == 1) || (PTEMP[playerid][pMember] == 2) || (PTEMP[playerid][pMember] == 17) || (PTEMP[playerid][pMember] == 18)))
	{
	    new param[16];
		new param2;
		if(sscanf(params, "s[16]D", param,param2))	{	return SendClientMessage(playerid, 0xFFFFFFFF, "Введите: /bort [list, create, edit, remove]"); }
		if(strcmp(param,"list",true) == 0)
		{
			format(string, 64, "{FFFFFF}Название\t{FFFFFF}ID объекта\t{FFFFFF}Никнейм");
			new icount = 0;
			for(new i = 0; i <= 159; i++)
		    {
		        if (bortslot[i] == PTEMP[playerid][pMember])
		        {
		        	format(string,sizeof(string),"%s\n{FFFFFF}%s\t{FFFFFF}%d\t{FFFFFF}%s",string,bortname[i],i,bortowner[i]);
		        	icount++;
				}
				continue;
		    }
 			ShowPlayerDialog(playerid, 81023, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Список ограждений",string,"Закрыть", "Отмена");
 			return true;
		}
		else if(strcmp(param,"create",true) == 0)
		{
			new icount = 0;
			for(new i = 0; i <= 159; i++)
		    {
		        if (bortslot[i] == PTEMP[playerid][pMember])
		        {
		        	icount++;
				}
				continue;
		    }
		    if (icount >= 40) return SendClientMessage(playerid, 0xFFFFFFFF, "Вы достигли лимита установленных ограждений");
			return ShowPlayerDialog(playerid, 8113, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Выбор ограждения",
			"{FFFFFF}Название\t{FFFFFF}ID объекта\n\
			Дорожный барьер #1 \t 1427\n\
			Дорожный барьер #2 \t 1422\n\
			Дорожный барьер #3 \t 1434\n\
			Дорожный барьер #4 \t 1459\n\
			Дорожный барьер #5 \t 1228\n\
			Дорожный барьер #6 \t 1423\n\
			Дорожный барьер #7 \t 1424\n\
			Дорожный барьер #8 \t 1282\n\
			Дорожный барьер #9 \t 1435\n\
			Дорожный конус \t 1238\n\
			Водный барьер \t 1237\n\
			Отбойник \t 979\n\
			Оранжевый дорожный барьер с надписью Detour \t 1425\n\
			Барьер с надписью LINE CLOSED \t 3091\n\
			Большое ограждение WARNING! CLOSED TO TRAFFIC \t 981\n\
			Полицейская лента \t 19834","Создать", "Отмена");
		}
		else if(strcmp(param,"edit",true) == 0)
		{
			if(sscanf(params, "s[16]d", params[0], params[1]))
			{
			    new distancecheck = 0;
				for(new i = 0; i <= 159; i++)
			    {
            		if (bortSphereDist[playerid] == 1) { distancecheck = 1; break; }
					continue;
			    }
				if (distancecheck == 1) return SendClientMessage(playerid, 0xFFFFFFFF, "Рядом нет ограждения для редактирования");
				SendClientMessage(playerid, 0xFFFFFFFF, "Выберите ограждение для редактирования");
				borteditobj[playerid] = 1;
				bortactiveslot[playerid] = 0;
				SelectObject(playerid);
				return true;
			}
			new bordobjectid = params[1];
			new Float:x = bortobjX[bordobjectid];
			new Float:y = bortobjY[bordobjectid];
			new Float:z = bortobjZ[bordobjectid];
			new Float: px, Float: py, Float: pz;
	        GetPlayerPos(playerid, px, py, pz);

	        new distance = floatround(floatsqroot(floatpower(px - x, 2) + floatpower(py - y, 2) + floatpower(pz - z, 2)));
			if (distance > 25) return SendClientMessage(playerid, 0xFFFFFFFF, "Рядом нет ограждения для редактирования");
    		new playername[MAX_PLAYER_NAME];
 			GetPlayerName(playerid, playername, sizeof(playername));

 			if (strlen(bortowner[bordobjectid]) != strlen(playername))
		 	{
				format(string, 128, "Вы не устанавливали ограждение #%d",bordobjectid);
		 		SendClientMessage(playerid, 0xFFFFFFFF, string);
				return true;
			}
			format(string, 128, "Вы редактируете ограждение #%d",bordobjectid);
	 		SendClientMessage(playerid, 0xFFFFFFFF, string);
		    editbortmodenc[playerid] = 1;
			bortactiveslot[playerid] = bordobjectid;
			Delete3DTextLabel(bort3d[bordobjectid]);
		    EditDynamicObject(playerid,bortobj[bordobjectid]);
   			SetPVarInt(playerid, "bortobj[bordobjectid]", 1);
			return true;
		}
		else if(strcmp(param,"remove",true) == 0)
		{
			if(sscanf(params, "s[16]d", params[0], params[1]))
			{
				SendClientMessage(playerid, 0xFFFFFFFF, "Выберите ограждение для редактирования");
				bortremoveobj[playerid] = 1;
				SelectObject(playerid);
				return true;
			}
			new bordobjectid = params[1];
			new Float:x = bortobjX[bordobjectid];
			new Float:y = bortobjY[bordobjectid];
			new Float:z = bortobjZ[bordobjectid];
			new Float: px, Float: py, Float: pz;
	        GetPlayerPos(playerid, px, py, pz);
	        new distance = floatround(floatsqroot(floatpower(px - x, 2) + floatpower(py - y, 2) + floatpower(pz - z, 2)));
            if (distance > 25)	return SendClientMessage(playerid, 0xFFFFFFFF, "Рядом нет ограждения для удаления");
    		new playername[MAX_PLAYER_NAME];
 			GetPlayerName(playerid, playername, sizeof(playername));
 			if (strlen(bortowner[bordobjectid]) != strlen(playername))
		 	{
				format(string, 128, "Вы не устанавливали ограждение #%d",bordobjectid);
		 		SendClientMessage(playerid, 0xFFFFFFFF, string);
				return true;
			}
			DestroyDynamicObject(bortobj[bordobjectid]);
			DestroyDynamicArea(bortSphere[bordobjectid]);
			Delete3DTextLabel(bort3d[bordobjectid]);
			bortslot[bordobjectid] = 0;
			format(string, 128, "Вы удалили ограждение #%d",bordobjectid);
	 		SendClientMessage(playerid, 0xFFFFFFFF, string);
	  		return true;
		}
		return SendClientMessage(playerid, 0xFFFFFFFF, "Введите: /bort [list, create, edit, remove]");
	}
	return true;
}



public OnPlayerEditDynamicObject( playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz )
{
	// BORT
	if ((editbortmode[playerid] == 1) || (editbortmodenc[playerid] == 1))
	{
	    if(response == 1)
		{
			new slot = bortactiveslot[playerid];
			new Float: px, Float: py, Float: pz;
	        GetPlayerPos(playerid, px, py, pz);
	        new distance = floatround(floatsqroot(floatpower(px - x, 2) + floatpower(py - y, 2) + floatpower(pz - z, 2)));
            if (distance > 25)
	        {
				if(editbortmode[playerid] == 1)
				{
					DestroyDynamicObject(bortobj[slot]);
                    DestroyDynamicArea(bortSphere[slot]);
					format(string, 128, "Вы попытались установить ограждение далеко. Объект не был установлен");
					SendClientMessage(playerid, 0xFFFFFFFF, string);
					bortslot[slot] = 0;
		            editbortmode[playerid] = 0;
					bortactiveslot[playerid] = 0;
					return true;
				}
				else if(editbortmodenc[playerid] == 1)
				{
					format(string, 128, "Вы попытались установить ограждение далеко. Объект возвращен на исходное положение");
					SendClientMessage(playerid, 0xFFFFFFFF, string);
       				DestroyDynamicObject(bortobj[slot]);
					DestroyDynamicArea(bortSphere[slot]);
					bortobj[slot] = CreateDynamicObject(bortobjid[slot],bortobjX[slot], bortobjY[slot], bortobjZ[slot],0,0,0);
					bortSphere[slot] = CreateDynamicSphere(bortobjX[slot], bortobjY[slot], bortobjZ[slot], 25, 0, 0, -1);
					format(string, 128, "Ограждение #%d\nУстановил: %s",slot,bortowner[slot]);
			 		bort3d[slot] = Create3DTextLabel(string, 0x80808077, bortobjX[slot], bortobjY[slot], bortobjZ[slot]+1, 25.0 , 0, 1);
					format(string, 64, "Вы отменили редактирование ограждения '%d'",slot);
					SendClientMessage(playerid, 0xFFFFFFFF, string);
				    editbortmodenc[playerid] = 0;
					bortactiveslot[playerid] = 0;
					GetPlayerPos(playerid, x,y,z);
					SetPlayerPos(playerid, x,y,z+0.3);
					return true;
				}
	        }
			if(editbortmode[playerid] == 1)
			{
                DestroyDynamicObject(bortobj[slot]);
                DestroyDynamicArea(bortSphere[slot]);
				bortobj[slot] = CreateDynamicObject(bortobjid[slot],x, y,z,0,0,0);
				bortSphere[slot] = CreateDynamicSphere(x, y, z, 25, 0, 0, -1);
				format(string, 128, "Вы установили ограждение '%s' под номером %d",bortname[slot],slot);
				SendClientMessage(playerid, 0xFFFFFFFF, string);
				format(string, 128, "Ограждение #%d\nУстановил: %s",slot,bortowner[slot]);
		 		bort3d[slot] = Create3DTextLabel(string, 0x80808077, x, y, z+1, 25.0 , 0, 1);
	            editbortmode[playerid] = 0;
				bortactiveslot[playerid] = 0;
				bortobjX[slot] = x;
				bortobjY[slot] = y;
				bortobjZ[slot] = z;
				GetPlayerPos(playerid,x,y,z);
				SetPlayerPos(playerid, x,y,z+0.3);
				return true;
			}
			else if(editbortmodenc[playerid] == 1)
			{
                DestroyDynamicObject(bortobj[slot]);
                DestroyDynamicArea(bortSphere[slot]);
				Delete3DTextLabel(bort3d[slot]);
   				bortobj[slot] = CreateDynamicObject(bortobjid[slot],x, y,z,0,0,0);
				bortSphere[slot] = CreateDynamicSphere(x, y, z, 25, 0, 0, -1);
				format(string, 128, "Вы изменили положение у ограждения %d",slot);
				SendClientMessage(playerid, 0xFFFFFFFF, string);
				format(string, 128, "Ограждение #%d\nУстановил: %s",slot,bortowner[slot]);
		 		bort3d[slot] = Create3DTextLabel(string, 0x80808077, x, y, z+1, 25.0 , 0, 1);
	            editbortmode[playerid] = 0;
				bortactiveslot[playerid] = 0;
                bortobjX[slot] = x; bortobjY[slot] = y; bortobjZ[slot] = z;
				GetPlayerPos(playerid,x,y,z);
				SetPlayerPos(playerid, x,y,z+0.3);
				return true;
			}
		}
		else if(response == 0)
		{
			new slot = bortactiveslot[playerid];
			if(editbortmode[playerid] == 1)
			{
				format(string, 64, "Вы отменили установку ограждения '%s'",bortname[slot]);
				SendClientMessage(playerid, 0xFFFFFFFF, string);
				bortslot[slot] = 0;
	            editbortmode[playerid] = 0;
				bortactiveslot[playerid] = 0;
				return true;
			}
			else if(editbortmodenc[playerid] == 1)
			{
   				DestroyDynamicObject(bortobj[slot]);
				DestroyDynamicArea(bortSphere[slot]);
				Delete3DTextLabel(bort3d[slot]);
				bortobj[slot] = CreateDynamicObject(bortobjid[slot],bortobjX[slot], bortobjY[slot], bortobjZ[slot],0,0,0);
				bortSphere[slot] = CreateDynamicSphere(bortobjX[slot], bortobjY[slot], bortobjZ[slot], 25, 0, 0, -1);
		 		bort3d[slot] = Create3DTextLabel(string, 0x80808077, bortobjX[slot], bortobjY[slot], bortobjZ[slot]+1, 25.0 , 0, 1);
				format(string, 64, "Вы отменили редактирование ограждения '%d'",slot);
				SendClientMessage(playerid, 0xFFFFFFFF, string);
				format(string, 128, "Ограждение #%d\nУстановил: %s",slot,bortowner[slot]);
			    editbortmodenc[playerid] = 0;
				bortactiveslot[playerid] = 0;
				GetPlayerPos(playerid, x,y,z);
				SetPlayerPos(playerid, x,y,z+0.3);
				return true;
			}
		}
	}
}
public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{

	// BORT
	new bortpd = 0;
	new slot;
	for(new i = 0; i <= 159; i++)
    {
        if (bortobj[i] == objectid)
        {
        	slot = i;
            bortpd = 1;
        	break;
		}
		continue;
    }
    if (bortpd == 1)
    {
		if (borteditobj[playerid] == 1)
		{
			borteditobj[playerid] = 0;
		    editbortmodenc[playerid] = 1;
			bortactiveslot[playerid] = slot;
			new Float:ox = bortobjX[slot];
			new Float:oy = bortobjY[slot];
			new Float:oz = bortobjZ[slot];
			new Float: px, Float: py, Float: pz;
	        GetPlayerPos(playerid, px, py, pz);
	        new distance = floatround(floatsqroot(floatpower(px - ox, 2) + floatpower(py - oy, 2) + floatpower(pz - oz, 2)));
			if (distance > 25)
			{
			    borteditobj[playerid] = 1;
				SendClientMessage(playerid, 0xFFFFFFFF, "Рядом нет ограждения для редактирования");
				return true;
			}
   			new playername[MAX_PLAYER_NAME];
 			GetPlayerName(playerid, playername, sizeof(playername));
 			if (strlen(bortowner[slot]) != strlen(playername))
		 	{
				format(string, 128, "Вы не устанавливали ограждение #%d",slot);
		 		SendClientMessage(playerid, 0xFFFFFFFF, string);
				return true;
			}
			format(string, 128, "Вы редактируете ограждение #%d",slot);
	 		SendClientMessage(playerid, 0xFFFFFFFF, string);
			Delete3DTextLabel(bort3d[slot]);
		    EditDynamicObject(playerid,objectid);
   			SetPVarInt(playerid, "objectid", 1);
			return true;
		}
		if (bortremoveobj[playerid] == 1)
		{
		    new playername[MAX_PLAYER_NAME];
 			GetPlayerName(playerid, playername, sizeof(playername));
 			if (strlen(bortowner[slot]) != strlen(playername))
		 	{
				format(string, 128, "Вы не устанавливали ограждение #%d",slot);
		 		SendClientMessage(playerid, 0xFFFFFFFF, string);
				return true;
			}
			DestroyDynamicObject(bortobj[slot]);
			DestroyDynamicArea(bortSphere[slot]);
			Delete3DTextLabel(bort3d[slot]);
			bortslot[slot] = 0;
			format(string, 128, "Вы удалили ограждение #%d",slot);
	 		SendClientMessage(playerid, 0xFFFFFFFF, string);
            editbortmode[playerid] = 0;
			return true;
		}
    }
}
