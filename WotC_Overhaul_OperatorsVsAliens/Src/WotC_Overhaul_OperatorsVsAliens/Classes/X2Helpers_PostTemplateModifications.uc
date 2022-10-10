// FILE:	X2Helpers_PostTemplateModifications
// AUTHOR:	E3245
// DESC:	Modifies certain templates of the game requested by Beagle

class X2Helpers_PostTemplateModifications extends Object config(OvA_Gameplay);

var config array<name> BlacklistWeapons;
var config array<name> BlacklistAcademyUnlocks;
var config array<name> BlacklistTechs;

static function ResourceModifications_WorldWarLost()
{
	local X2ItemTemplateManager TemplateManager;
	local X2ItemTemplate Template;
	local array<X2DataTemplate> DataTemplates;
	local int idx;

	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	TemplateManager.FindDataTemplateAllDifficulties('CorpseTheLost', DataTemplates);

	for (idx = 0; idx < DataTemplates.Length; ++idx)
	{	
		Template = X2ItemTemplate(DataTemplates[idx]);
		if (Template != none)
		{
			Template.TradingPostValue = 0;
		}
	}
}

static function DisableWeaponTemplates()
{
	local X2ItemTemplateManager TemplateManager;
	local X2WeaponTemplate WeaponTemplate;
	local array<X2DataTemplate> DataTemplates;
	local name ItemTemplateName;
	local int idx;

	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	foreach default.BlacklistWeapons(ItemTemplateName)
	{
		TemplateManager.FindDataTemplateAllDifficulties(ItemTemplateName, DataTemplates);
		for (idx = 0; idx < DataTemplates.Length; ++idx)
		{	
			WeaponTemplate = X2WeaponTemplate(DataTemplates[idx]);
			if (WeaponTemplate != none)
			{
				//Disable tech requirements
				WeaponTemplate.Requirements.RequiredTechs.Length = 0;

				WeaponTemplate.Requirements.SpecialRequirementsFn = DisableFn;
				WeaponTemplate.Requirements.RequiredScienceScore = 999999999;
				WeaponTemplate.Requirements.RequiredHighestSoldierRank = 999999999;
				WeaponTemplate.Requirements.bVisibleIfPersonnelGatesNotMet = false;
				WeaponTemplate.Requirements.bVisibleIfSoldierRankGatesNotMet = false;

				//Disallow building
				WeaponTemplate.CanBeBuilt = false;
				`LOG("Disabling " $ ItemTemplateName $ "... SUCCESS!", , 'WotC_Overhaul_OperatorsVsAliens');
			}
			else
				`LOG("Disabling " $ ItemTemplateName $ "... FAILED!", , 'WotC_Overhaul_OperatorsVsAliens');
		}

	}
}

static function DisableAcademyUnlocks()
{
	local X2StrategyElementTemplateManager StrategyTemplateManager;
	local X2FacilityTemplate GTSTemplate;
	local name TemplateName;

	StrategyTemplateManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();;
	GTSTemplate = X2FacilityTemplate(StrategyTemplateManager.FindStrategyElementTemplate('OfficerTrainingSchool'));

	if (GTSTemplate == none)
		return;

	foreach default.BlacklistAcademyUnlocks(TemplateName)
	{
		GTSTemplate.SoldierUnlockTemplates.RemoveItem(TemplateName);
		`LOG("Disabling " $ TemplateName $ "... SUCCESS!", , 'WotC_Overhaul_OperatorsVsAliens');
	}
}

static function DisableTechsAndProvingGroundProjects()
{
	local X2StrategyElementTemplateManager StrategyTemplateManager;
	local X2TechTemplate TechTemplate;
	local array<X2DataTemplate> DataTemplates;
	local name TemplateName;
	local int idx;

	StrategyTemplateManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();;

	foreach default.BlacklistTechs(TemplateName)
	{
		StrategyTemplateManager.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
		for (idx = 0; idx < DataTemplates.Length; ++idx)
		{
			TechTemplate = X2TechTemplate(DataTemplates[idx]);
			if (TechTemplate != none)
			{
				//Disable tech requirements
				// Requirements
				TechTemplate.Requirements.SpecialRequirementsFn = DisableFn;
				TechTemplate.Requirements.RequiredScienceScore = 999999999;
				TechTemplate.Requirements.RequiredHighestSoldierRank = 999999999;
				TechTemplate.Requirements.bVisibleIfPersonnelGatesNotMet = false;
				TechTemplate.Requirements.bVisibleIfSoldierRankGatesNotMet = false;

				`LOG("Disabling " $ TemplateName $ "... SUCCESS!", , 'WotC_Overhaul_OperatorsVsAliens');
			}
			else
				`LOG("Disabling " $ TemplateName $ "... FAILED!", , 'WotC_Overhaul_OperatorsVsAliens');
		}
	}
}

static function bool DisableFn()
{
	return false;
}