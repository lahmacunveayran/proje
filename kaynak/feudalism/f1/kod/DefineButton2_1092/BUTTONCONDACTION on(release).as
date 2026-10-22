on(release){
   if(_global.MAIN_HERO.free_points >= 1)
   {
      _global.MAIN_HERO.SKILL.Mace = _global.MAIN_HERO.SKILL.Mace + 1;
      _global.MAIN_HERO.free_points--;
      inventoryShowStats();
   }
}
