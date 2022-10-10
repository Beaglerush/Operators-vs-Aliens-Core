// This is an ability all units have that sets their health to their lowest health OnEndTacticalPlay
class X2Ability_JustAScratchHealthMod extends X2Ability;

static event array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateJASAbility());

	return Templates;
}

static function X2AbilityTemplate CreateJASAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_JustAScratch                 Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'JustAScratch_UniversalAbility');

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow; // This ability doesn't show up on the action HUD (can't click to activate it)
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_unknown";

	Template.AbilityToHitCalc = default.DeadEye; // Always hits
	Template.AbilityTargetStyle = default.SelfTarget; // Applies to the unit with the ability
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger); // Basically begins immediately when the unit is spawned with the ability

	Effect = new class'X2Effect_JustAScratch';
	// we don't remove this effect on unit death because bleeding out units might mess things up
	Effect.BuildPersistentEffect(1, true, false, true);
	Template.AddTargetEffect(Effect);

	// Function delegate for setting up a standard XComGameState_Ability object for this ability
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	// No function delegates for creating function visualizations because this passive ability isn't showy

	return Template;

}