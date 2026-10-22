class Unit extends Hero
{
   var ACTIVE_SKILLS;
   var ARMOR;
   var AURA_SKILLS;
   var CON;
   var DEX;
   var GENDER;
   var HELMET;
   var HORSE;
   var ID;
   var LEVEL;
   var NAME;
   var NATION;
   var SKILL;
   var SPR;
   var STR;
   var TYPE;
   var WEAPON_PRI;
   var WEAPON_SEC;
   var price;
   var primary_skill;
   var secondary_skill;
   function Unit(nt, tp, lv)
   {
      super();
      this.ID = lv;
      this.TYPE = tp;
      var _loc4_;
      if(nt != "Rog")
      {
         this.NATION = nt;
         this.GENDER = !_root.percent(70) ? "f" : "m";
      }
      else
      {
         _loc4_ = ["Viz","Ger","Rus","Jap","Mon","Ara"];
         this.NATION = String(_loc4_[_root.dice(4)]);
         this.GENDER = "m";
      }
      this.LEVEL = (this.ID + 1) * 3;
      this["Unit" + nt + "_" + tp + lv]();
      this.price = this.getPrice();
   }
   function getUnitInfo()
   {
      return new UnitInfo(this.NATION,this.TYPE,this.ID);
   }
   function setActiveSkills(atk_anim, lv1, lv2, lv3)
   {
      this.ACTIVE_SKILLS[atk_anim] = [lv1,lv2,lv3];
   }
   function getPrice()
   {
      var _loc2_;
      if(this.NAME !== "Shogun Ghost")
      {
         _loc2_ = 0;
         _loc2_ += this.STR * 5;
         _loc2_ += this.CON * 5;
         _loc2_ += this.DEX * 5;
         _loc2_ += this.SPR * 5;
         if(this.WEAPON_PRI != null)
         {
            _loc2_ += this.WEAPON_PRI.price / 10;
         }
         if(this.WEAPON_SEC != null)
         {
            _loc2_ += this.WEAPON_SEC.price / 10;
         }
         if(this.ARMOR != null)
         {
            _loc2_ += this.ARMOR.price / 10;
         }
         if(this.HELMET != null)
         {
            _loc2_ += this.HELMET.price / 10;
         }
         _loc2_ += this.LEVEL * 50;
         if(this.TYPE == "caster")
         {
            _loc2_ += 1000 * this.ID * this.ID;
         }
         return Math.round(_loc2_);
      }
      return 100000;
   }
   function UnitViz_shield0()
   {
      this.NAME = "Caravan Guard";
      this.STR = 15;
      this.DEX = 4;
      this.CON = 9;
      this.SPR = 4;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Viz",1);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 55;
      this.WEAPON_SEC = new WeaponClass("Shield","Viz",1);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 45;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("shield",0,1,0);
   }
   function UnitViz_shield3()
   {
      this.NAME = "Legionary";
      this.STR = 32;
      this.DEX = 10;
      this.CON = 19;
      this.SPR = 10;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Viz",3);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("Shield","Viz",2);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Viz",3);
      this.HELMET = new Armor("Helmet","Viz",3);
      this.HORSE = null;
      this.setActiveSkills("shield",2,0,0);
   }
   function UnitViz_shield4()
   {
      this.NAME = "Light Chivalry";
      this.STR = 44;
      this.DEX = 13;
      this.CON = 26;
      this.SPR = 13;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Viz",4);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("Shield","Viz",3);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Viz",4);
      this.HELMET = new Armor("Helmet","Viz",4);
      this.HORSE = new Horse("any",15,1,5);
   }
   function UnitViz_shield7()
   {
      this.NAME = "Heavy Chivalry";
      this.STR = 85;
      this.DEX = 26;
      this.CON = 51;
      this.SPR = 26;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Viz",6);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 97;
      this.WEAPON_SEC = new WeaponClass("Shield","Viz",4);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 94;
      this.ARMOR = new Armor("Clothes","Viz",7);
      this.HELMET = new Armor("Helmet","Viz",7);
      this.HORSE = new Horse("white",220,12,1);
   }
   function UnitViz_2H_sword5()
   {
      this.NAME = "Moon Warrior";
      this.STR = 50;
      this.DEX = 10;
      this.CON = 30;
      this.SPR = 20;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Viz",4);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",3);
      this.secondary_skill = "Crossbow";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Viz",5);
      this.HELMET = new Armor("Helmet","Viz",5);
      this.HORSE = null;
      this.setActiveSkills("2H_sword",0,3,0);
   }
   function UnitViz_2H_sword6()
   {
      this.NAME = "Golden Rider";
      this.STR = 65;
      this.DEX = 13;
      this.CON = 39;
      this.SPR = 26;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Viz",5);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",3);
      this.secondary_skill = "Crossbow";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Viz",6);
      this.HELMET = new Armor("Helmet","Viz",6);
      this.HORSE = new Horse("white",200,10,2);
   }
   function UnitViz_2H_sword7()
   {
      this.NAME = "Elite Chivalry";
      this.STR = 85;
      this.DEX = 17;
      this.CON = 51;
      this.SPR = 34;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Viz",6);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 97;
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",4);
      this.secondary_skill = "Crossbow";
      this.SKILL[this.secondary_skill] = 94;
      this.ARMOR = new Armor("Clothes","Viz",7);
      this.HELMET = new Armor("Helmet","Viz",7);
      this.HORSE = new Horse("white",250,10,2);
   }
   function UnitViz_2H_axe2()
   {
      this.NAME = "Town Guard";
      this.STR = 25;
      this.DEX = 8;
      this.CON = 12;
      this.SPR = 10;
      this.WEAPON_PRI = new WeaponClass("TwohandedAxe","Viz",2);
      this.primary_skill = "Axe";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("Bow","Viz",1);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Viz",2);
      this.HELMET = new Armor("Helmet","Viz",1);
      this.HORSE = null;
      this.setActiveSkills("2H_axe",0,1,0);
   }
   function UnitViz_spear1()
   {
      this.NAME = "Light Pikeman";
      this.STR = 25;
      this.DEX = 10;
      this.CON = 10;
      this.SPR = 10;
      this.WEAPON_PRI = new WeaponClass("Spear","Viz",2);
      this.primary_skill = "Spear";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = new WeaponClass("Bow","Viz",1);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 52;
      this.ARMOR = new Armor("Clothes","Viz",1);
      this.HELMET = new Armor("Helmet","Viz",1);
      this.HORSE = null;
      this.setActiveSkills("spear",0,1,0);
   }
   function UnitViz_spear3()
   {
      this.NAME = "Line Infantry";
      this.STR = 37;
      this.DEX = 15;
      this.CON = 15;
      this.SPR = 15;
      this.WEAPON_PRI = new WeaponClass("Spear","Viz",3);
      this.primary_skill = "Spear";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("Bow","Viz",2);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Viz",3);
      this.HELMET = new Armor("Helmet","Viz",3);
      this.HORSE = null;
      this.setActiveSkills("spear",2,0,0);
   }
   function UnitViz_spear4()
   {
      this.NAME = "Elite Phalax";
      this.STR = 40;
      this.DEX = 16;
      this.CON = 16;
      this.SPR = 16;
      this.WEAPON_PRI = new WeaponClass("Spear","Viz",3);
      this.primary_skill = "Spear";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("Bow","Viz",2);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Viz",4);
      this.HELMET = new Armor("Helmet","Viz",4);
      this.HORSE = null;
      this.setActiveSkills("spear",1,2,0);
   }
   function UnitViz_spear5()
   {
      this.NAME = "Field Commander";
      this.STR = 58;
      this.DEX = 23;
      this.CON = 23;
      this.SPR = 23;
      this.WEAPON_PRI = new WeaponClass("Spear","Viz",4);
      this.primary_skill = "Spear";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("Bow","Viz",3);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Viz",5);
      this.HELMET = new Armor("Helmet","Viz",5);
      this.HORSE = new Horse("any",60,5,3);
   }
   function UnitViz_dual2()
   {
      this.NAME = "Mercenary";
      this.STR = 25;
      this.DEX = 10;
      this.CON = 12;
      this.SPR = 8;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Viz",2);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Viz",2);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Viz",2);
      this.HELMET = new Armor("Helmet","Viz",1);
      this.HORSE = null;
      this.setActiveSkills("dual",1,0,0);
   }
   function UnitViz_dual5()
   {
      this.NAME = "Blademaster";
      this.STR = 50;
      this.DEX = 20;
      this.CON = 25;
      this.SPR = 15;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Viz",4);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Viz",4);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Viz",5);
      this.HELMET = new Armor("Helmet","Viz",4);
      this.HORSE = null;
      this.setActiveSkills("dual",2,2,0);
   }
   function UnitViz_dagger3()
   {
      this.NAME = "Rogue";
      this.STR = 13;
      this.DEX = 32;
      this.CON = 10;
      this.SPR = 16;
      this.WEAPON_PRI = new WeaponClass("Dagger","Viz",3);
      this.primary_skill = "Dagger";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",2);
      this.secondary_skill = "Crossbow";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Viz",2);
      this.HELMET = new Armor("Helmet","Viz",2);
      this.HORSE = null;
   }
   function UnitViz_dagger6()
   {
      this.NAME = "Dark Rogue";
      this.STR = 27;
      this.DEX = 68;
      this.CON = 20;
      this.SPR = 34;
      this.WEAPON_PRI = new WeaponClass("Dagger","Viz",6);
      this.primary_skill = "Dagger";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",4);
      this.secondary_skill = "Crossbow";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Viz",4);
      this.HELMET = new Armor("Helmet","Viz",5);
      this.HORSE = null;
      this.setActiveSkills("dagger",1,3,0);
   }
   function UnitViz_bow0()
   {
      this.NAME = "Bowman";
      this.STR = 4;
      this.DEX = 15;
      this.CON = 6;
      this.SPR = 8;
      this.WEAPON_PRI = new WeaponClass("Bow","Viz",1);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 55;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Viz",1);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 45;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("bow",1,0,0);
   }
   function UnitViz_bow2()
   {
      this.NAME = "Archer Master";
      this.STR = 8;
      this.DEX = 28;
      this.CON = 11;
      this.SPR = 14;
      this.WEAPON_PRI = new WeaponClass("Bow","Viz",2);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Viz",2);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Viz",1);
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("bow",0,2,0);
   }
   function UnitViz_bow4()
   {
      this.NAME = "Chivalry Archer";
      this.STR = 15;
      this.DEX = 50;
      this.CON = 20;
      this.SPR = 25;
      this.WEAPON_PRI = new WeaponClass("Bow","Viz",3);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Viz",3);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Viz",3);
      this.HELMET = new Armor("Helmet","Viz",2);
      this.HORSE = new Horse("any",5,5,5);
      this.setActiveSkills("bow",1,2,0);
   }
   function UnitViz_bow6()
   {
      this.NAME = "Elite Archer";
      this.STR = 27;
      this.DEX = 90;
      this.CON = 36;
      this.SPR = 45;
      this.WEAPON_PRI = new WeaponClass("Bow","Viz",4);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Viz",4);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Viz",4);
      this.HELMET = new Armor("Helmet","Viz",3);
      this.HORSE = new Horse("any",20,5,4);
      this.setActiveSkills("bow",0,4,0);
   }
   function UnitViz_crossbow0()
   {
      this.NAME = "Crossbowman";
      this.STR = 9;
      this.DEX = 15;
      this.CON = 3;
      this.SPR = 6;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Viz",1);
      this.primary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 55;
      this.WEAPON_SEC = new WeaponClass("TwohandedAxe","Viz",1);
      this.secondary_skill = "Axe";
      this.SKILL[this.secondary_skill] = 45;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("crossbow",1,0,0);
   }
   function UnitViz_crossbow2()
   {
      this.NAME = "Sharpshooter";
      this.STR = 17;
      this.DEX = 28;
      this.CON = 6;
      this.SPR = 11;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Viz",2);
      this.primary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("TwohandedAxe","Viz",2);
      this.secondary_skill = "Axe";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Viz",1);
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("crossbow",0,1,0);
   }
   function UnitViz_crossbow4()
   {
      this.NAME = "Sniper";
      this.STR = 30;
      this.DEX = 50;
      this.CON = 10;
      this.SPR = 20;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Viz",3);
      this.primary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("TwohandedAxe","Viz",3);
      this.secondary_skill = "Axe";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Viz",3);
      this.HELMET = new Armor("Helmet","Viz",2);
      this.HORSE = null;
      this.setActiveSkills("crossbow",0,2,1);
   }
   function UnitViz_crossbow6()
   {
      this.NAME = "Elite Sniper";
      this.STR = 54;
      this.DEX = 90;
      this.CON = 18;
      this.SPR = 36;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Viz",4);
      this.primary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("TwohandedAxe","Viz",4);
      this.secondary_skill = "Axe";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Viz",4);
      this.HELMET = new Armor("Helmet","Viz",3);
      this.HORSE = new Horse("any",20,5,4);
      this.setActiveSkills("crossbow",1,4,0);
   }
   function UnitViz_throwing0()
   {
      this.NAME = "Fire Thrower";
      this.STR = 18;
      this.DEX = 30;
      this.CON = 12;
      this.SPR = 2;
      this.WEAPON_PRI = new WeaponClass("Throwing","Viz",1);
      this.primary_skill = "Throwing";
      this.SKILL[this.primary_skill] = 55;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Viz",1);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 45;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
   }
   function UnitViz_throwing2()
   {
      this.NAME = "Demolisher";
      this.STR = 30;
      this.DEX = 50;
      this.CON = 20;
      this.SPR = 2;
      this.WEAPON_PRI = new WeaponClass("Throwing","Viz",2);
      this.primary_skill = "Throwing";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Viz",2);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Viz",1);
      this.HELMET = null;
      this.HORSE = null;
   }
   function UnitGer_shield1()
   {
      this.NAME = "Maceman";
      this.STR = 16;
      this.DEX = 2;
      this.CON = 20;
      this.SPR = 6;
      this.WEAPON_PRI = new WeaponClass("OnehandedMace","Ger",1);
      this.primary_skill = "Mace";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = new WeaponClass("Shield","Ger",1);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 52;
      this.ARMOR = new Armor("Clothes","Ger",1);
      this.HELMET = new Armor("Helmet","Ger",1);
      this.HORSE = null;
      this.setActiveSkills("shield",1,0,0);
   }
   function UnitGer_shield2()
   {
      this.NAME = "Footman";
      this.STR = 20;
      this.DEX = 2;
      this.CON = 25;
      this.SPR = 8;
      this.WEAPON_PRI = new WeaponClass("OnehandedMace","Ger",2);
      this.primary_skill = "Mace";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("Shield","Ger",2);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Ger",2);
      this.HELMET = new Armor("Helmet","Ger",2);
      this.HORSE = null;
      this.setActiveSkills("shield",1,1,0);
   }
   function UnitGer_shield3()
   {
      this.NAME = "Heavy Maceman";
      this.STR = 26;
      this.DEX = 3;
      this.CON = 32;
      this.SPR = 10;
      this.WEAPON_PRI = new WeaponClass("OnehandedMace","Ger",3);
      this.primary_skill = "Mace";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("Shield","Ger",2);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Ger",3);
      this.HELMET = new Armor("Helmet","Ger",3);
      this.HORSE = null;
      this.setActiveSkills("shield",2,0,0);
   }
   function UnitGer_shield5()
   {
      this.NAME = "Knight";
      this.STR = 40;
      this.DEX = 5;
      this.CON = 50;
      this.SPR = 15;
      this.WEAPON_PRI = new WeaponClass("OnehandedMace","Ger",4);
      this.primary_skill = "Mace";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("Shield","Ger",3);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Ger",5);
      this.HELMET = new Armor("Helmet","Ger",5);
      this.HORSE = new Horse("white",70,7,2);
   }
   function UnitGer_shield6()
   {
      this.NAME = "Crusader";
      this.STR = 52;
      this.DEX = 6;
      this.CON = 65;
      this.SPR = 20;
      this.WEAPON_PRI = new WeaponClass("OnehandedMace","Ger",5);
      this.primary_skill = "Mace";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("Shield","Ger",4);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Ger",6);
      this.HELMET = new Armor("Helmet","Ger",6);
      this.HORSE = new Horse("black",100,15,0);
   }
   function UnitGer_2H_sword0()
   {
      this.NAME = "Light Fighter";
      this.STR = 15;
      this.DEX = 2;
      this.CON = 12;
      this.SPR = 4;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Ger",1);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 55;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
   }
   function UnitGer_2H_sword4()
   {
      this.NAME = "Paladin";
      this.STR = 44;
      this.DEX = 4;
      this.CON = 35;
      this.SPR = 13;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Ger",4);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("Crossbow","Ger",2);
      this.secondary_skill = "Crossbow";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Ger",4);
      this.HELMET = new Armor("Helmet","Ger",3);
      this.HORSE = null;
      this.setActiveSkills("2H_sword",0,3,0);
   }
   function UnitGer_2H_sword7()
   {
      this.NAME = "Serafim";
      this.STR = 85;
      this.DEX = 8;
      this.CON = 68;
      this.SPR = 26;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Ger",6);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 97;
      this.WEAPON_SEC = new WeaponClass("Crossbow","Ger",4);
      this.secondary_skill = "Crossbow";
      this.SKILL[this.secondary_skill] = 94;
      this.ARMOR = new Armor("Clothes","Ger",7);
      this.HELMET = new Armor("Helmet","Ger",7);
      this.HORSE = new Horse("white",300,5,3);
   }
   function UnitGer_2H_axe1()
   {
      this.NAME = "Monk";
      this.STR = 22;
      this.DEX = 2;
      this.CON = 22;
      this.SPR = 2;
      this.WEAPON_PRI = new WeaponClass("TwohandedMace","Ger",1);
      this.primary_skill = "Mace";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Ger",1);
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("2H_axe",2,0,0);
   }
   function UnitGer_2H_axe2()
   {
      this.NAME = "Town Guard";
      this.STR = 25;
      this.DEX = 2;
      this.CON = 25;
      this.SPR = 2;
      this.WEAPON_PRI = new WeaponClass("TwohandedMace","Ger",2);
      this.primary_skill = "Mace";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("Bow","Ger",1);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Ger",2);
      this.HELMET = new Armor("Helmet","Ger",1);
      this.HORSE = null;
      this.setActiveSkills("2H_axe",0,0,1);
   }
   function UnitGer_2H_axe6()
   {
      this.NAME = "Dark Priest";
      this.STR = 65;
      this.DEX = 6;
      this.CON = 65;
      this.SPR = 6;
      this.WEAPON_PRI = new WeaponClass("TwohandedMace","Ger",5);
      this.primary_skill = "Mace";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("Bow","Ger",3);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Ger",6);
      this.HELMET = new Armor("Helmet","Ger",6);
      this.HORSE = null;
      this.setActiveSkills("2H_axe",0,0,4);
   }
   function UnitGer_spear2()
   {
      this.NAME = "Guard Infantry";
      this.STR = 28;
      this.DEX = 6;
      this.CON = 17;
      this.SPR = 11;
      this.WEAPON_PRI = new WeaponClass("Spear","Ger",2);
      this.primary_skill = "Spear";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("Bow","Ger",1);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Ger",2);
      this.HELMET = new Armor("Helmet","Ger",2);
      this.HORSE = null;
      this.setActiveSkills("spear",0,1,0);
   }
   function UnitGer_spear3()
   {
      this.NAME = "Grey Infantry";
      this.STR = 37;
      this.DEX = 7;
      this.CON = 22;
      this.SPR = 15;
      this.WEAPON_PRI = new WeaponClass("Spear","Ger",3);
      this.primary_skill = "Spear";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("Bow","Ger",2);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Ger",3);
      this.HELMET = new Armor("Helmet","Ger",3);
      this.HORSE = null;
      this.setActiveSkills("spear",1,2,0);
   }
   function UnitGer_spear4()
   {
      this.NAME = "Elite Infantry";
      this.STR = 40;
      this.DEX = 8;
      this.CON = 24;
      this.SPR = 16;
      this.WEAPON_PRI = new WeaponClass("Spear","Ger",3);
      this.primary_skill = "Spear";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("Bow","Ger",2);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Ger",4);
      this.HELMET = new Armor("Helmet","Ger",4);
      this.HORSE = null;
      this.setActiveSkills("spear",2,0,1);
   }
   function UnitGer_spear7()
   {
      this.NAME = "Holy Rider";
      this.STR = 85;
      this.DEX = 17;
      this.CON = 51;
      this.SPR = 34;
      this.WEAPON_PRI = new WeaponClass("Spear","Ger",5);
      this.primary_skill = "Spear";
      this.SKILL[this.primary_skill] = 97;
      this.WEAPON_SEC = new WeaponClass("Bow","Ger",4);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 94;
      this.ARMOR = new Armor("Clothes","Ger",7);
      this.HELMET = new Armor("Helmet","Ger",7);
      this.HORSE = new Horse("white",200,20,0);
   }
   function UnitGer_dual4()
   {
      this.NAME = "Macemaster";
      this.STR = 18;
      this.DEX = 18;
      this.CON = 44;
      this.SPR = 18;
      this.WEAPON_PRI = new WeaponClass("OnehandedMace","Ger",4);
      this.primary_skill = "Mace";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("OnehandedMace","Ger",4);
      this.secondary_skill = "Mace";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Ger",4);
      this.HELMET = new Armor("Helmet","Ger",3);
      this.HORSE = null;
      this.setActiveSkills("dual",2,0,0);
   }
   function UnitGer_bow1()
   {
      this.NAME = "Hunter";
      this.STR = 2;
      this.DEX = 18;
      this.CON = 11;
      this.SPR = 9;
      this.WEAPON_PRI = new WeaponClass("Bow","Ger",1);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Ger",1);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 52;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("bow",0,0,1);
   }
   function UnitGer_bow3()
   {
      this.NAME = "Sr. Bowman";
      this.STR = 3;
      this.DEX = 28;
      this.CON = 17;
      this.SPR = 14;
      this.WEAPON_PRI = new WeaponClass("Bow","Ger",2);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Ger",2);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Ger",2);
      this.HELMET = new Armor("Helmet","Ger",1);
      this.HORSE = null;
      this.setActiveSkills("bow",1,0,1);
   }
   function UnitGer_crossbow2()
   {
      this.NAME = "Castle Defender";
      this.STR = 3;
      this.DEX = 28;
      this.CON = 22;
      this.SPR = 8;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Ger",2);
      this.primary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Ger",2);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Ger",1);
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("crossbow",0,0,1);
   }
   function UnitGer_crossbow4()
   {
      this.NAME = "Castle Keeper";
      this.STR = 5;
      this.DEX = 50;
      this.CON = 40;
      this.SPR = 15;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Ger",3);
      this.primary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Ger",3);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Ger",3);
      this.HELMET = new Armor("Helmet","Ger",2);
      this.HORSE = null;
      this.setActiveSkills("crossbow",2,0,1);
   }
   function UnitGer_crossbow6()
   {
      this.NAME = "Dark Shooter";
      this.STR = 9;
      this.DEX = 90;
      this.CON = 72;
      this.SPR = 27;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Ger",4);
      this.primary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Ger",4);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Ger",4);
      this.HELMET = new Armor("Helmet","Ger",3);
      this.HORSE = new Horse("black",20,15,1);
      this.setActiveSkills("crossbow",1,1,3);
   }
   function UnitGer_throwing1()
   {
      this.NAME = "Recon";
      this.STR = 4;
      this.DEX = 20;
      this.CON = 8;
      this.SPR = 12;
      this.WEAPON_PRI = new WeaponClass("Throwing","Ger",2);
      this.primary_skill = "Throwing";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Ger",1);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 52;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("throwing",1,0,0);
   }
   function UnitGer_throwing3()
   {
      this.NAME = "Master Recon";
      this.STR = 6;
      this.DEX = 28;
      this.CON = 11;
      this.SPR = 17;
      this.WEAPON_PRI = new WeaponClass("Throwing","Ger",3);
      this.primary_skill = "Throwing";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Ger",3);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Ger",2);
      this.HELMET = new Armor("Helmet","Ger",1);
      this.HORSE = null;
      this.setActiveSkills("throwing",1,1,0);
   }
   function UnitGer_throwing5()
   {
      this.NAME = "Inquisitor";
      this.STR = 10;
      this.DEX = 50;
      this.CON = 20;
      this.SPR = 30;
      this.WEAPON_PRI = new WeaponClass("Throwing","Ger",5);
      this.primary_skill = "Throwing";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Ger",4);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Ger",4);
      this.HELMET = new Armor("Helmet","Ger",3);
      this.HORSE = new Horse("black",50,5,3);
      this.setActiveSkills("throwing",0,3,1);
   }
   function UnitRus_shield2()
   {
      this.NAME = "Warrior";
      this.STR = 28;
      this.DEX = 10;
      this.CON = 10;
      this.SPR = 8;
      this.WEAPON_PRI = new WeaponClass("OnehandedAxe","Rus",2);
      this.primary_skill = "Axe";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("Shield","Rus",2);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Rus",2);
      this.HELMET = new Armor("Helmet","Rus",2);
      this.HORSE = null;
      this.setActiveSkills("shield",1,0,1);
   }
   function UnitRus_shield3()
   {
      this.NAME = "Veteran Warrior";
      this.STR = 35;
      this.DEX = 13;
      this.CON = 13;
      this.SPR = 10;
      this.WEAPON_PRI = new WeaponClass("OnehandedAxe","Rus",3);
      this.primary_skill = "Axe";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("Shield","Rus",2);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Rus",3);
      this.HELMET = new Armor("Helmet","Rus",3);
      this.HORSE = null;
      this.setActiveSkills("shield",1,0,2);
   }
   function UnitRus_shield4()
   {
      this.NAME = "Elite Warrior";
      this.STR = 48;
      this.DEX = 18;
      this.CON = 18;
      this.SPR = 13;
      this.WEAPON_PRI = new WeaponClass("OnehandedAxe","Rus",4);
      this.primary_skill = "Axe";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("Shield","Rus",3);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Rus",4);
      this.HELMET = new Armor("Helmet","Rus",4);
      this.HORSE = null;
      this.setActiveSkills("shield",1,0,3);
   }
   function UnitRus_2H_sword0()
   {
      this.NAME = "Militia Commander";
      this.STR = 16;
      this.DEX = 9;
      this.CON = 3;
      this.SPR = 2;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Rus",1);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 55;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("2H_sword",1,0,0);
   }
   function UnitRus_2H_sword7()
   {
      this.NAME = "Holy Warrior";
      this.STR = 94;
      this.DEX = 51;
      this.CON = 17;
      this.SPR = 8;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Rus",6);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 97;
      this.WEAPON_SEC = new WeaponClass("Bow","Rus",4);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 94;
      this.ARMOR = new Armor("Clothes","Rus",7);
      this.HELMET = new Armor("Helmet","Rus",7);
      this.HORSE = new Horse("white",300,10,0);
   }
   function UnitRus_2H_axe0()
   {
      this.NAME = "Militia";
      this.STR = 16;
      this.DEX = 2;
      this.CON = 9;
      this.SPR = 3;
      this.WEAPON_PRI = new WeaponClass("TwohandedAxe","Rus",1);
      this.primary_skill = "Axe";
      this.SKILL[this.primary_skill] = 55;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("2H_axe",0,1,0);
   }
   function UnitRus_2H_axe1()
   {
      this.NAME = "Village Guard";
      this.STR = 24;
      this.DEX = 2;
      this.CON = 13;
      this.SPR = 4;
      this.WEAPON_PRI = new WeaponClass("TwohandedAxe","Rus",1);
      this.primary_skill = "Axe";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Rus",1);
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("2H_axe",0,0,1);
   }
   function UnitRus_2H_axe6()
   {
      this.NAME = "Great Guard";
      this.STR = 72;
      this.DEX = 6;
      this.CON = 39;
      this.SPR = 13;
      this.WEAPON_PRI = new WeaponClass("TwohandedAxe","Rus",5);
      this.primary_skill = "Axe";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("Crossbow","Rus",3);
      this.secondary_skill = "Crossbow";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Rus",6);
      this.HELMET = new Armor("Helmet","Rus",6);
      this.HORSE = new Horse("any",250,5,1);
      this.setActiveSkills("2H_axe",0,4,0);
   }
   function UnitRus_2H_axe7()
   {
      this.NAME = "Great Hero";
      this.STR = 94;
      this.DEX = 8;
      this.CON = 51;
      this.SPR = 17;
      this.WEAPON_PRI = new WeaponClass("TwohandedAxe","Rus",6);
      this.primary_skill = "Axe";
      this.SKILL[this.primary_skill] = 97;
      this.WEAPON_SEC = new WeaponClass("Crossbow","Rus",4);
      this.secondary_skill = "Crossbow";
      this.SKILL[this.secondary_skill] = 94;
      this.ARMOR = new Armor("Clothes","Rus",7);
      this.HELMET = new Armor("Helmet","Rus",7);
      this.HORSE = new Horse("white",350,5,0);
   }
   function UnitRus_spear4()
   {
      this.NAME = "Light Rider";
      this.STR = 40;
      this.DEX = 16;
      this.CON = 24;
      this.SPR = 8;
      this.WEAPON_PRI = new WeaponClass("Spear","Rus",3);
      this.primary_skill = "Spear";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("Bow","Rus",2);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Rus",4);
      this.HELMET = new Armor("Helmet","Rus",4);
      this.HORSE = new Horse("any",20,5,4);
   }
   function UnitRus_spear5()
   {
      this.NAME = "Elite Guard";
      this.STR = 58;
      this.DEX = 23;
      this.CON = 35;
      this.SPR = 12;
      this.WEAPON_PRI = new WeaponClass("Spear","Rus",4);
      this.primary_skill = "Spear";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("Bow","Rus",3);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Rus",5);
      this.HELMET = new Armor("Helmet","Rus",5);
      this.HORSE = new Horse("any",100,7,2);
   }
   function UnitRus_dual3()
   {
      this.NAME = "Axemaster";
      this.STR = 35;
      this.DEX = 3;
      this.CON = 22;
      this.SPR = 10;
      this.WEAPON_PRI = new WeaponClass("OnehandedAxe","Rus",3);
      this.primary_skill = "Axe";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("OnehandedAxe","Rus",3);
      this.secondary_skill = "Axe";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Rus",3);
      this.HELMET = new Armor("Helmet","Rus",2);
      this.HORSE = null;
      this.setActiveSkills("dual",0,3,0);
   }
   function UnitRus_dual5()
   {
      this.NAME = "Berserker";
      this.STR = 55;
      this.DEX = 5;
      this.CON = 35;
      this.SPR = 15;
      this.WEAPON_PRI = new WeaponClass("OnehandedAxe","Rus",4);
      this.primary_skill = "Axe";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("OnehandedAxe","Rus",4);
      this.secondary_skill = "Axe";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Rus",5);
      this.HELMET = new Armor("Helmet","Rus",4);
      this.HORSE = null;
      this.setActiveSkills("dual",4,0,0);
   }
   function UnitRus_bow2()
   {
      this.NAME = "Forest Guard";
      this.STR = 14;
      this.DEX = 28;
      this.CON = 3;
      this.SPR = 17;
      this.WEAPON_PRI = new WeaponClass("Bow","Rus",2);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("TwohandedMace","Rus",2);
      this.secondary_skill = "Mace";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Rus",1);
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("bow",0,2,0);
   }
   function UnitRus_bow4()
   {
      this.NAME = "Forest Keeper";
      this.STR = 25;
      this.DEX = 50;
      this.CON = 5;
      this.SPR = 30;
      this.WEAPON_PRI = new WeaponClass("Bow","Rus",3);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("TwohandedMace","Rus",3);
      this.secondary_skill = "Mace";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Rus",3);
      this.HELMET = new Armor("Helmet","Rus",2);
      this.HORSE = null;
      this.setActiveSkills("bow",1,3,0);
   }
   function UnitRus_bow6()
   {
      this.NAME = "Elder";
      this.STR = 45;
      this.DEX = 90;
      this.CON = 9;
      this.SPR = 54;
      this.WEAPON_PRI = new WeaponClass("Bow","Rus",4);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("TwohandedMace","Rus",4);
      this.secondary_skill = "Mace";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Rus",4);
      this.HELMET = new Armor("Helmet","Rus",3);
      this.HORSE = new Horse("white",80,5,3);
      this.setActiveSkills("bow",0,4,1);
   }
   function UnitRus_crossbow1()
   {
      this.NAME = "Crossbow Master";
      this.STR = 2;
      this.DEX = 18;
      this.CON = 11;
      this.SPR = 9;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Rus",1);
      this.primary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = new WeaponClass("TwohandedMace","Rus",1);
      this.secondary_skill = "Mace";
      this.SKILL[this.secondary_skill] = 52;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("crossbow",1,0,0);
   }
   function UnitRus_throwing3()
   {
      this.NAME = "Axe Thrower";
      this.STR = 28;
      this.DEX = 6;
      this.CON = 22;
      this.SPR = 6;
      this.WEAPON_PRI = new WeaponClass("Throwing","Rus",3);
      this.primary_skill = "Throwing";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("TwohandedAxe","Rus",3);
      this.secondary_skill = "Axe";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Rus",2);
      this.HELMET = new Armor("Helmet","Rus",1);
      this.HORSE = null;
      this.setActiveSkills("throwing",0,2,0);
   }
   function UnitRus_throwing5()
   {
      this.NAME = "Elite Axe Thrower";
      this.STR = 50;
      this.DEX = 10;
      this.CON = 40;
      this.SPR = 10;
      this.WEAPON_PRI = new WeaponClass("Throwing","Rus",5);
      this.primary_skill = "Throwing";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("TwohandedAxe","Rus",4);
      this.secondary_skill = "Axe";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Rus",4);
      this.HELMET = new Armor("Helmet","Rus",3);
      this.HORSE = null;
      this.setActiveSkills("throwing",2,3,0);
   }
   function UnitJap_katana2()
   {
      this.NAME = "Ninja";
      this.STR = 21;
      this.DEX = 26;
      this.CON = 5;
      this.SPR = 13;
      this.WEAPON_PRI = new WeaponClass("Katana","Jap",2);
      this.primary_skill = "FarEast";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("Throwing","Jap",1);
      this.secondary_skill = "Throwing";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Jap",2);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
      this.setActiveSkills("katana",2,0,0);
   }
   function UnitJap_katana3()
   {
      this.NAME = "Rhonin";
      this.STR = 26;
      this.DEX = 33;
      this.CON = 7;
      this.SPR = 16;
      this.WEAPON_PRI = new WeaponClass("Katana","Jap",3);
      this.primary_skill = "FarEast";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("Throwing","Jap",2);
      this.secondary_skill = "Throwing";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Jap",3);
      this.HELMET = new Armor("Helmet","Jap",3);
      this.HORSE = null;
      this.setActiveSkills("katana",2,2,0);
   }
   function UnitJap_katana4()
   {
      this.NAME = "Rhonin Rider";
      this.STR = 34;
      this.DEX = 42;
      this.CON = 8;
      this.SPR = 21;
      this.WEAPON_PRI = new WeaponClass("Katana","Jap",4);
      this.primary_skill = "FarEast";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("Throwing","Jap",3);
      this.secondary_skill = "Throwing";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Jap",4);
      this.HELMET = new Armor("Helmet","Jap",4);
      this.HORSE = new Horse("any",150,15,4);
   }
   function UnitJap_katana5()
   {
      this.NAME = "Samurai";
      this.STR = 43;
      this.DEX = 54;
      this.CON = 11;
      this.SPR = 27;
      this.WEAPON_PRI = new WeaponClass("Katana","Jap",5);
      this.primary_skill = "FarEast";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("Throwing","Jap",4);
      this.secondary_skill = "Throwing";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Jap",5);
      this.HELMET = new Armor("Helmet","Jap",5);
      this.HORSE = null;
      this.setActiveSkills("katana",4,2,0);
   }
   function UnitJap_katana6()
   {
      this.NAME = "Black Samurai";
      this.STR = 52;
      this.DEX = 65;
      this.CON = 13;
      this.SPR = 32;
      this.WEAPON_PRI = new WeaponClass("Katana","Jap",6);
      this.primary_skill = "FarEast";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("Throwing","Jap",6);
      this.secondary_skill = "Throwing";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Jap",6);
      this.HELMET = new Armor("Helmet","Jap",6);
      this.HORSE = null;
      this.setActiveSkills("katana",4,2,1);
   }
   function UnitJap_katana7()
   {
      this.NAME = "Shogun";
      this.STR = 68;
      this.DEX = 85;
      this.CON = 17;
      this.SPR = 42;
      this.WEAPON_PRI = new WeaponClass("Katana","Jap",7);
      this.primary_skill = "FarEast";
      this.SKILL[this.primary_skill] = 97;
      this.WEAPON_SEC = new WeaponClass("Throwing","Jap",7);
      this.secondary_skill = "Throwing";
      this.SKILL[this.secondary_skill] = 94;
      this.ARMOR = new Armor("Clothes","Jap",7);
      this.HELMET = new Armor("Helmet","Jap",7);
      this.HORSE = null;
      this.setActiveSkills("katana",4,3,2);
   }
   function UnitJap_katana8()
   {
      this.NAME = "Shogun Ghost";
      this.STR = 80;
      this.DEX = 100;
      this.CON = 20;
      this.SPR = 50;
      this.WEAPON_PRI = new WeaponClass("Katana","Jap",8);
      this.primary_skill = "FarEast";
      this.SKILL[this.primary_skill] = 100;
      this.WEAPON_SEC = new WeaponClass("Throwing","Jap",7);
      this.secondary_skill = "Throwing";
      this.SKILL[this.secondary_skill] = 100;
      this.ARMOR = new Armor("Clothes","Jap",8);
      this.HELMET = new Armor("Helmet","Jap",8);
      this.HORSE = null;
      this.setActiveSkills("katana",0,0,5);
   }
   function UnitJap_dual3()
   {
      this.NAME = "Elite Ninja";
      this.STR = 29;
      this.DEX = 29;
      this.CON = 10;
      this.SPR = 13;
      this.WEAPON_PRI = new WeaponClass("NinjaTo","Jap",3);
      this.primary_skill = "FarEast";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("NinjaTo","Jap",3);
      this.secondary_skill = "FarEast";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Jap",3);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
      this.setActiveSkills("dual",2,2,0);
   }
   function UnitJap_dual4()
   {
      this.NAME = "Master Ninja";
      this.STR = 40;
      this.DEX = 40;
      this.CON = 13;
      this.SPR = 18;
      this.WEAPON_PRI = new WeaponClass("NinjaTo","Jap",4);
      this.primary_skill = "FarEast";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("NinjaTo","Jap",4);
      this.secondary_skill = "FarEast";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Jap",4);
      this.HELMET = new Armor("Helmet","Jap",3);
      this.HORSE = null;
      this.setActiveSkills("dual",2,0,3);
   }
   function UnitJap_dual5()
   {
      this.NAME = "Ninja Ghost";
      this.STR = 45;
      this.DEX = 45;
      this.CON = 15;
      this.SPR = 20;
      this.WEAPON_PRI = new WeaponClass("NinjaTo","Jap",4);
      this.primary_skill = "FarEast";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("NinjaTo","Jap",4);
      this.secondary_skill = "FarEast";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Jap",5);
      this.HELMET = new Armor("Helmet","Jap",4);
      this.HORSE = null;
      this.setActiveSkills("dual",0,4,4);
   }
   function UnitJap_staff1()
   {
      this.NAME = "Apprentice";
      this.STR = 8;
      this.DEX = 24;
      this.CON = 6;
      this.SPR = 12;
      this.WEAPON_PRI = new WeaponClass("Staff","Jap",2);
      this.primary_skill = "Staff";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Jap",1);
      this.HELMET = new Armor("Helmet","Jap",1);
      this.HORSE = null;
      this.setActiveSkills("staff",1,0,0);
   }
   function UnitJap_staff2()
   {
      this.NAME = "High Apprentice";
      this.STR = 10;
      this.DEX = 31;
      this.CON = 8;
      this.SPR = 16;
      this.WEAPON_PRI = new WeaponClass("Staff","Jap",3);
      this.primary_skill = "Staff";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Jap",2);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
      this.setActiveSkills("staff",3,0,0);
   }
   function UnitJap_staff3()
   {
      this.NAME = "Samurai Guard";
      this.STR = 13;
      this.DEX = 40;
      this.CON = 10;
      this.SPR = 20;
      this.WEAPON_PRI = new WeaponClass("Staff","Jap",4);
      this.primary_skill = "Staff";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("Bow","Jap",1);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Jap",3);
      this.HELMET = new Armor("Helmet","Jap",3);
      this.HORSE = null;
      this.setActiveSkills("staff",3,1,0);
   }
   function UnitJap_staff4()
   {
      this.NAME = "Samurai Soldier";
      this.STR = 17;
      this.DEX = 50;
      this.CON = 13;
      this.SPR = 25;
      this.WEAPON_PRI = new WeaponClass("Staff","Jap",5);
      this.primary_skill = "Staff";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("Bow","Jap",2);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Jap",4);
      this.HELMET = new Armor("Helmet","Jap",4);
      this.HORSE = null;
      this.setActiveSkills("staff",0,3,2);
   }
   function UnitJap_staff5()
   {
      this.NAME = "Shogun Guard";
      this.STR = 22;
      this.DEX = 65;
      this.CON = 16;
      this.SPR = 32;
      this.WEAPON_PRI = new WeaponClass("Staff","Jap",6);
      this.primary_skill = "Staff";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("Bow","Jap",2);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Jap",5);
      this.HELMET = new Armor("Helmet","Jap",5);
      this.HORSE = null;
      this.setActiveSkills("staff",2,4,0);
   }
   function UnitJap_staff6()
   {
      this.NAME = "Secret Elites";
      this.STR = 28;
      this.DEX = 84;
      this.CON = 21;
      this.SPR = 42;
      this.WEAPON_PRI = new WeaponClass("Staff","Jap",7);
      this.primary_skill = "Staff";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("Bow","Jap",3);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Jap",6);
      this.HELMET = new Armor("Helmet","Jap",6);
      this.HORSE = null;
      this.setActiveSkills("staff",0,4,3);
   }
   function UnitJap_bow1()
   {
      this.NAME = "Shadow Bowman";
      this.STR = 11;
      this.DEX = 18;
      this.CON = 2;
      this.SPR = 14;
      this.WEAPON_PRI = new WeaponClass("Bow","Jap",1);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = new WeaponClass("Staff","Jap",1);
      this.secondary_skill = "Staff";
      this.SKILL[this.secondary_skill] = 52;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("bow",0,1,0);
   }
   function UnitJap_bow2()
   {
      this.NAME = "Ghost Bowman";
      this.STR = 17;
      this.DEX = 28;
      this.CON = 3;
      this.SPR = 22;
      this.WEAPON_PRI = new WeaponClass("Bow","Jap",2);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("Staff","Jap",2);
      this.secondary_skill = "Staff";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Jap",1);
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("bow",1,2,0);
   }
   function UnitJap_bow3()
   {
      this.NAME = "Phantom Bowman";
      this.STR = 17;
      this.DEX = 28;
      this.CON = 3;
      this.SPR = 22;
      this.WEAPON_PRI = new WeaponClass("Bow","Jap",2);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("Staff","Jap",2);
      this.secondary_skill = "Staff";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Jap",2);
      this.HELMET = new Armor("Helmet","Jap",1);
      this.HORSE = null;
      this.setActiveSkills("bow",4,0,0);
   }
   function UnitJap_bow5()
   {
      this.NAME = "Whisper Bowman";
      this.STR = 36;
      this.DEX = 60;
      this.CON = 6;
      this.SPR = 48;
      this.WEAPON_PRI = new WeaponClass("Bow","Jap",3);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("Staff","Jap",4);
      this.secondary_skill = "Staff";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Jap",3);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
      this.setActiveSkills("bow",4,4,0);
   }
   function UnitJap_throwing0()
   {
      this.NAME = "Suriken Thrower";
      this.STR = 12;
      this.DEX = 15;
      this.CON = 2;
      this.SPR = 9;
      this.WEAPON_PRI = new WeaponClass("Throwing","Jap",1);
      this.primary_skill = "Throwing";
      this.SKILL[this.primary_skill] = 55;
      this.WEAPON_SEC = new WeaponClass("Staff","Jap",1);
      this.secondary_skill = "Staff";
      this.SKILL[this.secondary_skill] = 45;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("throwing",1,0,0);
   }
   function UnitJap_throwing1()
   {
      this.NAME = "Suriken Master";
      this.STR = 16;
      this.DEX = 20;
      this.CON = 2;
      this.SPR = 12;
      this.WEAPON_PRI = new WeaponClass("Throwing","Jap",2);
      this.primary_skill = "Throwing";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = new WeaponClass("Staff","Jap",1);
      this.secondary_skill = "Staff";
      this.SKILL[this.secondary_skill] = 52;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("throwing",0,1,0);
   }
   function UnitJap_throwing3()
   {
      this.NAME = "Elite Suriken Thrower";
      this.STR = 22;
      this.DEX = 28;
      this.CON = 3;
      this.SPR = 17;
      this.WEAPON_PRI = new WeaponClass("Throwing","Jap",3);
      this.primary_skill = "Throwing";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("Staff","Jap",3);
      this.secondary_skill = "Staff";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Jap",2);
      this.HELMET = new Armor("Helmet","Jap",1);
      this.HORSE = null;
      this.setActiveSkills("throwing",2,1,1);
   }
   function UnitJap_throwing4()
   {
      this.NAME = "Black Suriken Thrower";
      this.STR = 30;
      this.DEX = 37;
      this.CON = 4;
      this.SPR = 22;
      this.WEAPON_PRI = new WeaponClass("Throwing","Jap",4);
      this.primary_skill = "Throwing";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("Staff","Jap",4);
      this.secondary_skill = "Staff";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Jap",3);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
      this.setActiveSkills("throwing",2,3,1);
   }
   function UnitJap_throwing6()
   {
      this.NAME = "Shadow";
      this.STR = 54;
      this.DEX = 67;
      this.CON = 7;
      this.SPR = 40;
      this.WEAPON_PRI = new WeaponClass("Throwing","Jap",6);
      this.primary_skill = "Throwing";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("Staff","Jap",5);
      this.secondary_skill = "Staff";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Jap",5);
      this.HELMET = new Armor("Helmet","Jap",4);
      this.HORSE = null;
      this.setActiveSkills("throwing",0,3,4);
   }
   function UnitJap_throwing7()
   {
      this.NAME = "Golden Shadpw";
      this.STR = 68;
      this.DEX = 85;
      this.CON = 8;
      this.SPR = 51;
      this.WEAPON_PRI = new WeaponClass("Throwing","Jap",7);
      this.primary_skill = "Throwing";
      this.SKILL[this.primary_skill] = 97;
      this.WEAPON_SEC = new WeaponClass("Staff","Jap",5);
      this.secondary_skill = "Staff";
      this.SKILL[this.secondary_skill] = 94;
      this.ARMOR = new Armor("Clothes","Jap",6);
      this.HELMET = new Armor("Helmet","Jap",5);
      this.HORSE = null;
      this.setActiveSkills("throwing",0,4,5);
   }
   function UnitJap_fists1()
   {
      this.NAME = "Taekwon";
      this.STR = 20;
      this.DEX = 20;
      this.CON = 8;
      this.SPR = 2;
      this.WEAPON_PRI = null;
      this.primary_skill = "Fists";
      this.SKILL[this.primary_skill] = 100;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Jap",1);
      this.HELMET = new Armor("Helmet","Jap",1);
      this.HORSE = null;
   }
   function UnitJap_fists2()
   {
      this.NAME = "Taekwon Master";
      this.STR = 30;
      this.DEX = 30;
      this.CON = 12;
      this.SPR = 3;
      this.WEAPON_PRI = null;
      this.primary_skill = "Fists";
      this.SKILL[this.primary_skill] = 100;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Jap",2);
      this.HELMET = new Armor("Helmet","Jap",2);
      this.HORSE = null;
   }
   function UnitMon_shield1()
   {
      this.NAME = "Swordsman";
      this.STR = 20;
      this.DEX = 10;
      this.CON = 8;
      this.SPR = 12;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",1);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = new WeaponClass("Shield","Mon",1);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 52;
      this.ARMOR = new Armor("Clothes","Mon",1);
      this.HELMET = new Armor("Helmet","Mon",1);
      this.HORSE = null;
      this.setActiveSkills("shield",0,1,0);
   }
   function UnitMon_shield2()
   {
      this.NAME = "Footman Guard";
      this.STR = 25;
      this.DEX = 12;
      this.CON = 10;
      this.SPR = 15;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",2);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("Shield","Mon",2);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Mon",2);
      this.HELMET = new Armor("Helmet","Mon",2);
      this.HORSE = null;
      this.setActiveSkills("shield",0,2,0);
   }
   function UnitMon_shield3()
   {
      this.NAME = "Rider Guard";
      this.STR = 32;
      this.DEX = 16;
      this.CON = 13;
      this.SPR = 19;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",3);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("Shield","Mon",2);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Mon",3);
      this.HELMET = new Armor("Helmet","Mon",3);
      this.HORSE = new Horse("any",20,3,4);
   }
   function UnitMon_shield4()
   {
      this.NAME = "Wind Rider";
      this.STR = 44;
      this.DEX = 22;
      this.CON = 18;
      this.SPR = 26;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",4);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("Shield","Mon",3);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Mon",4);
      this.HELMET = new Armor("Helmet","Mon",4);
      this.HORSE = new Horse("any",30,4,4);
   }
   function UnitMon_shield5()
   {
      this.NAME = "Storm Rider";
      this.STR = 50;
      this.DEX = 25;
      this.CON = 20;
      this.SPR = 30;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",4);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("Shield","Mon",3);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Mon",5);
      this.HELMET = new Armor("Helmet","Mon",5);
      this.HORSE = new Horse("any",50,6,4);
   }
   function UnitMon_shield6()
   {
      this.NAME = "Hurricane Rider";
      this.STR = 65;
      this.DEX = 32;
      this.CON = 26;
      this.SPR = 39;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",5);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("Shield","Mon",4);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Mon",6);
      this.HELMET = new Armor("Helmet","Mon",6);
      this.HORSE = new Horse("any",100,8,5);
   }
   function UnitMon_shield7()
   {
      this.NAME = "Khan\'s Guard";
      this.STR = 85;
      this.DEX = 42;
      this.CON = 34;
      this.SPR = 51;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",6);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 97;
      this.WEAPON_SEC = new WeaponClass("Shield","Mon",4);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 94;
      this.ARMOR = new Armor("Clothes","Mon",7);
      this.HELMET = new Armor("Helmet","Mon",7);
      this.HORSE = new Horse("any",100,20,6);
   }
   function UnitMon_2H_sword0()
   {
      this.NAME = "Merchant Guard";
      this.STR = 15;
      this.DEX = 9;
      this.CON = 6;
      this.SPR = 8;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Mon",1);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 55;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("2H_sword",1,0,0);
   }
   function UnitMon_2H_sword2()
   {
      this.NAME = "Light Scout";
      this.STR = 25;
      this.DEX = 15;
      this.CON = 10;
      this.SPR = 12;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Mon",2);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("Bow","Mon",1);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Mon",2);
      this.HELMET = new Armor("Helmet","Mon",1);
      this.HORSE = null;
      this.setActiveSkills("2H_sword",0,2,0);
   }
   function UnitMon_2H_sword3()
   {
      this.NAME = "Scout";
      this.STR = 32;
      this.DEX = 19;
      this.CON = 13;
      this.SPR = 16;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Mon",3);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("Bow","Mon",2);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Mon",3);
      this.HELMET = new Armor("Helmet","Mon",2);
      this.HORSE = new Horse("any",10,2,5);
   }
   function UnitMon_2H_sword4()
   {
      this.NAME = "Veteran Scout";
      this.STR = 44;
      this.DEX = 26;
      this.CON = 18;
      this.SPR = 22;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Mon",4);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("Bow","Mon",2);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Mon",4);
      this.HELMET = new Armor("Helmet","Mon",3);
      this.HORSE = new Horse("any",15,5,5);
   }
   function UnitMon_2H_sword5()
   {
      this.NAME = "Horde Guard";
      this.STR = 50;
      this.DEX = 30;
      this.CON = 20;
      this.SPR = 25;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Mon",4);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("Bow","Mon",3);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Mon",5);
      this.HELMET = new Armor("Helmet","Mon",5);
      this.HORSE = new Horse("any",50,8,3);
   }
   function UnitMon_2H_sword6()
   {
      this.NAME = "Elte Rider";
      this.STR = 65;
      this.DEX = 39;
      this.CON = 26;
      this.SPR = 32;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Mon",5);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("Bow","Mon",3);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Mon",6);
      this.HELMET = new Armor("Helmet","Mon",6);
      this.HORSE = new Horse("any",120,12,4);
   }
   function UnitMon_2H_sword7()
   {
      this.NAME = "Veteran Rider";
      this.STR = 85;
      this.DEX = 51;
      this.CON = 34;
      this.SPR = 42;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Mon",6);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 97;
      this.WEAPON_SEC = new WeaponClass("Bow","Mon",4);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 94;
      this.ARMOR = new Armor("Clothes","Mon",7);
      this.HELMET = new Armor("Helmet","Mon",7);
      this.HORSE = new Horse("any",200,5,6);
   }
   function UnitMon_dual1()
   {
      this.NAME = "Skilled Nomad";
      this.STR = 20;
      this.DEX = 10;
      this.CON = 12;
      this.SPR = 8;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",1);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Mon",1);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 52;
      this.ARMOR = new Armor("Clothes","Mon",1);
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("dual",1,0,0);
   }
   function UnitMon_dual2()
   {
      this.NAME = "Fencer";
      this.STR = 25;
      this.DEX = 12;
      this.CON = 15;
      this.SPR = 10;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",2);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Mon",2);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Mon",2);
      this.HELMET = new Armor("Helmet","Mon",1);
      this.HORSE = null;
      this.setActiveSkills("dual",2,0,0);
   }
   function UnitMon_dual3()
   {
      this.NAME = "Master Fencer";
      this.STR = 32;
      this.DEX = 16;
      this.CON = 19;
      this.SPR = 13;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",3);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Mon",3);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Mon",3);
      this.HELMET = new Armor("Helmet","Mon",2);
      this.HORSE = null;
      this.setActiveSkills("dual",3,0,0);
   }
   function UnitMon_dual4()
   {
      this.NAME = "Wanderer";
      this.STR = 44;
      this.DEX = 22;
      this.CON = 26;
      this.SPR = 18;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",4);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Mon",4);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Mon",4);
      this.HELMET = new Armor("Helmet","Mon",3);
      this.HORSE = null;
      this.setActiveSkills("dual",2,0,1);
   }
   function UnitMon_dual5()
   {
      this.NAME = "Bloody Wanderer";
      this.STR = 50;
      this.DEX = 25;
      this.CON = 30;
      this.SPR = 20;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",4);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Mon",4);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Mon",5);
      this.HELMET = new Armor("Helmet","Mon",4);
      this.HORSE = null;
      this.setActiveSkills("dual",2,0,2);
   }
   function UnitMon_dual6()
   {
      this.NAME = "Swordmaster";
      this.STR = 65;
      this.DEX = 32;
      this.CON = 39;
      this.SPR = 26;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",5);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Mon",5);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Mon",6);
      this.HELMET = new Armor("Helmet","Mon",5);
      this.HORSE = null;
      this.setActiveSkills("dual",3,2,0);
   }
   function UnitMon_dual7()
   {
      this.NAME = "Dust Warrior";
      this.STR = 85;
      this.DEX = 42;
      this.CON = 51;
      this.SPR = 34;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Mon",6);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 97;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Mon",6);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 94;
      this.ARMOR = new Armor("Clothes","Mon",7);
      this.HELMET = new Armor("Helmet","Mon",6);
      this.HORSE = null;
      this.setActiveSkills("dual",3,1,2);
   }
   function UnitMon_dagger0()
   {
      this.NAME = "Poor Nomad";
      this.STR = 3;
      this.DEX = 15;
      this.CON = 6;
      this.SPR = 14;
      this.WEAPON_PRI = new WeaponClass("Dagger","Mon",1);
      this.primary_skill = "Dagger";
      this.SKILL[this.primary_skill] = 55;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("dagger",0,1,0);
   }
   function UnitMon_dagger2()
   {
      this.NAME = "Forest Rogue";
      this.STR = 4;
      this.DEX = 22;
      this.CON = 9;
      this.SPR = 20;
      this.WEAPON_PRI = new WeaponClass("Dagger","Mon",2);
      this.primary_skill = "Dagger";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("Bow","Mon",1);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Mon",2);
      this.HELMET = new Armor("Helmet","Mon",1);
      this.HORSE = null;
      this.setActiveSkills("dagger",1,1,0);
   }
   function UnitMon_dagger3()
   {
      this.NAME = "Town Rogue";
      this.STR = 6;
      this.DEX = 32;
      this.CON = 13;
      this.SPR = 29;
      this.WEAPON_PRI = new WeaponClass("Dagger","Mon",3);
      this.primary_skill = "Dagger";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("Bow","Mon",2);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Mon",2);
      this.HELMET = new Armor("Helmet","Mon",2);
      this.HORSE = null;
      this.setActiveSkills("dagger",2,0,1);
   }
   function UnitMon_dagger4()
   {
      this.NAME = "Headhunter";
      this.STR = 8;
      this.DEX = 40;
      this.CON = 16;
      this.SPR = 36;
      this.WEAPON_PRI = new WeaponClass("Dagger","Mon",4);
      this.primary_skill = "Dagger";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("Bow","Mon",2);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Mon",3);
      this.HELMET = new Armor("Helmet","Mon",3);
      this.HORSE = null;
      this.setActiveSkills("dagger",2,2,0);
   }
   function UnitMon_dagger5()
   {
      this.NAME = "Chaos Rogue";
      this.STR = 10;
      this.DEX = 50;
      this.CON = 20;
      this.SPR = 45;
      this.WEAPON_PRI = new WeaponClass("Dagger","Mon",5);
      this.primary_skill = "Dagger";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("Bow","Mon",3);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Mon",3);
      this.HELMET = new Armor("Helmet","Mon",4);
      this.HORSE = null;
      this.setActiveSkills("dagger",2,2,1);
   }
   function UnitMon_dagger6()
   {
      this.NAME = "Grimkeeper";
      this.STR = 14;
      this.DEX = 68;
      this.CON = 27;
      this.SPR = 61;
      this.WEAPON_PRI = new WeaponClass("Dagger","Mon",6);
      this.primary_skill = "Dagger";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("Bow","Mon",4);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Mon",4);
      this.HELMET = new Armor("Helmet","Mon",5);
      this.HORSE = null;
      this.setActiveSkills("dagger",2,3,2);
   }
   function UnitMon_bow0()
   {
      this.NAME = "Light Bowman";
      this.STR = 3;
      this.DEX = 15;
      this.CON = 4;
      this.SPR = 15;
      this.WEAPON_PRI = new WeaponClass("Bow","Mon",1);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 55;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Mon",1);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 45;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = new Horse("any",5,0,3);
      this.setActiveSkills("bow",2,0,1);
   }
   function UnitMon_bow2()
   {
      this.NAME = "Light Horseman";
      this.STR = 6;
      this.DEX = 28;
      this.CON = 8;
      this.SPR = 28;
      this.WEAPON_PRI = new WeaponClass("Bow","Mon",2);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Mon",2);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Mon",1);
      this.HELMET = null;
      this.HORSE = new Horse("any",10,3,3);
      this.setActiveSkills("bow",0,2,1);
   }
   function UnitMon_bow4()
   {
      this.NAME = "Master Archer";
      this.STR = 10;
      this.DEX = 50;
      this.CON = 15;
      this.SPR = 50;
      this.WEAPON_PRI = new WeaponClass("Bow","Mon",3);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Mon",3);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Mon",3);
      this.HELMET = new Armor("Helmet","Mon",2);
      this.HORSE = new Horse("any",15,5,4);
      this.setActiveSkills("bow",0,0,4);
   }
   function UnitMon_bow6()
   {
      this.NAME = "Creepy Archer";
      this.STR = 18;
      this.DEX = 90;
      this.CON = 27;
      this.SPR = 90;
      this.WEAPON_PRI = new WeaponClass("Bow","Mon",4);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Mon",4);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Mon",4);
      this.HELMET = new Armor("Helmet","Mon",3);
      this.HORSE = new Horse("any",30,10,4);
      this.setActiveSkills("bow",0,2,4);
   }
   function UnitAra_2H_sword1()
   {
      this.NAME = "Light Swordsman";
      this.STR = 22;
      this.DEX = 18;
      this.CON = 9;
      this.SPR = 7;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Ara",1);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Ara",1);
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("2H_sword",1,0,0);
   }
   function UnitAra_2H_sword2()
   {
      this.NAME = "Sr. Swordsman";
      this.STR = 25;
      this.DEX = 20;
      this.CON = 10;
      this.SPR = 8;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Ara",2);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",1);
      this.secondary_skill = "Crossbow";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Ara",2);
      this.HELMET = new Armor("Helmet","Ara",1);
      this.HORSE = null;
      this.setActiveSkills("2H_sword",2,0,0);
   }
   function UnitAra_2H_sword3()
   {
      this.NAME = "Scimitar Master";
      this.STR = 32;
      this.DEX = 26;
      this.CON = 13;
      this.SPR = 10;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Ara",3);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",2);
      this.secondary_skill = "Crossbow";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Ara",3);
      this.HELMET = new Armor("Helmet","Ara",2);
      this.HORSE = null;
      this.setActiveSkills("2H_sword",0,2,0);
   }
   function UnitAra_2H_sword4()
   {
      this.NAME = "Light Janissary";
      this.STR = 44;
      this.DEX = 35;
      this.CON = 18;
      this.SPR = 13;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Ara",4);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",2);
      this.secondary_skill = "Crossbow";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Ara",4);
      this.HELMET = new Armor("Helmet","Ara",3);
      this.HORSE = null;
      this.setActiveSkills("2H_sword",0,2,1);
   }
   function UnitAra_2H_sword5()
   {
      this.NAME = "Janissary";
      this.STR = 50;
      this.DEX = 40;
      this.CON = 20;
      this.SPR = 15;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Ara",4);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",3);
      this.secondary_skill = "Crossbow";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Ara",5);
      this.HELMET = new Armor("Helmet","Ara",5);
      this.HORSE = null;
      this.setActiveSkills("2H_sword",0,2,2);
   }
   function UnitAra_2H_sword6()
   {
      this.NAME = "Janissary Master";
      this.STR = 65;
      this.DEX = 52;
      this.CON = 26;
      this.SPR = 20;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Ara",5);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",3);
      this.secondary_skill = "Crossbow";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Ara",6);
      this.HELMET = new Armor("Helmet","Ara",6);
      this.HORSE = null;
      this.setActiveSkills("2H_sword",3,0,2);
   }
   function UnitAra_2H_sword7()
   {
      this.NAME = "Elite Janissary";
      this.STR = 85;
      this.DEX = 68;
      this.CON = 34;
      this.SPR = 26;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Ara",6);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 97;
      this.WEAPON_SEC = new WeaponClass("Crossbow","Viz",4);
      this.secondary_skill = "Crossbow";
      this.SKILL[this.secondary_skill] = 94;
      this.ARMOR = new Armor("Clothes","Ara",7);
      this.HELMET = new Armor("Helmet","Ara",7);
      this.HORSE = null;
      this.setActiveSkills("2H_sword",0,4,3);
   }
   function UnitAra_dual0()
   {
      this.NAME = "Slave";
      this.STR = 15;
      this.DEX = 10;
      this.CON = 8;
      this.SPR = 4;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Ara",1);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 55;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Ara",1);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 45;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("dual",0,1,0);
   }
   function UnitAra_dual2()
   {
      this.NAME = "Sailor";
      this.STR = 25;
      this.DEX = 18;
      this.CON = 12;
      this.SPR = 8;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Ara",2);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Ara",2);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Ara",2);
      this.HELMET = new Armor("Helmet","Ara",1);
      this.HORSE = null;
      this.setActiveSkills("dual",2,0,0);
   }
   function UnitAra_dual3()
   {
      this.NAME = "Pirate";
      this.STR = 32;
      this.DEX = 22;
      this.CON = 16;
      this.SPR = 10;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Ara",3);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Ara",3);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Ara",3);
      this.HELMET = new Armor("Helmet","Ara",2);
      this.HORSE = null;
      this.setActiveSkills("dual",2,1,0);
   }
   function UnitAra_dual4()
   {
      this.NAME = "Sea Dog";
      this.STR = 44;
      this.DEX = 31;
      this.CON = 22;
      this.SPR = 13;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Ara",4);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Ara",4);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Ara",4);
      this.HELMET = new Armor("Helmet","Ara",3);
      this.HORSE = null;
      this.setActiveSkills("dual",2,0,1);
   }
   function UnitAra_dual5()
   {
      this.NAME = "Corsair";
      this.STR = 50;
      this.DEX = 35;
      this.CON = 25;
      this.SPR = 15;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Ara",4);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Ara",4);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Ara",5);
      this.HELMET = new Armor("Helmet","Ara",4);
      this.HORSE = null;
      this.setActiveSkills("dual",3,0,2);
   }
   function UnitAra_dual6()
   {
      this.NAME = "Captain";
      this.STR = 65;
      this.DEX = 46;
      this.CON = 32;
      this.SPR = 20;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Ara",5);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Ara",5);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Ara",6);
      this.HELMET = new Armor("Helmet","Ara",5);
      this.HORSE = null;
      this.setActiveSkills("dual",3,0,3);
   }
   function UnitAra_dual7()
   {
      this.NAME = "Pirate Captain";
      this.STR = 85;
      this.DEX = 59;
      this.CON = 42;
      this.SPR = 26;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Ara",6);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 97;
      this.WEAPON_SEC = new WeaponClass("OnehandedSword","Ara",6);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 94;
      this.ARMOR = new Armor("Clothes","Ara",7);
      this.HELMET = new Armor("Helmet","Ara",6);
      this.HORSE = null;
      this.setActiveSkills("dual",4,3,0);
   }
   function UnitAra_katar1()
   {
      this.NAME = "Theif";
      this.STR = 18;
      this.DEX = 18;
      this.CON = 8;
      this.SPR = 6;
      this.WEAPON_PRI = new WeaponClass("Katar","Ara",1);
      this.primary_skill = "Katar";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Ara",1);
      this.HELMET = new Armor("Helmet","Ara",1);
      this.HORSE = null;
      this.setActiveSkills("katar",1,0,0);
   }
   function UnitAra_katar3()
   {
      this.NAME = "Assassin";
      this.STR = 29;
      this.DEX = 29;
      this.CON = 13;
      this.SPR = 10;
      this.WEAPON_PRI = new WeaponClass("Katar","Ara",3);
      this.primary_skill = "Katar";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Ara",3);
      this.HELMET = new Armor("Helmet","Ara",3);
      this.HORSE = null;
      this.setActiveSkills("katar",1,2,0);
   }
   function UnitAra_katar4()
   {
      this.NAME = "Shadow Assassin";
      this.STR = 40;
      this.DEX = 40;
      this.CON = 18;
      this.SPR = 13;
      this.WEAPON_PRI = new WeaponClass("Katar","Ara",4);
      this.primary_skill = "Katar";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Ara",4);
      this.HELMET = new Armor("Helmet","Ara",4);
      this.HORSE = null;
      this.setActiveSkills("katar",0,3,0);
   }
   function UnitAra_katar5()
   {
      this.NAME = "Master Assassin";
      this.STR = 45;
      this.DEX = 45;
      this.CON = 20;
      this.SPR = 15;
      this.WEAPON_PRI = new WeaponClass("Katar","Ara",4);
      this.primary_skill = "Katar";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Ara",5);
      this.HELMET = new Armor("Helmet","Ara",5);
      this.HORSE = null;
      this.setActiveSkills("katar",0,3,1);
   }
   function UnitAra_katar6()
   {
      this.NAME = "Ghost Assassin";
      this.STR = 58;
      this.DEX = 58;
      this.CON = 26;
      this.SPR = 20;
      this.WEAPON_PRI = new WeaponClass("Katar","Ara",5);
      this.primary_skill = "Katar";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Ara",6);
      this.HELMET = new Armor("Helmet","Ara",6);
      this.HORSE = null;
      this.setActiveSkills("katar",2,3,1);
   }
   function UnitAra_katar7()
   {
      this.NAME = "Elite Assassin";
      this.STR = 81;
      this.DEX = 81;
      this.CON = 36;
      this.SPR = 27;
      this.WEAPON_PRI = new WeaponClass("Katar","Ara",6);
      this.primary_skill = "Katar";
      this.SKILL[this.primary_skill] = 97;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Ara",7);
      this.HELMET = new Armor("Helmet","Ara",7);
      this.HORSE = null;
      this.setActiveSkills("katar",0,4,3);
   }
   function UnitAra_crossbow0()
   {
      this.NAME = "Light Archer";
      this.STR = 9;
      this.DEX = 15;
      this.CON = 8;
      this.SPR = 6;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Viz",1);
      this.primary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 55;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Ara",1);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 45;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("crossbow",0,0,1);
   }
   function UnitAra_crossbow2()
   {
      this.NAME = "Siege Archer";
      this.STR = 17;
      this.DEX = 28;
      this.CON = 14;
      this.SPR = 11;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Viz",2);
      this.primary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Ara",2);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Ara",1);
      this.HELMET = null;
      this.HORSE = null;
      this.setActiveSkills("crossbow",0,0,2);
   }
   function UnitAra_crossbow4()
   {
      this.NAME = "Castle Guard";
      this.STR = 30;
      this.DEX = 50;
      this.CON = 25;
      this.SPR = 20;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Viz",3);
      this.primary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Ara",3);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Ara",3);
      this.HELMET = new Armor("Helmet","Ara",2);
      this.HORSE = null;
      this.setActiveSkills("crossbow",3,0,0);
   }
   function UnitAra_crossbow6()
   {
      this.NAME = "Stalker";
      this.STR = 54;
      this.DEX = 90;
      this.CON = 45;
      this.SPR = 36;
      this.WEAPON_PRI = new WeaponClass("Crossbow","Viz",4);
      this.primary_skill = "Crossbow";
      this.SKILL[this.primary_skill] = 91;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Ara",4);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 87;
      this.ARMOR = new Armor("Clothes","Ara",4);
      this.HELMET = new Armor("Helmet","Ara",3);
      this.HORSE = null;
      this.setActiveSkills("crossbow",2,0,2);
   }
   function UnitViz_caster1()
   {
      this.NAME = "Protector";
      this.STR = 32;
      this.DEX = 10;
      this.CON = 19;
      this.SPR = 10;
      this.WEAPON_PRI = new WeaponClass("OnehandedSword","Viz",3);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 73;
      this.WEAPON_SEC = new WeaponClass("Shield","Viz",2);
      this.secondary_skill = "Shield";
      this.SKILL[this.secondary_skill] = 66;
      this.ARMOR = new Armor("Clothes","Viz",3);
      this.HELMET = new Armor("Helmet","Viz",3);
      this.HORSE = null;
      this.AURA_SKILLS.push(["Barrier",3]);
      this.SPR = 30;
   }
   function UnitViz_caster2()
   {
      this.NAME = "Healer";
      this.STR = 50;
      this.DEX = 15;
      this.CON = 25;
      this.SPR = 20;
      this.WEAPON_PRI = new WeaponClass("TwohandedAxe","Viz",4);
      this.primary_skill = "Axe";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("Bow","Viz",3);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Viz",5);
      this.HELMET = new Armor("Helmet","Viz",5);
      this.HORSE = null;
      this.AURA_SKILLS.push(["DivineHelp",4]);
      this.SPR = 60;
   }
   function UnitGer_caster1()
   {
      this.NAME = "Acolyte";
      this.STR = 22;
      this.DEX = 2;
      this.CON = 22;
      this.SPR = 2;
      this.WEAPON_PRI = new WeaponClass("TwohandedMace","Ger",1);
      this.primary_skill = "Mace";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Ger",1);
      this.HELMET = null;
      this.HORSE = null;
      this.AURA_SKILLS.push(["DivineHelp",3]);
      this.SPR = 30;
   }
   function UnitGer_caster2()
   {
      this.NAME = "Priest";
      this.STR = 22;
      this.DEX = 2;
      this.CON = 22;
      this.SPR = 2;
      this.WEAPON_PRI = new WeaponClass("TwohandedMace","Ger",1);
      this.primary_skill = "Mace";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Ger",1);
      this.HELMET = null;
      this.HORSE = null;
      this.AURA_SKILLS.push(["Devotion",3]);
      this.SPR = 60;
   }
   function UnitRus_caster1()
   {
      this.NAME = "Dryad";
      this.STR = 24;
      this.DEX = 13;
      this.CON = 4;
      this.SPR = 2;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Rus",1);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Rus",1);
      this.HELMET = null;
      this.HORSE = null;
      this.AURA_SKILLS.push(["HolyTribunal",3]);
      this.SPR = 30;
   }
   function UnitRus_caster2()
   {
      this.NAME = "Forest Soul";
      this.STR = 58;
      this.DEX = 23;
      this.CON = 35;
      this.SPR = 12;
      this.WEAPON_PRI = new WeaponClass("Spear","Rus",4);
      this.primary_skill = "Spear";
      this.SKILL[this.primary_skill] = 85;
      this.WEAPON_SEC = new WeaponClass("Bow","Rus",3);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Rus",5);
      this.HELMET = new Armor("Helmet","Rus",5);
      this.HORSE = null;
      this.AURA_SKILLS.push(["DivineHelp",3]);
      this.SPR = 60;
   }
   function UnitJap_caster1()
   {
      this.NAME = "White Monk";
      this.STR = 8;
      this.DEX = 24;
      this.CON = 6;
      this.SPR = 12;
      this.WEAPON_PRI = new WeaponClass("Staff","Jap",2);
      this.primary_skill = "Staff";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = new Armor("Clothes","Jap",1);
      this.HELMET = new Armor("Helmet","Jap",1);
      this.HORSE = null;
      this.AURA_SKILLS.push(["Barrier",4]);
      this.SPR = 30;
   }
   function UnitJap_caster2()
   {
      this.NAME = "Mentor";
      this.STR = 17;
      this.DEX = 50;
      this.CON = 13;
      this.SPR = 25;
      this.WEAPON_PRI = new WeaponClass("Staff","Jap",5);
      this.primary_skill = "Staff";
      this.SKILL[this.primary_skill] = 79;
      this.WEAPON_SEC = new WeaponClass("Bow","Jap",2);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 73;
      this.ARMOR = new Armor("Clothes","Jap",4);
      this.HELMET = new Armor("Helmet","Jap",4);
      this.HORSE = null;
      this.AURA_SKILLS.push(["NationJap",3]);
      this.SPR = 60;
   }
   function UnitMon_caster1()
   {
      this.NAME = "Shaman";
      this.STR = 4;
      this.DEX = 18;
      this.CON = 5;
      this.SPR = 18;
      this.WEAPON_PRI = new WeaponClass("Bow","Mon",1);
      this.primary_skill = "Bow";
      this.SKILL[this.primary_skill] = 61;
      this.WEAPON_SEC = new WeaponClass("TwohandedSword","Mon",1);
      this.secondary_skill = "Sword";
      this.SKILL[this.secondary_skill] = 52;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.AURA_SKILLS.push(["Devotion",3]);
      this.SPR = 30;
   }
   function UnitMon_caster2()
   {
      this.NAME = "Sage";
      this.STR = 4;
      this.DEX = 22;
      this.CON = 9;
      this.SPR = 20;
      this.WEAPON_PRI = new WeaponClass("Dagger","Mon",2);
      this.primary_skill = "Dagger";
      this.SKILL[this.primary_skill] = 67;
      this.WEAPON_SEC = new WeaponClass("Bow","Mon",1);
      this.secondary_skill = "Bow";
      this.SKILL[this.secondary_skill] = 59;
      this.ARMOR = new Armor("Clothes","Mon",2);
      this.HELMET = new Armor("Helmet","Mon",1);
      this.HORSE = null;
      this.AURA_SKILLS.push(["ForceBalance",3]);
      this.SPR = 60;
   }
   function UnitAra_caster1()
   {
      this.NAME = "Mullah";
      this.STR = 15;
      this.DEX = 6;
      this.CON = 15;
      this.SPR = 2;
      this.WEAPON_PRI = null;
      this.primary_skill = "Fists";
      this.SKILL[this.primary_skill] = 100;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.AURA_SKILLS.push(["Devotion",3]);
      this.SPR = 30;
   }
   function UnitAra_caster2()
   {
      this.NAME = "Virgin";
      this.STR = 15;
      this.DEX = 12;
      this.CON = 6;
      this.SPR = 4;
      this.WEAPON_PRI = new WeaponClass("TwohandedSword","Ara",1);
      this.primary_skill = "Sword";
      this.SKILL[this.primary_skill] = 55;
      this.WEAPON_SEC = null;
      this.secondary_skill = "Fists";
      this.SKILL[this.secondary_skill] = 80;
      this.ARMOR = null;
      this.HELMET = null;
      this.HORSE = null;
      this.AURA_SKILLS.push(["BansheeCry",2]);
      this.SPR = 60;
      this.GENDER = "f";
   }
   static function getMeleeRogue(lv)
   {
      var _loc6_ = ["shield","2H_sword","2H_axe","staff","dagger","dual"];
      var _loc2_ = new Unit("Rog",_loc6_[_root.dice(5)],Math.floor(lv / 10));
      _loc2_.NAME = "Rogue (" + _loc2_.TYPE + ")";
      _loc2_.STR = 16 + lv;
      _loc2_.DEX = 5 + Math.floor(lv / 2);
      _loc2_.CON = 10 + Math.floor(lv / 2);
      _loc2_.SPR = 1;
      var _loc4_;
      var _loc5_;
      switch(_loc2_.TYPE)
      {
         case "dual":
            _loc4_ = ["OnehandedSword","OnehandedAxe","OnehandedMace","NinjaTo"];
            _loc2_.WEAPON_PRI = new WeaponClass(_loc4_[_root.dice(4)],"Rog",_root.d(2));
            _loc2_.WEAPON_SEC = new WeaponClass(_loc4_[_root.dice(4)],"Rog",_root.d(2));
            break;
         case "shield":
            _loc5_ = ["Viz","Ger","Rus"];
            _loc4_ = ["OnehandedSword","OnehandedAxe","OnehandedMace"];
            _loc2_.WEAPON_PRI = new WeaponClass(_loc4_[_root.dice(3)],"Rog",_root.d(2));
            _loc2_.WEAPON_SEC = new WeaponClass("Shield",_loc5_[_root.dice(3)],1);
            break;
         case "2H_sword":
            _loc4_ = ["TwohandedSword","Katana"];
            _loc2_.WEAPON_PRI = new WeaponClass("TwohandedSword","Rog",_root.d(2));
            _loc2_.WEAPON_SEC = null;
            break;
         case "2H_axe":
            _loc4_ = ["TwohandedAxe","TwohandedMace"];
            _loc2_.WEAPON_PRI = new WeaponClass(_loc4_[_root.dice(2)],"Rog",_root.d(2));
            _loc2_.WEAPON_SEC = null;
            break;
         case "staff":
            _loc2_.WEAPON_PRI = new WeaponClass("Staff","Jap",1);
            _loc2_.WEAPON_SEC = null;
            break;
         case "dagger":
            _loc5_ = ["Viz","Mon"];
            _loc2_.WEAPON_PRI = new WeaponClass("Dagger",_loc5_[_root.dice(2)],1);
            _loc2_.WEAPON_SEC = null;
      }
      _loc2_.ARMOR = lv <= 8 ? null : new Armor("Clothes",_loc2_.NATION,Math.floor(lv / 8));
      _loc2_.HELMET = lv <= 8 ? null : new Armor("Helmet",_loc2_.NATION,Math.floor(lv / 8));
      _loc2_.primary_skill = _loc2_.WEAPON_PRI.skill;
      _loc2_.secondary_skill = "none";
      _loc2_.SKILL[_loc2_.primary_skill] = 40 + lv;
      _loc2_.price = 10 * lv;
      return _loc2_;
   }
   static function getRangedRogue(lv)
   {
      var _loc5_ = ["bow","crossbow","throwing"];
      var _loc2_ = new Unit("Rog",_loc5_[_root.dice(3)],Math.floor(lv / 10));
      _loc2_.NAME = "Rogue (" + _loc2_.TYPE + ")";
      _loc2_.STR = 10 + Math.floor(lv / 2);
      _loc2_.DEX = 15 + lv;
      _loc2_.CON = 5 + Math.floor(lv / 2);
      _loc2_.SPR = 1;
      var _loc4_;
      switch(_loc2_.TYPE)
      {
         case "bow":
            _loc4_ = ["Viz","Ger","Rus","Jap","Mon"];
            _loc2_.WEAPON_PRI = new WeaponClass("Bow",_loc4_[_root.dice(5)],1);
            break;
         case "crossbow":
            _loc4_ = ["Viz","Ger","Rus"];
            _loc2_.WEAPON_PRI = new WeaponClass("Crossbow",_loc4_[_root.dice(3)],1);
            break;
         case "throwing":
            _loc4_ = ["Ger","Rus"];
            _loc2_.WEAPON_PRI = new WeaponClass("Throwing",_loc4_[_root.dice(2)],1);
      }
      _loc2_.WEAPON_SEC = null;
      _loc2_.ARMOR = lv <= 10 ? null : new Armor("Clothes",_loc2_.NATION,Math.floor(lv / 10));
      _loc2_.HELMET = lv <= 10 ? null : new Armor("Helmet",_loc2_.NATION,Math.floor(lv / 10));
      _loc2_.primary_skill = _loc2_.WEAPON_PRI.skill;
      _loc2_.secondary_skill = "none";
      _loc2_.SKILL[_loc2_.primary_skill] = 40 + lv;
      _loc2_.price = 10 * lv;
      return _loc2_;
   }
   static function getMeleeMilitia(nation, sub_lv)
   {
      if(!sub_lv)
      {
         sub_lv = 0;
      }
      if(sub_lv < 0 || sub_lv > 7)
      {
         trace("Inacceptable militia level:" + sub_lv);
      }
      switch(nation)
      {
         case "Viz":
            switch(sub_lv)
            {
               case 0:
                  return new Unit(nation,"shield",sub_lv);
               case 1:
                  return new Unit(nation,"spear",sub_lv);
               case 2:
                  return new Unit(nation,"2H_axe",sub_lv);
               case 3:
                  return new Unit(nation,"spear",sub_lv);
               case 4:
                  return new Unit(nation,"shield",sub_lv);
               case 5:
                  return new Unit(nation,"2H_sword",sub_lv);
               case 6:
                  return new Unit(nation,"2H_sword",sub_lv);
               case 7:
                  return new Unit(nation,"shield",sub_lv);
            }
            break;
         case "Ger":
            switch(sub_lv)
            {
               case 0:
                  return new Unit(nation,"2H_sword",sub_lv);
               case 1:
                  return new Unit(nation,"shield",sub_lv);
               case 2:
                  return new Unit(nation,"shield",sub_lv);
               case 3:
                  return new Unit(nation,"shield",sub_lv);
               case 4:
                  return new Unit(nation,"2H_sword",sub_lv);
               case 5:
                  return new Unit(nation,"shield",sub_lv);
               case 6:
                  return new Unit(nation,"2H_axe",sub_lv);
               case 7:
                  return new Unit(nation,"2H_sword",sub_lv);
            }
            break;
         case "Rus":
            switch(sub_lv)
            {
               case 0:
                  return new Unit(nation,"2H_axe",sub_lv);
               case 1:
                  return new Unit(nation,"2H_axe",sub_lv);
               case 2:
                  return new Unit(nation,"shield",sub_lv);
               case 3:
                  return new Unit(nation,"shield",sub_lv);
               case 4:
                  return new Unit(nation,"shield",sub_lv);
               case 5:
                  return new Unit(nation,"dual",sub_lv);
               case 6:
                  return new Unit(nation,"2H_axe",sub_lv);
               case 7:
                  return new Unit(nation,"2H_axe",sub_lv);
            }
            break;
         case "Jap":
            switch(sub_lv)
            {
               case 0:
                  return new Unit(nation,"fists",sub_lv + 1);
               case 1:
                  return new Unit(nation,"staff",sub_lv);
               case 2:
                  return new Unit(nation,"staff",sub_lv);
               case 3:
                  return new Unit(nation,"staff",sub_lv);
               case 4:
                  return new Unit(nation,"staff",sub_lv);
               case 5:
                  return new Unit(nation,"staff",sub_lv);
               case 6:
                  return new Unit(nation,"staff",sub_lv);
               case 7:
                  return new Unit(nation,"katana",sub_lv);
            }
            break;
         case "Mon":
            switch(sub_lv)
            {
               case 0:
                  return new Unit(nation,"dagger",sub_lv);
               case 1:
                  return new Unit(nation,"shield",sub_lv);
               case 2:
                  return new Unit(nation,"2H_sword",sub_lv);
               case 3:
                  return new Unit(nation,"dual",sub_lv);
               case 4:
                  return new Unit(nation,"shield",sub_lv);
               case 5:
                  return new Unit(nation,"2H_sword",sub_lv);
               case 6:
                  return new Unit(nation,"dual",sub_lv);
               case 7:
                  return new Unit(nation,"2H_sword",sub_lv);
            }
            break;
         case "Ara":
            switch(sub_lv)
            {
               case 0:
                  return new Unit(nation,"dual",sub_lv);
               case 1:
                  return new Unit(nation,"2H_sword",sub_lv);
               case 2:
                  return new Unit(nation,"dual",sub_lv);
               case 3:
                  return new Unit(nation,"katar",sub_lv);
               case 4:
                  return new Unit(nation,"katar",sub_lv);
               case 5:
                  return new Unit(nation,"2H_sword",sub_lv);
               case 6:
                  return new Unit(nation,"katar",sub_lv);
               case 7:
                  return new Unit(nation,"katar",sub_lv);
            }
         default:
            return;
      }
   }
   static function getRangedMilitia(nation, sub_lv)
   {
      if(!sub_lv)
      {
         sub_lv = 0;
      }
      if(sub_lv < 0 || sub_lv > 7)
      {
         trace("Inacceptable militia level:" + sub_lv);
      }
      switch(nation)
      {
         case "Viz":
            switch(sub_lv)
            {
               case 0:
                  return new Unit(nation,"bow",sub_lv);
               case 1:
                  return new Unit(nation,"crossbow",sub_lv - 1);
               case 2:
                  return new Unit(nation,"bow",sub_lv);
               case 3:
                  return new Unit(nation,"crossbow",sub_lv - 1);
               case 4:
                  return new Unit(nation,"bow",sub_lv);
               case 5:
                  return new Unit(nation,"crossbow",sub_lv - 1);
               case 6:
                  return new Unit(nation,"throwing",0);
               case 7:
                  return new Unit(nation,"throwing",2);
            }
            break;
         case "Ger":
            switch(sub_lv)
            {
               case 0:
                  return new Unit(nation,"bow",sub_lv + 1);
               case 1:
                  return new Unit(nation,"throwing",sub_lv);
               case 2:
                  return new Unit(nation,"crossbow",sub_lv);
               case 3:
                  return new Unit(nation,"bow",sub_lv);
               case 4:
                  return new Unit(nation,"crossbow",sub_lv);
               case 5:
                  return new Unit(nation,"throwing",sub_lv);
               case 6:
                  return new Unit(nation,"crossbow",sub_lv);
               case 7:
                  return new Unit(nation,"crossbow",sub_lv - 1);
            }
            break;
         case "Rus":
            switch(sub_lv)
            {
               case 0:
                  return new Unit(nation,"crossbow",sub_lv + 1);
               case 1:
                  return new Unit(nation,"crossbow",sub_lv);
               case 2:
                  return new Unit(nation,"bow",sub_lv);
               case 3:
                  return new Unit(nation,"throwing",sub_lv);
               case 4:
                  return new Unit(nation,"bow",sub_lv);
               case 5:
                  return new Unit(nation,"throwing",sub_lv);
               case 6:
                  return new Unit(nation,"bow",sub_lv);
               case 7:
                  return new Unit(nation,"bow",sub_lv - 1);
            }
            break;
         case "Jap":
            switch(sub_lv)
            {
               case 0:
                  return new Unit(nation,"throwing",sub_lv + 1);
               case 1:
                  return new Unit(nation,"bow",sub_lv);
               case 2:
                  return new Unit(nation,"bow",sub_lv);
               case 3:
                  return new Unit(nation,"bow",sub_lv);
               case 4:
                  return new Unit(nation,"throwing",sub_lv);
               case 5:
                  return new Unit(nation,"bow",sub_lv);
               case 6:
                  return new Unit(nation,"throwing",sub_lv);
               case 7:
                  return new Unit(nation,"throwing",sub_lv);
            }
            break;
         case "Mon":
            switch(sub_lv)
            {
               case 0:
                  return new Unit(nation,"bow",sub_lv);
               case 1:
                  return new Unit(nation,"bow",sub_lv - 1);
               case 2:
                  return new Unit(nation,"bow",sub_lv);
               case 3:
                  return new Unit(nation,"bow",sub_lv - 1);
               case 4:
                  return new Unit(nation,"bow",sub_lv);
               case 5:
                  return new Unit(nation,"bow",sub_lv - 1);
               case 6:
                  return new Unit(nation,"bow",sub_lv);
               case 7:
                  return new Unit(nation,"bow",sub_lv - 1);
            }
            break;
         case "Ara":
            switch(sub_lv)
            {
               case 0:
                  return new Unit(nation,"crossbow",sub_lv);
               case 1:
                  return new Unit(nation,"crossbow",sub_lv - 1);
               case 2:
                  return new Unit(nation,"crossbow",sub_lv);
               case 3:
                  return new Unit(nation,"crossbow",sub_lv - 1);
               case 4:
                  return new Unit(nation,"crossbow",sub_lv);
               case 5:
                  return new Unit(nation,"crossbow",sub_lv - 1);
               case 6:
                  return new Unit(nation,"crossbow",sub_lv);
               case 7:
                  return new Unit(nation,"crossbow",sub_lv - 1);
            }
         default:
            return;
      }
   }
}
