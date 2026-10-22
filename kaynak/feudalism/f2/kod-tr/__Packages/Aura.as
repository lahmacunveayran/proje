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
            return "Adanmışlık";
         case "DivineHelp":
            return "İlahi Yardım";
         case "Barrier":
            return "Bariyer";
         case "Sacrifice":
            return "Fedakârlık";
         case "ForceBalance":
            return "Güç Dengesi";
         case "VenomCloud":
            return "Zehir Bulutu";
         case "HolyTribunal":
            return "Kutsal Divan";
         case "UnholyBreath":
            return "Şeytani Nefes";
         case "LifeLeech":
            return "Can Emici";
         case "SoulDrain":
            return "Ruh Emici";
         case "Healing":
            return "İyileştirme";
         case "BansheeCry":
            return "Banşi Çığlığı";
         case "NationViz":
            return "Ticaret Cumhuriyeti'nin İşareti";
         case "NationGer":
            return "Kutsal Tarikat'ın İşareti";
         case "NationRus":
            return "Orman Diyarı'nın İşareti";
         case "NationJap":
            return "Doğu İmparatorluğu'nun İşareti";
         case "NationMon":
            return "Kara Orda'nın İşareti";
         case "NationAra":
            return "Güney Çölü'nün İşareti";
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
            return "Her saniye tüm dost birlikleri 7*Sv can iyileştirir.";
         case "DivineHelp":
            return "Her saniye rastgele bir yaralı birliği 50*Sv can iyileştirir.";
         case "Barrier":
            return "Her saniye rastgele bir dost birliğe 30*Sv can ekler. Bu ek can, birliğin en yüksek canını bile aşabilir.";
         case "Sacrifice":
            return "Aurayı kullanan her saniye en yüksek canının %20'sini kaybeder ve tüm dost birlikleri her saniye 100*Sv can iyileştirir. Dikkat: bu aura kullananı ÖLDÜREBİLİR.";
         case "ForceBalance":
            return "Her saniye tüm dost birlikler en yüksek canlarının Sv%'sini geri kazanır, tüm düşmanlar da Sv%'sini kaybeder. Bu aura düşmanları öldüremez: canları en az 1 kalır.";
         case "VenomCloud":
            return "Her saniye Sv düşmanı zehirler. Zehir 5 saniye sürer. Zehirlenen birlik her saniye en yüksek canının %5'ini kaybeder ama zehirden ölmez.";
         case "HolyTribunal":
            return "Her saniye rastgele bir düşmana 50*Sv hasar verir. Bu hasar her zaman kritiktir ve kaçınılamaz.";
         case "UnholyBreath":
            return "Her saniye tüm düşmanları 2*Sv% ihtimalle zehirler, sersemletir ya da çıldırtır. Bu durumlar 5 saniye sürer. Çıldıran birlik dost düşman demeden en yakındakine saldırır, kendi müttefikleri de ona saldırır. Bir birliği anında öldürme ihtimali de %3'tür.";
         case "LifeLeech":
            return "Her saniye tüm DOST birlikler en yüksek canlarının %20'sini kaybeder, aurayı kullanan da en yüksek canının 5*Sv%'sini geri kazanır. Bu aura dost birlikleri öldüremez ama dost birlik kalmayınca çalışmaz.";
         case "SoulDrain":
            return "Her saniye tüm DOST birlikler en yüksek canlarının %20'sini kaybeder, aurayı kullanan da en yüksek RP'sinin 4*Sv%'sini geri kazanır. Bu aura dost birlikleri öldüremez ama dost birlik kalmayınca çalışmaz.";
         case "Healing":
            return "Her saniye aurayı kullananı 15*Sv can iyileştirir.";
         case "BansheeCry":
            return "Aurayı kullanan her saniye en yüksek canının %20'sini feda ederek her düşmanına 15*Sv hasar verir. Ne düşmanlar ne de kullanan bu hasardan kaçabilir ve hasar her zaman kritiktir. Dikkat: bu aura kullananı ÖLDÜREBİLİR.";
         case "NationViz":
            return "Tüm Ticaret Cumhuriyeti birliklerini en yüksek canlarının 2*Sv%'si kadar iyileştirir, diğer birlikler ise en yüksek canlarının 2*Sv%'si kadar hasar alır (bu hasar onları öldüremez). Bu aura yalnızca dost birliklerde çalışır.";
         case "NationGer":
            return "Tüm Kutsal Tarikat birliklerini en yüksek canlarının 2*Sv%'si kadar iyileştirir, diğer birlikler ise en yüksek canlarının 2*Sv%'si kadar hasar alır (bu hasar onları öldüremez). Bu aura yalnızca dost birliklerde çalışır.";
         case "NationRus":
            return "Tüm Orman Diyarı birliklerini en yüksek canlarının 2*Sv%'si kadar iyileştirir, diğer birlikler ise en yüksek canlarının 2*Sv%'si kadar hasar alır (bu hasar onları öldüremez). Bu aura yalnızca dost birliklerde çalışır.";
         case "NationJap":
            return "Tüm Doğu İmparatorluğu birliklerini en yüksek canlarının 2*Sv%'si kadar iyileştirir, diğer birlikler ise en yüksek canlarının 2*Sv%'si kadar hasar alır (bu hasar onları öldüremez). Bu aura yalnızca dost birliklerde çalışır.";
         case "NationMon":
            return "Tüm Kara Orda birliklerini en yüksek canlarının 2*Sv%'si kadar iyileştirir, diğer birlikler ise en yüksek canlarının 2*Sv%'si kadar hasar alır (bu hasar onları öldüremez). Bu aura yalnızca dost birliklerde çalışır.";
         case "NationAra":
            return "Tüm Güney Çölü Klanı birliklerini en yüksek canlarının 2*Sv%'si kadar iyileştirir, diğer birlikler ise en yüksek canlarının 2*Sv%'si kadar hasar alır (bu hasar onları öldüremez). Bu aura yalnızca dost birliklerde çalışır.";
         default:
            return;
      }
   }
}
