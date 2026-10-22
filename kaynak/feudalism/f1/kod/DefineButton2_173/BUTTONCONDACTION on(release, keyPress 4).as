on(release, keyPress "4"){
   if(_global.SCROLL_AllHealSmall > 0)
   {
      _global.SCROLL_AllHealSmall--;
      scroll_1_txt.text = _global.SCROLL_AllHealSmall;
      makeThemHealUnits(0.33);
   }
}
