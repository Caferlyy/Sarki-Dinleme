#include <sourcemod>
#include <sdktools>
#include <sdktools_sound>
#include <emitsoundany>
#include <multicolors>

#pragma semicolon 1
#define MAX_FILE_LEN 35
Handle g_CvarSoundName;
int beklemeclient[MAXPLAYERS+1];

public Plugin myinfo =
{
    name = "Şarkı Dinlemece",
    author = "Caferly!",
    description = "Komutu kullandığınızda arkada güzelinden bir şarkı çalar.",
    version = "1.1",
    url = "https://hovn.com - #CAFERLY"
};

public OnPluginStart()
{
	g_CvarSoundName = CreateConVar("sm_sarki_sesi", "caferly-cakal-sarki.mp3"); /// - Dosya adını değişerek istediğiniz şarkıyı ekleyebilirsiniz.
	RegConsoleCmd("sm_sarkidinle", Command_Sarki);	
	RegConsoleCmd("sm_sarki", Command_Sarki);
}

public OnMapStart()
{
	char buffer1[MAX_FILE_LEN];
	GetConVarString(g_CvarSoundName, buffer1, MAX_FILE_LEN);
	PrecacheSound(buffer1, true);
	char buffer2[MAX_FILE_LEN];
	Format(buffer2, sizeof(buffer2), "sound/%s", buffer1);
	AddFileToDownloadsTable(buffer2);
}

public Action Command_Sarki(int client, int args) 
{
	char buffer3[MAX_FILE_LEN];
	if (!beklemeclient[client])
	{
		GetConVarString(g_CvarSoundName, buffer3, MAX_FILE_LEN);
		EmitSoundToClient(client, buffer3);
		CreateTimer(60.0, Bekleme_Kaldir, client);
		Handle hHudText = CreateHudSynchronizer();
		SetHudTextParams(-1.0, -0.5, 5.0, 251, 51, 204, 0, 2, 1.0, 0.1, 0.2);
		ShowSyncHudText(client, hHudText, "Şarkı - ÇAKAL DÜNYA FANİ");
		PrintToChat(client, " \x07[Caferly] \x01Şarkı Dinlemeye Başladın.");
		PrintToChatAll(" \x07[Caferly] \x01%N isimli oyuncu şarkı dinlemeye başladı.", client);
		beklemeclient[client] = 1;
	}
	else
	{
		PrintToChat(client, " \x07[Caferly] \x01Fazla şarkı dinledin. Biraz beklemelisin!");
	}	
	return Plugin_Handled;
}

public Action Bekleme_Kaldir(Handle timer, any client)
{
	beklemeclient[client] = 0;
}
