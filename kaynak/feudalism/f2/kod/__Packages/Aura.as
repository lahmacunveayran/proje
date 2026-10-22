class Aura
{
   var TYPE;
   var back_ref;
   var caster;
   var skill_lv;
   var sp_cost;
   function Aura(aura_id, lv, cstr, br)
   {
      this.TYPE = aura_id;
      this.caster = cstr;
      this.skill_lv = lv;
      this.back_ref = br;
      this.sp_cost = Aura.getCostSP(this.TYPE);
   }
   static function getName(aura_id)
   {
      switch(aura_id)
      {
         case "Devotion":
            return "Devotion";
         case "DivineHelp":
            return "Divine Help";
         case "Barrier":
            return "Barrier";
         case "Sacrifice":
            return "Sacrifice";
         case "ForceBalance":
            return "Balance of Force";
         case "VenomCloud":
            return "Venom Cloud";
         case "HolyTribunal":
            return "Holy Tribunal";
         case "UnholyBreath":
            return "Unholy Breath";
         case "LifeLeech":
            return "Life Leech";
         case "SoulDrain":
            return "Soul Drain";
         case "Healing":
            return "Healing";
         case "BansheeCry":
            return "Banshee Cry";
         case "NationViz":
            return "Sign of Trade Republic";
         case "NationGer":
            return "Sign of Holy Order";
         case "NationRus":
            return "Sign of Forest Lands";
         case "NationJap":
            return "Sign of East Empire";
         case "NationMon":
            return "Sign of Black Horde";
         case "NationAra":
            return "Sign of South Desert";
         default:
            return;
      }
   }
   static function getCostSP(aura_id)
   {
      switch(aura_id)
      {
         case "Devotion":
            return 10;
         case "DivineHelp":
            return 10;
         case "Barrier":
            return 15;
         case "Sacrifice":
            return 15;
         case "ForceBalance":
            return 18;
         case "VenomCloud":
            return 10;
         case "HolyTribunal":
            return 15;
         case "UnholyBreath":
            return 30;
         case "LifeLeech":
            return 20;
         case "SoulDrain":
            return 0;
         case "Healing":
            return 8;
         case "BansheeCry":
            return 5;
         case "NationViz":
            return 20;
         case "NationGer":
            return 20;
         case "NationRus":
            return 20;
         case "NationJap":
            return 20;
         case "NationMon":
            return 20;
         case "NationAra":
            return 20;
         default:
            return;
      }
   }
   static function getFrame(aura_id)
   {
      var _loc1_ = 60;
      switch(aura_id)
      {
         case "Devotion":
            return _loc1_;
         case "DivineHelp":
            return _loc1_ + 1;
         case "Barrier":
            return _loc1_ + 2;
         case "Sacrifice":
            return _loc1_ + 3;
         case "ForceBalance":
            return _loc1_ + 4;
         case "VenomCloud":
            return _loc1_ + 5;
         case "HolyTribunal":
            return _loc1_ + 6;
         case "UnholyBreath":
            return _loc1_ + 7;
         case "LifeLeech":
            return _loc1_ + 8;
         case "SoulDrain":
            return _loc1_ + 9;
         case "Healing":
            return _loc1_ + 10;
         case "BansheeCry":
            return _loc1_ + 11;
         case "NationViz":
            return _loc1_ + 12;
         case "NationGer":
            return _loc1_ + 13;
         case "NationRus":
            return _loc1_ + 14;
         case "NationJap":
            return _loc1_ + 15;
         case "NationMon":
            return _loc1_ + 16;
         case "NationAra":
            return _loc1_ + 17;
         default:
            return;
      }
   }
   function operate(team0, team1)
   {
      if(this.caster.HP <= 0)
      {
         return false;
      }
      if(this.caster.SP < this.sp_cost)
      {
         return false;
      }
      this.caster.SP -= this.sp_cost;
      if(this["aura_" + this.TYPE])
      {
         if(this.caster.team == 0)
         {
            this["aura_" + this.TYPE](team0,team1);
         }
         else
         {
            this["aura_" + this.TYPE](team1,team0);
         }
      }
      return true;
   }
   function aura_Devotion(friends, enemies)
   {
      var _loc2_ = 0;
      while(_loc2_ < friends.length)
      {
         friends[_loc2_].healHP(7 * this.skill_lv);
         _loc2_ = _loc2_ + 1;
      }
   }
   function aura_DivineHelp(friends, enemies)
   {
      var _loc2_ = 0;
      while(_loc2_ < friends.length)
      {
         if(friends[_loc2_].HP < friends[_loc2_].MAX_HP)
         {
            friends[_loc2_].healHP(50 * this.skill_lv);
            this.caster.attachMovie("StarsAnim","anim",1);
            break;
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function aura_Barrier(friends, enemies)
   {
      var _loc3_ = _root.dice(friends.length - 1);
      friends[_loc3_].HP += 30 * this.skill_lv;
      friends[_loc3_].attachMovie("BarrierAnim","anim",1);
   }
   function aura_Sacrifice(friends, enemies)
   {
      var _loc2_ = 0;
      while(_loc2_ < friends.length)
      {
         friends[_loc2_].healHP(100 * this.skill_lv);
         _loc2_ = _loc2_ + 1;
      }
      this.caster.takeDamage(new DamageData(null,0.19 * this.caster.MAX_HP,100,100),false);
   }
   function aura_ForceBalance(friends, enemies)
   {
      var _loc2_ = 0;
      while(_loc2_ < friends.length)
      {
         friends[_loc2_].healHP(Math.round(0.01 * this.skill_lv * friends[_loc2_].MAX_HP));
         _loc2_ = _loc2_ + 1;
      }
      _loc2_ = 0;
      var _loc4_;
      while(_loc2_ < enemies.length)
      {
         _loc4_ = Math.round(0.01 * this.skill_lv * enemies[_loc2_].MAX_HP);
         if(enemies[_loc2_].HP > _loc4_)
         {
            enemies[_loc2_].takeDamage(new DamageData(null,_loc4_,100,100),false);
         }
         _loc2_ = _loc2_ + 1;
      }
      this.caster.attachMovie("BalanceAnim","anim",1);
   }
   function aura_VenomCloud(friends, enemies)
   {
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < this.skill_lv)
      {
         _loc4_ = _root.dice(enemies.length - 1);
         enemies[_loc4_].addStatus(new Status("Poison",5));
         _loc3_ = _loc3_ + 1;
      }
      this.caster.attachMovie("VenomCluodAnim","anim",1);
   }
   function aura_HolyTribunal(friends, enemies)
   {
      var _loc3_ = _root.dice(enemies.length - 1);
      enemies[_loc3_].attachMovie("LightningAnim","anim",1);
      enemies[_loc3_].anim._xscale *= 2;
      enemies[_loc3_].anim._yscale *= 2;
      enemies[_loc3_].takeDamage(new DamageData(null,50 * this.skill_lv,100,100),false);
   }
   function aura_UnholyBreath(friends, enemies)
   {
      var _loc3_ = 0;
      while(_loc3_ < enemies.length)
      {
         if(_root.percent(3))
         {
            enemies[_loc3_].addMessage(enemies[_loc3_].MAX_HP,"FlyDamage");
            enemies[_loc3_].die();
            return undefined;
         }
         if(_root.percent(this.skill_lv * 2))
         {
            enemies[_loc3_].addStatus(new Status("Poison",5));
         }
         if(_root.percent(this.skill_lv * 2))
         {
            enemies[_loc3_].addStatus(new Status("Stun",5));
         }
         if(_root.percent(this.skill_lv * 2))
         {
            enemies[_loc3_].addStatus(new Status("Chaos",5));
         }
         _loc3_ = _loc3_ + 1;
      }
      this.caster.attachMovie("UnholyBreathAnim","anim",1);
   }
   function aura_LifeLeech(friends, enemies)
   {
      if(friends.length == 0)
      {
         return undefined;
      }
      var _loc2_ = 0;
      while(_loc2_ < friends.length)
      {
         friends[_loc2_].HP -= Math.round(0.2 * friends[_loc2_].MAX_HP);
         if(friends[_loc2_].HP <= 0)
         {
            friends[_loc2_].HP = 1;
         }
         friends[_loc2_].attachMovie("LifeLeechAnim","anim",1);
         friends[_loc2_].redrawHealthBar();
         _loc2_ = _loc2_ + 1;
      }
      this.caster.healHP(0.05 * this.skill_lv * this.caster.MAX_HP);
   }
   function aura_SoulDrain(friends, enemies)
   {
      if(friends.length == 0)
      {
         return undefined;
      }
      var _loc2_ = 0;
      while(_loc2_ < friends.length)
      {
         friends[_loc2_].HP -= Math.round(0.2 * friends[_loc2_].MAX_HP);
         if(friends[_loc2_].HP <= 0)
         {
            friends[_loc2_].HP = 1;
         }
         friends[_loc2_].attachMovie("SoulDrainAnim","anim",1);
         friends[_loc2_].redrawHealthBar();
         _loc2_ = _loc2_ + 1;
      }
      this.caster.SP += Math.round(0.04 * this.skill_lv * this.caster.MAX_SP);
      if(this.caster.SP > this.caster.MAX_SP)
      {
         this.caster.SP = this.caster.MAX_SP;
      }
   }
   function aura_Healing(friends, enemies)
   {
      this.caster.healHP(15 * this.skill_lv);
   }
   function aura_BansheeCry(friends, enemies)
   {
      var _loc2_ = 0;
      while(_loc2_ < enemies.length)
      {
         enemies[_loc2_].takeDamage(new DamageData(null,15 * this.skill_lv,100,100),false);
         _loc2_ = _loc2_ + 1;
      }
      this.caster.attachMovie("BansheeCryAnim","anim",1);
      this.caster.takeDamage(new DamageData(null,0.19 * this.caster.MAX_HP,100,100),false);
   }
   function aura_NationViz(friends, enemies)
   {
      var _loc2_ = 0;
      while(_loc2_ < friends.length)
      {
         if(friends[_loc2_].unit_ref.NATION == "Viz")
         {
            friends[_loc2_].healHP(Math.round(0.02 * this.skill_lv * friends[_loc2_].MAX_HP));
         }
         else
         {
            friends[_loc2_].HP -= Math.round(0.02 * this.skill_lv * friends[_loc2_].MAX_HP);
            if(friends[_loc2_].HP <= 0)
            {
               friends[_loc2_].HP = 1;
            }
            friends[_loc2_].redrawHealthBar();
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function aura_NationGer(friends, enemies)
   {
      var _loc2_ = 0;
      while(_loc2_ < friends.length)
      {
         if(friends[_loc2_].unit_ref.NATION == "Ger")
         {
            friends[_loc2_].healHP(Math.round(0.02 * this.skill_lv * friends[_loc2_].MAX_HP));
         }
         else
         {
            friends[_loc2_].HP -= Math.round(0.02 * this.skill_lv * friends[_loc2_].MAX_HP);
            if(friends[_loc2_].HP <= 0)
            {
               friends[_loc2_].HP = 1;
            }
            friends[_loc2_].redrawHealthBar();
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function aura_NationRus(friends, enemies)
   {
      var _loc2_ = 0;
      while(_loc2_ < friends.length)
      {
         if(friends[_loc2_].unit_ref.NATION == "Rus")
         {
            friends[_loc2_].healHP(Math.round(0.02 * this.skill_lv * friends[_loc2_].MAX_HP));
         }
         else
         {
            friends[_loc2_].HP -= Math.round(0.02 * this.skill_lv * friends[_loc2_].MAX_HP);
            if(friends[_loc2_].HP <= 0)
            {
               friends[_loc2_].HP = 1;
            }
            friends[_loc2_].redrawHealthBar();
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function aura_NationJap(friends, enemies)
   {
      var _loc2_ = 0;
      while(_loc2_ < friends.length)
      {
         if(friends[_loc2_].unit_ref.NATION == "Jap")
         {
            friends[_loc2_].healHP(Math.round(0.02 * this.skill_lv * friends[_loc2_].MAX_HP));
         }
         else
         {
            friends[_loc2_].HP -= Math.round(0.02 * this.skill_lv * friends[_loc2_].MAX_HP);
            if(friends[_loc2_].HP <= 0)
            {
               friends[_loc2_].HP = 1;
            }
            friends[_loc2_].redrawHealthBar();
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function aura_NationMon(friends, enemies)
   {
      var _loc2_ = 0;
      while(_loc2_ < friends.length)
      {
         if(friends[_loc2_].unit_ref.NATION == "Mon")
         {
            friends[_loc2_].healHP(Math.round(0.02 * this.skill_lv * friends[_loc2_].MAX_HP));
         }
         else
         {
            friends[_loc2_].HP -= Math.round(0.02 * this.skill_lv * friends[_loc2_].MAX_HP);
            if(friends[_loc2_].HP <= 0)
            {
               friends[_loc2_].HP = 1;
            }
            friends[_loc2_].redrawHealthBar();
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function aura_NationAra(friends, enemies)
   {
      var _loc2_ = 0;
      while(_loc2_ < friends.length)
      {
         if(friends[_loc2_].unit_ref.NATION == "Ara")
         {
            friends[_loc2_].healHP(Math.round(0.02 * this.skill_lv * friends[_loc2_].MAX_HP));
         }
         else
         {
            friends[_loc2_].HP -= Math.round(0.02 * this.skill_lv * friends[_loc2_].MAX_HP);
            if(friends[_loc2_].HP <= 0)
            {
               friends[_loc2_].HP = 1;
            }
            friends[_loc2_].redrawHealthBar();
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   static function getDescription(aura_id)
   {
      switch(aura_id)
      {
         case "Devotion":
            return "Heals all friendly units for 7*SkillLv HP every second.";
         case "DivineHelp":
            return "Heals random injured unit for 50*SkillLv HP every second.";
         case "Barrier":
            return "Adds 30*SkillLv HP to random friendly unit every second. This bonus HP can even go higher than unit’s max HP.";
         case "Sacrifice":
            return "Caster looses 20% of his max HP every second and heals all friendly units for 100*SkillLv HP every second. Warning: this aura CAN kill the caster.";
         case "ForceBalance":
            return "All friendly units recover SkillLv% of their max HP every second and all enemy units loose SkillLv% of their max HP every second. This aura cannot kill enemy units: they will have at least 1 HP.";
         case "VenomCloud":
            return "Poison SkillLv enemies every second. Poison status lasts 5 seconds. Poisoned unit looses 5% of max HP every second, but cannot die from poison.";
         case "HolyTribunal":
            return "Deals 50*SkillLv damage to random enemy every second. This damage is always critical and cannot be avoided.";
         case "UnholyBreath":
            return "Gives 2*SkillLv% chance of poisoning, stunning or making mad all enemy units every second. All statuses last 5 seconds. Mad unit attacks nearest character, friend or foe, and is attacked by his own allies. There’s also a 3% chance to instantly kill a unit.";
         case "LifeLeech":
            return "All FRIENDLY units loose 20% of their max HP and caster recovers 5*SkillLv% of his/her max HP every second. This aura cannot kill friendly units, but doesn’t work when there’re no friendly units anymore.";
         case "SoulDrain":
            return "All FRIENDLY units loose 20% of their max HP and caster recovers 4*SkillLv% of his/her max SP every second. This aura cannot kill friendly units, but doesn’t work when there’re no friendly units anymore.";
         case "Healing":
            return "Heals caster for 15*SkillLv HP every second.";
         case "BansheeCry":
            return "Every second caster sacrifices 20% of his max HP to deal 15*SkillLv damage to every of his enemies. Neither enemies nor caster can avoid this damage and it’s always critical. Warning: this aura CAN kill the caster.";
         case "NationViz":
            return "Heals all Trade Republic’s units for 2*SkillLv% of their max HP, but other units suffer damage of 2*SkillLv% of their max HP (but this damage cannot kill them). This aura works only for friendly units.";
         case "NationGer":
            return "Heals all Holy Order’s units for 2*SkillLv% of their max HP, but other units suffer damage of 2*SkillLv% of their max HP (but this damage cannot kill them). This aura works only for friendly units.";
         case "NationRus":
            return "Heals all Forest Lands’ units for 2*SkillLv% of their max HP, but other units suffer damage of 2*SkillLv% of their max HP (but this damage cannot kill them). This aura works only for friendly units.";
         case "NationJap":
            return "Heals all East Empire’s units for 2*SkillLv% of their max HP, but other units suffer damage of 2*SkillLv% of their max HP (but this damage cannot kill them). This aura works only for friendly units.";
         case "NationMon":
            return "Heals all Black Horde’s units for 2*SkillLv% of their max HP, but other units suffer damage of 2*SkillLv% of their max HP (but this damage cannot kill them). This aura works only for friendly units.";
         case "NationAra":
            return "Heals all South Desert Clan’s units for 2*SkillLv% of their max HP, but other units suffer damage of 2*SkillLv% of their max HP (but this damage cannot kill them). This aura works only for friendly units.";
         default:
            return;
      }
   }
}
