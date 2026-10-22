class Quest extends Object
{
   var cities;
   var curr_city;
   var curr_gold;
   var deliver_to;
   var enemies_amount;
   var rewards;
   var avatar_id = -1;
   function Quest()
   {
      super();
      this.cities = new Array();
      this.rewards = new Array();
   }
   function initQuestBattle(city_id)
   {
      this.removeDeliverNote();
      this.deliver_to = "";
      this.avatar_id = this.getQuestAvatarID(city_id);
      this.curr_city = city_id;
      this.enemies_amount = _root.d(_global.MAIN_HERO.LEVEL + 5);
      this.curr_gold = _root.d(this.enemies_amount) * 1000 * Math.ceil(_global.MAIN_HERO.LEVEL / 10);
      if(this.enemies_amount > 20)
      {
         this.enemies_amount = 20;
      }
   }
   function initQuestFedEx(city_id, nation_id)
   {
      this.removeDeliverNote();
      while((this.deliver_to = this.getCityID(nation_id)) == city_id)
      {
      }
      this.avatar_id = -1;
      this.curr_city = city_id;
      this.enemies_amount = 0;
      this.curr_gold = 500 + 100 * _root.d(10);
   }
   function anyOf(arr)
   {
      return arr[_root.dice(arr.length)];
   }
   function aproveDeliver()
   {
      this.cities.push(this.deliver_to);
      this.rewards.push(this.curr_gold);
   }
   function removeDeliverNote()
   {
      var _loc2_ = 0;
      while(_loc2_ < this.cities.length)
      {
         if(this.cities[_loc2_] == this.deliver_to)
         {
            this.rewards.splice(_loc2_,1);
            this.cities.splice(_loc2_,1);
            break;
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function getCityID(nation_id)
   {
      switch(nation_id)
      {
         case "Viz":
            return this.anyOf(["Caesarea","Veii","Palmyra","Tyrus","Artaxata","Seleucia","Treveri","Curia"]);
         case "Ger":
            return this.anyOf(["Grobben","Torburg","Dortmund","Odense","Holmgard","Skara","Lunde","Risby"]);
         case "Rus":
            return this.anyOf(["RaGorod","Zlatograd","Dobrov","Grouzeno","Krasnodolye","Svetlolesye","Staroe","Elki"]);
         case "Jap":
            return this.anyOf(["Nagoya","Izumo","Matsuyama","Omi","Echigo","Sapporo","Suo","Nara"]);
         case "Mon":
            return this.anyOf(["Cardiff","Armagh","Kells","Iona","Tara","Swansea","Llanelli","Neath"]);
         case "Ara":
            return this.anyOf(["Tiflis","Medina","Mosul","Samarra","Mahdia","Shiraz","Rabat","Aden"]);
         default:
            return;
      }
   }
   function getQuestAvatarID(city_id)
   {
      switch(city_id)
      {
         case "Caesarea":
         case "Palmyra":
         case "Curia":
         case "Treveri":
            return this.anyOf([0,1,2]);
         case "Veii":
            return 3;
         case "Tyrus":
         case "Artaxata":
         case "Seleucia":
            return this.anyOf([4,5,6]);
         case "Grobben":
         case "Odense":
            return this.anyOf([9,12,13]);
         case "Torburg":
         case "Dortmund":
         case "Holmgard":
         case "Skara":
         case "Lunde":
         case "Risby":
            return this.anyOf([7,8,9,10,11]);
         case "RaGorod":
         case "Zlatograd":
         case "Dobrov":
         case "Grouzeno":
         case "Krasnodolye":
         case "Elki":
            return this.anyOf([14,15,16,17,18]);
         case "Svetlolesye":
         case "Staroe":
            return 19;
         case "Nagoya":
         case "Izumo":
         case "Omi":
            return 20;
         case "Matsuyama":
         case "Suo":
         case "Nara":
            return 21;
         case "Echigo":
            return 22;
         case "Sapporo":
            return 23;
         case "Kells":
         case "Neath":
         case "Swansea":
            return this.anyOf([24,25]);
         case "Cardiff":
         case "Iona":
         case "Tara":
            return this.anyOf([26,27]);
         case "Armagh":
            return 23;
         case "Llanelli":
            return 28;
         case "Tiflis":
         case "Rabat":
         case "Aden":
         case "Mahdia":
            return this.anyOf([29,30,31,32]);
         case "Medina":
         case "Samarra":
            return 33;
         case "Mosul":
         case "Shiraz":
            return 22;
         default:
            return;
      }
   }
   function prepareBattle()
   {
      delete _global.ENEMIES;
      _global.ENEMIES = new Array();
      var _loc3_ = 0;
      while(_loc3_ < this.enemies_amount)
      {
         _global.ENEMIES.push(this["get" + (Math.floor(_loc3_ / 5) % 2 != 0 ? "Ranged" : "Melee") + "Unit"]());
         _loc3_ = _loc3_ + 1;
      }
      this.cities.push(this.curr_city);
      this.rewards.push(this.curr_gold);
      this.avatar_id = -1;
   }
   function getMeleeUnit()
   {
      var _loc3_ = new Unit("Rog",null,0);
      _loc3_.NAME = "Quest Melee Rogue";
      _loc3_.LEVEL = 1 + Math.round(_global.MAIN_HERO.LEVEL / 5);
      var _loc4_ = Math.max(Math.max(_global.MAIN_HERO.STR,_global.MAIN_HERO.DEX),Math.max(_global.MAIN_HERO.CON,_global.MAIN_HERO.SPR));
      _loc3_.SPR = 5;
      switch(_loc3_.NATION)
      {
         case "Viz":
            _loc3_.STR = _root.d(_loc4_);
            _loc3_.DEX = _root.d(_loc4_ / 3);
            _loc3_.CON = _root.d(_loc4_ / 2);
            _loc3_.WEAPON_PRI = new WeaponClass("TwohandedSword","Viz",Math.ceil(_global.MAIN_HERO.LEVEL / 10));
            _loc3_.WEAPON_SEC = null;
            break;
         case "Ger":
            _loc3_.STR = _root.d(_loc4_ / 1.5);
            _loc3_.DEX = _root.d(_loc4_ / 6);
            _loc3_.CON = _root.d(_loc4_);
            _loc3_.WEAPON_PRI = new WeaponClass("OnehandedMace","Ger",Math.ceil(_global.MAIN_HERO.LEVEL / 13));
            _loc3_.WEAPON_SEC = new WeaponClass("Shield","Ger",Math.ceil(_global.MAIN_HERO.LEVEL / 25));
            break;
         case "Rus":
            _loc3_.STR = _root.d(_loc4_);
            _loc3_.DEX = _root.d(_loc4_ / 2);
            _loc3_.CON = _root.d(_loc4_ / 4);
            _loc3_.WEAPON_PRI = new WeaponClass("OnehandedAxe","Rus",Math.ceil(_global.MAIN_HERO.LEVEL / 13));
            _loc3_.WEAPON_SEC = new WeaponClass("OnehandedAxe","Rus",Math.ceil(_global.MAIN_HERO.LEVEL / 13));
            _loc3_.SKILL.Dual = 75 + Math.round(_global.MAIN_HERO.LEVEL / 2);
            break;
         case "Jap":
            _loc3_.STR = _root.d(_loc4_);
            _loc3_.DEX = _root.d(_loc4_);
            _loc3_.CON = _root.d(_loc4_ / 6);
            _loc3_.WEAPON_PRI = new WeaponClass(_root.d(2) != 1 ? "Staff" : "Katana","Jap",Math.ceil(_global.MAIN_HERO.LEVEL / 10));
            _loc3_.WEAPON_SEC = null;
            break;
         case "Mon":
            _loc3_.STR = _root.d(_loc4_ / 2);
            _loc3_.DEX = _root.d(_loc4_);
            _loc3_.CON = _root.d(_loc4_ / 3);
            _loc3_.WEAPON_PRI = new WeaponClass("Dagger","Mon",Math.ceil(_global.MAIN_HERO.LEVEL / 10));
            _loc3_.WEAPON_SEC = null;
            break;
         case "Ara":
            _loc3_.STR = _root.d(_loc4_ / 1.5);
            _loc3_.DEX = _root.d(_loc4_ / 1.5);
            _loc3_.CON = _root.d(_loc4_ / 3);
            _loc3_.WEAPON_PRI = new WeaponClass("OnehandedSword","Ara",Math.ceil(_global.MAIN_HERO.LEVEL / 13));
            _loc3_.WEAPON_SEC = new WeaponClass("OnehandedSword","Ara",Math.ceil(_global.MAIN_HERO.LEVEL / 13));
            _loc3_.SKILL.Dual = 75 + Math.round(_global.MAIN_HERO.LEVEL / 2);
      }
      if(_global.MAIN_HERO.ARMOR == null || _global.MAIN_HERO.ARMOR.LEVEL == 1)
      {
         _loc3_.ARMOR = null;
      }
      else
      {
         _loc3_.ARMOR = new Armor("Clothes",_loc3_.NATION,_global.MAIN_HERO.ARMOR.LEVEL - 1);
      }
      if(_global.MAIN_HERO.HELMET == null || _global.MAIN_HERO.HELMET.LEVEL == 1)
      {
         _loc3_.HELMET = null;
      }
      else
      {
         _loc3_.HELMET = new Armor("Helmet",_loc3_.NATION,_global.MAIN_HERO.HELMET.LEVEL - 1);
      }
      if(_loc3_.DEX > 100)
      {
         _loc3_.DEX = 100;
      }
      _loc3_.HORSE = null;
      _loc3_.primary_skill = _loc3_.WEAPON_PRI.skill;
      _loc3_.secondary_skill = _loc3_.WEAPON_SEC.skill;
      _loc3_.SKILL[_loc3_.primary_skill] = 50 + _global.MAIN_HERO.LEVEL;
      _loc3_.SKILL[_loc3_.secondary_skill] = 50 + _global.MAIN_HERO.LEVEL;
      _loc3_.price = _global.MAIN_HERO.LEVEL * 20;
      return _loc3_;
   }
   function getRangedUnit()
   {
      var _loc3_ = new Unit("Rog",null,0);
      _loc3_.NAME = "Quest Ranged Rogue";
      _loc3_.LEVEL = 1 + Math.round(_global.MAIN_HERO.LEVEL / 5);
      var _loc4_ = Math.max(Math.max(_global.MAIN_HERO.STR,_global.MAIN_HERO.DEX),Math.max(_global.MAIN_HERO.CON,_global.MAIN_HERO.SPR));
      _loc3_.SPR = 5;
      switch(_loc3_.NATION)
      {
         case "Viz":
            _loc3_.STR = _root.d(_loc4_ / 3);
            _loc3_.DEX = _root.d(_loc4_);
            _loc3_.CON = _root.d(_loc4_ / 4);
            _loc3_.WEAPON_PRI = new WeaponClass("Crossbow","Viz",Math.ceil(_global.MAIN_HERO.LEVEL / 17));
            _loc3_.WEAPON_SEC = new WeaponClass("TwohandedSword","Viz",Math.ceil(_global.MAIN_HERO.LEVEL / 13));
            break;
         case "Ger":
            _loc3_.STR = _root.d(_loc4_ / 5);
            _loc3_.DEX = _root.d(_loc4_);
            _loc3_.CON = _root.d(_loc4_ / 2);
            _loc3_.WEAPON_PRI = new WeaponClass("Crossbow","Ger",Math.ceil(_global.MAIN_HERO.LEVEL / 17));
            _loc3_.WEAPON_SEC = new WeaponClass("TwohandedMace","Ger",Math.ceil(_global.MAIN_HERO.LEVEL / 17));
            break;
         case "Rus":
            _loc3_.STR = _root.d(_loc4_ / 2);
            _loc3_.DEX = _root.d(_loc4_);
            _loc3_.CON = _root.d(_loc4_ / 5);
            _loc3_.WEAPON_PRI = new WeaponClass("Bow","Rus",Math.ceil(_global.MAIN_HERO.LEVEL / 20));
            _loc3_.WEAPON_SEC = new WeaponClass("TwohandedAxe","Rus",Math.ceil(_global.MAIN_HERO.LEVEL / 17));
            break;
         case "Jap":
            _loc3_.STR = _root.d(_loc4_);
            _loc3_.DEX = _root.d(_loc4_);
            _loc3_.CON = _root.d(_loc4_ / 6);
            _loc3_.WEAPON_PRI = new WeaponClass("Throwing","Jap",Math.ceil(_global.MAIN_HERO.LEVEL / 13));
            _loc3_.WEAPON_SEC = new WeaponClass(_root.d(2) != 1 ? "Staff" : "Katana","Jap",Math.ceil(_global.MAIN_HERO.LEVEL / 13));
            break;
         case "Mon":
            _loc3_.STR = _root.d(_loc4_ / 2);
            _loc3_.DEX = _root.d(_loc4_);
            _loc3_.CON = _root.d(_loc4_ / 5);
            _loc3_.WEAPON_PRI = new WeaponClass("Bow","Mon",Math.ceil(_global.MAIN_HERO.LEVEL / 17));
            _loc3_.WEAPON_SEC = new WeaponClass("TwohandedSword","Mon",Math.ceil(_global.MAIN_HERO.LEVEL / 17));
            break;
         case "Ara":
            _loc3_.STR = _root.d(_loc4_ / 2);
            _loc3_.DEX = _root.d(_loc4_);
            _loc3_.CON = _root.d(_loc4_ / 5);
            _loc3_.WEAPON_PRI = new WeaponClass("Crossbow","Ara",Math.ceil(_global.MAIN_HERO.LEVEL / 17));
            _loc3_.WEAPON_SEC = new WeaponClass("TwohandedSword","Ara",Math.ceil(_global.MAIN_HERO.LEVEL / 17));
      }
      if(_global.MAIN_HERO.ARMOR == null || _global.MAIN_HERO.ARMOR.LEVEL <= 2)
      {
         _loc3_.ARMOR = null;
      }
      else
      {
         _loc3_.ARMOR = new Armor("Clothes",_loc3_.NATION,_global.MAIN_HERO.ARMOR.LEVEL - 2);
      }
      if(_global.MAIN_HERO.HELMET == null || _global.MAIN_HERO.HELMET.LEVEL <= 2)
      {
         _loc3_.HELMET = null;
      }
      else
      {
         _loc3_.HELMET = new Armor("Helmet",_loc3_.NATION,_global.MAIN_HERO.HELMET.LEVEL - 2);
      }
      if(_loc3_.DEX > 100)
      {
         _loc3_.DEX = 100;
      }
      _loc3_.HORSE = null;
      _loc3_.primary_skill = _loc3_.WEAPON_PRI.skill;
      _loc3_.secondary_skill = _loc3_.WEAPON_SEC.skill;
      _loc3_.SKILL[_loc3_.primary_skill] = 75 + Math.round(_global.MAIN_HERO.LEVEL / 2);
      _loc3_.SKILL[_loc3_.secondary_skill] = 25 + _global.MAIN_HERO.LEVEL;
      _loc3_.price = _global.MAIN_HERO.LEVEL * 15;
      return _loc3_;
   }
}
