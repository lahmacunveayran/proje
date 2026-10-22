_root.loot_txt.text = "";
var i = 0;
while(i < _global.LOOT.length)
{
   _root.addItemInfoTo(_global.INVENTORY,_global.LOOT[i]);
   temp_item = _global.LOOT[i].getItem();
   _root.loot_txt.text += temp_item.NAME + " x" + _global.LOOT[i].COUNT + "\n";
   if(!_global.EASY_MODE)
   {
      if(temp_item.NAME == "Occult Rune")
      {
         _root.kongregateStats.submit("OccultRuneFound",_global.LOOT[i].COUNT);
      }
   }
   i++;
}
