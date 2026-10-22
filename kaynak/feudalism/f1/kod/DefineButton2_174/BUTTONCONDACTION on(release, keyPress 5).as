on(release, keyPress "5"){
   if(_global.SCROLL_AllHealBig > 0)
   {
      _global.SCROLL_AllHealBig--;
      scroll_2_txt.text = _global.SCROLL_AllHealBig;
      makeThemHealUnits(0.66);
   }
}
