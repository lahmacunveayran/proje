onClipEvent(enterFrame){
   if(_global.GOLD_GOT > 0)
   {
      _global.GOLD = _global.GOLD + 1;
      _global.GOLD_GOT--;
      this.gold_txt.text = _global.GOLD + " gp.";
   }
   if(_global.EXP_GOT > 0)
   {
      if(_global.MAIN_HERO.experience(1))
      {
         this.level_up.gotoAndPlay(2);
      }
      this.exp_txt.text = _global.MAIN_HERO.EXP + "/" + Hero.getExpForLevel(_global.MAIN_HERO.LEVEL + 1);
      _global.EXP_GOT--;
   }
}
