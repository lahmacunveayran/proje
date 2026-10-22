class Creature extends MovieClip
{
   var ANTI_FLEE;
   var DEF;
   var FLEE;
   var HP;
   var MAX_HP;
   var MOVE_FRAMES;
   var SHIELD_FLEE;
   var X;
   var Y;
   var atkAnim;
   var attacking;
   var bar_clr;
   var body;
   var borders;
   var disapear_time;
   var gox;
   var goy;
   var inner_depth;
   var isBusy;
   var isDead;
   var isHorseman;
   var light_circle;
   var moveX;
   var moveY;
   var nextX;
   var nextY;
   var onEnterFrame;
   var preferRanged;
   var runAnim;
   var secAtkAnim;
   var secRunAnim;
   var speed;
   var t_aft;
   var t_bef;
   var team;
   var unit_ref;
   var wpn;
   var wpnSec;
   function Creature()
   {
      super();
      this.isHorseman = false;
      this.speed = 3;
      this._xscale = 25;
      this._yscale = 25;
      this.X = _root.getX(this._x);
      this.Y = _root.getY(this._y);
      this._x = _root.stgX(this.X);
      this._y = _root.stgY(this.Y);
      this.moveX = 0;
      this.moveY = 0;
      this.isBusy = false;
      this.isDead = false;
      if(this.team == 0)
      {
         this.body._xscale = -100;
      }
      this.t_bef = 0;
      this.t_aft = 0;
      this.bar_clr = new Color(this.borders.hp_bar);
      this.attacking = null;
      this.gox = null;
      this.goy = null;
      this.initPosition();
      this.disapear_time = 0;
      this.inner_depth = 1;
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
      if(!this.isBusy)
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
      this.isBusy = true;
      if(this.wpn.TYPE == "Melee")
      {
         if(this.secAtkAnim == "bow")
         {
            this.body.gotoAndPlay("bow_on");
         }
         else
         {
            this.body.gotoAndPlay("crossbow_on");
         }
      }
      else if(this.atkAnim == "bow")
      {
         this.body.gotoAndPlay("bow_off");
      }
      else
      {
         this.body.gotoAndPlay("crossbow_off");
      }
   }
   function onAnimComplete()
   {
      this.isBusy = false;
      if(!this.isDead)
      {
         this.body.gotoAndStop(this.atkAnim);
      }
   }
   function onSwitchWeapons()
   {
      var _loc2_ = this.wpn;
      this.wpn = this.wpnSec;
      this.wpnSec = _loc2_;
      _loc2_ = this.runAnim;
      this.runAnim = this.secRunAnim;
      this.secRunAnim = _loc2_;
      _loc2_ = this.atkAnim;
      this.atkAnim = this.secAtkAnim;
      this.secAtkAnim = _loc2_;
      this.initGuns();
      this.onAnimComplete();
   }
   function onEndAttack()
   {
      this.onAnimComplete();
   }
   function strike(who, useSecondWeapon)
   {
      var _loc5_;
      var _loc6_;
      var _loc4_;
      var _loc11_;
      var _loc10_;
      var _loc8_;
      var _loc9_;
      if(this.team != who.team)
      {
         _loc5_ = _root.percent(!useSecondWeapon ? this.wpn.CRIT : this.wpnSec.CRIT);
         _loc6_ = !useSecondWeapon ? this.wpn.dmg : this.wpnSec.dmg;
         _loc4_ = !useSecondWeapon ? this.wpn.rnd : this.wpnSec.rnd;
         if(!useSecondWeapon ? this.wpn.TYPE == "Melee" : this.wpnSec.TYPE)
         {
            _loc11_ = this.body._xscale > 0 == who.body._xscale > 0 ? 0 : who.SHIELD_FLEE;
            _loc10_ = (!useSecondWeapon ? this.wpn.HIT : this.wpnSec.HIT) * (100 - (who.FLEE * this.ANTI_FLEE + _loc11_)) / 100;
            if(_root.percent(_loc10_))
            {
               who.takeDamage(_loc6_ + _root.dice(_loc4_),this,_loc5_);
            }
            else
            {
               this.addMessage("miss",false);
            }
         }
         else
         {
            _loc8_ = !useSecondWeapon ? this.body.weapL._currentframe : this.body.weapR._currentframe;
            _loc9_ = this.body._xscale <= 0 ? -1 : 1;
            _loc10_ = !useSecondWeapon ? this.wpn.HIT : this.wpnSec.HIT;
            if(_root.percent(_loc10_))
            {
               _root.addProjectile(this.X,this.Y,who.X,who.Y,_loc6_,_loc4_,_loc5_,_loc9_,_loc8_,this.team);
            }
            else if(_root.percent(_loc10_ * 1.5))
            {
               _root.addProjectile(this.X,this.Y,who.X + _root.dd(1),who.Y + _root.dd(1),_loc6_,_loc4_,_loc5_,_loc9_,_loc8_,this.team);
            }
            else if(_root.percent(_loc10_ * 2))
            {
               _root.addProjectile(this.X,this.Y,who.X + _root.dd(2),who.Y + _root.dd(2),_loc6_,_loc4_,_loc5_,_loc9_,_loc8_,this.team);
            }
            else if(_root.percent(_loc10_ * 3))
            {
               _root.addProjectile(this.X,this.Y,who.X + _root.dd(3),who.Y + _root.dd(3),_loc6_,_loc4_,_loc5_,_loc9_,_loc8_,this.team);
            }
            else
            {
               _root.addProjectile(this.X,this.Y,who.X + _root.dd(4),who.Y + _root.dd(4),_loc6_,_loc4_,_loc5_,_loc9_,_loc8_,this.team);
            }
         }
      }
      else
      {
         this.attacking = null;
      }
   }
   function takeDamage(dmg, who, is_crit)
   {
      if(this.isDead)
      {
         return undefined;
      }
      if(who == undefined)
      {
         who = null;
      }
      if(this.attacking != null && who != null && who.team != this.team)
      {
         this.gox = null;
         this.goy = null;
         this.attacking = who;
      }
      if(!is_crit)
      {
         dmg -= this.DEF;
         if(dmg < 0)
         {
            dmg = 0;
         }
      }
      this.addMessage(dmg,is_crit);
      this.HP -= dmg;
      if(this.HP <= 0)
      {
         this.HP = 0;
         this.die();
         return undefined;
      }
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
   function die()
   {
      if(!this.isDead)
      {
         if(this.isHorseman)
         {
            this.body.gotoAndPlay("die_horse");
         }
         else
         {
            switch(this.atkAnim)
            {
               case "sword":
               case "double":
                  this.body.gotoAndPlay("die_onehanded");
                  break;
               case "suriken":
               case "bow":
               case "crossbow":
                  this.body.gotoAndPlay("die_ranged");
                  break;
               default:
                  this.body.gotoAndPlay("die_twohanded");
            }
         }
         this.isDead = true;
         this.light_circle._visible = false;
         this.onEnterFrame = null;
         _global.field[this.X][this.Y].empty = true;
         _global.field[this.X][this.Y].who = null;
         _global.field[this.nextX][this.nextY].empty = true;
         this.borders._visible = false;
         if(this.team != 0)
         {
            if(_root.percent(10))
            {
               switch(_root.dice(4))
               {
                  case 0:
                     this.unit_ref.WEAPON_PRI.ENCH_ID = _root.d(24);
                     break;
                  case 1:
                     this.unit_ref.WEAPON_SEC.ENCH_ID = _root.d(24);
                     break;
                  case 2:
                     this.unit_ref.ARMOR.ENCH_ID = _root.d(24);
                     break;
                  case 3:
                     this.unit_ref.HELMET.ENCH_ID = _root.d(24);
               }
            }
            _root.addItemTo(_global.LOOT,this.unit_ref.WEAPON_PRI);
            _root.addItemTo(_global.LOOT,this.unit_ref.WEAPON_SEC);
            _root.addItemTo(_global.LOOT,this.unit_ref.ARMOR);
            _root.addItemTo(_global.LOOT,this.unit_ref.HELMET);
            _global.EXP_GOT += Math.round(Math.sqrt(this.unit_ref.price)) * 3;
            _global.GOLD_GOT += _root.d(this.unit_ref.price / 4);
         }
         if(this._name == "hero0")
         {
            _root.unloadMap();
            _root.gotoAndStop("GAME_OVER");
         }
      }
   }
   function restInPeace()
   {
      var _loc3_ = _root.getDepthMan(this.X,this.Y);
      _root["blood_" + _loc3_].removeMovieClip();
      _root.getInstanceAtDepth(_root.getDepthCorpse(this.X,this.Y)).removeMovieClip();
      this.swapDepths(_root.getDepthCorpse(this.X,this.Y));
   }
   function initGuns()
   {
      var _loc2_ = this.body.weapR._currentframe;
      this.body.weapR.gotoAndStop(this.body.weapL._currentframe);
      this.body.weapL.gotoAndStop(_loc2_);
   }
   function addMessage(some_text, is_crit)
   {
      this.attachMovie(!is_crit ? "FlyDamage" : "FlyCritDamage","flying_damage_" + this.inner_depth,this.inner_depth,{_x:0,_y:100});
      this["flying_damage_" + this.inner_depth].inner.value_txt.text = some_text;
      this.inner_depth += this.inner_depth >= 15 ? -14 : 1;
   }
   function initUnit(hero)
   {
      this.unit_ref = hero;
      var _loc10_ = hero.NATION.toLowerCase();
      this.DEF = 0;
      if(hero.DEX <= 100)
      {
         this.FLEE = Math.floor(hero.DEX * 0.8);
      }
      else
      {
         this.FLEE = 80 + Math.floor((hero.DEX - 100) * 0.15);
      }
      this.ANTI_FLEE = (100 - Math.round(hero.DEX / 3)) / 100;
      this.SHIELD_FLEE = hero.WEAPON_SEC.TYPE != "Shield" ? 0 : hero.WEAPON_SEC.crit;
      this.MAX_HP = hero.CON * 5 + hero.LEVEL * 20;
      this.body.arm_l.gotoAndStop(hero.GENDER + "_" + _loc10_);
      this.body.arm_r.gotoAndStop(hero.GENDER + "_" + _loc10_);
      this.body.hand_l.gotoAndStop(hero.GENDER + "_" + _loc10_);
      this.body.hand_r.gotoAndStop(hero.GENDER + "_" + _loc10_);
      this.body.footL.gotoAndStop(hero.GENDER + "_" + _loc10_);
      this.body.footR.gotoAndStop(hero.GENDER + "_" + _loc10_);
      this.body.legL.gotoAndStop(hero.GENDER + "_" + _loc10_);
      this.body.legR.gotoAndStop(hero.GENDER + "_" + _loc10_);
      this.body.body.gotoAndStop(hero.GENDER + "_" + _loc10_);
      this.body.head.gotoAndStop(hero.GENDER + "_" + _loc10_);
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
         this.HP += hero.HORSE.bonus_HP;
         this.MAX_HP += hero.HORSE.bonus_HP;
         this.FLEE /= 2;
      }
      else
      {
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
      }
      else
      {
         this.body.head.armor._visible = false;
      }
      var _loc6_ = hero.WEAPON_PRI;
      var _loc8_ = hero.WEAPON_SEC;
      if(_loc6_ == null)
      {
         _loc6_ = new WeaponClass("Fists","All",0);
      }
      if(_loc8_ == null && _loc6_.rng > 0)
      {
         _loc8_ = new WeaponClass("Fists","All",0);
      }
      this.body.weapL.gotoAndStop(_loc6_.FRAME);
      this.body.weapR.gotoAndStop(_loc8_ == null ? 169 : _loc8_.FRAME);
      if(!_loc6_.twohanded && !_loc8_.twohanded)
      {
         if(_loc8_.TYPE == "Shield" || _loc8_ == null)
         {
            this.wpn = new Weapon(_loc6_.rng != 0 ? "Ranged" : "Melee",_loc6_.dmg,_loc6_.rnd,_loc6_.rng,hero.SKILL[_loc6_.skill],_loc6_.crit + Math.floor(hero.SKILL[_loc6_.skill] / 10),_loc6_.t_bef,_loc6_.t_aft);
            this.runAnim = "run_sword";
            this.atkAnim = "sword";
            this.secRunAnim = "none";
            this.secAtkAnim = "none";
            this.wpnSec = null;
         }
         else
         {
            this.wpn = new Weapon(_loc6_.rng != 0 ? "Ranged" : "Melee",_loc6_.dmg,_loc6_.rnd,_loc6_.rng,hero.SKILL[_loc6_.skill],_loc6_.crit + Math.floor(hero.SKILL[_loc6_.skill] / 10),Math.max(_loc6_.t_bef,_loc8_.t_bef),Math.max(_loc6_.t_aft,_loc8_.t_aft));
            this.wpnSec = new Weapon(_loc8_.rng != 0 ? "Ranged" : "Melee",_loc8_.dmg,_loc8_.rnd,_loc8_.rng,hero.SKILL[_loc8_.skill] * hero.SKILL.Dual / 100,_loc8_.crit + Math.floor(hero.SKILL[_loc8_.skill] / 10),Math.max(_loc6_.t_bef,_loc8_.t_bef),Math.max(_loc6_.t_aft,_loc8_.t_aft));
            this.runAnim = "run_double";
            this.atkAnim = "double";
            this.secRunAnim = "none";
            this.secAtkAnim = "none";
         }
         this.preferRanged = false;
      }
      else
      {
         this.wpn = new Weapon(_loc6_.rng != 0 ? "Ranged" : "Melee",_loc6_.dmg,_loc6_.rnd,_loc6_.rng,hero.SKILL[_loc6_.skill],_loc6_.crit + Math.floor(hero.SKILL[_loc6_.skill] / 10),_loc6_.t_bef,_loc6_.t_aft);
         this.wpnSec = new Weapon(_loc8_.rng != 0 ? "Ranged" : "Melee",_loc8_.dmg,_loc8_.rnd,_loc8_.rng,hero.SKILL[_loc8_.skill],_loc8_.crit + Math.floor(hero.SKILL[_loc8_.skill] / 10),_loc8_.t_bef,_loc8_.t_aft);
         if(this.preferRanged = _loc6_.rng > 0)
         {
            switch(_loc8_.TYPE)
            {
               case "OnehandedSword":
               case "OnehandedAxe":
               case "OnehandedMace":
               case "TwohandedSword":
                  this.secRunAnim = "run_twohandedsword";
                  this.secAtkAnim = "twohanded_sword";
                  break;
               case "TwohandedAxe":
               case "TwohandedMace":
                  this.secRunAnim = "run_axe";
                  this.secAtkAnim = "twohanded_axe";
                  break;
               case "NinjaTo":
               case "Katana":
                  this.secRunAnim = "run_katana";
                  this.secAtkAnim = "katana";
                  break;
               case "Staff":
                  this.secRunAnim = "run_axe";
                  this.secAtkAnim = "staff";
                  break;
               case "Spear":
                  this.secRunAnim = "run_axe";
                  this.secAtkAnim = "spear";
                  break;
               case "Dagger":
                  this.secRunAnim = "run_twohandedsword";
                  this.secAtkAnim = "dagger";
                  break;
               case "Fists":
                  this.secRunAnim = "run_double";
                  this.secAtkAnim = "fists";
            }
            switch(_loc6_.TYPE)
            {
               case "Bow":
                  this.runAnim = "run_bow";
                  this.atkAnim = "bow";
                  break;
               case "Crossbow":
                  this.runAnim = "run_crossbow";
                  this.atkAnim = "crossbow";
                  break;
               case "Throwing":
                  this.runAnim = "run_suriken";
                  this.atkAnim = "suriken";
            }
         }
         else
         {
            switch(_loc6_.TYPE)
            {
               case "OnehandedSword":
               case "OnehandedAxe":
               case "OnehandedMace":
               case "TwohandedSword":
                  this.runAnim = "run_twohandedsword";
                  this.atkAnim = "twohanded_sword";
                  break;
               case "TwohandedAxe":
               case "TwohandedMace":
                  this.runAnim = "run_axe";
                  this.atkAnim = "twohanded_axe";
                  break;
               case "NinjaTo":
               case "Katana":
                  this.runAnim = "run_katana";
                  this.atkAnim = "katana";
                  break;
               case "Staff":
                  this.runAnim = "run_axe";
                  this.atkAnim = "staff";
                  break;
               case "Spear":
                  this.runAnim = "run_axe";
                  this.atkAnim = "spear";
                  break;
               case "Dagger":
                  this.runAnim = "run_twohandedsword";
                  this.atkAnim = "dagger";
                  break;
               case "Fists":
                  this.runAnim = "run_double";
                  this.atkAnim = "fists";
            }
            switch(_loc8_.TYPE)
            {
               case "Bow":
                  this.secRunAnim = "run_bow";
                  this.secAtkAnim = "bow";
                  break;
               case "Crossbow":
                  this.secRunAnim = "run_crossbow";
                  this.secAtkAnim = "crossbow";
                  break;
               case "Throwing":
                  this.secRunAnim = "run_suriken";
                  this.secAtkAnim = "suriken";
            }
         }
      }
      if(this.atkAnim == "double" && this.wpn.t_aft < 40)
      {
         this.wpn.t_aft = 40;
      }
      var _loc13_ = Math.floor(hero.STR / 2);
      if(this.wpn.TYPE == "Melee")
      {
         this.wpn.dmg += _loc13_;
      }
      if(this.wpnSec.TYPE == "Melee")
      {
         this.wpnSec.dmg += _loc13_;
      }
      var _loc9_ = ["WEAPON_PRI","WEAPON_SEC","ARMOR","HELMET"];
      var _loc7_ = 0;
      var _loc3_;
      var _loc4_;
      while(_loc7_ < _loc9_.length)
      {
         if(hero[_loc9_[_loc7_]].ENCH_ID != 0)
         {
            _loc3_ = new Enchant(hero[_loc9_[_loc7_]].ENCH_ID);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.hero_bonus.length)
            {
               this[_loc3_.hero_bonus[_loc4_]] = Math.round(this[_loc3_.hero_bonus[_loc4_]] * _loc3_.hero_amount[_loc4_]);
               _loc4_ = _loc4_ + 1;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc3_.wpn_bonus.length)
            {
               this.wpn[_loc3_.wpn_bonus[_loc4_]] += _loc3_.wpn_amount[_loc4_];
               this.wpnSec[_loc3_.wpn_bonus[_loc4_]] += _loc3_.wpn_amount[_loc4_];
               _loc4_ = _loc4_ + 1;
            }
         }
         _loc7_ = _loc7_ + 1;
      }
      this.HP = this.MAX_HP;
      this.body.gotoAndStop(this.atkAnim);
      var _loc12_;
      var _loc11_;
      if(this.team == 0 && hero.LEVEL == 0)
      {
         _loc12_ = Math.floor(_global.MAIN_HERO.INT / 2);
         _loc12_ += Math.floor(_global.MAIN_HERO.SKILL.ArtOfWar / 2);
         if(hero.NATION == _global.MAIN_HERO.NATION)
         {
            _loc12_ += _global.MAIN_HERO.SKILL.Patriotism;
         }
         _loc11_ = 1 + _loc12_ / 100;
         this.MAX_HP = Math.round(this.MAX_HP * _loc11_);
         this.HP = Math.round(this.HP * _loc11_);
         this.wpn.dmg = Math.round(this.wpn.dmg * _loc11_);
         this.wpn.rnd = Math.round(this.wpn.rnd * _loc11_);
         this.wpnSec.dmg = Math.round(this.wpnSec.dmg * _loc11_);
         this.wpnSec.rnd = Math.round(this.wpnSec.rnd * _loc11_);
      }
   }
}
