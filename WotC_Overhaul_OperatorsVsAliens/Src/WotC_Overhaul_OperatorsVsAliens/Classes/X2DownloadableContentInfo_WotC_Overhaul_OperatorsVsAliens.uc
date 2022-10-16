class X2DownloadableContentInfo_WotC_Overhaul_OperatorsVsAliens extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{

}

static event OnLoadedSavedGameToStrategy()
{

}

static event OnPostTemplatesCreated()
{
	if (CheckForActiveMod("WorldWarLost"))
	{
		class'X2Helpers_PostTemplateModifications'.static.ResourceModifications_WorldWarLost();
	}

	class'X2Helpers_PostTemplateModifications'.static.DisableWeaponTemplates();
	class'X2Helpers_PostTemplateModifications'.static.DisableAcademyUnlocks();
	class'X2Helpers_PostTemplateModifications'.static.DisableTechsAndProvingGroundProjects();
	class'X2Helpers_PostTemplateModifications'.static.PatchAbilityGlobalCooldowns();
}


//This function checks if a mod is installed
static function bool CheckForActiveMod(string DLCName) {
    local string CurrentMod;

    foreach class'XComModOptions'.default.ActiveMods(CurrentMod) {
        if (CurrentMod == DLCName) {
            return true;
        }
    }

    return false;
}
