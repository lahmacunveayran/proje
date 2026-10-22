on(press){
   var mult = !Key.isDown(16) ? 1 : 5;
   if(_global.GOLD >= 100 * mult)
   {
      _global.GOLD -= 100 * mult;
      _global.POTION_HealMedium += mult;
      money_txt.text = _global.GOLD + " gp.";
      potion_2_txt.text = _global.POTION_HealMedium;
   }
   else
   {
      item_name_txt.text = "Not enough money!";
      item_stats_txt.text = "";
   }
}
