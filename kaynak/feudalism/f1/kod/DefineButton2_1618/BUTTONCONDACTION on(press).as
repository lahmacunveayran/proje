on(press){
   var mult = !Key.isDown(16) ? 1 : 5;
   if(_global.GOLD >= 1000 * mult)
   {
      _global.GOLD -= 1000 * mult;
      _global.SCROLL_Rage += mult;
      money_txt.text = _global.GOLD + " gp.";
      scroll_3_txt.text = _global.SCROLL_Rage;
   }
   else
   {
      item_name_txt.text = "Not enough money!";
      item_stats_txt.text = "";
   }
}
