on(press){
   var mult = !Key.isDown(16) ? 1 : 5;
   if(_global.GOLD >= 10 * mult)
   {
      _global.GOLD -= 10 * mult;
      _global.POTION_HealSmall += mult;
      money_txt.text = _global.GOLD + " altın";
      potion_1_txt.text = _global.POTION_HealSmall;
   }
   else
   {
      item_name_txt.text = "Paran yetmiyor!";
      item_stats_txt.text = "";
   }
}
