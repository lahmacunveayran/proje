class Creature extends MovieClip
{
   var DEF;
   var DODGE;
   var HP;
   var MAX_HP;
   var MAX_SP;
   var MOVE_FRAMES;
   var SHIELD_DODGE;
   var SP;
   var SPregen;
   var X;
   var Y;
   var active_skills;
   var agi_delay;
   var aspd_delay;
   var aspd_timer;
   var atkAnim;
   var attacking;
   var aura_skills;
   var bar_clr;
   var body;
   var borders;
   var dex_aspd_mod;
   var gox;
   var goy;
   var inner_depth;
   var isDead;
   var isHorseman;
   var isSwitchingWeapons;
   var light_circle;
   var moveX;
   var moveY;
   var nextX;
   var nextY;
   var onEnterFrame;
   var preferRanged;
   var runAnim;
   var speed;
   var statuses;
   var team;
   var unit_ref;
   var wpnPri;
   var wpnSec;
   function Creature()
   {
      super();
   }
   function CreatureInit()
   {
      this.isHorseman = false;
      this.statuses = new Array();
      this.speed = 3;
      this._xscale = 25;
      this._yscale = 25;
      this.X = _root.getX(this._x);
      this.Y = _root.getY(this._y);
      this._x = _root.stgX(this.X);
      this._y = _root.stgY(this.Y);
      this.moveX = 0;
      this.moveY = 0;
      this.isSwitchingWeapons = false;
      this.isDead = false;
      if(this.team == 0)
      {
         this.body._xscale = -100;
      }
      this.aspd_timer = 0;
      this.bar_clr = new Color(this.borders.hp_bar);
      this.attacking = null;
      this.gox = null;
      this.goy = null;
      this.initPosition();
      this.inner_depth = 1;
      this.body.head.stun_anim._visible = false;
   }
   function dist(man)
   {
      return Math.round(Math.sqrt((this.X - man.X) * (this.X - man.X) + (this.Y - man.Y) * (this.Y - man.Y)));
   }
   function canGo(xx, yy)
   {
      return xx >= 0 && xx < _global.F_WIDTH && yy >= 0 && yy < _global.F_HEIGHT && _global.field[xx][yy].empty && _global.field[xx][yy].free;
   }
   function leavePosition()
   {
      _global.field[this.X][this.Y].who = null;
      _global.field[this.X][this.Y].empty = true;
      this.X = this.nextX;
      this.Y = this.nextY;
      this.swapDepths(_root.getDepthMan(this.X,this.Y));
      _global.field[this.X][this.Y].who = this;
   }
   function initPosition()
   {
      this.swapDepths(_root.getDepthMan(this.X,this.Y));
      _global.field[this.X][this.Y].who = this;
      _global.field[this.X][this.Y].empty = false;
   }
   function startMove()
   {
      if(this.moveX != 0)
      {
         this.body._xscale = (- this.moveX) * 100;
      }
      if(this.canGo(this.X + this.moveX,this.Y + this.moveY))
      {
         if(this.body._currentframe <= this.MOVE_FRAMES && this.HP > 0)
         {
            this.body.gotoAndPlay(this.runAnim);
         }
         this.nextX = this.X + this.moveX;
         this.nextY = this.Y + this.moveY;
         _global.field[this.nextX][this.nextY].empty = false;
         return true;
      }
      this.moveX = 0;
      this.moveY = 0;
      return false;
   }
   function stopMove()
   {
      this.moveX = 0;
      this.moveY = 0;
      if(!this.isSwitchingWeapons)
      {
         this.body.gotoAndStop(this.atkAnim);
      }
   }
   function continueMove()
   {
      if(this.moveX != 0)
      {
         this.body._xscale = (- this.moveX) * 100;
      }
      if(this.canGo(this.X + this.moveX,this.Y + this.moveY))
      {
         this.nextX = this.X + this.moveX;
         this.nextY = this.Y + this.moveY;
         _global.field[this.nextX][this.nextY].empty = false;
         return true;
      }
      return false;
   }
   function moveOnX()
   {
      if(this.moveX != 0)
      {
         this._x += this.speed * this.moveX;
      }
   }
   function moveOnY()
   {
      if(this.moveY != 0)
      {
         this._y += this.speed * this.moveY / (_global.CAGE_W / _global.CAGE_H);
      }
   }
   function moveNewStep()
   {
      if(_root.getX(this._x) != this.X || _root.getY(this._y) != this.Y)
      {
         this.leavePosition();
      }
   }
   function moveComplete()
   {
      if(this.X == this.nextX && this.Y == this.nextY && Math.abs(this._y - _root.stgY(this.Y)) < this.speed && Math.abs(this._x - _root.stgX(this.X)) < this.speed)
      {
         this._x = _root.stgX(this.X);
         this._y = _root.stgY(this.Y);
         return true;
      }
      return false;
   }
   function switchWeapons()
   {
      if(!this.canSwitchWeapons())
      {
         return undefined;
      }
      this.isSwitchingWeapons = true;
      if(this.wpnPri.TYPE == "Melee")
      {
         if(this.wpnSec.c_type == "bow")
         {
            this.body.gotoAndPlay("bow_on");
         }
         else
         {
            this.body.gotoAndPlay("crossbow_on");
         }
      }
      else if(this.wpnPri.c_type == "bow")
      {
         this.body.gotoAndPlay("bow_off");
      }
      else
      {
         this.body.gotoAndPlay("crossbow_off");
      }
   }
   function onRunAnimComplete()
   {
      if(!this.isDead)
      {
         this.body.gotoAndPlay(this.runAnim);
      }
      else
      {
         this.playDieAnim();
      }
   }
   function onAnimComplete()
   {
      this.isSwitchingWeapons = false;
      if(!this.isDead)
      {
         this.body.gotoAndStop(this.atkAnim);
      }
      else
      {
         this.playDieAnim();
      }
   }
   function onSwitchWeapons()
   {
      var _loc2_ = this.wpnPri;
      this.wpnPri = this.wpnSec;
      this.wpnSec = _loc2_;
      this.initFightingStyle();
      this.onAnimComplete();
   }
   function onEndAttack()
   {
      this.onAnimComplete();
   }
   static function getArrowErrorRatio(hit_chance)
   {
      switch(true)
      {
         case _root.percent(hit_chance):
            return 0;
         case _root.percent(hit_chance * 1.5):
            return 1;
         case _root.percent(hit_chance * 2):
            return 2;
         case _root.percent(hit_chance * 3):
            return 3;
         default:
            return 4;
      }
   }
   function getHitChance(who, useSecondWeapon)
   {
      var _loc2_ = !useSecondWeapon ? this.wpnPri : this.wpnSec;
      if(who == null)
      {
         return _loc2_.HIT;
      }
      var _loc4_;
      if(_loc2_.TYPE == "Melee")
      {
         _loc4_ = _loc2_.HIT + 90 - Math.floor(who.DODGE);
         if(this.body._xscale > 0 != who.body._xscale > 0)
         {
            _loc4_ *= (100 - who.SHIELD_DODGE) / 100;
         }
         return _loc4_;
      }
      return _loc2_.HIT * _loc2_.HIT / 100 + 90 - Math.floor(who.DODGE);
   }
   function getDamageData(who, useSecondWeapon, dmg_mod)
   {
      var _loc3_ = !useSecondWeapon ? this.wpnPri : this.wpnSec;
      var _loc4_ = new DamageData(this,_loc3_.dmg + _root.dice(_loc3_.rnd),this.getHitChance(who,useSecondWeapon),_loc3_.CRIT);
      if(who != null)
      {
         _loc3_.setDmgDataMods(who,_loc4_);
      }
      return _loc4_;
   }
   function takeDamage(dmg_data, close_hit)
   {
      if(this.isDead)
      {
         return undefined;
      }
      if(dmg_data.attacker.team == this.team)
      {
         return undefined;
      }
      if(dmg_data.hit < 10)
      {
         dmg_data.hit = 10;
      }
      if(!_root.percent(dmg_data.hit))
      {
         dmg_data.attacker.addMessage("miss","FlyMiss");
         return undefined;
      }
      if(this.attacking != null && close_hit)
      {
         this.gox = null;
         this.goy = null;
         this.attacking = dmg_data.attacker;
      }
      dmg_data.damage = Math.round(dmg_data.damage);
      var _loc5_;
      if(dmg_data.statuses.length > 0)
      {
         _loc5_ = 0;
         while(_loc5_ < dmg_data.statuses.length)
         {
            this.addStatus(dmg_data.statuses[_loc5_]);
            _loc5_ = _loc5_ + 1;
         }
      }
      var _loc6_ = _root.percent(dmg_data.crit);
      if(!_loc6_)
      {
         dmg_data.damage -= this.DEF;
         if(dmg_data.damage < 0)
         {
            dmg_data.damage = 0;
         }
      }
      if(dmg_data.attacker == _root.hero0)
      {
         if(_global.MAX_INFLICTED < dmg_data.damage)
         {
            _global.MAX_INFLICTED = dmg_data.damage;
         }
      }
      if(this == _root.hero0 && _global.EASY_MODE && dmg_data.damage > this.MAX_HP * 0.9)
      {
         dmg_data.damage = Math.floor(this.MAX_HP * 0.9);
      }
      this.addMessage(dmg_data.damage,!_loc6_ ? "FlyDamage" : "FlyCritDamage");
      this.HP -= dmg_data.damage;
      if(this.HP <= 0)
      {
         this.die();
         return undefined;
      }
      if(this == _root.hero0)
      {
         if(_global.MAX_RECEIVED < dmg_data.damage)
         {
            _global.MAX_RECEIVED = dmg_data.damage;
         }
      }
      this.redrawHealthBar();
   }
   function redrawHealthBar()
   {
      var _loc2_ = this.HP / this.MAX_HP * 100;
      this.borders.hp_bar._xscale = _loc2_;
      if(_loc2_ > 70)
      {
         this.bar_clr.setRGB(52224);
      }
      else if(_loc2_ > 40)
      {
         this.bar_clr.setRGB(16776960);
      }
      else if(_loc2_ > 20)
      {
         this.bar_clr.setRGB(16750848);
      }
      else
      {
         this.bar_clr.setRGB(16711680);
      }
   }
   function playDieAnim()
   {
      if(this.isHorseman)
      {
         this.body.gotoAndPlay("die_horse");
      }
      else
      {
         switch(this.atkAnim)
         {
            case "shield":
            case "katar":
            case "dual":
               this.body.gotoAndPlay("die_onehanded");
               return;
            case "throwing":
            case "bow":
            case "crossbow":
               this.body.gotoAndPlay("die_ranged");
               return;
            default:
               this.body.gotoAndPlay("die_twohanded");
               return;
         }
      }
   }
   function die()
   {
      this.HP = 0;
      var _loc4_;
      if(!this.isDead)
      {
         this.cancelAllStatuses();
         this.isDead = true;
         this.light_circle._visible = false;
         this.onEnterFrame = null;
         _global.field[this.X][this.Y].empty = true;
         _global.field[this.X][this.Y].who = null;
         _global.field[this.nextX][this.nextY].empty = true;
         this.borders._visible = false;
         this.body.head.stun_anim._visible = false;
         if(this.team != 0)
         {
            _loc4_ = Rune.getRandomRune();
            if(_loc4_)
            {
               _root.addItemTo(_global.LOOT,_loc4_);
            }
            _root.addItemTo(_global.LOOT,this.unit_ref.WEAPON_PRI);
            _root.addItemTo(_global.LOOT,this.unit_ref.WEAPON_SEC);
            _root.addItemTo(_global.LOOT,this.unit_ref.ARMOR);
            _root.addItemTo(_global.LOOT,this.unit_ref.HELMET);
            _global.EXP_GOT += Math.round(Math.sqrt(this.unit_ref.price)) * 3;
            _global.GOLD_GOT += _root.d(this.unit_ref.price / 4);
         }
         this.playDieAnim();
         if(this._name == "hero0")
         {
            _root.unloadMap();
            _root.gotoAndStop("GAME_OVER");
         }
      }
   }
   function cancelAllStatuses()
   {
      var _loc2_ = 0;
      while(_loc2_ < this.statuses.length)
      {
         this.statuses[_loc2_].endStatus(this);
         _loc2_ = _loc2_ + 1;
      }
   }
   function restInPeace()
   {
      var _loc3_ = _root.getDepthMan(this.X,this.Y);
      _root["blood_" + _loc3_].removeMovieClip();
      _root.getInstanceAtDepth(_root.getDepthCorpse(this.X,this.Y)).removeMovieClip();
      this.swapDepths(_root.getDepthCorpse(this.X,this.Y));
   }
   function addMessage(some_text, msg_type)
   {
      this.attachMovie(msg_type,"flying_msg_" + this.inner_depth,this.inner_depth,{_x:0,_y:100});
      this["flying_msg_" + this.inner_depth].inner.value_txt.text = some_text;
      this.inner_depth += this.inner_depth >= 15 ? -14 : 1;
   }
   function canSwitchWeapons()
   {
      switch(this.atkAnim)
      {
         case "dual":
            return false;
         case "shield":
            return this.wpnSec != null && this.wpnSec.c_type != "Shield";
         case "dagger":
         case "katana":
         case "spear":
         case "throwing":
         case "katar":
         case "fists":
         case "staff":
         case "2H_sword":
         case "2H_axe":
            return this.wpnSec.c_type != "Fists";
         case "bow":
         case "crossbow":
            return true;
         default:
            trace("Fighting style missed:" + this.atkAnim);
            return;
      }
   }
   static function getAtkAnim(pri_tp, sec_tp)
   {
      if(!WeaponClass.isTwohandedType(pri_tp) && !WeaponClass.isTwohandedType(sec_tp) && sec_tp != "Shield")
      {
         return "dual";
      }
      switch(pri_tp)
      {
         case "OnehandedSword":
         case "OnehandedAxe":
         case "OnehandedMace":
            return "shield";
         case "TwohandedSword":
            return "2H_sword";
         case "TwohandedAxe":
         case "TwohandedMace":
            return "2H_axe";
         case "NinjaTo":
         case "Katana":
            return "katana";
         case "Katar":
            return "katar";
         case "Staff":
            return "staff";
         case "Spear":
            return "spear";
         case "Dagger":
            return "dagger";
         case "Fists":
            return "fists";
         case "Bow":
            return "bow";
         case "Crossbow":
            return "crossbow";
         case "Throwing":
            return "throwing";
         default:
            trace("Unknown weapon type:" + pri_tp);
            return;
      }
   }
   static function getRunAnim(atk_anim, is_horseman)
   {
      switch(atk_anim)
      {
         case "spear":
         case "staff":
            return "run_2H_axe";
         case "dagger":
            return "run_2H_sword";
         case "fists":
            return !is_horseman ? "run_dual" : "run_2H_sword";
         case "katana":
            return !is_horseman ? "run_katana" : "run_2H_sword";
         default:
            return "run_" + atk_anim;
      }
   }
   function getAttackDelay()
   {
      switch(this.atkAnim)
      {
         case "dagger":
            return 20;
         case "katana":
            return 25;
         case "shield":
         case "dual":
         case "spear":
         case "throwing":
         case "katar":
            return 30;
         case "fists":
         case "staff":
            return 35;
         case "2H_sword":
         case "2H_axe":
         case "bow":
            return 40;
         case "crossbow":
            return 60;
         default:
            trace("Fighting style missed:" + this.atkAnim);
            return;
      }
   }
   function getWeaponDelay()
   {
      switch(this.atkAnim)
      {
         case "dagger":
         case "katana":
            return 30;
         case "shield":
         case "dual":
         case "throwing":
            return 50;
         case "staff":
         case "katar":
            return 40;
         case "spear":
            return 70;
         case "fists":
            return 20;
         case "2H_sword":
         case "bow":
            return 60;
         case "2H_axe":
         case "crossbow":
            return 70;
         default:
            trace("Fighting style missed:" + this.atkAnim);
            return;
      }
   }
   function initStoringWeapon()
   {
      this.body.body.storage_spear._visible = false;
      this.body.body.storage_bow._visible = false;
      this.body.body.storage_axe._visible = false;
      this.body.body.storage_staff._visible = false;
      this.body.body.storage_sword._visible = false;
      this.body.body.storage_katar._visible = false;
      this.body.body.storage_dagger._visible = false;
      this.body.body.storage_throwing._visible = false;
      if(this.atkAnim == "dual")
      {
         return undefined;
      }
      switch(this.wpnSec.c_type)
      {
         case "OnehandedSword":
         case "TwohandedSword":
         case "OnehandedMace":
         case "OnehandedAxe":
         case "NinjaTo":
         case "Katana":
            this.body.body.storage_sword._visible = true;
            this.body.body.storage_sword.gotoAndStop(this.wpnSec.frame);
            break;
         case "TwohandedAxe":
         case "TwohandedMace":
            this.body.body.storage_axe._visible = true;
            this.body.body.storage_axe.gotoAndStop(this.wpnSec.frame);
            break;
         case "Staff":
            this.body.body.storage_staff._visible = true;
            this.body.body.storage_staff.gotoAndStop(this.wpnSec.frame);
            break;
         case "Spear":
            this.body.body.storage_spear._visible = true;
            this.body.body.storage_spear.gotoAndStop(this.wpnSec.frame);
            break;
         case "Katar":
            this.body.body.storage_katar._visible = true;
            this.body.body.storage_katar.gotoAndStop(this.wpnSec.frame);
            break;
         case "Dagger":
            this.body.body.storage_dagger._visible = true;
            this.body.body.storage_dagger.gotoAndStop(this.wpnSec.frame);
            break;
         case "Bow":
         case "Crossbow":
            this.body.body.storage_bow._visible = true;
            this.body.body.storage_bow.gotoAndStop(this.wpnSec.frame);
            break;
         case "Throwing":
            this.body.body.storage_throwing._visible = true;
            this.body.body.storage_throwing.gotoAndStop(this.wpnSec.frame);
         default:
            return;
      }
   }
   function initFightingStyle()
   {
      this.atkAnim = Creature.getAtkAnim(this.wpnPri.c_type,!this.wpnSec ? null : this.wpnSec.c_type);
      this.runAnim = Creature.getRunAnim(this.atkAnim,this.isHorseman);
      this.agi_delay = Math.max(1,Math.round(this.dex_aspd_mod * (this.getWeaponDelay() / 3 - this.wpnPri.aspd_bonus)));
      this.aspd_delay = this.agi_delay + this.getAttackDelay();
      switch(this.atkAnim)
      {
         case "dual":
         case "shield":
            this.body.weapL.gotoAndStop(this.wpnPri.frame);
            this.body.weapR.gotoAndStop(this.wpnSec.frame);
            break;
         case "2H_sword":
         case "2H_axe":
         case "katana":
         case "staff":
         case "spear":
         case "dagger":
         case "fists":
         case "bow":
         case "crossbow":
         case "throwing":
            this.body.weapL.gotoAndStop(this.wpnPri.frame);
            this.body.weapR.gotoAndStop("unarmed");
            break;
         case "katar":
            this.body.weapL.gotoAndStop(this.wpnPri.frame);
            this.body.weapR.gotoAndStop(this.wpnPri.frame);
            break;
         default:
            trace("Fighting style missed:" + this.atkAnim);
      }
      this.initStoringWeapon();
      this.initSkills();
      this.body.gotoAndStop(this.atkAnim);
   }
   function initSkills()
   {
   }
   function initUnit(hero)
   {
      this.unit_ref = hero;
      var _loc6_ = hero.NATION.toLowerCase();
      this.DEF = 0;
      this.DODGE = Math.floor(hero.DEX * Hero.getNationDodgeMod(hero.NATION));
      this.SHIELD_DODGE = hero.WEAPON_SEC.TYPE != "Shield" ? 0 : hero.WEAPON_SEC.crit;
      this.MAX_HP = Math.round((1 + hero.CON * 0.05) * hero.LEVEL * 10);
      this.MAX_SP = 20 + Math.round((1 + hero.SPR * 0.1) * hero.LEVEL * 2);
      if(_global.EASY_MODE && hero == _global.MAIN_HERO)
      {
         this.MAX_HP += 200;
      }
      this.SPregen = Math.round(this.MAX_SP / 20);
      this.dex_aspd_mod = 1 - Math.min(1,hero.DEX / 100);
      this.active_skills = hero.ACTIVE_SKILLS;
      this.aura_skills = hero.AURA_SKILLS;
      this.body.arm_l.gotoAndStop(hero.GENDER + "_" + _loc6_);
      this.body.arm_r.gotoAndStop(hero.GENDER + "_" + _loc6_);
      this.body.hand_l.gotoAndStop(hero.GENDER + "_" + _loc6_);
      this.body.hand_r.gotoAndStop(hero.GENDER + "_" + _loc6_);
      this.body.footL.gotoAndStop(hero.GENDER + "_" + _loc6_);
      this.body.footR.gotoAndStop(hero.GENDER + "_" + _loc6_);
      this.body.legL.gotoAndStop(hero.GENDER + "_" + _loc6_);
      this.body.legR.gotoAndStop(hero.GENDER + "_" + _loc6_);
      this.body.body.gotoAndStop(hero.GENDER + "_" + _loc6_);
      this.body.head.gotoAndStop(hero.GENDER + "_" + _loc6_);
      if(hero.HORSE != null)
      {
         this.isHorseman = true;
         this.body.horse.gotoAndStop(hero.HORSE.skin_color);
         this.body.morda.gotoAndStop(hero.HORSE.skin_color);
         this.body.ftL1.gotoAndStop(hero.HORSE.skin_color);
         this.body.ftR1.gotoAndStop(hero.HORSE.skin_color);
         this.body.ftL2.gotoAndStop(hero.HORSE.skin_color);
         this.body.ftR2.gotoAndStop(hero.HORSE.skin_color);
         this.body.lgL1.gotoAndStop(hero.HORSE.skin_color);
         this.body.lgR1.gotoAndStop(hero.HORSE.skin_color);
         this.body.lgL2.gotoAndStop(hero.HORSE.skin_color);
         this.body.lgR2.gotoAndStop(hero.HORSE.skin_color);
         this.DEF += hero.HORSE.bonus_DEF;
         this.speed += hero.HORSE.bonus_speed;
         this.MAX_HP += hero.HORSE.bonus_HP;
         this.DODGE /= 1.5;
         this.MOVE_FRAMES = 890;
      }
      else
      {
         this.MOVE_FRAMES = 2115;
         this.isHorseman = false;
      }
      if(hero.ARMOR != null)
      {
         this.body.arm_l.armor._visible = true;
         this.body.arm_r.armor._visible = true;
         this.body.hand_l.armor._visible = true;
         this.body.hand_r.armor._visible = true;
         this.body.body.armor._visible = true;
         this.body.arm_l.armor.gotoAndStop(hero.ARMOR.FRAME);
         this.body.arm_r.armor.gotoAndStop(hero.ARMOR.FRAME);
         this.body.hand_l.armor.gotoAndStop(hero.ARMOR.FRAME);
         this.body.hand_r.armor.gotoAndStop(hero.ARMOR.FRAME);
         this.body.body.armor.gotoAndStop(hero.ARMOR.FRAME);
         this.DEF += hero.ARMOR.value;
         this.MAX_HP += hero.ARMOR.HP_mod;
         this.MAX_SP += hero.ARMOR.SP_mod;
      }
      else
      {
         this.body.arm_l.armor._visible = false;
         this.body.arm_r.armor._visible = false;
         this.body.hand_l.armor._visible = false;
         this.body.hand_r.armor._visible = false;
         this.body.body.armor._visible = false;
      }
      if(hero.HELMET != null)
      {
         this.body.head.armor._visible = true;
         this.body.head.armor.gotoAndStop(hero.HELMET.FRAME);
         this.DEF += hero.HELMET.value;
         this.MAX_HP += hero.HELMET.HP_mod;
         this.MAX_SP += hero.HELMET.SP_mod;
      }
      else
      {
         this.body.head.armor._visible = false;
      }
      var _loc8_ = hero.WEAPON_PRI;
      var _loc7_ = hero.WEAPON_SEC;
      if(_loc8_ == null)
      {
         _loc8_ = new WeaponClass("Fists","All",0);
      }
      if(_loc7_ == null)
      {
         _loc7_ = new WeaponClass("Fists","All",0);
      }
      this.wpnPri = new Weapon(_loc8_,hero.SKILL[_loc8_.skill],hero.STR,hero.DEX);
      this.wpnSec = new Weapon(_loc7_,hero.SKILL[_loc7_.skill],hero.STR,hero.DEX);
      this.initFightingStyle();
      switch(this.atkAnim)
      {
         case "bow":
         case "crossbow":
         case "throwing":
            this.preferRanged = true;
            break;
         default:
            this.preferRanged = false;
      }
      if(_global.EASY_MODE && this.team == 0)
      {
         this.MAX_HP += Math.round(this.MAX_HP * 0.2);
      }
      this.HP = this.MAX_HP;
      this.SP = this.MAX_SP;
      var _loc5_;
      var _loc4_;
      if(hero instanceof Unit)
      {
         _loc5_ = this.team != 0 ? _global.EVIL_HERO : _global.MAIN_HERO;
         if(_loc5_ != null)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc5_.PASSIVE_SKILLS.length)
            {
               Skill.operatePassive(this,_loc5_.PASSIVE_SKILLS[_loc4_][0],_loc5_.PASSIVE_SKILLS[_loc4_][1]);
               _loc4_ = _loc4_ + 1;
            }
         }
      }
      if(hero == _global.EVIL_HERO)
      {
         this.speed *= 2;
      }
   }
   function meleeHit(skill_id, useSecondWeapon, dmg_mod, skill_flag)
   {
      if(this.attacking == null && skill_id == 0)
      {
         return undefined;
      }
      if(useSecondWeapon == undefined)
      {
         useSecondWeapon = false;
      }
      if(skill_id == undefined)
      {
         skill_id = 0;
      }
      if(dmg_mod == undefined)
      {
         dmg_mod = 1;
      }
      if(skill_flag == undefined)
      {
         skill_flag = 0;
      }
      var _loc3_;
      var _loc5_;
      if(skill_id != 0)
      {
         if(!this.active_skills[this.atkAnim])
         {
            trace(this.unit_ref.NAME + " uses unavailable skill: " + this.atkAnim + " (" + skill_id + ")");
            return undefined;
         }
         _loc3_ = this.active_skills[this.atkAnim][skill_id - 1];
         if(_loc3_ <= 0)
         {
            trace(this.unit_ref.NAME + " uses skill (" + this.atkAnim + "-" + skill_id + ") of strange level:" + _loc3_);
            return undefined;
         }
         Skill.operate(true,this,this.attacking,useSecondWeapon,this.atkAnim,skill_id,_loc3_,skill_flag);
      }
      else
      {
         _loc5_ = this.getDamageData(this.attacking,useSecondWeapon);
         _loc5_.damage *= dmg_mod;
         this.attacking.takeDamage(_loc5_,true);
      }
   }
   function rangedHit(skill_id, useSecondWeapon, dmg_mod, skill_flag)
   {
      if(useSecondWeapon == undefined)
      {
         useSecondWeapon = false;
      }
      if(skill_id == undefined)
      {
         skill_id = 0;
      }
      if(dmg_mod == undefined)
      {
         dmg_mod = 1;
      }
      if(skill_flag == undefined)
      {
         skill_flag = 0;
      }
      var _loc5_ = this.getDamageData(this.attacking,useSecondWeapon,dmg_mod);
      var _loc4_;
      if(skill_id != 0)
      {
         if(!this.active_skills[this.atkAnim])
         {
            trace(this.unit_ref.NAME + " uses unavailable skill: " + this.atkAnim + " (" + skill_id + ")");
            return undefined;
         }
         _loc4_ = this.active_skills[this.atkAnim][skill_id - 1];
         if(_loc4_ <= 0)
         {
            trace(this.unit_ref.NAME + " uses skill (" + this.atkAnim + "-" + skill_id + ") of strange level:" + _loc4_);
            return undefined;
         }
         Skill.operate(false,this,this.attacking,useSecondWeapon,this.atkAnim,skill_id,_loc4_,skill_flag);
      }
      else
      {
         _loc5_ = this.getDamageData(this.attacking,useSecondWeapon);
         _loc5_.damage *= dmg_mod;
         this.addProjectile(this.attacking,Creature.getArrowErrorRatio(this.getHitChance(this.attacking,useSecondWeapon)),_loc5_);
      }
   }
   function addProjectile(target, err, dmg_data, pierce)
   {
      var _loc5_;
      var _loc4_;
      if(target == null)
      {
         _loc5_ = this.X - 10 * _root.znak(this.body._xscale);
         _loc4_ = this.Y;
      }
      else
      {
         _loc5_ = target.X + _root.dd(err);
         _loc4_ = target.Y + _root.dd(err);
      }
      _root.addProjectile(this.X,this.Y,_loc5_,_loc4_,dmg_data,this.body._xscale <= 0 ? -1 : 1,this.wpnPri.frame,this.team,pierce);
   }
   function canHitRanged(man, no_range_check)
   {
      var _loc8_ = this.dist(man);
      var _loc5_;
      var _loc7_;
      var _loc4_;
      if(Math.abs((this.X - man.X) / (this.Y - man.Y)) >= _global.S_ANGLE)
      {
         if(_loc8_ <= this.wpnPri.rng || no_range_check)
         {
            _loc5_ = _root.znak(man.X - this.X);
            _loc7_ = (this.X - man.X) / (this.Y - man.Y);
            _loc4_ = this.X + _loc5_;
            while(_loc4_ != man.X)
            {
               if(!_global.field[_loc4_][this.Y + Math.round((_loc4_ - this.X + _loc5_) / _loc7_)].free)
               {
                  return false;
               }
               _loc4_ += _loc5_;
            }
            return true;
         }
      }
      return false;
   }
   function canHitMelee(man)
   {
      return man.Y == this.Y && Math.abs(this.X - man.X) == 1 || man.nextY == this.Y && Math.abs(this.X - man.nextX) == 1;
   }
   function getNearestCreatureInSight(friend, no_range_check)
   {
      var _loc7_ = null;
      var _loc6_ = 10000;
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _global.HERO)
      {
         if(_root["hero" + _loc4_].HP > 0 && friend == (_root["hero" + _loc4_].team == this.team))
         {
            if(this.canHitRanged(_root["hero" + _loc4_],no_range_check))
            {
               _loc5_ = this.dist(_root["hero" + _loc4_]);
               if(_loc5_ < _loc6_)
               {
                  _loc7_ = _root["hero" + _loc4_];
                  _loc6_ = _loc5_;
               }
            }
         }
         _loc4_ = _loc4_ + 1;
      }
      return _loc7_;
   }
   function getCreaturesInSight(friend, amount)
   {
      var _loc5_ = new Array();
      var _loc8_ = 10000;
      var _loc4_ = 0;
      while(_loc4_ < _global.HERO)
      {
         if(_root["hero" + _loc4_].HP > 0 && friend == (_root["hero" + _loc4_].team == this.team))
         {
            if(this.canHitRanged(_root["hero" + _loc4_]))
            {
               _loc5_.push(_root["hero" + _loc4_]);
               if(_loc5_.length == amount)
               {
                  return _loc5_;
               }
            }
         }
         _loc4_ = _loc4_ + 1;
      }
      return _loc5_;
   }
   function addStatus(newStatus)
   {
      var _loc2_ = 0;
      while(_loc2_ < this.statuses.length)
      {
         if(this.statuses[_loc2_].TYPE == newStatus.TYPE)
         {
            this.statuses[_loc2_].time_left += newStatus.time_left;
            return undefined;
         }
         _loc2_ = _loc2_ + 1;
      }
      newStatus.startStatus(this);
      this.statuses.push(newStatus);
   }
   function operateStatuses()
   {
      var _loc2_ = 0;
      while(_loc2_ < this.statuses.length)
      {
         this.statuses[_loc2_].duringStatus(this);
         if(this.statuses[_loc2_].timePassed())
         {
            this.statuses[_loc2_].endStatus(this);
            this.statuses.splice(_loc2_,1);
            _loc2_ = _loc2_ - 1;
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function regenerateSP()
   {
      this.SP += this.SPregen;
      if(this.SP > this.MAX_SP)
      {
         this.SP = this.MAX_SP;
      }
   }
   function healHP(heal_amount)
   {
      if(this.HP <= 0)
      {
         return undefined;
      }
      heal_amount = Math.round(heal_amount);
      this.attachMovie("HealAnim","anim",1);
      this.addMessage(heal_amount,"FlyHeal");
      if(this.HP >= this.MAX_HP)
      {
         return undefined;
      }
      this.HP += heal_amount;
      if(this.HP > this.MAX_HP)
      {
         this.HP = this.MAX_HP;
      }
      this.redrawHealthBar();
   }
   function getAuraID(aura_name)
   {
      var _loc3_ = 0;
      while(_loc3_ < _global.AURAS.length)
      {
         if(_global.AURAS[_loc3_].TYPE == aura_name && _global.AURAS[_loc3_].caster.team == this.team)
         {
            return _loc3_;
         }
         _loc3_ = _loc3_ + 1;
      }
      return -1;
   }
   function startAura(aura_id)
   {
      var _loc4_ = this.getAuraID(this.aura_skills[aura_id - 1][0]);
      if(_loc4_ >= 0)
      {
         return false;
      }
      _global.AURAS.push(new Aura(this.aura_skills[aura_id - 1][0],this.aura_skills[aura_id - 1][1],this,aura_id));
      return true;
   }
   function endAura(aura_id)
   {
      var _loc3_ = this.getAuraID(this.aura_skills[aura_id - 1][0]);
      if(_loc3_ >= 0 && _global.AURAS[_loc3_].caster == this)
      {
         _global.AURAS.splice(_loc3_,1);
         return true;
      }
      return false;
   }
}
