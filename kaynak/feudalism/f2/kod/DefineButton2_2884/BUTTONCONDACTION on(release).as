on(release){
   if(_global.MAIN_HERO.stat_points >= 1)
   {
      _global.MAIN_HERO.SKILL.Dagger = _global.MAIN_HERO.SKILL.Dagger + 1;
      _global.MAIN_HERO.stat_points--;
      _parent.showStats();
   }
}
