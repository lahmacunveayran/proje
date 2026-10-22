on(release){
   if(_global.MAIN_HERO.free_points >= 1)
   {
      _global.MAIN_HERO.SKILL.Bow = _global.MAIN_HERO.SKILL.Bow + 1;
      _global.MAIN_HERO.free_points--;
      inventoryShowStats();
   }
}
