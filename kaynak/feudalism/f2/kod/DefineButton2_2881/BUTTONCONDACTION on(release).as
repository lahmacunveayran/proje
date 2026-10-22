on(release){
   if(_global.MAIN_HERO.stat_points >= 1)
   {
      _global.MAIN_HERO.SKILL.Axe = _global.MAIN_HERO.SKILL.Axe + 1;
      _global.MAIN_HERO.stat_points--;
      _parent.showStats();
   }
}
