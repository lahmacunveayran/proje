on(release){
   if(_global.MAIN_HERO.free_points >= 1)
   {
      _global.MAIN_HERO.SKILL.Dual = _global.MAIN_HERO.SKILL.Dual + 1;
      _global.MAIN_HERO.free_points--;
      _parent.inventoryShowStats();
   }
}
