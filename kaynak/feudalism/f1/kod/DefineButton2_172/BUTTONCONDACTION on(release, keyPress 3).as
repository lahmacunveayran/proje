on(release, keyPress "3"){
   if(_global.SCROLL_AllHealBig > 0)
   {
      _global.SCROLL_AllHealBig--;
      potion_3_txt.text = _global.SCROLL_AllHealBig;
      makeThemHealHero(100000);
   }
}
