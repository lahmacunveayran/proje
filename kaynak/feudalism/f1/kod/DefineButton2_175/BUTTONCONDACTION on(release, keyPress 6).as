on(release, keyPress "6"){
   if(_global.SCROLL_Rage > 0)
   {
      _global.SCROLL_Rage--;
      scroll_2_txt.text = _global.SCROLL_Rage;
      makeThemRage();
   }
}
