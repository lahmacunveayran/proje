on(release){
   if(_global.MAIN_HERO.free_points >= 1)
   {
      _global.MAIN_HERO.SKILL.Dagger = _global.MAIN_HERO.SKILL.Dagger + 1;
      _global.MAIN_HERO.free_points--;
      _parent.inventoryShowStats();
   }
}
