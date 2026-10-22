on(release){
   if(_global.MAIN_HERO.free_points >= 1)
   {
      _global.MAIN_HERO.SKILL.Crossbow = _global.MAIN_HERO.SKILL.Crossbow + 1;
      _global.MAIN_HERO.free_points--;
      inventoryShowStats();
   }
}
