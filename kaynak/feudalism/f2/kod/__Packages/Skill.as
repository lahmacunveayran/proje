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
      loop0:
      switch(skill_name)
      {
         case "shield":
            switch(skill_id)
            {
               case 1:
                  return "Shield Charge";
               case 2:
                  return "Triple Attack";
               case 3:
                  return "Guarded Attack";
            }
            break;
         case "2H_sword":
            switch(skill_id)
            {
               case 1:
                  return "Mighty blow";
               case 2:
                  return "Blast Wave";
               case 3:
                  return "Smashing Jump";
            }
            break;
         case "2H_axe":
            switch(skill_id)
            {
               case 1:
                  return "Stunning Hit";
               case 2:
                  return "Berserk Smash";
               case 3:
                  return "Mad Hit";
            }
            break;
         case "dual":
            switch(skill_id)
            {
               case 1:
                  return "Bladestorm";
               case 2:
                  return "Salto";
               case 3:
                  return "Double Jump";
            }
            break;
         case "spear":
            switch(skill_id)
            {
               case 1:
                  return "Pierce";
               case 2:
                  return "Fury of Blows";
               case 3:
                  return "Burning Spear";
            }
            break;
         case "dagger":
            switch(skill_id)
            {
               case 1:
                  return "Backstab";
               case 2:
                  return "Double Crit";
               case 3:
                  return "Dagger Boomerang";
            }
            break;
         case "katana":
            switch(skill_id)
            {
               case 1:
                  return "Windy Strike";
               case 2:
                  return "Kick";
               case 3:
                  return "Guillotine Blade";
            }
            break;
         case "staff":
            switch(skill_id)
            {
               case 1:
                  return "Fast Combo";
               case 2:
                  return "Light Pillar";
               case 3:
                  return "Thunder Assault";
            }
            break;
         case "katar":
            switch(skill_id)
            {
               case 1:
                  return "Shadow Strike";
               case 2:
                  return "Crit Combo";
               case 3:
                  return "Meteor Strike";
            }
            break;
         case "bow":
            switch(skill_id)
            {
               case 1:
                  return "Double Shot";
               case 2:
                  return "Quick Shooting";
               case 3:
                  return "Arrow Rain";
            }
            break;
         case "crossbow":
            switch(skill_id)
            {
               case 1:
                  return "Stunning Shot";
               case 2:
                  return "Headshot";
               case 3:
                  return "Piercing Shot";
            }
            break;
         case "throwing":
            switch(skill_id)
            {
               case 1:
                  return "Multithrow";
               case 2:
                  return "Fast Throwing";
               case 3:
                  return "Ricochette";
               default:
                  break loop0;
            }
         case "fists":
            return "[No skillname for fists]";
         case "Bowmen_1":
            return "Marksmen Training";
         case "Bowmen_2":
            return "Eagle Eyes";
         case "Bowmen_3":
            return "Sharp Arrows";
         case "Infantry_1":
            return "Infantry Defense Mastery";
         case "Infantry_2":
            return "Infantry Offense Mastery";
         case "Infantry_3":
            return "Infantry Weapon Mastery";
         case "Horsemen_1":
            return "Horsemen Riding Mastery";
         case "Horsemen_2":
            return "Horsemen Defense Mastery";
         case "Horsemen_3":
            return "Horsemen Battle Mastery";
         case "Swordsmen_1":
            return "Footmen Defense Mastery";
         case "Swordsmen_2":
            return "Footmen Offense Mastery";
         case "Swordsmen_3":
            return "Footmen Weapon Mastery";
         case "Meditate":
            return "Meditation";
         case "FarEastWarTraining":
            return "Far East War Arts";
         case "AssassinTraining":
            return "Assassination Mastery";
         case "BerserkerTraining":
            return "Berserkers\' Fury";
         case "KungFuSecrets":
            return "Kung-Fu Secrets";
         case "FindWeakPoint":
            return "Find Weak Point";
      }
      return "No such skill for " + skill_name + skill_id;
   }
   static function getSkilltypeDescr(skill_name)
   {
      switch(skill_name)
      {
         case "shield":
            return "One handed weapon & shield moves";
         case "2H_sword":
            return "Two handed sword moves";
         case "2H_axe":
            return "Two handed mace and axe moves";
         case "dual":
            return "Dual weapons moves";
         case "spear":
            return "Spear moves";
         case "dagger":
            return "Dagger moves";
         case "katana":
            return "Katana moves";
         case "staff":
            return "Staff moves";
         case "katar":
            return "Katar moves";
         case "bow":
            return "Bow moves";
         case "crossbow":
            return "Crossbow moves";
         case "throwing":
            return "Throwing weapons moves";
         default:
            return "[no such skill type]";
      }
   }
   static function getCostSP(atk_anim, skill_id)
   {
      loop0:
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
                  break loop0;
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
      loop0:
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
                  break loop0;
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
            return "Horsemen Defense Mastery";
         case "Horsemen_3":
            return "Horsemen Battle Mastery";
         case "Swordsmen_1":
            return "Footmen Defense Mastery";
         case "Swordsmen_2":
            return "Footmen Offense Mastery";
         case "Swordsmen_3":
            return "Footmen Weapon Mastery";
         case "Meditate":
            return "Meditation";
         case "FarEastWarTraining":
            return "Far East War Arts";
         case "AssassinTraining":
            return "Assassination Mastery";
         case "BerserkerTraining":
            return "Berserkers\' Fury";
         case "KungFuSecrets":
            return "Kung-Fu Secrets";
         case "FindWeakPoint":
            return "Find Weak Point";
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
      loop0:
      switch(skill_name)
      {
         case "shield":
            switch(skill_id)
            {
               case 1:
                  return "Hit an enemy with your shield. The damage depends on character’s STR and shield defense and calculated as (STR + defense*2)*SkillLv/2. There’s also a defense+2*SkillLv % chance to stun the target.";
               case 2:
                  return "Hit an enemy with 3 fast attacks. Each attack deals 50+10*SkillLv% damage.";
               case 3:
                  return "Hide behind the shield and strike from a safe position. This attack deals only 40+10*SkillLv% damage, but you’re invincible for opponent’s strikes while attacking.";
            }
            break;
         case "2H_sword":
            switch(skill_id)
            {
               case 1:
                  return "A powerful smash that deals 150+20*SkillLv% damage with your two handed sword.";
               case 2:
                  return "Deals 100+20*SkillLv% damage to all enemies in 3 cells in front of character.";
               case 3:
                  return "Character jumps and blows ground below him, dealing 100+40*SkillLv% damage to all enemies in 3x3 area around him.";
            }
            break;
         case "2H_axe":
            switch(skill_id)
            {
               case 1:
                  return "Hit an enemy in the head dealing 50+10*SkillLv% damage and stunning him with 30+3*SkillLv% chance.";
               case 2:
                  return "Hit an enemy with powerful critical attack for 200+40*SkillLv% damage. There’s also a 2*SkillLv% chance of stunning everyone (except you) in 3x3 area around the enemy.";
               case 3:
                  return "Deal 100+40*SkillLv% damage to all enemies in 3x3 area around the target.";
            }
            break;
         case "dual":
            switch(skill_id)
            {
               case 1:
                  return "A combo of 3 hits with each weapon. Each hit deals 40+10*SkillLv% damage.";
               case 2:
                  return "Attack that deals 100+20*SkillLv% damage with 10*SkillLv% crit bonus to enemies in front of character and behind him. Character is very hard to be hit while doing this attack.";
               case 3:
                  return "Jump and hit an enemy with several strikes. Each strike deals 100+30*SkillLv% damage and has 50% critical chance.";
            }
            break;
         case "spear":
            switch(skill_id)
            {
               case 1:
                  return "Strike which pierces enemy’s defense dealing100+10*SkillLv% damage. This attack always has 100% critical chance.";
               case 2:
                  return "3 fast attacks with spear, each attack deals 75+15*SkillLv% damage, but critrate of these attacks is 3 times lower.";
               case 3:
                  return "Hit all enemies in a cone in front of the character for 200+40*SkillLv% damage, but without critical chance.";
            }
            break;
         case "dagger":
            switch(skill_id)
            {
               case 1:
                  return "If you hit an enemy from behind, there’s a (0.4+0.1*SkillLv)*WeaponCrit% chance of instantly killing him. If instant kill fails, enemy still receives 300+100*SkillLv% damage. If you attack not from behind, enemy will get only 50% of normal damage.";
               case 2:
                  return "Two critical strikes, for 75+15*SkillLv% damage each.";
               case 3:
                  return "Character throws his dagger at enemy, then jumps, catches the dagger in the air and hits the ground. Flying dagger hits the enemy 3 times, each hit deals 50+10*SkillLv% damage. The ground hit damages all enemies in 5x5 area around the character for 50+20*SkillLv%.";
            }
            break;
         case "katana":
            switch(skill_id)
            {
               case 1:
                  return "Character jumps and hits the enemy for 150+20*SkillLv% damage. Critical rate of this attack is also increased in 1+0.2*SkillLv times.";
               case 2:
                  return "Character kicks an enemy and then hits him with the sword for 100+30*SkillLv% damage. The kick itself deals damage depending on character’s STR and slows enemies’ attacks.";
               case 3:
                  return "A very powerful attack which always deals critical damage depending on target’s defense. The more defense has the target, the more damage it will receive. This skill always consumes all SP. Amount of consumed SP affect the damage too.";
            }
            break;
         case "staff":
            switch(skill_id)
            {
               case 1:
                  return "Hit an enemy 3 times, each hit deals 100+20*SkillLv% damage.";
               case 2:
                  return "Hits all enemies in 7x7 area around the character for 50+10*SkillLv% damage.";
               case 3:
                  return "Combo of 10 hits, each hit deals 50+10*SkillLv% damage.";
            }
            break;
         case "katar":
            switch(skill_id)
            {
               case 1:
                  return "Fast strike that deals 200+30*SkillLv% damage. There’s also a chance to poison the enemy.";
               case 2:
                  return "Combination of 4 critical hits (2 hits per hand). Each hit deals 100+10*SkillLv% damage.";
               case 3:
                  return "Hit all enemies around the character for 200+40*SkillLv% non-critical damage.";
            }
            break;
         case "bow":
            switch(skill_id)
            {
               case 1:
                  return "Shoot two arrows with one shot to deal 120+20*SkillLv% damage.";
               case 2:
                  return "3 shots at different targets, 50+20*SkillLv% damage each.";
               case 3:
                  return "Shots nine arrows attacking 3x3 area around the target. Each arrow deals 50+10*SkillLv% damage.";
            }
            break;
         case "crossbow":
            switch(skill_id)
            {
               case 1:
                  return "Strong shot that deals 150+50*SkillLv% damage (with no crit chance) and has 10*SkillLv% chance to stun the target.";
               case 2:
                  return "Character hits the enemy right in the head dealing 220+20*SkillLv% damage. This attack is always critical.";
               case 3:
                  return "Shot a very powerful arrow that will pierce up to 3 enemies in line. The first enemy will receive 160+20*SkillLv% damage, damage for the next enemies will be reduced for 30%. This attack is always critical.";
            }
            break;
         case "throwing":
            switch(skill_id)
            {
               case 1:
                  return "Throw 3 knives, surikens or axes at 3 nearby targets. Each throw deals 90+10*SkillLv% damage.";
               case 2:
                  return "3 throws at one target 50+10*SkillLv% damage each.";
               case 3:
                  return "Throw a ricocheting knife, axe or suriken which will hit multiple enemies. The knife will ricochet up to SkillLv times.";
               default:
                  break loop0;
            }
         case "fists":
            return "[No skill description for fists]";
         case "Bowmen_1":
            return "Increases ranged units’ hit chance by 3*SkillLv%.";
         case "Bowmen_2":
            return "Increases ranged units’ critical hit chance by 2*SkillLv% and range by SkillLv tiles.";
         case "Bowmen_3":
            return "Increases ranged units’ damage by 4*SkillLv%.";
         case "Infantry_1":
            return "Increases all infantry units’ HP by 5*SkillLv points and defense by SkillLv points.";
         case "Infantry_2":
            return "Increases all infantry units’ damage by 2*SkillLv%.";
         case "Infantry_3":
            return "Increases all infantry units’ hit and dodge chances by SkillLv%.";
         case "Horsemen_1":
            return "Increases all mounted units’ dodge chance by 2*SkillLv% and greatly increases their movement speed depending on SkillLv.";
         case "Horsemen_2":
            return "Increases all mounted units’ HP by 10*SkillLv points, defense by 3*SkillLv points and chance to block attack with the shield (if unit have one) by SkillLv%.";
         case "Horsemen_3":
            return "Increases all mounted units’ hit chance and damage by 3*SkillLv%.";
         case "Swordsmen_1":
            return "Increases HP by 10*SkillLv points and chance to block attack with the shield by SkillLv% of all units armed with one handed swords, axes or maces. If unit doesn’t have a shield his block chance still will be increased. Does NOT work for units armed with dual weapons.";
         case "Swordsmen_2":
            return "Increases damage by 4*SkillLv% of all units armed with one handed swords, axes or maces. Does NOT work for units armed with dual weapons.";
         case "Swordsmen_3":
            return "Increases hit chance by 2*SkillLv% and dodge chance by 3*SkillLv% of all units armed with one handed swords, axes or maces. Does NOT work for units armed with dual weapons.";
         case "Meditate":
            return "Increases SP by 10*SkillLv points and SP regeneration rate by 20*SkillLv% of all East Empire’s (e.g. Japanese-like) units.";
         case "FarEastWarTraining":
            return "Increases hit chance by 2*SkillLv% and damage by 3*SkillLv% of all units armed with katana, staffs or ninja-to. Does NOT work for units armed with dual ninja-to.";
         case "AssassinTraining":
            return "Increases dodge chance by 4*SkillLv% and damage by 2*SkillLv% of all units armed with daggers or katars. Also greatly increases their movement speed depending on SkillLv.";
         case "BerserkerTraining":
            return "Increases dodge chance by SkillLv% and damage by 2*SkillLv% of all units armed with two handed axes or maces. Also increases their movement speed depending on SkillLv.";
         case "KungFuSecrets":
            return "Increases damage by 10*SkillLv points, hit chance by 6*SkillLv%, critical strike chance by 10*SkillLv%, dodge chance by 5*SkillLv% and HP by 30*SkillLv points of all unarmed units.";
         case "FindWeakPoint":
            return "Increases hit chance by 4*SkillLv% and critical strike chance by 6*SkillLv% of all units armed with katars.";
      }
      return "No such skill for " + skill_name + skill_id;
   }
}
