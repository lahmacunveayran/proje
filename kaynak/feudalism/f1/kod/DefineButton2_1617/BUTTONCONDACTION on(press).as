on(press){
   var mult = !Key.isDown(16) ? 1 : 5;
   if(_global.GOLD >= 200 * mult)
   {
      _global.GOLD -= 200 * mult;
      _global.SCROLL_AllHealBig += mult;
      money_txt.text = _global.GOLD + " gp.";
      scroll_2_txt.text = _global.SCROLL_AllHealBig;
   }
   else
   {
      item_name_txt.text = "Not enough money!";
      item_stats_txt.text = "";
   }
}
