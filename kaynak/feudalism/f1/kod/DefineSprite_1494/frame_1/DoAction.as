function inventoryShowStats()
{
   this.STR_txt.text = _global.MAIN_HERO.STR;
   this.DEX_txt.text = _global.MAIN_HERO.DEX;
   this.CON_txt.text = _global.MAIN_HERO.CON;
   this.INT_txt.text = _global.MAIN_HERO.INT;
   var _loc3_ = _global.MAIN_HERO.free_points >= 2;
   var _loc4_ = 0;
   while(_loc4_ < 4)
   {
      this["stat_btn_" + _loc4_]._visible = _loc3_;
      _loc4_ = _loc4_ + 1;
   }
   if(_global.MAIN_HERO.STR >= 200)
   {
      this.stat_btn_0._visible = false;
   }
   if(_global.MAIN_HERO.DEX >= 200)
   {
      this.stat_btn_1._visible = false;
   }
   if(_global.MAIN_HERO.CON >= 200)
   {
      this.stat_btn_2._visible = false;
   }
   if(_global.MAIN_HERO.INT >= 200)
   {
      this.stat_btn_3._visible = false;
   }
   this.free_points_txt.text = _global.MAIN_HERO.free_points;
   _loc3_ = _global.MAIN_HERO.free_points >= 1;
   for(_loc4_ in _global.MAIN_HERO.SKILL)
   {
      this[_loc4_ + "_txt"].text = _global.MAIN_HERO.SKILL[_loc4_];
      this["skill_btn_" + _loc4_]._visible = _global.MAIN_HERO.SKILL[_loc4_] >= 100 ? false : _loc3_;
   }
   if(_global.MAIN_HERO.SKILL.ArtOfWar >= _global.MAIN_HERO.INT * 2)
   {
      this.skill_btn_ArtOfWar._visible = false;
   }
   if(_global.MAIN_HERO.SKILL.Patriotism >= _global.MAIN_HERO.INT * 2)
   {
      this.skill_btn_Patriotism._visible = false;
   }
   this.hero_stats_txt.text = _global.MAIN_HERO.NAME + "\nLevel " + _global.MAIN_HERO.LEVEL;
}
stop();
delete _global.MAIN_HERO;
_global.MAIN_HERO = new Hero();
_global.MAIN_HERO.LEVEL = 1;
_global.MAIN_HERO.NAME = "Edgar";
_global.MAIN_HERO.NATION = "Viz";
_global.MAIN_HERO.GENDER = "m";
_global.MAIN_HERO.STR = 30;
_global.MAIN_HERO.CON = 15;
_global.MAIN_HERO.DEX = 20;
_global.MAIN_HERO.INT = 10;
_global.MAIN_HERO.SKILL = new Array();
_global.MAIN_HERO.SKILL.Sword = 55;
_global.MAIN_HERO.SKILL.Axe = 20;
_global.MAIN_HERO.SKILL.Mace = 20;
_global.MAIN_HERO.SKILL.FarEast = 0;
_global.MAIN_HERO.SKILL.Spear = 25;
_global.MAIN_HERO.SKILL.Dagger = 45;
_global.MAIN_HERO.SKILL.Staff = 0;
_global.MAIN_HERO.SKILL.Dual = 15;
_global.MAIN_HERO.SKILL.Fist = 50;
_global.MAIN_HERO.SKILL.Bow = 20;
_global.MAIN_HERO.SKILL.Crossbow = 30;
_global.MAIN_HERO.SKILL.Throwing = 40;
_global.MAIN_HERO.SKILL.Patriotism = 0;
_global.MAIN_HERO.SKILL.ArtOfWar = 0;
_global.MAIN_HERO.WEAPON_PRI = new WeaponClass("TwohandedSword","Viz",1);
_global.MAIN_HERO.WEAPON_SEC = new WeaponClass("Bow","Viz",1);
_global.MAIN_HERO.ARMOR = null;
_global.MAIN_HERO.HELMET = null;
_global.MAIN_HERO.HORSE = null;
_global.GOLD = 100;
_global.SHIP_LOCATION = "none";
_global.SAILING_SHIP = false;
_global.GAME_ENDED = false;
delete _global.INVENTORY;
_global.INVENTORY = new Array();
_global.INVENTORY.push(new ItemInfo("WeaponClass","Dagger","Viz",1));
_global.IS_CAPTURED.Trapezus = true;
_global.CURR_TOWN = "Trapezus";
delete _global.FRIENDS;
_global.FRIENDS = new Array();
_global.FRIENDS.push(new Unit("Ranged","Viz",1));
_global.FRIENDS.push(new Unit("Melee","Viz",1));
_global.FRIENDS.push(new Unit("Melee","Viz",1));
_global.FRIENDS.push(new Unit("Melee","Viz",1));
_global.FRIENDS.push(new Unit("Ranged","Viz",1));
_global.POTION_HealSmall = 5;
_global.POTION_HealMedium = 2;
_global.POTION_HealBig = 1;
_global.SCROLL_AllHealSmall = 4;
_global.SCROLL_AllHealBig = 2;
_global.SCROLL_Rage = 1;
