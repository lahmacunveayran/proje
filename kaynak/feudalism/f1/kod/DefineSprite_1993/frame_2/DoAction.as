max_lv_txt.text = _global.MAIN_HERO.LEVEL;
max_gold_txt.text = _global.GOLD;
attachMovie(_global.MAIN_HERO.HORSE == null ? "Human_Player" : "Horseman_Player","temp_hero",1,{_x:1000,_y:1000});
temp_hero.initUnit(_global.MAIN_HERO);
max_dmg_txt.text = temp_hero.wpn.dmg + temp_hero.wpn.rnd;
max_hp_txt.text = temp_hero.MAX_HP;
if(!isNaN(_global.MAIN_HERO.LEVEL) && !isNaN(_global.GOLD) && !isNaN(temp_hero.wpn.dmg + temp_hero.wpn.rnd) && !isNaN(temp_hero.MAX_HP))
{
   _root.kongregateStats.submit("MaxLevel",_global.MAIN_HERO.LEVEL);
   _root.kongregateStats.submit("MaxGold",_global.GOLD);
   _root.kongregateStats.submit("MaxDamage",temp_hero.wpn.dmg + temp_hero.wpn.rnd);
   _root.kongregateStats.submit("Max HP",temp_hero.MAX_HP);
}
