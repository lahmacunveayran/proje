on(release){
   if(_global.MAIN_HERO.free_points >= 2)
   {
      _global.MAIN_HERO.DEX = _global.MAIN_HERO.DEX + 1;
      _global.MAIN_HERO.free_points -= 2;
      inventoryShowStats();
   }
}
