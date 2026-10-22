on(release){
   if(_global.MAIN_HERO.free_points >= 1)
   {
      _global.MAIN_HERO.SKILL.ArtOfWar = _global.MAIN_HERO.SKILL.ArtOfWar + 1;
      _global.MAIN_HERO.free_points--;
      _parent.inventoryShowStats();
   }
}
