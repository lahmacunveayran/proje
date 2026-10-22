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
      this.curr_gold = _root.d(this.enemies_amount) * 100 * Math.ceil(_global.MAIN_HERO.LEVEL / 10);
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
      this.curr_gold = 200 + 50 * _root.d(10);
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
            return this.anyOf(["Trapezus","Lutetia","Arretium","Ravenna","Lacrimosa","Caesaria","Carthage","Alexandria"]);
         case "Ger":
            return this.anyOf(["Jana","Konstanz","Gerlitz","Sturmburg","Hoffen","Endem","Braunburg","Wanderburg"]);
         case "Rus":
            return this.anyOf(["Dubkee","Dalnevodye","Losevo","Dobrov","Zlatograd","Medvedevo","Grouzeno","RaGorod"]);
         case "Jap":
            return this.anyOf(["Omi","Kozuke","Matsuyama","Fukushima","Izumo","Suo","Nagoya","Echigo"]);
         default:
            return;
      }
   }
   function getQuestAvatarID(city_id)
   {
      switch(city_id)
      {
         case "Trapezus":
         case "Lutetia":
         case "Arretium":
         case "Ravenna":
            return this.anyOf([8,9,10]);
         case "Lacrimosa":
         case "Caesaria":
            return 11;
         case "Carthage":
         case "Alexandria":
            return this.anyOf([8,9,10]);
         case "Jana":
         case "Konstanz":
            return this.anyOf([1,7,8]);
         case "Gerlitz":
         case "Sturmburg":
            return this.anyOf([1,2,3,5]);
         case "Hoffen":
         case "Endem":
            return 0;
         case "Braunburg":
            return this.anyOf([1,2,3,5]);
         case "Wanderburg":
            return 0;
         case "Dubkee":
         case "Dalnevodye":
         case "Losevo":
         case "Dobrov":
         case "Zlatograd":
            return this.anyOf([2,5,6,7]);
         case "Medvedevo":
         case "Grouzeno":
            return 4;
         case "RaGorod":
            return this.anyOf([2,3,5,6,7]);
         case "Omi":
         case "Kozuke":
         case "Matsuyama":
            return this.anyOf([12,13]);
         case "Fukushima":
            return this.anyOf([5,6]);
         case "Izumo":
            return this.anyOf([12,13]);
         case "Suo":
            return 11;
         case "Nagoya":
         case "Echigo":
            return 14;
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
      var _loc3_ = new Unit("Melee","Rog",0);
      _loc3_.NAME = "Quest Melee Rogue";
      var _loc4_ = Math.max(Math.max(_global.MAIN_HERO.STR,_global.MAIN_HERO.DEX),Math.max(_global.MAIN_HERO.CON,_global.MAIN_HERO.INT));
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
      var _loc3_ = new Unit("Ranged","Rog",0);
      _loc3_.NAME = "Quest Ranged Rogue";
      var _loc4_ = Math.max(Math.max(_global.MAIN_HERO.STR,_global.MAIN_HERO.DEX),Math.max(_global.MAIN_HERO.CON,_global.MAIN_HERO.INT));
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
            _loc3_.WEAPON_PRI = new WeaponClass("Bow","Rus",Math.ceil(_global.MAIN_HERO.LEVEL / 25));
            _loc3_.WEAPON_SEC = new WeaponClass("TwohandedAxe","Rus",Math.ceil(_global.MAIN_HERO.LEVEL / 17));
            break;
         case "Jap":
            _loc3_.STR = _root.d(_loc4_);
            _loc3_.DEX = _root.d(_loc4_);
            _loc3_.CON = _root.d(_loc4_ / 6);
            _loc3_.WEAPON_PRI = new WeaponClass("Throwing","Jap",Math.ceil(_global.MAIN_HERO.LEVEL / 13));
            _loc3_.WEAPON_SEC = new WeaponClass(_root.d(2) != 1 ? "Staff" : "Katana","Jap",Math.ceil(_global.MAIN_HERO.LEVEL / 13));
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
