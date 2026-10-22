on(release){
   if(_global.MAIN_HERO)
   {
      gotoAndStop("diff");
   }
   else
   {
      item_stats_txt.text = "Önce bir kahraman seç!";
   }
}
