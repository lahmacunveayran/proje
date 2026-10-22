onClipEvent(enterFrame){
   if(_global.GOLD_GOT > 0)
   {
      _global.GOLD = _global.GOLD + 1;
      _global.GOLD_GOT--;
      this.gold_txt.text = _global.GOLD + " altın";
   }
   if(_global.EXP_GOT > 0)
   {
      if(_global.MAIN_HERO.experience(1))
      {
         this.level_up.gotoAndPlay(2);
      }
      this.exp_txt.text = _global.MAIN_HERO.EXP + "/" + _global.MAIN_HERO.EXP_FOR_LEVELS[_global.MAIN_HERO.LEVEL + 1];
      _global.EXP_GOT--;
   }
}
