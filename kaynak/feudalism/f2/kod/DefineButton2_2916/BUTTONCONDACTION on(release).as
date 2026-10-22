on(release){
   if(_global.MAIN_HERO.stat_points >= 1)
   {
      _global.MAIN_HERO.SKILL.Katar = _global.MAIN_HERO.SKILL.Katar + 1;
      _global.MAIN_HERO.stat_points--;
      _parent.showStats();
   }
}
