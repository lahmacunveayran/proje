on(release){
   if(_global.POTION_HealSmall > 0)
   {
      _global.POTION_HealSmall--;
      potion_1_txt.text = _global.POTION_HealSmall;
      makeThemHealHero(40);
   }
}
