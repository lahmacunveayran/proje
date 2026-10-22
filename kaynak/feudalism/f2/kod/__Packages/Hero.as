class Hero extends Object
{
   var ACTIVE_SKILLS;
   var ARMOR;
   var AURA_SKILLS;
   var CON;
   var DEX;
   var EXP;
   var GENDER;
   var HELMET;
   var HORSE;
   var LEVEL;
   var NAME;
   var NATION;
   var PASSIVE_SKILLS;
   var SKILL;
   var SPR;
   var STR;
   var WEAPON_PRI;
   var WEAPON_SEC;
   var skill_points;
   var stat_points;
   var price = 0;
   function Hero()
   {
      super();
      this.LEVEL = 0;
      this.EXP = 0;
      this.stat_points = 10;
      this.skill_points = 1;
      this.ACTIVE_SKILLS = new Array();
      this.PASSIVE_SKILLS = new Array();
      this.AURA_SKILLS = new Array();
      this.SKILL = new Array();
      this.SKILL.Sword = 0;
      this.SKILL.Axe = 0;
      this.SKILL.Mace = 0;
      this.SKILL.FarEast = 0;
      this.SKILL.Spear = 0;
      this.SKILL.Dagger = 0;
      this.SKILL.Staff = 0;
      this.SKILL.Dual = 0;
      this.SKILL.Katar = 0;
      this.SKILL.Fist = 0;
      this.SKILL.Bow = 0;
      this.SKILL.Crossbow = 0;
      this.SKILL.Throwing = 0;
   }
   static function getExpForLevel(lv)
   {
      switch(lv)
      {
         case 0:
            return -1;
         case 1:
            return 0;
         case 2:
            return 50;
         case 3:
            return 107;
         case 4:
            return 173;
         case 5:
            return 247;
         case 6:
            return 333;
         case 7:
            return 431;
         case 8:
            return 543;
         case 9:
            return 671;
         case 10:
            return 817;
         case 11:
            return 984;
         case 12:
            return 1176;
         case 13:
            return 1395;
         case 14:
            return 1645;
         case 15:
            return 1932;
         case 16:
            return 2259;
         case 17:
            return 2634;
         case 18:
            return 3062;
         case 19:
            return 3552;
         case 20:
            return 4112;
         case 21:
            return 4753;
         case 22:
            return 5486;
         case 23:
            return 6325;
         case 24:
            return 7283;
         case 25:
            return 8380;
         case 26:
            return 9634;
         case 27:
            return 11068;
         case 28:
            return 12708;
         case 29:
            return 14584;
         case 30:
            return 16730;
         case 31:
            return 19184;
         case 32:
            return 21990;
         case 33:
            return 25199;
         case 34:
            return 28870;
         case 35:
            return 33068;
         case 36:
            return 37870;
         case 37:
            return 43361;
         case 38:
            return 49641;
         case 39:
            return 56824;
         case 40:
            return 65038;
         case 41:
            return 74433;
         case 42:
            return 85178;
         case 43:
            return 97467;
         case 44:
            return 11152;
         case 45:
            return 127595;
         case 46:
            return 145978;
         case 47:
            return 167002;
         case 48:
            return 191048;
         case 49:
            return 218548;
         case 50:
            return 250000;
         default:
            return 0;
      }
   }
   static function getNationDodgeMod(nation)
   {
      switch(nation)
      {
         case "Rog":
            return 1.2;
         case "Viz":
            return 1.4;
         case "Ger":
            return 1.3;
         case "Rus":
            return 1.6;
         case "Jap":
            return 1.7;
         case "Mon":
            return 1.5;
         case "Ara":
            return 1.6;
         default:
            return;
      }
   }
   function experience(xp)
   {
      this.EXP += xp;
      var _loc3_ = false;
      while(this.LEVEL < 50 && this.EXP >= Hero.getExpForLevel(this.LEVEL + 1))
      {
         this.LEVEL = this.LEVEL + 1;
         this.stat_points += !_global.EASY_MODE ? 10 : 20;
         this.skill_points += !_global.EASY_MODE ? 1 : 2;
         _loc3_ = true;
      }
      return _loc3_;
   }
   function equipItemInfo(slot, item_info)
   {
      var _loc2_ = item_info.getItem();
      if(_loc2_.TYPE == "Rune")
      {
         return "Cant\'t eqiup runes! Have to combine them with a weapon first!";
      }
      if(slot == "ARMOR" && item_info.TYPE != "Clothes" || slot == "HELMET" && item_info.TYPE != "Helmet")
      {
         return "Cant\'t eqiup armor into this slot!";
      }
      if((slot == "WEAPON_PRI" || slot == "WEAPON_SEC") && (item_info.TYPE == "Clothes" || item_info.TYPE == "Helmet"))
      {
         return "Cant\'t eqiup weapon or shield into this slot!";
      }
      if(_loc2_.require_param != null && this[_loc2_.require_param] < _loc2_.require_value)
      {
         return "You have not enough " + _loc2_.require_param + " to equip this item.";
      }
      var _loc4_;
      if(item_info.CATEGORY == "WeaponClass")
      {
         _loc4_ = slot != "WEAPON_PRI" ? "WEAPON_PRI" : "WEAPON_SEC";
         if(this.HORSE != null)
         {
            switch(_loc2_.TYPE)
            {
               case "Dagger":
               case "Katar":
               case "Staff":
                  return "This weapon isn\'t designed for fighting from a horse!";
               default:
                  if(slot == "WEAPON_SEC" && _loc2_.TYPE != "Shield" && !_loc2_.isTwohanded() && this.WEAPON_PRI.rng == 0)
                  {
                     return "Can\'t use dual weapon from a horse!";
                  }
            }
         }
         if(_loc2_.TYPE == "Shield" && slot == "WEAPON_PRI")
         {
            return "Can\'t equip shield into right hand!";
         }
         if(_loc2_.TYPE == "Shield" && this[_loc4_] == null)
         {
            return "It\'s impossible to wear a shield and fight with bare hands!";
         }
         if(_loc2_.TYPE == "Shield" && this[_loc4_].isTwohanded())
         {
            return "It\'s impossible to use shield with a twohanded weapon!";
         }
         if(this[_loc4_].TYPE == "Shield" && _loc2_.isTwohanded())
         {
            return "It\'s impossible to use a twohanded weapon with shield!";
         }
         if(this[_loc4_] != null)
         {
            if(_loc2_.rng > 0 && this[_loc4_].rng > 0)
            {
               return "Can\'t equip both ranged weapons";
            }
            if(_loc2_.rng == 0 && this[_loc4_].rng == 0 && (_loc2_.isTwohanded() || this[_loc4_].isTwohanded()))
            {
               return "Can\'t equip two melee weapons, if one of them is twohanded";
            }
         }
         if(this.WEAPON_PRI == null && slot == "WEAPON_SEC" && _loc2_.rng == 0)
         {
            slot = "WEAPON_PRI";
            this.WEAPON_SEC = null;
         }
      }
      this[slot] = _loc2_;
      return "OK";
   }
   function equipHorse(horse)
   {
      switch(this.WEAPON_PRI.TYPE)
      {
         case "Katana":
         case "NinjaTo":
         case "Dagger":
         case "Katar":
         case "Staff":
            return "My weapon isn\'t designed for fighting from a horse!";
         default:
            switch(this.WEAPON_SEC.TYPE)
            {
               case "Katana":
               case "NinjaTo":
               case "Dagger":
               case "Katar":
               case "Staff":
                  return "My weapon isn\'t designed for fighting from a horse!";
               default:
                  if(this.WEAPON_SEC.TYPE != "Shield" && !(this.WEAPON_SEC.isTwohanded() || this.WEAPON_PRI.isTwohanded()))
                  {
                     return "I can\'t fight with dual weapons from a horse!";
                  }
                  this.HORSE = horse;
                  return "OK";
            }
      }
   }
   function heroVizMale()
   {
      this.LEVEL = 1;
      this.NAME = "Edgar";
      this.NATION = "Viz";
      this.GENDER = "m";
      this.STR = 30;
      this.CON = 15;
      this.DEX = 20;
      this.SPR = 10;
      this.SKILL = new Array();
      this.SKILL.Sword = 55;
      this.SKILL.Axe = 20;
      this.SKILL.Mace = 20;
      this.SKILL.FarEast = 0;
      this.SKILL.Spear = 25;
      this.SKILL.Dagger = 45;
      this.SKILL.Staff = 0;
      this.SKILL.Dual = 15;
      this.SKILL.Katar = 0;
      this.SKILL.Fist = 50;
      this.SKILL.Bow = 20;
      this.SKILL.Crossbow = 30;
      this.SKILL.Throwing = 40;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Viz",1);
      this.WEAPON_SEC = new WeaponClass("Bow","Viz",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.ACTIVE_SKILLS["2H_sword"] = [0,0,0];
      this.ACTIVE_SKILLS.spear = [0,0,0];
      this.ACTIVE_SKILLS.crossbow = [0,0,0];
      this.PASSIVE_SKILLS.push(["Infantry_1",0]);
      this.PASSIVE_SKILLS.push(["Infantry_2",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_2",0]);
      this.PASSIVE_SKILLS.push(["Bowmen_1",0]);
      this.PASSIVE_SKILLS.push(["Horsemen_1",0]);
      this.PASSIVE_SKILLS.push(["Horsemen_3",0]);
      this.AURA_SKILLS.push(["Barrier",0]);
      this.AURA_SKILLS.push(["NationViz",0]);
      this.AURA_SKILLS.push(["ForceBalance",0]);
   }
   function heroVizFemale()
   {
      this.LEVEL = 1;
      this.NAME = "Selena";
      this.NATION = "Viz";
      this.GENDER = "f";
      this.STR = 15;
      this.CON = 10;
      this.DEX = 35;
      this.SPR = 10;
      this.SKILL = new Array();
      this.SKILL.Sword = 35;
      this.SKILL.Axe = 10;
      this.SKILL.Mace = 10;
      this.SKILL.FarEast = 0;
      this.SKILL.Spear = 30;
      this.SKILL.Dagger = 50;
      this.SKILL.Staff = 0;
      this.SKILL.Dual = 15;
      this.SKILL.Katar = 0;
      this.SKILL.Fist = 50;
      this.SKILL.Bow = 50;
      this.SKILL.Crossbow = 60;
      this.SKILL.Throwing = 15;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Viz",1);
      this.WEAPON_SEC = new WeaponClass("Dagger","Viz",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.ACTIVE_SKILLS.crossbow = [0,0,0];
      this.ACTIVE_SKILLS.dagger = [0,0,0];
      this.ACTIVE_SKILLS["2H_sword"] = [0,0,0];
      this.PASSIVE_SKILLS.push(["Infantry_3",0]);
      this.PASSIVE_SKILLS.push(["Bowmen_2",0]);
      this.PASSIVE_SKILLS.push(["Bowmen_3",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_2",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_3",0]);
      this.PASSIVE_SKILLS.push(["AssassinTraining",0]);
      this.AURA_SKILLS.push(["DivineHelp",0]);
      this.AURA_SKILLS.push(["Healing",0]);
      this.AURA_SKILLS.push(["UnholyBreath",0]);
   }
   function heroGerMale()
   {
      this.LEVEL = 1;
      this.NAME = "Karl";
      this.NATION = "Ger";
      this.GENDER = "m";
      this.STR = 20;
      this.CON = 35;
      this.DEX = 5;
      this.SPR = 10;
      this.SKILL = new Array();
      this.SKILL.Sword = 30;
      this.SKILL.Axe = 20;
      this.SKILL.Mace = 60;
      this.SKILL.FarEast = 0;
      this.SKILL.Spear = 25;
      this.SKILL.Dagger = 5;
      this.SKILL.Staff = 0;
      this.SKILL.Dual = 5;
      this.SKILL.Katar = 0;
      this.SKILL.Fist = 50;
      this.SKILL.Bow = 15;
      this.SKILL.Crossbow = 15;
      this.SKILL.Throwing = 45;
      this.WEAPON_PRI = new WeaponClass("OnehandedMace","Ger",1);
      this.WEAPON_SEC = new WeaponClass("Shield","Ger",1);
      this.ARMOR = new Armor("Clothes","Ger",1);
      this.HELMET = null;
      this.HORSE = null;
      this.ACTIVE_SKILLS.shield = [0,0,0];
      this.ACTIVE_SKILLS["2H_axe"] = [0,0,0];
      this.ACTIVE_SKILLS.throwing = [0,0,0];
      this.PASSIVE_SKILLS.push(["Infantry_1",0]);
      this.PASSIVE_SKILLS.push(["Infantry_2",0]);
      this.PASSIVE_SKILLS.push(["Infantry_3",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_2",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_1",0]);
      this.PASSIVE_SKILLS.push(["Horsemen_2",0]);
      this.AURA_SKILLS.push(["Devotion",0]);
      this.AURA_SKILLS.push(["Sacrifice",0]);
      this.AURA_SKILLS.push(["HolyTribunal",0]);
   }
   function heroGerFemale()
   {
      this.LEVEL = 1;
      this.NAME = "Elizabth";
      this.NATION = "Ger";
      this.GENDER = "f";
      this.STR = 20;
      this.CON = 25;
      this.DEX = 25;
      this.SPR = 10;
      this.SKILL = new Array();
      this.SKILL.Sword = 10;
      this.SKILL.Axe = 5;
      this.SKILL.Mace = 50;
      this.SKILL.FarEast = 0;
      this.SKILL.Spear = 50;
      this.SKILL.Dagger = 5;
      this.SKILL.Staff = 0;
      this.SKILL.Dual = 5;
      this.SKILL.Katar = 0;
      this.SKILL.Fist = 50;
      this.SKILL.Bow = 35;
      this.SKILL.Crossbow = 45;
      this.SKILL.Throwing = 60;
      this.WEAPON_PRI = new WeaponClass("Spear","Ger",1);
      this.WEAPON_SEC = new WeaponClass("Throwing","Ger",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.ACTIVE_SKILLS.spear = [0,0,0];
      this.ACTIVE_SKILLS.crossbow = [0,0,0];
      this.ACTIVE_SKILLS.shield = [0,0,0];
      this.PASSIVE_SKILLS.push(["Infantry_3",0]);
      this.PASSIVE_SKILLS.push(["Infantry_1",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_1",0]);
      this.PASSIVE_SKILLS.push(["Bowmen_3",0]);
      this.PASSIVE_SKILLS.push(["Horsemen_1",0]);
      this.PASSIVE_SKILLS.push(["Horsemen_2",0]);
      this.AURA_SKILLS.push(["DivineHelp",0]);
      this.AURA_SKILLS.push(["NationGer",0]);
      this.AURA_SKILLS.push(["BansheeCry",0]);
   }
   function heroRusMale()
   {
      this.LEVEL = 1;
      this.NAME = "Vseslav";
      this.NATION = "Rus";
      this.GENDER = "m";
      this.STR = 40;
      this.CON = 15;
      this.DEX = 10;
      this.SPR = 5;
      this.SKILL = new Array();
      this.SKILL.Sword = 5;
      this.SKILL.Axe = 60;
      this.SKILL.Mace = 35;
      this.SKILL.FarEast = 0;
      this.SKILL.Spear = 15;
      this.SKILL.Dagger = 5;
      this.SKILL.Staff = 0;
      this.SKILL.Dual = 20;
      this.SKILL.Katar = 0;
      this.SKILL.Fist = 50;
      this.SKILL.Bow = 15;
      this.SKILL.Crossbow = 5;
      this.SKILL.Throwing = 45;
      this.WEAPON_PRI = new WeaponClass("TwohandedAxe","Rus",1);
      this.WEAPON_SEC = new WeaponClass("Throwing","Rus",1);
      this.ARMOR = new Armor("Clothes","Rus",1);
      this.HELMET = new Armor("Helmet","Rus",1);
      this.HORSE = null;
      this.ACTIVE_SKILLS["2H_axe"] = [0,0,0];
      this.ACTIVE_SKILLS.shield = [0,0,0];
      this.ACTIVE_SKILLS.throwing = [0,0,0];
      this.PASSIVE_SKILLS.push(["Infantry_3",0]);
      this.PASSIVE_SKILLS.push(["Infantry_2",0]);
      this.PASSIVE_SKILLS.push(["BerserkerTraining",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_3",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_2",0]);
      this.PASSIVE_SKILLS.push(["Horsemen_3",0]);
      this.AURA_SKILLS.push(["Barrier",0]);
      this.AURA_SKILLS.push(["NationRus",0]);
      this.AURA_SKILLS.push(["Sacrifice",0]);
   }
   function heroRusFemale()
   {
      this.LEVEL = 1;
      this.NAME = "Olga";
      this.NATION = "Rus";
      this.GENDER = "f";
      this.STR = 20;
      this.CON = 10;
      this.DEX = 30;
      this.SPR = 15;
      this.SKILL = new Array();
      this.SKILL.Sword = 50;
      this.SKILL.Axe = 25;
      this.SKILL.Mace = 5;
      this.SKILL.FarEast = 0;
      this.SKILL.Spear = 15;
      this.SKILL.Dagger = 20;
      this.SKILL.Staff = 0;
      this.SKILL.Dual = 5;
      this.SKILL.Katar = 0;
      this.SKILL.Fist = 50;
      this.SKILL.Bow = 65;
      this.SKILL.Crossbow = 40;
      this.SKILL.Throwing = 15;
      this.WEAPON_PRI = new WeaponClass("Bow","Rus",1);
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Rus",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.ACTIVE_SKILLS.bow = [0,0,0];
      this.ACTIVE_SKILLS["2H_sword"] = [0,0,0];
      this.ACTIVE_SKILLS.spear = [0,0,0];
      this.PASSIVE_SKILLS.push(["Bowmen_1",0]);
      this.PASSIVE_SKILLS.push(["Bowmen_2",0]);
      this.PASSIVE_SKILLS.push(["Bowmen_3",0]);
      this.PASSIVE_SKILLS.push(["Infantry_1",0]);
      this.PASSIVE_SKILLS.push(["Infantry_2",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_2",0]);
      this.AURA_SKILLS.push(["DivineHelp",0]);
      this.AURA_SKILLS.push(["VenomCloud",0]);
      this.AURA_SKILLS.push(["SoulDrain",0]);
   }
   function heroJapMale()
   {
      this.LEVEL = 1;
      this.NAME = "Sieg";
      this.NATION = "Jap";
      this.GENDER = "m";
      this.STR = 30;
      this.CON = 5;
      this.DEX = 30;
      this.SPR = 10;
      this.SKILL = new Array();
      this.SKILL.Sword = 0;
      this.SKILL.Axe = 0;
      this.SKILL.Mace = 0;
      this.SKILL.FarEast = 70;
      this.SKILL.Spear = 0;
      this.SKILL.Dagger = 0;
      this.SKILL.Staff = 45;
      this.SKILL.Dual = 45;
      this.SKILL.Katar = 0;
      this.SKILL.Fist = 100;
      this.SKILL.Bow = 15;
      this.SKILL.Crossbow = 0;
      this.SKILL.Throwing = 0;
      this.WEAPON_PRI = new WeaponClass("NinjaTo","Jap",1);
      this.WEAPON_SEC = new WeaponClass("Bow","Jap",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.ACTIVE_SKILLS.dual = [0,0,0];
      this.ACTIVE_SKILLS.katana = [0,0,0];
      this.ACTIVE_SKILLS.bow = [0,0,0];
      this.PASSIVE_SKILLS.push(["Infantry_2",0]);
      this.PASSIVE_SKILLS.push(["Infantry_3",0]);
      this.PASSIVE_SKILLS.push(["FarEastWarTraining",0]);
      this.PASSIVE_SKILLS.push(["Bowmen_1",0]);
      this.PASSIVE_SKILLS.push(["Bowmen_2",0]);
      this.PASSIVE_SKILLS.push(["Meditate",0]);
      this.AURA_SKILLS.push(["VenomCloud",0]);
      this.AURA_SKILLS.push(["NationJap",0]);
      this.AURA_SKILLS.push(["LifeLeech",0]);
   }
   function heroJapFemale()
   {
      this.LEVEL = 1;
      this.NAME = "Niora";
      this.NATION = "Jap";
      this.GENDER = "f";
      this.STR = 20;
      this.CON = 5;
      this.DEX = 40;
      this.SPR = 15;
      this.SKILL = new Array();
      this.SKILL.Sword = 0;
      this.SKILL.Axe = 0;
      this.SKILL.Mace = 0;
      this.SKILL.FarEast = 55;
      this.SKILL.Spear = 0;
      this.SKILL.Dagger = 0;
      this.SKILL.Staff = 70;
      this.SKILL.Dual = 5;
      this.SKILL.Katar = 0;
      this.SKILL.Fist = 100;
      this.SKILL.Bow = 55;
      this.SKILL.Crossbow = 0;
      this.SKILL.Throwing = 0;
      this.WEAPON_PRI = new WeaponClass("Staff","Jap",1);
      this.WEAPON_SEC = new WeaponClass("Throwing","Jap",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.ACTIVE_SKILLS.staff = [0,0,0];
      this.ACTIVE_SKILLS.throwing = [0,0,0];
      this.ACTIVE_SKILLS.katana = [0,0,0];
      this.PASSIVE_SKILLS.push(["FarEastWarTraining",0]);
      this.PASSIVE_SKILLS.push(["Meditate",0]);
      this.PASSIVE_SKILLS.push(["KungFuSecrets",0]);
      this.PASSIVE_SKILLS.push(["Infantry_3",0]);
      this.PASSIVE_SKILLS.push(["Bowmen_1",0]);
      this.PASSIVE_SKILLS.push(["Bowmen_3",0]);
      this.AURA_SKILLS.push(["DivineHelp",0]);
      this.AURA_SKILLS.push(["SoulDrain",0]);
      this.AURA_SKILLS.push(["UnholyBreath",0]);
   }
   function heroMonMale()
   {
      this.LEVEL = 1;
      this.NAME = "Chingis";
      this.NATION = "Mon";
      this.GENDER = "m";
      this.STR = 25;
      this.CON = 15;
      this.DEX = 15;
      this.SPR = 15;
      this.SKILL = new Array();
      this.SKILL.Sword = 60;
      this.SKILL.Axe = 5;
      this.SKILL.Mace = 5;
      this.SKILL.FarEast = 0;
      this.SKILL.Spear = 5;
      this.SKILL.Dagger = 25;
      this.SKILL.Staff = 0;
      this.SKILL.Dual = 35;
      this.SKILL.Katar = 0;
      this.SKILL.Fist = 50;
      this.SKILL.Bow = 55;
      this.SKILL.Crossbow = 5;
      this.SKILL.Throwing = 10;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",1);
      this.WEAPON_SEC = new WeaponClass("Shield","Mon",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.ACTIVE_SKILLS.shield = [0,0,0];
      this.ACTIVE_SKILLS.bow = [0,0,0];
      this.ACTIVE_SKILLS["2H_sword"] = [0,0,0];
      this.PASSIVE_SKILLS.push(["Swordsmen_2",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_1",0]);
      this.PASSIVE_SKILLS.push(["Horsemen_2",0]);
      this.PASSIVE_SKILLS.push(["Bowmen_1",0]);
      this.PASSIVE_SKILLS.push(["Bowmen_3",0]);
      this.PASSIVE_SKILLS.push(["Horsemen_3",0]);
      this.AURA_SKILLS.push(["DivineHelp",0]);
      this.AURA_SKILLS.push(["NationMon",0]);
      this.AURA_SKILLS.push(["ForceBalance",0]);
   }
   function heroMonFemale()
   {
      this.LEVEL = 1;
      this.NAME = "Inga";
      this.NATION = "Mon";
      this.GENDER = "f";
      this.STR = 10;
      this.CON = 10;
      this.DEX = 30;
      this.SPR = 25;
      this.SKILL = new Array();
      this.SKILL.Sword = 40;
      this.SKILL.Axe = 5;
      this.SKILL.Mace = 5;
      this.SKILL.FarEast = 0;
      this.SKILL.Spear = 10;
      this.SKILL.Dagger = 60;
      this.SKILL.Staff = 0;
      this.SKILL.Dual = 5;
      this.SKILL.Katar = 0;
      this.SKILL.Fist = 50;
      this.SKILL.Bow = 65;
      this.SKILL.Crossbow = 5;
      this.SKILL.Throwing = 10;
      this.WEAPON_PRI = new WeaponClass("Bow","Mon",1);
      this.WEAPON_SEC = new WeaponClass("Dagger","Mon",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.ACTIVE_SKILLS.bow = [0,0,0];
      this.ACTIVE_SKILLS.dagger = [0,0,0];
      this.ACTIVE_SKILLS.shield = [0,0,0];
      this.PASSIVE_SKILLS.push(["Bowmen_1",0]);
      this.PASSIVE_SKILLS.push(["Bowmen_2",0]);
      this.PASSIVE_SKILLS.push(["Bowmen_3",0]);
      this.PASSIVE_SKILLS.push(["Horsemen_1",0]);
      this.PASSIVE_SKILLS.push(["Horsemen_2",0]);
      this.PASSIVE_SKILLS.push(["Horsemen_3",0]);
      this.AURA_SKILLS.push(["VenomCloud",0]);
      this.AURA_SKILLS.push(["Healing",0]);
      this.AURA_SKILLS.push(["BansheeCry",0]);
   }
   function heroAraMale()
   {
      this.LEVEL = 1;
      this.NAME = "Ismael";
      this.NATION = "Ara";
      this.GENDER = "m";
      this.STR = 35;
      this.CON = 20;
      this.DEX = 15;
      this.SPR = 5;
      this.SKILL = new Array();
      this.SKILL.Sword = 55;
      this.SKILL.Axe = 5;
      this.SKILL.Mace = 5;
      this.SKILL.FarEast = 0;
      this.SKILL.Spear = 5;
      this.SKILL.Dagger = 10;
      this.SKILL.Staff = 0;
      this.SKILL.Dual = 45;
      this.SKILL.Katar = 35;
      this.SKILL.Fist = 50;
      this.SKILL.Bow = 5;
      this.SKILL.Crossbow = 30;
      this.SKILL.Throwing = 10;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Ara",1);
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Ara",1);
      this.ARMOR = null;
      this.HELMET = new Armor("Helmet","Ara",1);
      this.HORSE = null;
      this.ACTIVE_SKILLS.dual = [0,0,0];
      this.ACTIVE_SKILLS["2H_sword"] = [0,0,0];
      this.ACTIVE_SKILLS.crossbow = [0,0,0];
      this.PASSIVE_SKILLS.push(["Infantry_2",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_2",0]);
      this.PASSIVE_SKILLS.push(["AssassinTraining",0]);
      this.PASSIVE_SKILLS.push(["Infantry_1",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_1",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_3",0]);
      this.AURA_SKILLS.push(["NationAra",0]);
      this.AURA_SKILLS.push(["Healing",0]);
      this.AURA_SKILLS.push(["HolyTribunal",0]);
   }
   function heroAraFemale()
   {
      this.LEVEL = 1;
      this.NAME = "Diana";
      this.NATION = "Ara";
      this.GENDER = "f";
      this.STR = 30;
      this.CON = 10;
      this.DEX = 30;
      this.SPR = 5;
      this.SKILL = new Array();
      this.SKILL.Sword = 40;
      this.SKILL.Axe = 5;
      this.SKILL.Mace = 5;
      this.SKILL.FarEast = 0;
      this.SKILL.Spear = 10;
      this.SKILL.Dagger = 60;
      this.SKILL.Staff = 0;
      this.SKILL.Dual = 10;
      this.SKILL.Katar = 65;
      this.SKILL.Fist = 50;
      this.SKILL.Bow = 5;
      this.SKILL.Crossbow = 20;
      this.SKILL.Throwing = 0;
      this.WEAPON_PRI = new WeaponClass("Katar","Ara",1);
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.ACTIVE_SKILLS.katar = [0,0,0];
      this.ACTIVE_SKILLS.crossbow = [0,0,0];
      this.ACTIVE_SKILLS.dagger = [0,0,0];
      this.PASSIVE_SKILLS.push(["Infantry_3",0]);
      this.PASSIVE_SKILLS.push(["AssassinTraining",0]);
      this.PASSIVE_SKILLS.push(["FindWeakPoint",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_3",0]);
      this.PASSIVE_SKILLS.push(["Horsemen_1",0]);
      this.PASSIVE_SKILLS.push(["Horsemen_3",0]);
      this.AURA_SKILLS.push(["VenomCloud",0]);
      this.AURA_SKILLS.push(["SoulDrain",0]);
      this.AURA_SKILLS.push(["UnholyBreath",0]);
   }
   function enemyVizKing()
   {
      this.LEVEL = 40;
      this.NAME = "Republic King";
      this.NATION = "Viz";
      this.GENDER = "m";
      this.STR = 100;
      this.CON = 60;
      this.DEX = 20;
      this.SPR = 40;
      this.SKILL = new Array();
      this.SKILL.Sword = 100;
      this.SKILL.Crossbow = 100;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Viz",7);
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",4);
      this.ARMOR = new Armor("Clothes","Viz",8);
      this.HELMET = new Armor("Helmet","Viz",8);
      this.HORSE = null;
      this.ACTIVE_SKILLS["2H_sword"] = [5,5,5];
      this.ACTIVE_SKILLS.crossbow = [5,5,5];
      this.PASSIVE_SKILLS.push(["Infantry_1",5]);
      this.PASSIVE_SKILLS.push(["Infantry_2",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_2",5]);
      this.PASSIVE_SKILLS.push(["Bowmen_1",5]);
      this.PASSIVE_SKILLS.push(["Horsemen_1",5]);
      this.PASSIVE_SKILLS.push(["Horsemen_3",5]);
      this.AURA_SKILLS.push(["NationViz",5]);
   }
   function enemyGerKing()
   {
      this.LEVEL = 40;
      this.NAME = "Order King";
      this.NATION = "Ger";
      this.GENDER = "m";
      this.STR = 100;
      this.CON = 100;
      this.DEX = 10;
      this.SPR = 10;
      this.SKILL = new Array();
      this.SKILL.Mace = 100;
      this.SKILL.Throwing = 100;
      this.WEAPON_PRI = new WeaponClass("TwohandedMace","Ger",6);
      this.WEAPON_SEC = new WeaponClass("Throwing","Ger",6);
      this.ARMOR = new Armor("Clothes","Ger",8);
      this.HELMET = new Armor("Helmet","Ger",8);
      this.HORSE = null;
      this.ACTIVE_SKILLS["2H_axe"] = [5,5,5];
      this.ACTIVE_SKILLS.throwing = [5,5,5];
      this.PASSIVE_SKILLS.push(["Infantry_1",5]);
      this.PASSIVE_SKILLS.push(["Infantry_1",5]);
      this.PASSIVE_SKILLS.push(["Infantry_3",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_2",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_1",5]);
      this.PASSIVE_SKILLS.push(["Horsemen_2",5]);
      this.AURA_SKILLS.push(["NationGer",5]);
   }
   function enemyRusKing()
   {
      this.LEVEL = 40;
      this.NAME = "Forest King";
      this.NATION = "Rus";
      this.GENDER = "m";
      this.STR = 110;
      this.CON = 60;
      this.DEX = 10;
      this.SPR = 20;
      this.SKILL = new Array();
      this.SKILL.Axe = 100;
      this.SKILL.Bow = 100;
      this.WEAPON_PRI = new WeaponClass("TwohandedAxe","Rus",6);
      this.WEAPON_SEC = new WeaponClass("Bow","Rus",4);
      this.ARMOR = new Armor("Clothes","Rus",8);
      this.HELMET = new Armor("Helmet","Rus",8);
      this.HORSE = null;
      this.ACTIVE_SKILLS["2H_axe"] = [5,5,5];
      this.ACTIVE_SKILLS.bow = [5,5,5];
      this.PASSIVE_SKILLS.push(["Infantry_3",5]);
      this.PASSIVE_SKILLS.push(["Infantry_2",5]);
      this.PASSIVE_SKILLS.push(["BerserkerTraining",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_3",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_2",5]);
      this.PASSIVE_SKILLS.push(["Horsemen_3",5]);
      this.AURA_SKILLS.push(["NationRus",5]);
   }
   function enemyJapKing()
   {
      this.LEVEL = 40;
      this.NAME = "Empire King";
      this.NATION = "Jap";
      this.GENDER = "m";
      this.STR = 90;
      this.CON = 30;
      this.DEX = 90;
      this.SPR = 40;
      this.SKILL = new Array();
      this.SKILL.FarEast = 100;
      this.SKILL.Dual = 100;
      this.WEAPON_PRI = new WeaponClass("NinjaTo","Jap",8);
      this.WEAPON_SEC = new WeaponClass("NinjaTo","Jap",8);
      this.ARMOR = new Armor("Clothes","Jap",8);
      this.HELMET = new Armor("Helmet","Jap",8);
      this.HORSE = null;
      this.ACTIVE_SKILLS.dual = [5,5,5];
      this.PASSIVE_SKILLS.push(["Infantry_2",5]);
      this.PASSIVE_SKILLS.push(["Infantry_3",5]);
      this.PASSIVE_SKILLS.push(["FarEastWarTraining",5]);
      this.PASSIVE_SKILLS.push(["Bowmen_1",5]);
      this.PASSIVE_SKILLS.push(["Bowmen_2",5]);
      this.PASSIVE_SKILLS.push(["Meditate",5]);
      this.AURA_SKILLS.push(["NationJap",5]);
   }
   function enemyMonKing()
   {
      this.LEVEL = 40;
      this.NAME = "Horde King";
      this.NATION = "Mon";
      this.GENDER = "m";
      this.STR = 100;
      this.CON = 20;
      this.DEX = 40;
      this.SPR = 60;
      this.SKILL = new Array();
      this.SKILL.Sword = 100;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",7);
      this.WEAPON_SEC = new WeaponClass("Shield","Mon",4);
      this.ARMOR = new Armor("Clothes","Mon",8);
      this.HELMET = new Armor("Helmet","Mon",8);
      this.HORSE = null;
      this.ACTIVE_SKILLS.shield = [5,5,5];
      this.PASSIVE_SKILLS.push(["Swordsmen_2",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_1",5]);
      this.PASSIVE_SKILLS.push(["Horsemen_2",5]);
      this.PASSIVE_SKILLS.push(["Bowmen_1",5]);
      this.PASSIVE_SKILLS.push(["Bowmen_3",5]);
      this.PASSIVE_SKILLS.push(["Horsemen_3",5]);
      this.AURA_SKILLS.push(["NationMon",5]);
   }
   function enemyAraKing()
   {
      this.LEVEL = 40;
      this.NAME = "Desert King";
      this.NATION = "Ara";
      this.GENDER = "m";
      this.STR = 100;
      this.CON = 60;
      this.DEX = 70;
      this.SPR = 30;
      this.SKILL = new Array();
      this.SKILL.Sword = 100;
      this.SKILL.Dual = 100;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Ara",7);
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Ara",7);
      this.ARMOR = new Armor("Clothes","Ara",8);
      this.HELMET = new Armor("Helmet","Ara",8);
      this.HORSE = null;
      this.ACTIVE_SKILLS.dual = [5,5,5];
      this.PASSIVE_SKILLS.push(["Infantry_2",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_2",5]);
      this.PASSIVE_SKILLS.push(["AssassinTraining",5]);
      this.PASSIVE_SKILLS.push(["Infantry_1",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_1",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_3",5]);
      this.AURA_SKILLS.push(["NationAra",5]);
   }
   static function getChampion(nation, lv)
   {
      var _loc1_ = new Hero();
      _loc1_["enemy" + nation + "Champion"]();
      _loc1_.LEVEL = 10 + 5 * lv;
      _loc1_.STR = 20 + 10 * lv;
      _loc1_.CON = 20 + 10 * lv;
      _loc1_.DEX = 20 + 10 * lv;
      _loc1_.SPR = 20 + 10 * lv;
      _loc1_.ARMOR = new Armor("Clothes",nation,lv);
      _loc1_.HELMET = new Armor("Helmet",nation,lv);
      return _loc1_;
   }
   function enemyVizChampion(lv)
   {
      this.LEVEL = 50;
      this.NAME = "Republic Champion";
      this.NATION = "Viz";
      this.GENDER = "f";
      this.STR = 100;
      this.CON = 100;
      this.DEX = 100;
      this.SPR = 100;
      this.SKILL = new Array();
      this.SKILL.Sword = 100;
      this.SKILL.Dual = 100;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Viz",7);
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Viz",7);
      this.ARMOR = new Armor("Clothes","Viz",8);
      this.HELMET = new Armor("Helmet","Viz",8);
      this.HORSE = null;
      this.ACTIVE_SKILLS.dual = [5,5,5];
      this.PASSIVE_SKILLS.push(["Infantry_1",5]);
      this.PASSIVE_SKILLS.push(["Infantry_2",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_2",5]);
      this.PASSIVE_SKILLS.push(["Bowmen_1",5]);
      this.PASSIVE_SKILLS.push(["Horsemen_1",5]);
      this.PASSIVE_SKILLS.push(["Horsemen_3",5]);
      this.AURA_SKILLS.push(["UnholyBreath",5]);
   }
   function enemyGerChampion()
   {
      this.LEVEL = 50;
      this.NAME = "Order Champion";
      this.NATION = "Ger";
      this.GENDER = "m";
      this.STR = 100;
      this.CON = 100;
      this.DEX = 100;
      this.SPR = 100;
      this.SKILL = new Array();
      this.SKILL.Mace = 100;
      this.SKILL.Throwing = 100;
      this.WEAPON_PRI = new WeaponClass("TwohandedMace","Ger",6);
      this.WEAPON_SEC = new WeaponClass("Throwing","Ger",6);
      this.ARMOR = new Armor("Clothes","Ger",8);
      this.HELMET = new Armor("Helmet","Ger",8);
      this.HORSE = null;
      this.ACTIVE_SKILLS["2H_axe"] = [5,5,5];
      this.ACTIVE_SKILLS.throwing = [5,5,5];
      this.PASSIVE_SKILLS.push(["Infantry_1",5]);
      this.PASSIVE_SKILLS.push(["Infantry_1",5]);
      this.PASSIVE_SKILLS.push(["Infantry_3",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_2",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_1",5]);
      this.PASSIVE_SKILLS.push(["Horsemen_2",5]);
      this.AURA_SKILLS.push(["HolyTribunal",5]);
   }
   function enemyRusChampion()
   {
      this.LEVEL = 50;
      this.NAME = "Forest Champion";
      this.NATION = "Rus";
      this.GENDER = "m";
      this.STR = 110;
      this.CON = 100;
      this.DEX = 100;
      this.SPR = 100;
      this.SKILL = new Array();
      this.SKILL.Axe = 100;
      this.SKILL.Dual = 100;
      this.WEAPON_PRI = new WeaponClass("OnehandedAxe","Rus",6);
      this.WEAPON_SEC = new WeaponClass("OnehandedAxe","Rus",6);
      this.ARMOR = new Armor("Clothes","Rus",8);
      this.HELMET = new Armor("Helmet","Rus",8);
      this.HORSE = null;
      this.ACTIVE_SKILLS.dual = [5,5,5];
      this.PASSIVE_SKILLS.push(["Infantry_3",5]);
      this.PASSIVE_SKILLS.push(["Infantry_2",5]);
      this.PASSIVE_SKILLS.push(["BerserkerTraining",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_3",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_2",5]);
      this.PASSIVE_SKILLS.push(["Horsemen_3",5]);
      this.AURA_SKILLS.push(["VenomCloud",5]);
   }
   function enemyJapChampion()
   {
      this.LEVEL = 50;
      this.NAME = "Empire Champion";
      this.NATION = "Jap";
      this.GENDER = "m";
      this.STR = 100;
      this.CON = 100;
      this.DEX = 100;
      this.SPR = 100;
      this.SKILL = new Array();
      this.SKILL.FarEast = 100;
      this.SKILL.Throwing = 100;
      this.WEAPON_PRI = new WeaponClass("Katana","Jap",8);
      this.WEAPON_SEC = new WeaponClass("Throwing","Jap",7);
      this.ARMOR = new Armor("Clothes","Jap",8);
      this.HELMET = new Armor("Helmet","Jap",8);
      this.HORSE = null;
      this.ACTIVE_SKILLS.katana = [5,5,5];
      this.ACTIVE_SKILLS.throwing = [5,5,5];
      this.PASSIVE_SKILLS.push(["Infantry_2",5]);
      this.PASSIVE_SKILLS.push(["Infantry_3",5]);
      this.PASSIVE_SKILLS.push(["FarEastWarTraining",5]);
      this.PASSIVE_SKILLS.push(["Bowmen_1",5]);
      this.PASSIVE_SKILLS.push(["Bowmen_2",5]);
      this.PASSIVE_SKILLS.push(["Meditate",5]);
      this.AURA_SKILLS.push(["UnholyBreath",5]);
   }
   function enemyMonChampion()
   {
      this.LEVEL = 50;
      this.NAME = "Horde Champion";
      this.NATION = "Mon";
      this.GENDER = "m";
      this.STR = 100;
      this.CON = 100;
      this.DEX = 100;
      this.SPR = 100;
      this.SKILL = new Array();
      this.SKILL.Sword = 100;
      this.SKILL.Dual = 100;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",7);
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Mon",7);
      this.ARMOR = new Armor("Clothes","Mon",8);
      this.HELMET = new Armor("Helmet","Mon",8);
      this.HORSE = null;
      this.ACTIVE_SKILLS.dual = [5,5,5];
      this.PASSIVE_SKILLS.push(["Swordsmen_2",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_1",5]);
      this.PASSIVE_SKILLS.push(["Horsemen_2",5]);
      this.PASSIVE_SKILLS.push(["Bowmen_1",5]);
      this.PASSIVE_SKILLS.push(["Bowmen_3",5]);
      this.PASSIVE_SKILLS.push(["Horsemen_3",5]);
      this.AURA_SKILLS.push(["ForceBalance",5]);
   }
   function enemyAraChampion()
   {
      this.LEVEL = 50;
      this.NAME = "Desert Champion";
      this.NATION = "Ara";
      this.GENDER = "f";
      this.STR = 100;
      this.CON = 100;
      this.DEX = 100;
      this.SPR = 100;
      this.SKILL = new Array();
      this.SKILL.Katar = 100;
      this.SKILL.Crossbow = 100;
      this.WEAPON_PRI = new WeaponClass("Katar","Ara",6);
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",4);
      this.ARMOR = new Armor("Clothes","Ara",8);
      this.HELMET = new Armor("Helmet","Ara",8);
      this.HORSE = null;
      this.ACTIVE_SKILLS.katar = [5,5,5];
      this.ACTIVE_SKILLS.crossbow = [5,5,5];
      this.PASSIVE_SKILLS.push(["Infantry_2",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_2",5]);
      this.PASSIVE_SKILLS.push(["AssassinTraining",5]);
      this.PASSIVE_SKILLS.push(["Infantry_1",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_1",5]);
      this.PASSIVE_SKILLS.push(["Swordsmen_3",5]);
      this.AURA_SKILLS.push(["UnholyBreath",5]);
   }
   function playerTutorialDummy()
   {
      this.LEVEL = 20;
      this.NAME = "Tutorial Player";
      this.NATION = _global.MAIN_HERO.NATION;
      this.GENDER = _global.MAIN_HERO.GENDER;
      this.STR = 30;
      this.CON = 50;
      this.DEX = 20;
      this.SPR = 40;
      this.SKILL = new Array();
      this.SKILL.Sword = 100;
      this.SKILL.Bow = 100;
      this.WEAPON_PRI = new WeaponClass("Bow","Viz",2);
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Viz",1);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.ACTIVE_SKILLS.crossbow = [0,0,0];
      this.ACTIVE_SKILLS["2H_sword"] = [5,0,0];
      this.ACTIVE_SKILLS["2H_axe"] = [0,0,0];
      this.PASSIVE_SKILLS.push(["Infantry_2",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_2",0]);
      this.PASSIVE_SKILLS.push(["AssassinTraining",0]);
      this.PASSIVE_SKILLS.push(["Infantry_1",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_1",0]);
      this.PASSIVE_SKILLS.push(["Swordsmen_3",0]);
      this.AURA_SKILLS.push(["Healing",3]);
      this.AURA_SKILLS.push(["HolyTribunal",0]);
      this.AURA_SKILLS.push(["VenomCloud",0]);
   }
   function enemyTutorialDummy()
   {
      this.LEVEL = 1;
      this.NAME = "Tutorial Enemy";
      this.NATION = "Mon";
      this.GENDER = "m";
      this.STR = 1;
      this.CON = 1;
      this.DEX = 1;
      this.SPR = 1;
      this.SKILL = new Array();
      this.SKILL.Sword = 50;
      this.SKILL.Bow = 50;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Mon",1);
      this.WEAPON_SEC = new WeaponClass("Bow","Mon",2);
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
   }
}
