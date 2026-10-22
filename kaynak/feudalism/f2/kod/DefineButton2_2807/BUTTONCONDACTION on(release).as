on(release){
   if(_global.MAIN_HERO.HORSE != null)
   {
      _global.GOLD += Math.round(_global.MAIN_HERO.HORSE.price / 3);
      _global.MAIN_HERO.HORSE = null;
      _parent.barnShowTrader();
   }
}
