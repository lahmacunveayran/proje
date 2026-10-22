on(release){
   if(_global.MAIN_HERO.stat_points >= 1)
   {
      _global.MAIN_HERO.SKILL.FarEast = _global.MAIN_HERO.SKILL.FarEast + 1;
      _global.MAIN_HERO.stat_points--;
      _parent.showStats();
   }
}
