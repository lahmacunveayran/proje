on(release){
   _global.EASY_MODE = false;
   if(!_global.SHOW_HELP)
   {
      _root.gotoAndStop("TOWN_SCREEN");
   }
   else
   {
      _root.gotoAndStop("TUTORIAL");
   }
}
