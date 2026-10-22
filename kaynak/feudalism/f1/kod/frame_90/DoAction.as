_root.loot_txt.text = "";
var i = 0;
while(i < _global.LOOT.length)
{
   _root.addItemInfoTo(_global.INVENTORY,_global.LOOT[i]);
   switch(_global.LOOT[i].CATEGORY)
   {
      case "WeaponClass":
         var temp_item = new WeaponClass(_global.LOOT[i].TYPE,_global.LOOT[i].NATION,_global.LOOT[i].LEVEL);
         break;
      case "Armor":
         var temp_item = new Armor(_global.LOOT[i].TYPE,_global.LOOT[i].NATION,_global.LOOT[i].LEVEL);
   }
   _root.loot_txt.text += temp_item.NAME + " x" + _global.LOOT[i].COUNT + "\n";
   i++;
}
