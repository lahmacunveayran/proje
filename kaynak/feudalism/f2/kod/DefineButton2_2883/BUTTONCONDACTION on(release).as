on(release){
   if(_global.MAIN_HERO.stat_points >= 1)
   {
      _global.MAIN_HERO.SKILL.Spear = _global.MAIN_HERO.SKILL.Spear + 1;
      _global.MAIN_HERO.stat_points--;
      _parent.showStats();
   }
}
