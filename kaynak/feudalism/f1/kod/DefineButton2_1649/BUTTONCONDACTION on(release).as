on(release){
   if(_global.MAIN_HERO.free_points >= 2)
   {
      _global.MAIN_HERO.STR = _global.MAIN_HERO.STR + 1;
      _global.MAIN_HERO.free_points -= 2;
      _parent.inventoryShowStats();
   }
}
