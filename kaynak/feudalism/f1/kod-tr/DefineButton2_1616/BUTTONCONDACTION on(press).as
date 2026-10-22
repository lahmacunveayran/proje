on(press){
   var mult = !Key.isDown(16) ? 1 : 5;
   if(_global.GOLD >= 50 * mult)
   {
      _global.GOLD -= 50 * mult;
      _global.SCROLL_AllHealSmall += mult;
      money_txt.text = _global.GOLD + " altın";
      scroll_1_txt.text = _global.SCROLL_AllHealSmall;
   }
   else
   {
      item_name_txt.text = "Paran yetmiyor!";
      item_stats_txt.text = "";
   }
}
