on(release){
   if(_global.MAIN_HERO.free_points >= 1)
   {
      _global.MAIN_HERO.SKILL.Throwing = _global.MAIN_HERO.SKILL.Throwing + 1;
      _global.MAIN_HERO.free_points--;
      _parent.inventoryShowStats();
   }
}
