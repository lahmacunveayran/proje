on(release){
   if(_global.MAIN_HERO.stat_points >= 1)
   {
      _global.MAIN_HERO.SKILL.Sword = _global.MAIN_HERO.SKILL.Sword + 1;
      _global.MAIN_HERO.stat_points--;
      _parent.showStats();
   }
}
