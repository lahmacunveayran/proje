on(release){
   if(_global.EXP_GOT == 0 && _global.GOLD_GOT == 0)
   {
      if(_global.BATTLE_TYPE != "SIEGE")
      {
         _root.gotoAndStop("WORLD_MAP");
      }
      else
      {
         var town = new Town(_global.CURR_TOWN);
         if(town.adv_defenders.length > 0)
         {
            town.getAdvDefenders();
            _global.BATTLE_MAP = 60 + _root.d(4);
            _global.BATTLE_TYPE = "THRONE_HALL";
            _root.gotoAndStop("SPLASH_SCREEN");
         }
         else
         {
            _root.gotoAndStop("WORLD_MAP");
         }
      }
   }
   else
   {
      if(_global.MAIN_HERO.experience(_global.EXP_GOT))
      {
         fields.level_up.gotoAndPlay(2);
      }
      _global.EXP_GOT = 0;
      _global.GOLD += _global.GOLD_GOT;
      _global.GOLD_GOT = 0;
      fields.exp_txt.text = _global.MAIN_HERO.EXP + "/" + _global.MAIN_HERO.EXP_FOR_LEVELS[_global.MAIN_HERO.LEVEL + 1];
      fields.gold_txt.text = _global.GOLD + " gp.";
   }
}
