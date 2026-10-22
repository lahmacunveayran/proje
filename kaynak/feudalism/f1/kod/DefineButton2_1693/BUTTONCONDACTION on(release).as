on(release){
   if(_global.MAIN_HERO.free_points >= 1)
   {
      _global.MAIN_HERO.SKILL.Staff = _global.MAIN_HERO.SKILL.Staff + 1;
      _global.MAIN_HERO.free_points--;
      _parent.inventoryShowStats();
   }
}
