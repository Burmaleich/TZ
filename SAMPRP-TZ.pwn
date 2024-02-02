// SPIKES

new spikesmax[MAX_PLAYERS] = 0; // �������� �� ���-�� ������������� �����
new spikesobj[1000]; // �������, �������� � ��� ��������
new spikesobjslot[1000] = 0; // ������� � ������� ��������
new spikeowner[1000][MAX_PLAYER_NAME]; // ��������� �����
new Text3D:spikes3d[1000]; // 3dtext � �����
new spikewheels[1000]; // ���� �������� ����
new spikepickup[1000]; // ����� ��� ����������� ������ �����
new spikepick[MAX_PLAYERS] = -1; // �������� �� ����������� ����� ����
new spiketrucks[MAX_PLAYERS] = 0; // �������� �� ����������� ����� ����

// BORT

new	bortslot[160] = 0;
new	bortname[160][128];
new bortowner[160][MAX_PLAYER_NAME];
new bortobj[160];
new bortSphere[160];
new bortSphereDist[MAX_PLAYERS] = 0; // �������� �� ����������
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


// �������� � ���������� � ������:  pSpikers + ���� ���-�� ����� �� ���

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

public OnPlayerConnect(playerid) // ���� ���� ���� � ����������� ��������
{
	// SPIKES
	spikesmax[playerid] = 0; // �������� �� ���-�� ������������� �����

	// BORT
	bortSphereDist[playerid] = 0; // �������� �� ����������
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
				case 0:	{	tbortname = "�������� ������ #1";	bortselobj = 1427;	}
				case 1:	{	tbortname = "�������� ������ #2";	bortselobj = 1422;	}
				case 2:	{	tbortname = "�������� ������ #3";	bortselobj = 1434;	}
				case 3:	{	tbortname = "�������� ������ #4";	bortselobj = 1459;	}
				case 4:	{	tbortname = "�������� ������ #5";	bortselobj = 1228;	}
				case 5:	{	tbortname = "�������� ������ #6";	bortselobj = 1423;	}
				case 6:	{	tbortname = "�������� ������ #7";	bortselobj = 1424;	}
				case 7:	{	tbortname = "�������� ������ #8";	bortselobj = 1282;	}
				case 8:	{	tbortname = "�������� ������ #9";	bortselobj = 1435;	}
				case 9:	{	tbortname = "�������� �����";	bortselobj = 1238;	}
				case 10:{	tbortname = "������ ������";	bortselobj = 1237;	}
				case 11:{	tbortname = "��������";	bortselobj = 979;	}
				case 12:{	tbortname = "��������� �������� ������ � �������� Detour";	bortselobj = 1425;	}
				case 13:{	tbortname = "������ � �������� LINE CLOSED";	bortselobj = 3091;	}
				case 14:{	tbortname = "������� ���������� WARNING! CLOSED TO TRAFFIC";	bortselobj = 981;	}
				case 15:{	tbortname = "����������� �����";	bortselobj = 19834;	}
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
			format(string, 64, "�� ������ ��������� ���������� '%s'",bortname[slot]);
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
	if(sscanf(params, "s[16]D", param, param2))	{	return SendClientMessage(playerid, 0xFFFFFFFF, "�������: /spikes [place/pickup/give/trunk]"); }
	if(strcmp(param,"place",true) == 0)
	{
		if(GetPVarInt(playerid,"Fraction_Duty") && ((PTEMP[playerid][pMember] == 1) || (PTEMP[playerid][pMember] == 2) || (PTEMP[playerid][pMember] == 17) || (PTEMP[playerid][pMember] == 18)))
		{
			if(PTEMP[playerid][pSpikers] == 0) return SendClientMessage(playerid, 0xFFFFFFFF, "� ��� ��� ����� � ���������");
		    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid, 0xFFFFFFFF, "�� ������ ���� �� �����!");
			if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFFFFFFFF, "�� �� ������ ���� � ������!");
			if (spikepick[playerid] >= 0) return SendClientMessage(playerid, 0xFFFFFFFF, "����� ��� ���� ����");
		    if(spikesmax[playerid] >= 2) return SendClientMessage(playerid, 0xFFFFFFFF, "�� ���������� ������������ ���������� �����");
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
			new Float:a, Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2, Float:x3, Float:y3, Float:z3; // 1 - ����������� �����. 2 - ����� ��� ��������� ������� �3� 3 - ����� ����� ��� �������� ���
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
			format(string, 128, "���� #%d\n���������: %s",spikesid,spikeowner[spikesid]);
	    	spikes3d[spikesid] = Create3DTextLabel(string, 0x80808077, x2, y2, z2+0.5, 25.0 , 0, 1);
			spikepickup[spikesid] = CreateDynamicSphere(x2, y2, z2, 7, 0, 0, -1);
	        x3 = x1; x3+=(10.2 * floatsin(-a, degrees));
	        y3 = y1; y3+=(10.2 * floatcos(-a, degrees));
			z3 = z1+1;	z1 = z1-0.5;
			spikewheels[spikesid] = CreateDynamicCube(x1, y1, z1, x3, y3, z3, 0, 0, -1);
			PTEMP[playerid][pSpikers]--;
	        SendClientMessage(playerid, 0xFFFFFFFF, "�� ���������� ����");
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
					format(string, 128, "�� �� ������������� ���� #%d",spikesid);
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
                SendClientMessage(playerid, 0xFFFFFFFF, "�� ������� ���� � �����");
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
		if(sscanf(params, "s[16]i", params[0], params[1]))	return SendClientMessage(playerid, 0xFFFFFFFF, "�������: /spikes give [id]");
		if(ProxDetectorS(5.0, playerid, params[1])) {} else return SendClientMessage(playerid, COLOR_GREY, "������� ������ �� ���!");
		if(PTEMP[playerid][pSpikers] == 0) return SendClientMessage(playerid, COLOR_GREY, "� ��� ��� ����� � ���������");
		// ��� �� ���� ����� ������ ����������� ����� ����. ������� ����� /accept, ��� ��������� � ��� ������, ����� ���� ������������� � ������ ����, � �� �� �� � ��� ���, �� ������ :)

		// ����� ����� �������� /accept spikes ���� ���:

		/*
		if(((carspicks[playerid] == 1) && (PTEMP[playerid][pSpikers] >= 1)) || (PTEMP[playerid][pSpikers] => 2)) return SendClientMessage(playerid, COLOR_GREY, "� ��� ��������� ����� �����");
		PTEMP[playerid][pSpikers]++;
		// �������� �� ���� ��� ��������� ����� ����
		PTEMP[IDIDID][pSpikers]--;
		new playername[MAX_PLAYER_NAME];
		GetPlayerName(playerid, playername, sizeof(playername));
		format(string, 128, "�� �������� ����: %s",playername);
		SendClientMessage(IDIDID, 0xFFFFFFFF, string); // ��������� ���� ��� ����� ����
		*/

		return true;
	}
	else if(strcmp(param,"trunk",true) == 0)
	{
	    new carspicks;
	    // ���� ����� ������ � ����������, ���������� �� ������. ���� ��� ����� ������ �� ��������� ������ ��� ����� ��� ������
		// ���� �� � ��������� ���� ����, ���� ���� �� carspicks = 1; ���� ��� �� carspicks = 0;
		if (carspicks == 0)
		{
			// �������� ���� � ��������
			spiketrucks[playerid] = 1;
			PTEMP[playerid][pSpikers]--;
   			SendClientMessage(playerid, 0xFFFFFFFF, "�� �������� ���� � ��������");
   			return true;
		}
		else
		{
            if (PTEMP[playerid][pSpikers] >= 2) return SendClientMessage(playerid, 0xFFFFFFFF, "� ��� ��������� ����� �����");
            // �������� ���� �� ���������
			spiketrucks[playerid] = 0;
			PTEMP[playerid][pSpikers]++;
			SendClientMessage(playerid, 0xFFFFFFFF, "�� ����� ���� �� ���������");
		}
		return true;
	}
	return SendClientMessage(playerid, 0xFFFFFFFF, "�������: /spikes [place/pickup/give/trunk]");
}

// BORT

CMD:bort(playerid, params[])
{
    if(PTEMP[playerid][pLogin] == 0) return true;
	if(GetPVarInt(playerid,"Fraction_Duty") && ((PTEMP[playerid][pMember] == 1) || (PTEMP[playerid][pMember] == 2) || (PTEMP[playerid][pMember] == 17) || (PTEMP[playerid][pMember] == 18)))
	{
	    new param[16];
		new param2;
		if(sscanf(params, "s[16]D", param,param2))	{	return SendClientMessage(playerid, 0xFFFFFFFF, "�������: /bort [list, create, edit, remove]"); }
		if(strcmp(param,"list",true) == 0)
		{
			format(string, 64, "{FFFFFF}��������\t{FFFFFF}ID �������\t{FFFFFF}�������");
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
 			ShowPlayerDialog(playerid, 81023, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}������ ����������",string,"�������", "������");
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
		    if (icount >= 40) return SendClientMessage(playerid, 0xFFFFFFFF, "�� �������� ������ ������������� ����������");
			return ShowPlayerDialog(playerid, 8113, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}����� ����������",
			"{FFFFFF}��������\t{FFFFFF}ID �������\n\
			�������� ������ #1 \t 1427\n\
			�������� ������ #2 \t 1422\n\
			�������� ������ #3 \t 1434\n\
			�������� ������ #4 \t 1459\n\
			�������� ������ #5 \t 1228\n\
			�������� ������ #6 \t 1423\n\
			�������� ������ #7 \t 1424\n\
			�������� ������ #8 \t 1282\n\
			�������� ������ #9 \t 1435\n\
			�������� ����� \t 1238\n\
			������ ������ \t 1237\n\
			�������� \t 979\n\
			��������� �������� ������ � �������� Detour \t 1425\n\
			������ � �������� LINE CLOSED \t 3091\n\
			������� ���������� WARNING! CLOSED TO TRAFFIC \t 981\n\
			����������� ����� \t 19834","�������", "������");
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
				if (distancecheck == 1) return SendClientMessage(playerid, 0xFFFFFFFF, "����� ��� ���������� ��� ��������������");
				SendClientMessage(playerid, 0xFFFFFFFF, "�������� ���������� ��� ��������������");
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
			if (distance > 25) return SendClientMessage(playerid, 0xFFFFFFFF, "����� ��� ���������� ��� ��������������");
    		new playername[MAX_PLAYER_NAME];
 			GetPlayerName(playerid, playername, sizeof(playername));

 			if (strlen(bortowner[bordobjectid]) != strlen(playername))
		 	{
				format(string, 128, "�� �� ������������� ���������� #%d",bordobjectid);
		 		SendClientMessage(playerid, 0xFFFFFFFF, string);
				return true;
			}
			format(string, 128, "�� ������������ ���������� #%d",bordobjectid);
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
				SendClientMessage(playerid, 0xFFFFFFFF, "�������� ���������� ��� ��������������");
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
            if (distance > 25)	return SendClientMessage(playerid, 0xFFFFFFFF, "����� ��� ���������� ��� ��������");
    		new playername[MAX_PLAYER_NAME];
 			GetPlayerName(playerid, playername, sizeof(playername));
 			if (strlen(bortowner[bordobjectid]) != strlen(playername))
		 	{
				format(string, 128, "�� �� ������������� ���������� #%d",bordobjectid);
		 		SendClientMessage(playerid, 0xFFFFFFFF, string);
				return true;
			}
			DestroyDynamicObject(bortobj[bordobjectid]);
			DestroyDynamicArea(bortSphere[bordobjectid]);
			Delete3DTextLabel(bort3d[bordobjectid]);
			bortslot[bordobjectid] = 0;
			format(string, 128, "�� ������� ���������� #%d",bordobjectid);
	 		SendClientMessage(playerid, 0xFFFFFFFF, string);
	  		return true;
		}
		return SendClientMessage(playerid, 0xFFFFFFFF, "�������: /bort [list, create, edit, remove]");
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
					format(string, 128, "�� ���������� ���������� ���������� ������. ������ �� ��� ����������");
					SendClientMessage(playerid, 0xFFFFFFFF, string);
					bortslot[slot] = 0;
		            editbortmode[playerid] = 0;
					bortactiveslot[playerid] = 0;
					return true;
				}
				else if(editbortmodenc[playerid] == 1)
				{
					format(string, 128, "�� ���������� ���������� ���������� ������. ������ ��������� �� �������� ���������");
					SendClientMessage(playerid, 0xFFFFFFFF, string);
       				DestroyDynamicObject(bortobj[slot]);
					DestroyDynamicArea(bortSphere[slot]);
					bortobj[slot] = CreateDynamicObject(bortobjid[slot],bortobjX[slot], bortobjY[slot], bortobjZ[slot],0,0,0);
					bortSphere[slot] = CreateDynamicSphere(bortobjX[slot], bortobjY[slot], bortobjZ[slot], 25, 0, 0, -1);
					format(string, 128, "���������� #%d\n���������: %s",slot,bortowner[slot]);
			 		bort3d[slot] = Create3DTextLabel(string, 0x80808077, bortobjX[slot], bortobjY[slot], bortobjZ[slot]+1, 25.0 , 0, 1);
					format(string, 64, "�� �������� �������������� ���������� '%d'",slot);
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
				format(string, 128, "�� ���������� ���������� '%s' ��� ������� %d",bortname[slot],slot);
				SendClientMessage(playerid, 0xFFFFFFFF, string);
				format(string, 128, "���������� #%d\n���������: %s",slot,bortowner[slot]);
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
				format(string, 128, "�� �������� ��������� � ���������� %d",slot);
				SendClientMessage(playerid, 0xFFFFFFFF, string);
				format(string, 128, "���������� #%d\n���������: %s",slot,bortowner[slot]);
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
				format(string, 64, "�� �������� ��������� ���������� '%s'",bortname[slot]);
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
				format(string, 64, "�� �������� �������������� ���������� '%d'",slot);
				SendClientMessage(playerid, 0xFFFFFFFF, string);
				format(string, 128, "���������� #%d\n���������: %s",slot,bortowner[slot]);
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
				SendClientMessage(playerid, 0xFFFFFFFF, "����� ��� ���������� ��� ��������������");
				return true;
			}
   			new playername[MAX_PLAYER_NAME];
 			GetPlayerName(playerid, playername, sizeof(playername));
 			if (strlen(bortowner[slot]) != strlen(playername))
		 	{
				format(string, 128, "�� �� ������������� ���������� #%d",slot);
		 		SendClientMessage(playerid, 0xFFFFFFFF, string);
				return true;
			}
			format(string, 128, "�� ������������ ���������� #%d",slot);
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
				format(string, 128, "�� �� ������������� ���������� #%d",slot);
		 		SendClientMessage(playerid, 0xFFFFFFFF, string);
				return true;
			}
			DestroyDynamicObject(bortobj[slot]);
			DestroyDynamicArea(bortSphere[slot]);
			Delete3DTextLabel(bort3d[slot]);
			bortslot[slot] = 0;
			format(string, 128, "�� ������� ���������� #%d",slot);
	 		SendClientMessage(playerid, 0xFFFFFFFF, string);
            editbortmode[playerid] = 0;
			return true;
		}
    }
}
