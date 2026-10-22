on(release){
   if(_global.MAIN_HERO.free_points >= 1)
   {
      _global.MAIN_HERO.SKILL.Spear = _global.MAIN_HERO.SKILL.Spear + 1;
      _global.MAIN_HERO.free_points--;
      _parent.inventoryShowStats();
   }
}
