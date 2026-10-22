on(release){
   if(_global.POTION_HealMedium > 0)
   {
      _global.POTION_HealMedium--;
      potion_2_txt.text = _global.POTION_HealMedium;
      makeThemHealHero(300);
   }
}
