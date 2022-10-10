class X2Effect_JustAScratch extends X2Effect_Persistent;

function UnitEndedTacticalPlay(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	local float HealthPercent, NewHealth;
	local int RoundedNewHealth, HealthLost;
	
	HealthLost = UnitState.HighestHP - UnitState.LowestHP;

	// If Dead or never injured, return
	if(UnitState.LowestHP <= 0 || HealthLost <= 0)
	{
		return;
	}

	// Calculate health percent
	HealthPercent = (float(UnitState.HighestHP - HealthLost) / float(UnitState.HighestHP));

	// Calculate and apply new health value
	NewHealth = (HealthPercent * UnitState.GetMaxStat(eStat_HP));
	RoundedNewHealth = Round(NewHealth);
	RoundedNewHealth = Clamp(RoundedNewHealth, 1, (int(UnitState.GetMaxStat(eStat_HP)) - 1));
	UnitState.SetCurrentStat(eStat_HP, RoundedNewHealth);

	`log("Just A Scratch -- Unit:" @ UnitState.GetFullName() $ ", Current HP:" @ UnitState.GetCurrentStat(eStat_HP) $ ", Lowest HP:" @ UnitState.LowestHP);
}

/*


// Health is adjusted after tactical play so that units that only took armor damage still require heal time
function EndTacticalHealthMod()
{
	local float HealthPercent, NewHealth;
	local int RoundedNewHealth, HealthLost;

	HealthLost = HighestHP - LowestHP;

	// If Dead or never injured, return
	if(LowestHP <= 0 || HealthLost <= 0)
	{
		return;
	}

	// Calculate health percent
	HealthPercent = (float(HighestHP - HealthLost) / float(HighestHP));

	// Calculate and apply new health value
	NewHealth = (HealthPercent * GetBaseStat(eStat_HP));
	RoundedNewHealth = Round(NewHealth);
	RoundedNewHealth = Clamp(RoundedNewHealth, 1, (int(GetBaseStat(eStat_HP)) - 1));
	SetCurrentStat(eStat_HP, RoundedNewHealth);
}


*/