on(release){
   if(_global.MAIN_HERO.stat_points >= 1)
   {
      _global.MAIN_HERO.SKILL.Throwing = _global.MAIN_HERO.SKILL.Throwing + 1;
      _global.MAIN_HERO.stat_points--;
      _parent.showStats();
   }
}
