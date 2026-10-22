on(release){
   if(_global.BATTLE_TUTORIAL_PLAYED || !_global.SHOW_HELP)
   {
      _root.loadMap(_global.BATTLE_MAP);
   }
   else
   {
      _root.gotoAndStop("BATTLE_TUT");
   }
}
