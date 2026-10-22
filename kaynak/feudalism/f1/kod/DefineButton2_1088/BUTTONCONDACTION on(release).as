on(release){
   if(_global.MAIN_HERO.free_points >= 2)
   {
      _global.MAIN_HERO.INT = _global.MAIN_HERO.INT + 1;
      _global.MAIN_HERO.free_points -= 2;
      inventoryShowStats();
   }
}
