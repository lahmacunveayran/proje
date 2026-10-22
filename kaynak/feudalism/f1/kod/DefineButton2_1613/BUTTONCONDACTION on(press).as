on(press){
   var mult = !Key.isDown(16) ? 1 : 5;
   if(_global.GOLD >= 10 * mult)
   {
      _global.GOLD -= 10 * mult;
      _global.POTION_HealSmall += mult;
      money_txt.text = _global.GOLD + " gp.";
      potion_1_txt.text = _global.POTION_HealSmall;
   }
   else
   {
      item_name_txt.text = "Not enough money!";
      item_stats_txt.text = "";
   }
}
