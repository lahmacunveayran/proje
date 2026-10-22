on(release){
   if(_global.SHIP_LOCATION == "none")
   {
      if(_global.GOLD >= _global.SHIP_PRICE)
      {
         _global.GOLD -= _global.SHIP_PRICE;
         _global.SHIP_LOCATION = _global.CURR_TOWN;
      }
      else
      {
         quest_txt.text = "Paran yetmiyor!\n\nGeminin fiyatı: " + _global.SHIP_PRICE + " altın";
      }
   }
   else
   {
      _global.SAILING_SHIP = true;
      _parent.leaveTown();
   }
   _parent.harborShow();
}
