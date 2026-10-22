class Hero extends Object
{
   var EXP;
   var EXP_FOR_LEVELS;
   var HORSE;
   var LEVEL;
   var SKILL;
   var WEAPON_PRI;
   var WEAPON_SEC;
   var free_points;
   function Hero()
   {
      super();
      this.LEVEL = 0;
      this.EXP = 0;
      this.free_points = 25;
      this.SKILL = new Array();
      this.SKILL.Sword = 0;
      this.SKILL.Axe = 0;
      this.SKILL.Mace = 0;
      this.SKILL.FarEast = 0;
      this.SKILL.Spear = 0;
      this.SKILL.Dagger = 0;
      this.SKILL.Staff = 0;
      this.SKILL.Dual = 0;
      this.SKILL.Fist = 0;
      this.SKILL.Bow = 0;
      this.SKILL.Crossbow = 0;
      this.SKILL.Throwing = 0;
      this.SKILL.Patriotism = 0;
      this.SKILL.ArtOfWar = 0;
      this.EXP_FOR_LEVELS = new Array();
      this.EXP_FOR_LEVELS[0] = -1;
      this.EXP_FOR_LEVELS[1] = 0;
      this.EXP_FOR_LEVELS[2] = 100;
      this.EXP_FOR_LEVELS[3] = 250;
      this.EXP_FOR_LEVELS[4] = 500;
      this.EXP_FOR_LEVELS[5] = 800;
      this.EXP_FOR_LEVELS[6] = 1200;
      this.EXP_FOR_LEVELS[7] = 1600;
      this.EXP_FOR_LEVELS[8] = 2000;
      this.EXP_FOR_LEVELS[9] = 2500;
      this.EXP_FOR_LEVELS[10] = 3000;
      this.EXP_FOR_LEVELS[11] = 3600;
      this.EXP_FOR_LEVELS[12] = 4200;
      this.EXP_FOR_LEVELS[13] = 4800;
      this.EXP_FOR_LEVELS[14] = 5500;
      this.EXP_FOR_LEVELS[15] = 6200;
      this.EXP_FOR_LEVELS[16] = 7000;
      this.EXP_FOR_LEVELS[17] = 7800;
      this.EXP_FOR_LEVELS[18] = 8700;
      this.EXP_FOR_LEVELS[19] = 9700;
      this.EXP_FOR_LEVELS[20] = 10800;
      this.EXP_FOR_LEVELS[21] = 12000;
      this.EXP_FOR_LEVELS[22] = 13400;
      this.EXP_FOR_LEVELS[23] = 15000;
      this.EXP_FOR_LEVELS[24] = 17000;
      this.EXP_FOR_LEVELS[25] = 19500;
      this.EXP_FOR_LEVELS[26] = 22000;
      this.EXP_FOR_LEVELS[27] = 25000;
      this.EXP_FOR_LEVELS[28] = 29000;
      this.EXP_FOR_LEVELS[29] = 34000;
      this.EXP_FOR_LEVELS[40] = 39000;
      this.EXP_FOR_LEVELS[41] = 45000;
      this.EXP_FOR_LEVELS[42] = 50000;
      this.EXP_FOR_LEVELS[43] = 55000;
      this.EXP_FOR_LEVELS[44] = 61000;
      this.EXP_FOR_LEVELS[45] = 67000;
      this.EXP_FOR_LEVELS[46] = 74000;
      this.EXP_FOR_LEVELS[47] = 81000;
      this.EXP_FOR_LEVELS[48] = 88000;
      this.EXP_FOR_LEVELS[49] = 95000;
      this.EXP_FOR_LEVELS[50] = 100000;
      this.EXP_FOR_LEVELS[51] = 0;
   }
   function experience(xp)
   {
      this.EXP += xp;
      var _loc2_ = false;
      while(this.LEVEL < 50 && this.EXP >= this.EXP_FOR_LEVELS[this.LEVEL + 1])
      {
         this.LEVEL = this.LEVEL + 1;
         this.free_points += 25;
         _loc2_ = true;
      }
      return _loc2_;
   }
   function equipItemInfo(slot, item_info)
   {
      var _loc2_ = item_info.getItem();
      if(slot == "ARMOR" && item_info.TYPE != "Clothes" || slot == "HELMET" && item_info.TYPE != "Helmet" || (slot == "WEAPON_PRI" || slot == "WEAPON_SEC") && (item_info.TYPE == "Clothes" || item_info.TYPE == "Helmet"))
      {
         return "Bu zırh bu yuvaya giyilemez!";
      }
      if(_loc2_.require_param != null && this[_loc2_.require_param] < _loc2_.require_value)
      {
         return "Bu eşya için yeterli " + {STR:"GÜÇ",DEX:"ÇEV",CON:"DAY",INT:"ZEK"}[_loc2_.require_param] + " puanın yok";
      }
      var _loc4_;
      if(item_info.CATEGORY == "WeaponClass")
      {
         _loc4_ = slot != "WEAPON_PRI" ? "WEAPON_PRI" : "WEAPON_SEC";
         if(this.HORSE != null)
         {
            switch(_loc2_.TYPE)
            {
               case "Katana":
               case "NinjaTo":
               case "Dagger":
               case "Staff":
                  return "Bu silah at üstünde kullanılamaz!";
               default:
                  if(slot == "WEAPON_SEC" && _loc2_.TYPE != "Shield" && !_loc2_.twohanded && this.WEAPON_PRI.rng == 0)
                  {
                     return "At üstünde çift silah kullanılamaz!";
                  }
            }
         }
         if(_loc2_.TYPE == "Shield" && slot == "WEAPON_PRI")
         {
            return "Kalkan sağ ele takılamaz!";
         }
         if(_loc2_.TYPE == "Shield" && this[_loc4_] == null)
         {
            return "Kalkanla çıplak elle dövüşülemez!";
         }
         if(_loc2_.TYPE == "Shield" && this[_loc4_].twohanded)
         {
            return "İki elli silahla kalkan kullanılamaz!";
         }
         if(this[_loc4_] != null)
         {
            if(_loc2_.rng > 0 && this[_loc4_].rng > 0)
            {
               return "İki menzilli silah birlikte kuşanılamaz";
            }
            if(_loc2_.rng == 0 && this[_loc4_].rng == 0 && (_loc2_.twohanded || this[_loc4_].twohanded))
            {
               return "Biri iki elliyse iki yakın dövüş silahı birlikte kuşanılamaz";
            }
         }
         if(this.WEAPON_PRI == null && slot == "WEAPON_SEC" && _loc2_.rng == 0)
         {
            slot = "WEAPON_PRI";
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
         case "Staff":
            return "Silahım at üstünde kullanılamaz!";
         default:
            switch(this.WEAPON_SEC.TYPE)
            {
               case "Katana":
               case "NinjaTo":
               case "Dagger":
               case "Staff":
                  return "Silahım at üstünde kullanılamaz!";
               default:
                  if(this.WEAPON_SEC.TYPE != "Shield" && !(this.WEAPON_SEC.twohanded || this.WEAPON_PRI.twohanded))
                  {
                     return "At üstünde çift silahla dövüşemem!";
                  }
                  this.HORSE = horse;
                  return "OK";
            }
      }
   }
}
