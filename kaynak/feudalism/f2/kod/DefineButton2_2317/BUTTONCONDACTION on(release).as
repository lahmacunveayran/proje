on(release){
   _global.MAIN_HERO.GENDER = _currentframe != 1 ? "m" : "f";
   _parent.hero_ico.setUnitView(_global.MAIN_HERO,false);
   gotoAndStop(3 - _currentframe);
}
