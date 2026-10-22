on(release){
   if(_global.MAIN_HERO.free_points >= 2)
   {
      _global.MAIN_HERO.CON = _global.MAIN_HERO.CON + 1;
      _global.MAIN_HERO.free_points -= 2;
      inventoryShowStats();
   }
}
