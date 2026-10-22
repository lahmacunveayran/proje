class Skill
{
   function Skill()
   {
   }
   static function getSkillInfoByFrame(frame)
   {
      switch(frame)
      {
         case 1:
            return {nm:"shield",id:1};
         case 2:
            return {nm:"shield",id:2};
         case 3:
            return {nm:"shield",id:3};
         case 4:
            return {nm:"2H_sword",id:1};
         case 5:
            return {nm:"2H_sword",id:2};
         case 6:
            return {nm:"2H_sword",id:3};
         case 7:
            return {nm:"2H_axe",id:1};
         case 8:
            return {nm:"2H_axe",id:2};
         case 9:
            return {nm:"2H_axe",id:3};
         case 10:
            return {nm:"dual",id:1};
         case 11:
            return {nm:"dual",id:2};
         case 12:
            return {nm:"dual",id:3};
         case 13:
            return {nm:"spear",id:1};
         case 14:
            return {nm:"spear",id:2};
         case 15:
            return {nm:"spear",id:3};
         case 16:
            return {nm:"dagger",id:1};
         case 17:
            return {nm:"dagger",id:2};
         case 18:
            return {nm:"dagger",id:3};
         case 19:
            return {nm:"katana",id:1};
         case 20:
            return {nm:"katana",id:2};
         case 21:
            return {nm:"katana",id:3};
         case 22:
            return {nm:"staff",id:1};
         case 23:
            return {nm:"staff",id:2};
         case 24:
            return {nm:"staff",id:3};
         case 25:
            return {nm:"katar",id:1};
         case 26:
            return {nm:"katar",id:2};
         case 27:
            return {nm:"katar",id:3};
         case 28:
            return {nm:"bow",id:1};
         case 29:
            return {nm:"bow",id:2};
         case 30:
            return {nm:"bow",id:3};
         case 31:
            return {nm:"crossbow",id:1};
         case 32:
            return {nm:"crossbow",id:2};
         case 33:
            return {nm:"crossbow",id:3};
         case 34:
            return {nm:"throwing",id:1};
         case 35:
            return {nm:"throwing",id:2};
         case 36:
            return {nm:"throwing",id:3};
         case 37:
            return {nm:"Bowmen_1",id:0};
         case 38:
            return {nm:"Bowmen_2",id:0};
         case 39:
            return {nm:"Bowmen_3",id:0};
         case 40:
            return {nm:"Infantry_1",id:0};
         case 41:
            return {nm:"Infantry_2",id:0};
         case 42:
            return {nm:"Infantry_3",id:0};
         case 43:
            return {nm:"Horsemen_1",id:0};
         case 44:
            return {nm:"Horsemen_2",id:0};
         case 45:
            return {nm:"Horsemen_3",id:0};
         case 46:
            return {nm:"Swordsmen_1",id:0};
         case 47:
            return {nm:"Swordsmen_2",id:0};
         case 48:
            return {nm:"Swordsmen_3",id:0};
         case 49:
            return {nm:"Meditate",id:0};
         case 50:
            return {nm:"FarEastWarTraining",id:0};
         case 51:
            return {nm:"AssassinTraining",id:0};
         case 52:
            return {nm:"BerserkerTraining",id:0};
         case 53:
            return {nm:"KungFuSecrets",id:0};
         case 54:
            return {nm:"FindWeakPoint",id:0};
         case 60:
            return {nm:"Devotion",id:-1};
         case 61:
            return {nm:"DivineHelp",id:-1};
         case 62:
            return {nm:"Barrier",id:-1};
         case 63:
            return {nm:"Sacrifice",id:-1};
         case 64:
            return {nm:"ForceBalance",id:-1};
         case 65:
            return {nm:"VenomCloud",id:-1};
         case 66:
            return {nm:"HolyTribunal",id:-1};
         case 67:
            return {nm:"UnholyBreath",id:-1};
         case 68:
            return {nm:"LifeLeech",id:-1};
         case 69:
            return {nm:"SoulDrain",id:-1};
         case 70:
            return {nm:"Healing",id:-1};
         case 71:
            return {nm:"BansheeCry",id:-1};
         case 72:
            return {nm:"NationViz",id:-1};
         case 73:
            return {nm:"NationGer",id:-1};
         case 74:
            return {nm:"NationRus",id:-1};
         case 75:
            return {nm:"NationJap",id:-1};
         case 76:
            return {nm:"NationMon",id:-1};
         case 77:
            return {nm:"NationAra",id:-1};
         default:
            return null;
      }
   }
   static function getSkillName(skill_name, skill_id)
   {
      // (derleyicinin okuyamadığı etiket kaldırıldı)
      switch(skill_name)
      {
         case "shield":
            switch(skill_id)
            {
               case 1:
                  return "Kalkan Hücumu";
               case 2:
                  return "Üçlü Saldırı";
               case 3:
                  return "Korunaklı Saldırı";
            }
            break;
         case "2H_sword":
            switch(skill_id)
            {
               case 1:
                  return "Güçlü Darbe";
               case 2:
                  return "Şok Dalgası";
               case 3:
                  return "Ezici Sıçrayış";
            }
            break;
         case "2H_axe":
            switch(skill_id)
            {
               case 1:
                  return "Sersemleten Vuruş";
               case 2:
                  return "Çılgın Ezme";
               case 3:
                  return "Delice Vuruş";
            }
            break;
         case "dual":
            switch(skill_id)
            {
               case 1:
                  return "Kılıç Fırtınası";
               case 2:
                  return "Salto";
               case 3:
                  return "Çift Sıçrayış";
            }
            break;
         case "spear":
            switch(skill_id)
            {
               case 1:
                  return "Delip Geçme";
               case 2:
                  return "Darbe Yağmuru";
               case 3:
                  return "Yanan Mızrak";
            }
            break;
         case "dagger":
            switch(skill_id)
            {
               case 1:
                  return "Sırttan Bıçaklama";
               case 2:
                  return "Çifte Kritik";
               case 3:
                  return "Bumerang Hançer";
            }
            break;
         case "katana":
            switch(skill_id)
            {
               case 1:
                  return "Rüzgâr Vuruşu";
               case 2:
                  return "Tekme";
               case 3:
                  return "Giyotin Kılıcı";
            }
            break;
         case "staff":
            switch(skill_id)
            {
               case 1:
                  return "Hızlı Kombo";
               case 2:
                  return "Işık Sütunu";
               case 3:
                  return "Yıldırım Saldırısı";
            }
            break;
         case "katar":
            switch(skill_id)
            {
               case 1:
                  return "Gölge Vuruşu";
               case 2:
                  return "Kritik Kombo";
               case 3:
                  return "Meteor Vuruşu";
            }
            break;
         case "bow":
            switch(skill_id)
            {
               case 1:
                  return "Çift Atış";
               case 2:
                  return "Seri Atış";
               case 3:
                  return "Ok Yağmuru";
            }
            break;
         case "crossbow":
            switch(skill_id)
            {
               case 1:
                  return "Sersemleten Atış";
               case 2:
                  return "Kafadan Vuruş";
               case 3:
                  return "Delici Atış";
            }
            break;
         case "throwing":
            switch(skill_id)
            {
               case 1:
                  return "Çoklu Fırlatma";
               case 2:
                  return "Hızlı Fırlatma";
               case 3:
                  return "Seken Atış";
               default:
                  return "No such skill for " + skill_name + skill_id;
            }
         case "fists":
            return "[No skillname for fists]";
         case "Bowmen_1":
            return "Nişancı Eğitimi";
         case "Bowmen_2":
            return "Kartal Gözü";
         case "Bowmen_3":
            return "Keskin Oklar";
         case "Infantry_1":
            return "Piyade Savunma Ustalığı";
         case "Infantry_2":
            return "Piyade Saldırı Ustalığı";
         case "Infantry_3":
            return "Piyade Silah Ustalığı";
         case "Horsemen_1":
            return "Süvari Binicilik Ustalığı";
         case "Horsemen_2":
            return "Süvari Savunma Ustalığı";
         case "Horsemen_3":
            return "Süvari Savaş Ustalığı";
         case "Swordsmen_1":
            return "Yaya Savunma Ustalığı";
         case "Swordsmen_2":
            return "Yaya Saldırı Ustalığı";
         case "Swordsmen_3":
            return "Yaya Silah Ustalığı";
         case "Meditate":
            return "Meditasyon";
         case "FarEastWarTraining":
            return "Uzak Doğu Savaş Sanatları";
         case "AssassinTraining":
            return "Suikast Ustalığı";
         case "BerserkerTraining":
            return "Çılgın Savaşçı Öfkesi";
         case "KungFuSecrets":
            return "Kung-Fu Sırları";
         case "FindWeakPoint":
            return "Zayıf Noktayı Bul";
      }
      return "No such skill for " + skill_name + skill_id;
   }
   static function getSkilltypeDescr(skill_name)
   {
      switch(skill_name)
      {
         case "shield":
            return "Tek elli silah ve kalkan hareketleri";
         case "2H_sword":
            return "İki elli kılıç hareketleri";
         case "2H_axe":
            return "İki elli topuz ve balta hareketleri";
         case "dual":
            return "Çift silah hareketleri";
         case "spear":
            return "Mızrak hareketleri";
         case "dagger":
            return "Hançer hareketleri";
         case "katana":
            return "Katana hareketleri";
         case "staff":
            return "Asa hareketleri";
         case "katar":
            return "Katar hareketleri";
         case "bow":
            return "Yay hareketleri";
         case "crossbow":
            return "Arbalet hareketleri";
         case "throwing":
            return "Fırlatma silahı hareketleri";
         default:
            return "[no such skill type]";
      }
   }
   static function getCostSP(atk_anim, skill_id)
   {
      // (derleyicinin okuyamadığı etiket kaldırıldı)
      switch(atk_anim)
      {
         case "shield":
            switch(skill_id)
            {
               case 1:
                  return 15;
               case 2:
                  return 20;
               case 3:
                  return 30;
            }
            break;
         case "2H_sword":
            switch(skill_id)
            {
               case 1:
                  return 20;
               case 2:
                  return 25;
               case 3:
                  return 35;
            }
            break;
         case "2H_axe":
            switch(skill_id)
            {
               case 1:
                  return 15;
               case 2:
                  return 20;
               case 3:
                  return 35;
            }
            break;
         case "dual":
            switch(skill_id)
            {
               case 1:
                  return 20;
               case 2:
                  return 25;
               case 3:
                  return 30;
            }
            break;
         case "spear":
            switch(skill_id)
            {
               case 1:
                  return 12;
               case 2:
                  return 17;
               case 3:
                  return 40;
            }
            break;
         case "dagger":
            switch(skill_id)
            {
               case 1:
                  return 35;
               case 2:
                  return 20;
               case 3:
                  return 30;
            }
            break;
         case "katana":
            switch(skill_id)
            {
               case 1:
                  return 20;
               case 2:
                  return 20;
               case 3:
                  return 100;
            }
            break;
         case "staff":
            switch(skill_id)
            {
               case 1:
                  return 15;
               case 2:
                  return 25;
               case 3:
                  return 25;
            }
            break;
         case "katar":
            switch(skill_id)
            {
               case 1:
                  return 10;
               case 2:
                  return 21;
               case 3:
                  return 40;
            }
            break;
         case "bow":
            switch(skill_id)
            {
               case 1:
                  return 18;
               case 2:
                  return 24;
               case 3:
                  return 28;
            }
            break;
         case "crossbow":
            switch(skill_id)
            {
               case 1:
                  return 15;
               case 2:
                  return 25;
               case 3:
                  return 30;
            }
            break;
         case "throwing":
            switch(skill_id)
            {
               case 1:
                  return 20;
               case 2:
                  return 25;
               case 3:
                  return 30;
               default:
                  trace("Attempt to get SP cost of skill which does not exist: " + atk_anim + "-" + skill_id);
                  return 0;
            }
         case "fists":
            return 0;
      }
      trace("Attempt to get SP cost of skill which does not exist: " + atk_anim + "-" + skill_id);
      return 0;
   }
   static function getActiveSkillFrame(atk_anim, skill_id)
   {
      switch(atk_anim)
      {
         case "shield":
            return skill_id;
         case "2H_sword":
            return 3 + skill_id;
         case "2H_axe":
            return 6 + skill_id;
         case "dual":
            return 9 + skill_id;
         case "spear":
            return 12 + skill_id;
         case "dagger":
            return 15 + skill_id;
         case "katana":
            return 18 + skill_id;
         case "staff":
            return 21 + skill_id;
         case "katar":
            return 24 + skill_id;
         case "bow":
            return 27 + skill_id;
         case "crossbow":
            return 30 + skill_id;
         case "throwing":
            return 33 + skill_id;
         case "fists":
            return 0;
         default:
            return "No such skill for " + atk_anim + skill_id;
      }
   }
   static function getPassiveSkillFrame(skill_name)
   {
      var _loc1_ = 37;
      switch(skill_name)
      {
         case "Bowmen_1":
            return _loc1_;
         case "Bowmen_2":
            return _loc1_ + 1;
         case "Bowmen_3":
            return _loc1_ + 2;
         case "Infantry_1":
            return _loc1_ + 3;
         case "Infantry_2":
            return _loc1_ + 4;
         case "Infantry_3":
            return _loc1_ + 5;
         case "Horsemen_1":
            return _loc1_ + 6;
         case "Horsemen_2":
            return _loc1_ + 7;
         case "Horsemen_3":
            return _loc1_ + 8;
         case "Swordsmen_1":
            return _loc1_ + 9;
         case "Swordsmen_2":
            return _loc1_ + 10;
         case "Swordsmen_3":
            return _loc1_ + 11;
         case "Meditate":
            return _loc1_ + 12;
         case "FarEastWarTraining":
            return _loc1_ + 13;
         case "AssassinTraining":
            return _loc1_ + 14;
         case "BerserkerTraining":
            return _loc1_ + 15;
         case "KungFuSecrets":
            return _loc1_ + 16;
         case "FindWeakPoint":
            return _loc1_ + 17;
         default:
            return;
      }
   }
   static function getSkillRequire(skill_name, skill_id)
   {
      if(skill_id <= 1)
      {
         return 0;
      }
      // (derleyicinin okuyamadığı etiket kaldırıldı)
      switch(skill_name)
      {
         case "shield":
            switch(skill_id)
            {
               case 2:
                  return 1;
               case 3:
                  return 3;
            }
            break;
         case "2H_sword":
            switch(skill_id)
            {
               case 2:
                  return 3;
               case 3:
                  return 4;
            }
            break;
         case "2H_axe":
            switch(skill_id)
            {
               case 2:
                  return 1;
               case 3:
                  return 4;
            }
            break;
         case "dual":
            switch(skill_id)
            {
               case 2:
                  return 1;
               case 3:
                  return 3;
            }
            break;
         case "spear":
            switch(skill_id)
            {
               case 2:
                  return 1;
               case 3:
                  return 3;
            }
            break;
         case "dagger":
            switch(skill_id)
            {
               case 2:
                  return 1;
               case 3:
                  return 3;
            }
            break;
         case "katana":
            switch(skill_id)
            {
               case 2:
                  return 5;
               case 3:
                  return 5;
            }
            break;
         case "staff":
            switch(skill_id)
            {
               case 2:
                  return 2;
               case 3:
                  return 5;
            }
            break;
         case "katar":
            switch(skill_id)
            {
               case 2:
                  return 3;
               case 3:
                  return 5;
            }
            break;
         case "bow":
            switch(skill_id)
            {
               case 2:
                  return 3;
               case 3:
                  return 3;
            }
            break;
         case "crossbow":
            switch(skill_id)
            {
               case 2:
                  return 1;
               case 3:
                  return 5;
            }
            break;
         case "throwing":
            switch(skill_id)
            {
               case 2:
                  return 1;
               case 3:
                  return 5;
               default:
                  return "No such skill for " + skill_name + skill_id;
            }
         case "fists":
            return 0;
         case "Bowmen_1":
         case "Bowmen_2":
         case "Bowmen_3":
         case "Infantry_1":
         case "Infantry_2":
         case "Infantry_3":
         case "Horsemen_1":
         case "Horsemen_2":
            return "Süvari Savunma Ustalığı";
         case "Horsemen_3":
            return "Süvari Savaş Ustalığı";
         case "Swordsmen_1":
            return "Yaya Savunma Ustalığı";
         case "Swordsmen_2":
            return "Yaya Saldırı Ustalığı";
         case "Swordsmen_3":
            return "Yaya Silah Ustalığı";
         case "Meditate":
            return "Meditasyon";
         case "FarEastWarTraining":
            return "Uzak Doğu Savaş Sanatları";
         case "AssassinTraining":
            return "Suikast Ustalığı";
         case "BerserkerTraining":
            return "Çılgın Savaşçı Öfkesi";
         case "KungFuSecrets":
            return "Kung-Fu Sırları";
         case "FindWeakPoint":
            return "Zayıf Noktayı Bul";
      }
      return "No such skill for " + skill_name + skill_id;
   }
   static function operate(is_melee, att, target, useSecondWeapon, atk_anim, skill_id, skill_lv, skill_flag)
   {
      var _loc1_ = att.getDamageData(target,useSecondWeapon);
      if(Skill["active_" + atk_anim + "_" + skill_id](att,target,_loc1_,skill_lv,skill_flag))
      {
         if(is_melee)
         {
            target.takeDamage(_loc1_,true);
         }
         else
         {
            att.addProjectile(target,Creature.getArrowErrorRatio(_loc1_.hit),_loc1_);
         }
      }
   }
   static function operatePassive(man, skill_name, skill_lv)
   {
      Skill["passive_" + skill_name](man,skill_lv);
   }
   static function active_shield_1(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.crit = 0;
      if(_root.percent(att.SHIELD_DODGE + 2 * skill_lv))
      {
         dmg_data.addStatus("Stun",3);
      }
      dmg_data.damage = (att.unit_ref.STR + att.SHIELD_DODGE * 2) * skill_lv / 2;
      return true;
   }
   static function active_shield_2(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 0.5 + 0.1 * skill_lv;
      return true;
   }
   static function active_shield_3(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 0.4 + 0.1 * skill_lv;
      return true;
   }
   static function active_2H_sword_1(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 1.5 + 0.2 * skill_lv;
      return true;
   }
   static function active_2H_sword_2(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 1 + 0.2 * skill_lv;
      dmg_data.hit = 10000;
      var _loc5_ = att.body._xscale <= 0 ? -1 : 1;
      var _loc2_ = 1;
      while(_loc2_ <= 3)
      {
         _global.field[att.X - _loc2_ * _loc5_][att.Y].who.takeDamage(dmg_data,null);
         _loc2_ = _loc2_ + 1;
      }
      return false;
   }
   static function active_2H_sword_3(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 1 + 0.4 * skill_lv;
      dmg_data.hit = 10000;
      var _loc4_ = -1;
      var _loc3_;
      while(_loc4_ <= 1)
      {
         _loc3_ = -1;
         while(_loc3_ <= 1)
         {
            _global.field[att.X + _loc4_][att.Y + _loc3_].who.takeDamage(dmg_data,null);
            _loc3_ = _loc3_ + 1;
         }
         _loc4_ = _loc4_ + 1;
      }
      _root.addBlow(att.X,att.Y,"3x3");
      return false;
   }
   static function active_2H_axe_1(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 0.5 + 0.1 * skill_lv;
      if(_root.percent(30 + 3 * skill_lv))
      {
         dmg_data.addStatus("Stun",3);
      }
      return true;
   }
   static function active_2H_axe_2(att, target, dmg_data, skill_lv, skill_flag)
   {
      var _loc7_ = new DamageData(att,dmg_data.damage * 0.1,100,0);
      if(_root.percent(2 * skill_lv))
      {
         dmg_data.addStatus("Stun",3);
         _loc7_.addStatus("Stun",3);
      }
      var _loc9_;
      var _loc8_;
      if(target)
      {
         _loc9_ = target.X;
         _loc8_ = target.Y;
      }
      else
      {
         _loc9_ = att.X + (att.body._xscale <= 0 ? -1 : 1);
         _loc8_ = att.Y;
      }
      var _loc5_ = -1;
      var _loc3_;
      var _loc4_;
      while(_loc5_ <= 1)
      {
         _loc3_ = -1;
         while(_loc3_ <= 1)
         {
            _loc4_ = _global.field[_loc9_ + _loc5_][_loc8_ + _loc3_].who;
            if(_loc4_ != att && _loc4_ != target)
            {
               _loc4_.takeDamage(_loc7_,null);
            }
            _loc3_ = _loc3_ + 1;
         }
         _loc5_ = _loc5_ + 1;
      }
      dmg_data.damage *= 2 + 0.4 * skill_lv;
      dmg_data.crit = 100;
      _root.addBlow(_loc9_,_loc8_,"3x3");
      return true;
   }
   static function active_2H_axe_3(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 1.5 + 0.4 * skill_lv;
      dmg_data.crit = 0;
      dmg_data.hit = 10000;
      var _loc7_;
      var _loc6_;
      if(target)
      {
         _loc7_ = target.X;
         _loc6_ = target.Y;
      }
      else
      {
         _loc7_ = att.X + (att.body._xscale <= 0 ? -1 : 1);
         _loc6_ = att.Y;
      }
      var _loc5_ = -1;
      var _loc3_;
      var _loc4_;
      while(_loc5_ <= 1)
      {
         _loc3_ = -1;
         while(_loc3_ <= 1)
         {
            _loc4_ = _global.field[_loc7_ + _loc5_][_loc6_ + _loc3_].who;
            if(_loc4_ != att)
            {
               _loc4_.takeDamage(dmg_data,null);
            }
            _loc3_ = _loc3_ + 1;
         }
         _loc5_ = _loc5_ + 1;
      }
      _root.addBlow(_loc7_,_loc6_,"3x3");
      return false;
   }
   static function active_dual_1(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 0.4 + 0.1 * skill_lv;
      return true;
   }
   static function active_dual_2(att, target, dmg_data, skill_lv, skill_flag)
   {
      var _loc4_ = att.getDamageData(target,true);
      dmg_data.damage *= 1 + 0.2 * skill_lv;
      dmg_data.crit *= 1 + 0.1 * skill_lv;
      _loc4_.damage *= 1 + 0.2 * skill_lv;
      _loc4_.crit *= 1 + 0.1 * skill_lv;
      var _loc6_ = - _root.znak(att.body._xscale);
      _global.field[target.X + _loc6_][target.Y].who.takeDamage(dmg_data,null);
      _global.field[target.X - _loc6_][target.Y].who.takeDamage(_loc4_,null);
      return false;
   }
   static function active_dual_3(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.addDmgData(att.getDamageData(target,true));
      dmg_data.damage *= 1 + 0.3 * skill_lv;
      dmg_data.crit = 50;
      return true;
   }
   static function active_spear_1(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 1 + 0.1 * skill_lv;
      dmg_data.crit = 100;
      return true;
   }
   static function active_spear_2(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 0.75 + 0.15 * skill_lv;
      dmg_data.crit /= 3;
      return true;
   }
   static function active_spear_3(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 2 + 0.4 * skill_lv;
      dmg_data.crit = 0;
      dmg_data.hit = 10000;
      var _loc6_ = - _root.znak(att.body._xscale);
      var _loc4_ = -1;
      while(_loc4_ <= 1)
      {
         _global.field[att.X + _loc6_][att.Y + _loc4_].who.takeDamage(dmg_data,null);
         _loc4_ = _loc4_ + 1;
      }
      _loc4_ = -2;
      while(_loc4_ <= 2)
      {
         _global.field[att.X + _loc6_ * 2][att.Y + _loc4_].who.takeDamage(dmg_data,null);
         _loc4_ = _loc4_ + 1;
      }
      _loc4_ = -3;
      while(_loc4_ <= 3)
      {
         _global.field[att.X + _loc6_ * 3][att.Y + _loc4_].who.takeDamage(dmg_data,null);
         _loc4_ = _loc4_ + 1;
      }
      return false;
   }
   static function active_dagger_1(att, target, dmg_data, skill_lv, skill_flag)
   {
      if(_root.znak(att.body._xscale) != _root.znak(target.body._xscale))
      {
         dmg_data.damage /= 2;
         dmg_data.crit = 0;
         return true;
      }
      dmg_data.hit = 100;
      var _loc5_ = (0.4 + 0.1 * skill_lv) * dmg_data.crit;
      if(_global.EASY_MODE && target == _root.hero0)
      {
         _loc5_ = 0;
      }
      if(_root.percent(_loc5_))
      {
         target.addMessage(target.MAX_HP,"FlyDamage");
         target.die();
         return false;
      }
      dmg_data.damage *= 3 + skill_lv;
      dmg_data.crit = 0;
      return true;
   }
   static function active_dagger_2(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 0.75 + 0.15 * skill_lv;
      dmg_data.crit = 100;
      return true;
   }
   static function active_dagger_3(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.crit = 0;
      var _loc4_;
      var _loc3_;
      var _loc5_;
      switch(skill_flag)
      {
         case 1:
            dmg_data.damage *= 0.5 + 0.1 * skill_lv;
            return true;
         case 2:
            dmg_data.damage *= 0.5 + 0.2 * skill_lv;
            dmg_data.hit = 10000;
            _loc4_ = -2;
            while(_loc4_ <= 2)
            {
               _loc3_ = -2;
               while(_loc3_ <= 2)
               {
                  _loc5_ = _global.field[att.X + _loc4_][att.Y + _loc3_].who;
                  _loc5_.takeDamage(dmg_data,null);
                  _loc3_ = _loc3_ + 1;
               }
               _loc4_ = _loc4_ + 1;
            }
            _root.addBlow(att.X,att.Y,"5x5");
            return false;
         default:
            trace("Strange skill flag in Dagger-3 skill:" + skill_flag);
            return true;
      }
   }
   static function active_katana_1(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 1.5 + 0.2 * skill_lv;
      dmg_data.crit *= 1 + 0.2 * skill_lv;
      return true;
   }
   static function active_katana_2(att, target, dmg_data, skill_lv, skill_flag)
   {
      switch(skill_flag)
      {
         case 1:
            dmg_data.damage = att.unit_ref.STR * skill_lv / 2;
            dmg_data.crit = 0;
            target.aspd_timer += 30;
            return true;
         case 2:
            dmg_data.damage *= 1 + 0.3 * skill_lv;
            return true;
         default:
            trace("Strange skill flag in Katana-2 skill:" + skill_flag);
            return true;
      }
   }
   static function active_katana_3(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.hit = 10000;
      dmg_data.crit = 100;
      dmg_data.damage += att.SP;
      att.SP = 0;
      dmg_data.damage *= target.DEF / (8 - skill_lv);
      return true;
   }
   static function active_staff_1(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 1 + 0.2 * skill_lv;
      if(_root.percent(2 * skill_lv))
      {
         dmg_data.addStatus("Stun",3);
      }
      return true;
   }
   static function active_staff_2(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 0.5 + 0.1 * skill_lv;
      dmg_data.crit = 100;
      dmg_data.hit = 10000;
      var _loc4_ = -3;
      var _loc3_;
      var _loc5_;
      while(_loc4_ <= 3)
      {
         _loc3_ = -3;
         while(_loc3_ <= 3)
         {
            _loc5_ = _global.field[att.X + _loc4_][att.Y + _loc3_].who;
            _loc5_.takeDamage(dmg_data,null);
            _loc3_ = _loc3_ + 1;
         }
         _loc4_ = _loc4_ + 1;
      }
      _root.addBlow(att.X,att.Y,"5x5");
      return false;
   }
   static function active_staff_3(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.crit = 0;
      dmg_data.damage *= 0.5 + 0.1 * skill_lv;
      return true;
   }
   static function active_katar_1(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 2 + 0.3 * skill_lv;
      if(_root.percent(dmg_data.crit))
      {
         dmg_data.addStatus("Poison",5);
      }
      return true;
   }
   static function active_katar_2(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.crit = 100;
      dmg_data.damage *= 1 + 0.1 * skill_lv;
      return true;
   }
   static function active_katar_3(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.crit = 0;
      dmg_data.damage *= 2 + 0.4 * skill_lv;
      dmg_data.hit = 10000;
      var _loc4_ = -2;
      var _loc3_;
      var _loc5_;
      while(_loc4_ <= 2)
      {
         _loc3_ = -2;
         while(_loc3_ <= 2)
         {
            _loc5_ = _global.field[att.X + _loc4_][att.Y + _loc3_].who;
            _loc5_.takeDamage(dmg_data,null);
            _loc3_ = _loc3_ + 1;
         }
         _loc4_ = _loc4_ + 1;
      }
      _root.addBlow(att.X,att.Y,"5x5");
      return false;
   }
   static function active_bow_1(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 1.2 + 0.2 * skill_lv;
      return true;
   }
   static function active_bow_2(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 0.5 + 0.2 * skill_lv;
      return true;
   }
   static function active_bow_3(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 0.5 + 0.1 * skill_lv;
      var _loc3_ = -1;
      var _loc2_;
      while(_loc3_ <= 1)
      {
         _loc2_ = -1;
         while(_loc2_ <= 1)
         {
            _root.addArrowShower(target.X + _loc3_,target.Y + _loc2_,dmg_data);
            _loc2_ = _loc2_ + 1;
         }
         _loc3_ = _loc3_ + 1;
      }
      return false;
   }
   static function active_crossbow_1(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 1.5 + 0.1 * skill_lv;
      dmg_data.crit = 0;
      if(_root.percent(10 * skill_lv))
      {
         dmg_data.addStatus("Stun",3);
      }
      return true;
   }
   static function active_crossbow_2(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 2.2 + 0.2 * skill_lv;
      dmg_data.crit = 100;
      return true;
   }
   static function active_crossbow_3(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 1.6 + 0.2 * skill_lv;
      dmg_data.crit = 100;
      att.addProjectile(target,Creature.getArrowErrorRatio(dmg_data.hit),dmg_data,3);
      return false;
   }
   static function active_throwing_1(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 0.9 + 0.1 * skill_lv;
      var _loc2_ = att.getCreaturesInSight(false,3);
      var _loc1_ = 0;
      while(_loc1_ < _loc2_.length)
      {
         att.addProjectile(_loc2_[_loc1_],Creature.getArrowErrorRatio(dmg_data.hit),dmg_data);
         _loc1_ = _loc1_ + 1;
      }
      return false;
   }
   static function active_throwing_2(att, target, dmg_data, skill_lv, skill_flag)
   {
      dmg_data.damage *= 0.5 + 0.1 * skill_lv;
      return true;
   }
   static function active_throwing_3(att, target, dmg_data, skill_lv, skill_flag)
   {
      att.addProjectile(target,Creature.getArrowErrorRatio(dmg_data.hit),dmg_data,skill_lv);
      return false;
   }
   static function passive_Bowmen_1(man, skill_lv)
   {
      var _loc2_;
      switch("Ranged")
      {
         case man.wpnPri.TYPE:
            _loc2_ = man.wpnPri;
            break;
         case man.wpnSec.TYPE:
            _loc2_ = man.wpnSec;
            break;
         default:
            return undefined;
      }
      _loc2_.HIT += skill_lv * 3;
   }
   static function passive_Bowmen_2(man, skill_lv)
   {
      var _loc2_;
      switch("Ranged")
      {
         case man.wpnPri.TYPE:
            _loc2_ = man.wpnPri;
            break;
         case man.wpnSec.TYPE:
            _loc2_ = man.wpnSec;
            break;
         default:
            return undefined;
      }
      _loc2_.CRIT += skill_lv * 2;
      _loc2_.rng += skill_lv;
   }
   static function passive_Bowmen_3(man, skill_lv)
   {
      var _loc1_;
      switch("Ranged")
      {
         case man.wpnPri.TYPE:
            _loc1_ = man.wpnPri;
            break;
         case man.wpnSec.TYPE:
            _loc1_ = man.wpnSec;
            break;
         default:
            return undefined;
      }
      _loc1_.dmg += Math.round(_loc1_.dmg * skill_lv * 0.04);
      _loc1_.rnd += Math.round(_loc1_.rnd * skill_lv * 0.04);
   }
   static function passive_Infantry_1(man, skill_lv)
   {
      if(!man.isHorseman)
      {
         man.MAX_HP += 5 * skill_lv;
         man.HP = man.MAX_HP;
         man.DEF += skill_lv;
      }
   }
   static function passive_Infantry_2(man, skill_lv)
   {
      if(!man.isHorseman)
      {
         man.wpnPri.dmg += Math.round(man.wpnPri.dmg * skill_lv * 0.02);
         man.wpnPri.rnd += Math.round(man.wpnPri.rnd * skill_lv * 0.02);
      }
   }
   static function passive_Infantry_3(man, skill_lv)
   {
      if(!man.isHorseman)
      {
         man.wpnPri.HIT += skill_lv;
         man.DODGE += skill_lv;
      }
   }
   static function passive_Horsemen_1(man, skill_lv)
   {
      if(man.isHorseman)
      {
         man.speed += skill_lv / 2;
         man.DODGE += skill_lv * 2;
      }
   }
   static function passive_Horsemen_2(man, skill_lv)
   {
      if(man.isHorseman)
      {
         man.DEF += 3 * skill_lv;
         man.MAX_HP += 10 * skill_lv;
         man.HP = man.MAX_HP;
         if(man.SHIELD_DODGE > 0)
         {
            man.SHIELD_DODGE += skill_lv;
         }
      }
   }
   static function passive_Horsemen_3(man, skill_lv)
   {
      if(man.isHorseman)
      {
         man.wpnPri.HIT += skill_lv * 3;
         man.wpnPri.dmg += Math.round(man.wpnPri.dmg * skill_lv * 0.03);
         man.wpnPri.rnd += Math.round(man.wpnPri.rnd * skill_lv * 0.03);
      }
   }
   static function passive_Swordsmen_1(man, skill_lv)
   {
      if(man.atkAnim == "shield")
      {
         man.MAX_HP += 10 * skill_lv;
         man.HP = man.MAX_HP;
         man.SHIELD_DODGE += skill_lv * 2;
      }
   }
   static function passive_Swordsmen_2(man, skill_lv)
   {
      if(man.atkAnim == "shield")
      {
         man.wpnPri.dmg += Math.round(man.wpnPri.dmg * skill_lv * 0.04);
         man.wpnPri.rnd += Math.round(man.wpnPri.rnd * skill_lv * 0.04);
      }
   }
   static function passive_Swordsmen_3(man, skill_lv)
   {
      if(man.atkAnim == "shield")
      {
         man.wpnPri.HIT += skill_lv * 2;
         man.DODGE += skill_lv * 3;
      }
   }
   static function passive_Meditate(man, skill_lv)
   {
      if(man.unit_ref.NATION == "Jap")
      {
         man.MAX_SP += 10 * skill_lv;
         man.SP = man.MAX_SP;
         man.SPregen *= 1 + 0.2 * skill_lv;
      }
   }
   static function passive_FarEastWarTraining(man, skill_lv)
   {
      if(man.atkAnim == "katana" || man.atkAnim == "staff")
      {
         man.wpnPri.dmg += Math.round(man.wpnPri.dmg * skill_lv * 0.03);
         man.wpnPri.rnd += Math.round(man.wpnPri.rnd * skill_lv * 0.03);
         man.wpnPri.HIT += skill_lv * 2;
      }
   }
   static function passive_AssassinTraining(man, skill_lv)
   {
      if(man.atkAnim == "katar" || man.atkAnim == "dagger")
      {
         man.wpnPri.dmg += Math.round(man.wpnPri.dmg * skill_lv * 0.02);
         man.wpnPri.rnd += Math.round(man.wpnPri.rnd * skill_lv * 0.02);
         man.DODGE += skill_lv * 4;
         man.speed += skill_lv / 2;
      }
   }
   static function passive_BerserkerTraining(man, skill_lv)
   {
      if(man.atkAnim == "2H_axe")
      {
         man.speed += skill_lv / 3;
         man.DODGE += skill_lv;
         man.wpnPri.dmg += Math.round(man.wpnPri.dmg * skill_lv * 0.02);
         man.wpnPri.rnd += Math.round(man.wpnPri.rnd * skill_lv * 0.02);
      }
   }
   static function passive_KungFuSecrets(man, skill_lv)
   {
      if(man.atkAnim == "fists")
      {
         man.wpnPri.dmg += 10 * skill_lv;
         man.wpnPri.HIT += skill_lv * 6;
         man.wpnPri.CRIT += skill_lv * 10;
         man.DODGE += skill_lv * 5;
         man.MAX_HP += 30 * skill_lv;
         man.HP = man.MAX_HP;
      }
   }
   static function passive_FindWeakPoint(man, skill_lv)
   {
      if(man.atkAnim == "katar")
      {
         man.wpnPri.HIT += skill_lv * 4;
         man.wpnPri.CRIT += skill_lv * 6;
      }
   }
   static function getSkillDescription(skill_name, skill_id)
   {
      // (derleyicinin okuyamadığı etiket kaldırıldı)
      switch(skill_name)
      {
         case "shield":
            switch(skill_id)
            {
               case 1:
                  return "Düşmana kalkanınla vur. Hasar karakterin GÜÇ'üne ve kalkanın savunmasına bağlıdır: (GÜÇ + savunma*2)*Sv/2. Ayrıca savunma+2*Sv % ihtimalle hedefi sersemletir.";
               case 2:
                  return "Düşmana 3 hızlı saldırı yap. Her saldırı 50+10*Sv% hasar verir.";
               case 3:
                  return "Kalkanının arkasına saklan ve güvenli bir yerden vur. Bu saldırı yalnızca 40+10*Sv% hasar verir ama saldırırken rakibin vuruşları sana işlemez.";
            }
            break;
         case "2H_sword":
            switch(skill_id)
            {
               case 1:
                  return "İki elli kılıcınla 150+20*Sv% hasar veren güçlü bir darbe.";
               case 2:
                  return "Karakterin önündeki 3 karedeki tüm düşmanlara 100+20*Sv% hasar verir.";
               case 3:
                  return "Karakter sıçrar ve altındaki yere vurur; çevresindeki 3x3 alandaki tüm düşmanlara 100+40*Sv% hasar verir.";
            }
            break;
         case "2H_axe":
            switch(skill_id)
            {
               case 1:
                  return "Düşmanın kafasına vurarak 50+10*Sv% hasar ver; 30+3*Sv% ihtimalle onu sersemletir.";
               case 2:
                  return "Düşmana 200+40*Sv% hasar veren güçlü bir kritik saldırı yap. Ayrıca düşmanın çevresindeki 3x3 alanda (sen hariç) herkesi 2*Sv% ihtimalle sersemletir.";
               case 3:
                  return "Hedefin çevresindeki 3x3 alandaki tüm düşmanlara 100+40*Sv% hasar ver.";
            }
            break;
         case "dual":
            switch(skill_id)
            {
               case 1:
                  return "Her silahla 3 vuruşluk kombo. Her vuruş 40+10*Sv% hasar verir.";
               case 2:
                  return "Karakterin önündeki ve arkasındaki düşmanlara 100+20*Sv% hasar ve 10*Sv% kritik bonusu veren saldırı. Bu saldırı sırasında karaktere isabet ettirmek çok zordur.";
               case 3:
                  return "Sıçra ve düşmana birkaç vuruş indir. Her vuruş 100+30*Sv% hasar verir ve kritik şansı %50'dir.";
            }
            break;
         case "spear":
            switch(skill_id)
            {
               case 1:
                  return "Düşmanın savunmasını delen ve 100+10*Sv% hasar veren vuruş. Bu saldırının kritik şansı her zaman %100'dür.";
               case 2:
                  return "Mızrakla 3 hızlı saldırı; her biri 75+15*Sv% hasar verir ama bu saldırıların kritik oranı 3 kat düşüktür.";
               case 3:
                  return "Karakterin önündeki koni biçimli alandaki tüm düşmanlara 200+40*Sv% hasar ver; kritik şansı yoktur.";
            }
            break;
         case "dagger":
            switch(skill_id)
            {
               case 1:
                  return "Düşmana arkadan vurursan (0,4+0,1*Sv)*SilahKritiği% ihtimalle onu anında öldürürsün. Anında öldürme olmazsa düşman yine de 300+100*Sv% hasar alır. Arkadan saldırmazsan düşman normal hasarın yalnızca %50'sini alır.";
               case 2:
                  return "Her biri 75+15*Sv% hasar veren iki kritik vuruş.";
               case 3:
                  return "Karakter hançerini düşmana fırlatır, sıçrar, hançeri havada yakalar ve yere vurur. Uçan hançer düşmana 3 kez çarpar, her çarpış 50+10*Sv% hasar verir. Yere vuruş, karakterin çevresindeki 5x5 alandaki tüm düşmanlara 50+20*Sv% hasar verir.";
            }
            break;
         case "katana":
            switch(skill_id)
            {
               case 1:
                  return "Karakter sıçrar ve düşmana 150+20*Sv% hasar veren bir vuruş indirir. Bu saldırının kritik oranı da 1+0,2*Sv kat artar.";
               case 2:
                  return "Karakter düşmana tekme atar, sonra kılıçla vurarak 100+30*Sv% hasar verir. Tekmenin hasarı karakterin GÜÇ'üne bağlıdır ve düşmanın saldırılarını yavaşlatır.";
               case 3:
                  return "Hedefin savunmasına göre her zaman kritik hasar veren çok güçlü bir saldırı. Hedefin savunması ne kadar yüksekse o kadar çok hasar alır. Bu beceri her zaman bütün RP'yi harcar; harcanan RP de hasarı etkiler.";
            }
            break;
         case "staff":
            switch(skill_id)
            {
               case 1:
                  return "Düşmana 3 kez vur; her vuruş 100+20*Sv% hasar verir.";
               case 2:
                  return "Karakterin çevresindeki 7x7 alandaki tüm düşmanlara 50+10*Sv% hasar verir.";
               case 3:
                  return "10 vuruşluk kombo; her vuruş 50+10*Sv% hasar verir.";
            }
            break;
         case "katar":
            switch(skill_id)
            {
               case 1:
                  return "200+30*Sv% hasar veren hızlı vuruş. Düşmanı zehirleme ihtimali de vardır.";
               case 2:
                  return "4 kritik vuruşluk kombinasyon (her elle 2 vuruş). Her vuruş 100+10*Sv% hasar verir.";
               case 3:
                  return "Karakterin çevresindeki tüm düşmanlara 200+40*Sv% kritik olmayan hasar ver.";
            }
            break;
         case "bow":
            switch(skill_id)
            {
               case 1:
                  return "Tek atışta iki ok fırlatarak 120+20*Sv% hasar ver.";
               case 2:
                  return "Farklı hedeflere 3 atış; her biri 50+20*Sv% hasar verir.";
               case 3:
                  return "Hedefin çevresindeki 3x3 alana dokuz ok atar. Her ok 50+10*Sv% hasar verir.";
            }
            break;
         case "crossbow":
            switch(skill_id)
            {
               case 1:
                  return "150+50*Sv% hasar veren (kritik şansı olmayan) ve hedefi 10*Sv% ihtimalle sersemleten güçlü atış.";
               case 2:
                  return "Karakter düşmanı tam kafasından vurarak 220+20*Sv% hasar verir. Bu saldırı her zaman kritiktir.";
               case 3:
                  return "Aynı sıradaki en fazla 3 düşmanı delip geçen çok güçlü bir ok at. İlk düşman 160+20*Sv% hasar alır, sonrakilerin hasarı %30 azalır. Bu saldırı her zaman kritiktir.";
            }
            break;
         case "throwing":
            switch(skill_id)
            {
               case 1:
                  return "Yakındaki 3 hedefe 3 bıçak, şuriken ya da balta fırlat. Her atış 90+10*Sv% hasar verir.";
               case 2:
                  return "Tek hedefe 3 atış; her biri 50+10*Sv% hasar verir.";
               case 3:
                  return "Birden çok düşmana çarpan seken bir bıçak, balta ya da şuriken fırlat. Bıçak en fazla Sv kez seker.";
               default:
                  return "No such skill for " + skill_name + skill_id;
            }
         case "fists":
            return "[No skill description for fists]";
         case "Bowmen_1":
            return "Menzilli birliklerin isabet şansını 3*Sv% artırır.";
         case "Bowmen_2":
            return "Menzilli birliklerin kritik vuruş şansını 2*Sv%, menzilini Sv kare artırır.";
         case "Bowmen_3":
            return "Menzilli birliklerin hasarını 4*Sv% artırır.";
         case "Infantry_1":
            return "Tüm piyade birliklerinin canını 5*Sv puan, savunmasını Sv puan artırır.";
         case "Infantry_2":
            return "Tüm piyade birliklerinin hasarını 2*Sv% artırır.";
         case "Infantry_3":
            return "Tüm piyade birliklerinin isabet ve kaçınma şansını Sv% artırır.";
         case "Horsemen_1":
            return "Tüm atlı birliklerin kaçınma şansını 2*Sv% artırır ve hareket hızlarını Sv'ye göre çok artırır.";
         case "Horsemen_2":
            return "Tüm atlı birliklerin canını 10*Sv puan, savunmasını 3*Sv puan ve (kalkanları varsa) kalkanla engelleme şansını Sv% artırır.";
         case "Horsemen_3":
            return "Tüm atlı birliklerin isabet şansını ve hasarını 3*Sv% artırır.";
         case "Swordsmen_1":
            return "Tek elli kılıç, balta ya da topuz taşıyan tüm birliklerin canını 10*Sv puan, kalkanla engelleme şansını Sv% artırır. Kalkanı olmayan birliğin de engelleme şansı artar. Çift silah taşıyan birliklerde işe YARAMAZ.";
         case "Swordsmen_2":
            return "Tek elli kılıç, balta ya da topuz taşıyan tüm birliklerin hasarını 4*Sv% artırır. Çift silah taşıyan birliklerde işe YARAMAZ.";
         case "Swordsmen_3":
            return "Tek elli kılıç, balta ya da topuz taşıyan tüm birliklerin isabet şansını 2*Sv%, kaçınma şansını 3*Sv% artırır. Çift silah taşıyan birliklerde işe YARAMAZ.";
         case "Meditate":
            return "Tüm Doğu İmparatorluğu birliklerinin (Japon tarzı birlikler) RP'sini 10*Sv puan, RP yenilenme hızını 20*Sv% artırır.";
         case "FarEastWarTraining":
            return "Katana, asa ya da ninja-to taşıyan tüm birliklerin isabet şansını 2*Sv%, hasarını 3*Sv% artırır. Çift ninja-to taşıyan birliklerde işe YARAMAZ.";
         case "AssassinTraining":
            return "Hançer ya da katar taşıyan tüm birliklerin kaçınma şansını 4*Sv%, hasarını 2*Sv% artırır. Hareket hızlarını da Sv'ye göre çok artırır.";
         case "BerserkerTraining":
            return "İki elli balta ya da topuz taşıyan tüm birliklerin kaçınma şansını Sv%, hasarını 2*Sv% artırır. Hareket hızlarını da Sv'ye göre artırır.";
         case "KungFuSecrets":
            return "Silahsız tüm birliklerin hasarını 10*Sv puan, isabet şansını 6*Sv%, kritik vuruş şansını 10*Sv%, kaçınma şansını 5*Sv% ve canını 30*Sv puan artırır.";
         case "FindWeakPoint":
            return "Katar taşıyan tüm birliklerin isabet şansını 4*Sv%, kritik vuruş şansını 6*Sv% artırır.";
      }
      return "No such skill for " + skill_name + skill_id;
   }
}
