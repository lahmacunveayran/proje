function getNationNumber(nation)
{
   return NATION_NUMBER[nation.toLowerCase()];
}
function isExclusive()
{
   var _loc2_ = ["http://www.arcadetown.com","http://www.freewebgames.com","http://www.gamedelight.com","http://cdn-www.arcadetown.com","file://","http://vitalyzaborov.narod.ru/swf/"];
   var _loc1_ = 0;
   while(_loc1_ < _loc2_.length)
   {
      if(_url.substr(0,_loc2_[_loc1_].length) == _loc2_[_loc1_])
      {
         return true;
      }
      _loc1_ = _loc1_ + 1;
   }
   return false;
}
function isEvilAddictingGames()
{
   var _loc2_ = ["http://www.andkon.com","http://andkon.com","https://www.andkon.com","https://andkon.com","https://addictinggames.com","https://www.addictinggames.com","http://addictinggames.com","http://www.addictinggames.com","https://www.armorgames.com","https://armorgames.com","http://www.armorgames.com","http://armorgames.com","http://vitalyzaborov.narod.ru/evil_url/","file://"];
   var _loc1_ = 0;
   while(_loc1_ < _loc2_.length)
   {
      if(_url.substr(0,_loc2_[_loc1_].length) == _loc2_[_loc1_])
      {
         return true;
      }
      _loc1_ = _loc1_ + 1;
   }
   return false;
}
function isAgame()
{
   var _loc2_ = ["https://www8.agame.com","http://www8.agame.com","http://www.agame.com","https://www.agame.com","http://agame.com","https://agame.com","file://"];
   var _loc1_ = 0;
   while(_loc1_ < _loc2_.length)
   {
      if(_url.substr(0,_loc2_[_loc1_].length) == _loc2_[_loc1_])
      {
         return true;
      }
      _loc1_ = _loc1_ + 1;
   }
   return false;
}
function getX(xx)
{
   return Math.floor(xx / CAGE_W);
}
function getY(yy)
{
   return Math.floor((yy - SKY_HEIGHT) / CAGE_H);
}
function stgX(XX)
{
   return XX * CAGE_W + CAGE_W / 2;
}
function stgY(YY)
{
   return YY * CAGE_H + CAGE_H / 2 + SKY_HEIGHT;
}
function getDepthDown(xx, yy)
{
   return DEPTH_DOWN + xx + yy * F_WIDTH;
}
function getDepthCorpse(xx, yy)
{
   return DEPTH_CORPSE + xx + yy * F_WIDTH;
}
function getDepthMan(xx, yy)
{
   return DEPTH_MAN + xx * 3 + yy * F_WIDTH * 3;
}
function normalX(xx)
{
   if(xx >= F_WIDTH)
   {
      return F_WIDTH - 1;
   }
   if(xx < 0)
   {
      return 0;
   }
   return xx;
}
function normalY(yy)
{
   if(yy >= F_WIDTH)
   {
      return F_HEIGHT - 1;
   }
   if(yy < 0)
   {
      return 0;
   }
   return yy;
}
function znak(num)
{
   return num >= 0 ? 1 : -1;
}
function d(ddd)
{
   return Math.floor(Math.random() * ddd) + 1;
}
function dice(ddd)
{
   return Math.floor(Math.random() * ddd);
}
function dd(dice)
{
   return Math.floor(Math.random() * (dice * 2 + 1)) - dice;
}
function addUnit(xx, yy, un, tm)
{
   if(un == null)
   {
      return undefined;
   }
   if(un.HORSE != null)
   {
      _root.attachMovie("Horseman","hero" + _global.HERO,9999,{_x:xx,_y:yy,team:tm});
      _root["hero" + _global.HERO].MOVE_FRAMES = 445;
   }
   else
   {
      _root.attachMovie("Human","hero" + _global.HERO,9999,{_x:xx,_y:yy,team:tm});
      _root["hero" + _global.HERO].MOVE_FRAMES = 475;
   }
   _root["hero" + _global.HERO].initUnit(un);
   _global.HERO = _global.HERO + 1;
}
function addHero(xx, yy, un, tm)
{
   if(un == null)
   {
      return undefined;
   }
   if(un.HORSE != null)
   {
      _root.attachMovie("Horseman_Player","hero0",9999,{_x:xx,_y:yy,team:tm});
      _root.hero0.MOVE_FRAMES = 445;
   }
   else
   {
      _root.attachMovie("Human_Player","hero0",9999,{_x:xx,_y:yy,team:tm});
      _root.hero0.MOVE_FRAMES = 475;
   }
   _root.hero0.initUnit(un);
}
function addProjectile(fx, fy, tx, ty, dmg_data, xscl_mod, wpn_frame, tm, pr)
{
   var _loc5_ = wpn_frame == 230 || wpn_frame == 231;
   var _loc4_ = wpn_frame >= 218 && wpn_frame <= 238;
   var _loc2_ = getDepthMan(fx,fy);
   _root.attachMovie(!_loc5_ ? "Arrow" : "Grenade","gr_" + _loc2_,_loc2_ + 2,{_x:stgX(fx),_y:stgY(fy),X:fx,Y:fy,dstX:tx,dstY:ty,dmg_data:dmg_data});
   if(_loc4_)
   {
      if(!_loc5_)
      {
         _root["gr_" + _loc2_].gren.gotoAndStop(wpn_frame);
      }
      _root["gr_" + _loc2_].play();
   }
   else
   {
      _root["gr_" + _loc2_].gotoAndStop(10);
   }
   _root["gr_" + _loc2_].is_throwing = _loc4_;
   if(pr)
   {
      _root["gr_" + _loc2_].pierce = pr;
   }
   _root["gr_" + _loc2_].team = tm;
   _root["gr_" + _loc2_]._xscale *= xscl_mod;
}
function addArrowShower(fx, fy, dmg_dat)
{
   var _loc2_ = getDepthMan(fx,fy);
   if(_root["as_" + _loc2_])
   {
      _root["as_" + _loc2_].play_count = _root["as_" + _loc2_].play_count + 1;
   }
   else
   {
      _root.attachMovie("ArrowShower","as_" + _loc2_,_loc2_ + 1,{_x:stgX(fx),_y:stgY(fy),X:fx,Y:fy});
   }
   _root["as_" + _loc2_].addDamage(dmg_dat);
}
function addArrowWall(fx, fy, dm, cr)
{
   var _loc2_ = getDepthMan(fx,fy);
   if(_root["as_" + _loc2_])
   {
      _root["as_" + _loc2_].play_count = _root["as_" + _loc2_].play_count + 1;
   }
   else
   {
      _root.attachMovie("ArrowWall","as_" + _loc2_,_loc2_ + 1,{_x:stgX(fx),_y:stgY(fy),X:fx,Y:fy});
   }
   _root["as_" + _loc2_].addDamage(dm,cr);
}
function addBlow(xx, yy, tp)
{
   var _loc2_ = getDepthDown(xx,yy);
   _root.attachMovie("Blow " + tp,"dw_" + _loc2_,_loc2_,{_x:stgX(xx),_y:stgY(yy)});
}
function openCity(townID)
{
   _global.CURR_TOWN = townID;
   gotoAndStop("TOWN_SCREEN");
}
function deselectUnits()
{
   var _loc2_;
   while(_loc2_ = _global.SELECTED.pop())
   {
      _loc2_.borders._visible = false;
   }
}
function getFreeY(xx)
{
   var _loc3_ = d(F_HEIGHT) - 1;
   var _loc2_ = 0;
   while(!(_global.field[xx][_loc3_].empty && _global.field[xx][_loc3_].free))
   {
      _loc3_ = d(F_HEIGHT) - 1;
      _loc2_ = _loc2_ + 1;
      if(_loc2_ > 150)
      {
         break;
      }
   }
   return _loc3_;
}
function getTeamCount(tm)
{
   var _loc4_ = 0;
   var _loc3_ = 0;
   while(_loc3_ < _global.HERO)
   {
      if(_root["hero" + _loc3_].HP > 0 && _root["hero" + _loc3_].team == tm)
      {
         _loc4_ = _loc4_ + 1;
      }
      _loc3_ = _loc3_ + 1;
   }
   return _loc4_;
}
function addItemTo(array, item)
{
   addItemInfoTo(array,item.getItemInfo());
}
function addItemInfoTo(array, item)
{
   if(!item)
   {
      return undefined;
   }
   var _loc1_ = 0;
   while(_loc1_ < array.length)
   {
      if(array[_loc1_].CATEGORY == item.CATEGORY && array[_loc1_].NATION == item.NATION && array[_loc1_].TYPE == item.TYPE && array[_loc1_].LEVEL == item.LEVEL && array[_loc1_].ENCH_ID == item.ENCH_ID && array[_loc1_].REFINE == item.REFINE)
      {
         array[_loc1_].COUNT += item.COUNT;
         return undefined;
      }
      _loc1_ = _loc1_ + 1;
   }
   array.push(item);
}
function unloadMap()
{
   submitStat("MaxDamageInflicted",_global.MAX_INFLICTED);
   submitStat("MaxDamageReceived",_global.MAX_RECEIVED);
   var _loc6_ = _global.HERO - 1;
   while(_loc6_ > 0)
   {
      if(_root["hero" + _loc6_].HP > 0)
      {
         _root["hero" + _loc6_].cancelAllStatuses();
         if(_root["hero" + _loc6_].team == 0)
         {
            if(_root["hero" + _loc6_].unit_ref != undefined)
            {
               _global.FRIENDS.unshift(_root["hero" + _loc6_].unit_ref);
            }
         }
      }
      _root["hero" + _loc6_].removeMovieClip();
      _loc6_ = _loc6_ - 1;
   }
   _root.hero0.removeMovieClip();
   delete _global.AURAS;
   var _loc4_ = 0;
   var _loc3_;
   var _loc5_;
   while(_loc4_ < F_WIDTH)
   {
      _loc3_ = 0;
      while(_loc3_ < F_HEIGHT)
      {
         _global.field[_loc4_][_loc3_].empty = true;
         _global.field[_loc4_][_loc3_].free = true;
         _global.field[_loc4_][_loc3_].who.removeMovieClip();
         _global.field[_loc4_][_loc3_].who = null;
         _loc5_ = getDepthMan(_loc4_,_loc3_);
         _root["blood_" + _loc5_].removeMovieClip();
         _root["gr_" + _loc5_].removeMovieClip();
         _root["as_" + _loc5_].removeMovieClip();
         _loc3_ = _loc3_ + 1;
      }
      _loc4_ = _loc4_ + 1;
   }
   _global.HERO = 1;
   if(_global.EVIL_HERO)
   {
      if(_global.EVIL_HERO.LEVEL == 50)
      {
         _root.submitStat("ChampionFallen_" + _global.EVIL_HERO.NATION,1);
      }
   }
   _global.EVIL_HERO = null;
   _root.scr.removeMovieClip();
   _root.attachMovie("ArrowCursor","_cursor",7001,{_x:_xmouse,_y:_ymouse});
   _root._quality = "HIGH";
   _root.onEnterFrame = null;
}
function commandAI()
{
   var _loc3_ = getTeamCount(0);
   if(MAX_UNIT_AMOUNT > _loc3_)
   {
      if(FRIENDS.length > 0 && _global.BATTLE_TYPE != "CHALLENGE" && _global.BATTLE_TYPE != "ARMY_CHALLENGE")
      {
         reinforceUnit(FRIENDS.shift(),0);
         _root.scr.reinitArrowStorm();
      }
   }
   _loc3_ = getTeamCount(1);
   if(MAX_UNIT_AMOUNT > _loc3_)
   {
      if(ENEMIES.length > 0 && _global.BATTLE_TYPE != "CHALLENGE" && _global.BATTLE_TYPE != "ARMY_CHALLENGE")
      {
         reinforceUnit(ENEMIES.shift(),1);
      }
      else if(_loc3_ == 0)
      {
         unloadMap();
         _root.gotoAndStop("VICTORY");
         return undefined;
      }
   }
}
function getTeam(team_num)
{
   var _loc4_ = new Array();
   var _loc3_ = _global.HERO - 1;
   while(_loc3_ >= 1)
   {
      if(_root["hero" + _loc3_].HP > 0 && _root["hero" + _loc3_].team == team_num && _root["hero" + _loc3_].unit_ref != _global.EVIL_HERO)
      {
         _loc4_.unshift(_root["hero" + _loc3_]);
      }
      _loc3_ = _loc3_ - 1;
   }
   return _loc4_;
}
function getSoldiersAmount()
{
   var _loc3_ = 0;
   var _loc2_ = 0;
   while(_loc2_ < _global.FRIENDS.length)
   {
      if(_global.FRIENDS[_loc2_] != null)
      {
         _loc3_ = _loc3_ + 1;
      }
      _loc2_ = _loc2_ + 1;
   }
   return _loc3_;
}
function operateStatuses()
{
   var _loc3_ = _global.HERO - 1;
   while(_loc3_ >= 0)
   {
      if(_root["hero" + _loc3_].HP > 0)
      {
         _root["hero" + _loc3_].regenerateSP();
         _root["hero" + _loc3_].operateStatuses();
      }
      _loc3_ = _loc3_ - 1;
   }
}
function operateAuras()
{
   var _loc5_ = getTeam(0);
   var _loc4_ = getTeam(1);
   var _loc3_ = 0;
   while(_loc3_ < _global.AURAS.length)
   {
      if(!_global.AURAS[_loc3_].operate(_loc5_,_loc4_))
      {
         if(_global.AURAS[_loc3_].caster == _root.hero0)
         {
            _root.scr.resetCurrAura(_global.AURAS[_loc3_].back_ref,false);
         }
         _global.AURAS.splice(_loc3_,1);
         _loc3_ = _loc3_ - 1;
      }
      _loc3_ = _loc3_ + 1;
   }
}
function reinforceUnit(un, sd)
{
   mana[sd] -= PRICES[un];
   var _loc1_ = (F_WIDTH - 1) * sd;
   var _loc3_ = getFreeY(_loc1_);
   addUnit(stgX(_loc1_),stgY(_loc3_),un,sd);
}
function submitStat(stat_name, stat_value)
{
   if(!_global.EASY_MODE)
   {
      _root.kongregateStats.submit(stat_name + "_Normal",stat_value);
   }
   _root.kongregateStats.submit(stat_name + "_Easy",stat_value);
}
function saveGame(slot)
{
   var _loc3_ = SharedObject.getLocal("Feudalism_Save_" + slot);
   _loc3_.data.FRIENDS = new Array();
   var _loc5_ = 0;
   while(_loc5_ < _global.FRIENDS.length)
   {
      if(_global.FRIENDS[_loc5_])
      {
         _loc3_.data.FRIENDS[_loc5_] = _global.FRIENDS[_loc5_].getUnitInfo();
      }
      _loc5_ = _loc5_ + 1;
   }
   _loc3_.data.QUEST = new Object();
   _loc3_.data.QUEST.avatar_id = _global.QUEST.avatar_id;
   _loc3_.data.QUEST.enemies_amount = _global.QUEST.enemies_amount;
   _loc3_.data.QUEST.cities = _global.QUEST.cities;
   _loc3_.data.QUEST.rewards = _global.QUEST.rewards;
   _loc3_.data.QUEST.curr_city = _global.QUEST.curr_city;
   _loc3_.data.QUEST.curr_gold = _global.QUEST.curr_gold;
   _loc3_.data.MAIN_HERO = new Object();
   _loc3_.data.MAIN_HERO.EXP = _global.MAIN_HERO.EXP;
   _loc3_.data.MAIN_HERO.LEVEL = _global.MAIN_HERO.LEVEL;
   _loc3_.data.MAIN_HERO.NAME = _global.MAIN_HERO.NAME;
   _loc3_.data.MAIN_HERO.NATION = _global.MAIN_HERO.NATION;
   _loc3_.data.MAIN_HERO.GENDER = _global.MAIN_HERO.GENDER;
   _loc3_.data.MAIN_HERO.STR = _global.MAIN_HERO.STR;
   _loc3_.data.MAIN_HERO.DEX = _global.MAIN_HERO.DEX;
   _loc3_.data.MAIN_HERO.CON = _global.MAIN_HERO.CON;
   _loc3_.data.MAIN_HERO.SPR = _global.MAIN_HERO.SPR;
   _loc3_.data.MAIN_HERO.stat_points = _global.MAIN_HERO.stat_points;
   _loc3_.data.MAIN_HERO.skill_points = _global.MAIN_HERO.skill_points;
   _loc3_.data.MAIN_HERO.SKILL = new Array();
   for(_loc5_ in _global.MAIN_HERO.SKILL)
   {
      _loc3_.data.MAIN_HERO.SKILL[_loc5_] = _global.MAIN_HERO.SKILL[_loc5_];
   }
   _loc3_.data.MAIN_HERO.ACTIVE_SKILLS = new Array();
   _loc3_.data.MAIN_HERO.PASSIVE_SKILLS = new Array();
   _loc3_.data.MAIN_HERO.AURA_SKILLS = new Array();
   for(_loc5_ in _global.MAIN_HERO.ACTIVE_SKILLS)
   {
      _loc3_.data.MAIN_HERO.ACTIVE_SKILLS[_loc5_] = new Array();
      for(_loc4_ in _global.MAIN_HERO.ACTIVE_SKILLS[_loc5_])
      {
         _loc3_.data.MAIN_HERO.ACTIVE_SKILLS[_loc5_][_loc4_] = _global.MAIN_HERO.ACTIVE_SKILLS[_loc5_][_loc4_];
      }
   }
   for(_loc5_ in _global.MAIN_HERO.PASSIVE_SKILLS)
   {
      _loc3_.data.MAIN_HERO.PASSIVE_SKILLS[_loc5_] = new Array();
      for(_loc4_ in _global.MAIN_HERO.PASSIVE_SKILLS[_loc5_])
      {
         _loc3_.data.MAIN_HERO.PASSIVE_SKILLS[_loc5_][_loc4_] = _global.MAIN_HERO.PASSIVE_SKILLS[_loc5_][_loc4_];
      }
   }
   for(_loc5_ in _global.MAIN_HERO.AURA_SKILLS)
   {
      _loc3_.data.MAIN_HERO.AURA_SKILLS[_loc5_] = new Array();
      for(_loc4_ in _global.MAIN_HERO.AURA_SKILLS[_loc5_])
      {
         _loc3_.data.MAIN_HERO.AURA_SKILLS[_loc5_][_loc4_] = _global.MAIN_HERO.AURA_SKILLS[_loc5_][_loc4_];
      }
   }
   _loc3_.data.MAIN_HERO.WEAPON_PRI = _global.MAIN_HERO.WEAPON_PRI == null ? null : _global.MAIN_HERO.WEAPON_PRI.getItemInfo();
   _loc3_.data.MAIN_HERO.WEAPON_SEC = _global.MAIN_HERO.WEAPON_SEC == null ? null : _global.MAIN_HERO.WEAPON_SEC.getItemInfo();
   _loc3_.data.MAIN_HERO.ARMOR = _global.MAIN_HERO.ARMOR == null ? null : _global.MAIN_HERO.ARMOR.getItemInfo();
   _loc3_.data.MAIN_HERO.HELMET = _global.MAIN_HERO.HELMET == null ? null : _global.MAIN_HERO.HELMET.getItemInfo();
   _loc3_.data.MAIN_HERO.HORSE = _global.MAIN_HERO.HORSE == null ? null : _global.MAIN_HERO.HORSE;
   _loc3_.data.INVENTORY = _global.INVENTORY;
   _loc3_.data.IS_CAPTURED = _global.IS_CAPTURED;
   _loc3_.data.IS_HOSTILE = _global.IS_HOSTILE;
   _loc3_.data.EASY_MODE = _global.EASY_MODE;
   _loc3_.data.SHIP_LOCATION = _global.SHIP_LOCATION;
   _loc3_.data.CURR_TOWN = _global.CURR_TOWN;
   _loc3_.data.SAILING_SHIP = _global.SAILING_SHIP;
   _loc3_.data.GOLD = _global.GOLD;
   _loc3_.data.POTION_HealSmall = _global.POTION_HealSmall;
   _loc3_.data.POTION_HealMedium = _global.POTION_HealMedium;
   _loc3_.data.POTION_HealBig = _global.POTION_HealBig;
   _loc3_.data.SCROLL_AllHealSmall = _global.SCROLL_AllHealSmall;
   _loc3_.data.SCROLL_AllHealBig = _global.SCROLL_AllHealBig;
   _loc3_.data.SCROLL_Rage = _global.SCROLL_Rage;
   _loc3_.data.GAME_ENDED = _global.GAME_ENDED;
   _loc3_.flush(65536);
   _root.town_screen.wnd.gotoAndStop(1);
   _root.town_screen.enableAll();
}
function loadGame(slot)
{
   var _loc3_ = SharedObject.getLocal("Feudalism_Save_" + slot);
   if(!_loc3_.data.GOLD)
   {
      return false;
   }
   delete _global.FRIENDS;
   _global.FRIENDS = new Array();
   var _loc4_ = 0;
   while(_loc4_ < _loc3_.data.FRIENDS.length)
   {
      if(_loc3_.data.FRIENDS[_loc4_])
      {
         _global.FRIENDS[_loc4_] = new Unit(_loc3_.data.FRIENDS[_loc4_].NATION,_loc3_.data.FRIENDS[_loc4_].TYPE,_loc3_.data.FRIENDS[_loc4_].ID);
      }
      _loc4_ = _loc4_ + 1;
   }
   delete _global.QUEST;
   _global.QUEST = new Quest();
   _global.QUEST.avatar_id = _loc3_.data.QUEST.avatar_id;
   _global.QUEST.enemies_amount = _loc3_.data.QUEST.enemies_amount;
   _global.QUEST.cities = _loc3_.data.QUEST.cities;
   _global.QUEST.rewards = _loc3_.data.QUEST.rewards;
   _global.QUEST.curr_city = _loc3_.data.QUEST.curr_city;
   _global.QUEST.curr_gold = _loc3_.data.QUEST.curr_gold;
   delete _global.MAIN_HERO;
   _global.MAIN_HERO = new Hero();
   _global.MAIN_HERO.EXP = _loc3_.data.MAIN_HERO.EXP;
   _global.MAIN_HERO.LEVEL = _loc3_.data.MAIN_HERO.LEVEL;
   _global.MAIN_HERO.NAME = _loc3_.data.MAIN_HERO.NAME;
   _global.MAIN_HERO.NATION = _loc3_.data.MAIN_HERO.NATION;
   _global.MAIN_HERO.GENDER = _loc3_.data.MAIN_HERO.GENDER;
   _global.MAIN_HERO.STR = _loc3_.data.MAIN_HERO.STR;
   _global.MAIN_HERO.DEX = _loc3_.data.MAIN_HERO.DEX;
   _global.MAIN_HERO.CON = _loc3_.data.MAIN_HERO.CON;
   _global.MAIN_HERO.SPR = _loc3_.data.MAIN_HERO.SPR;
   _global.MAIN_HERO.stat_points = _loc3_.data.MAIN_HERO.stat_points;
   _global.MAIN_HERO.skill_points = _loc3_.data.MAIN_HERO.skill_points;
   delete _global.MAIN_HERO.SKILL;
   _global.MAIN_HERO.SKILL = new Array();
   for(_loc4_ in _loc3_.data.MAIN_HERO.SKILL)
   {
      _global.MAIN_HERO.SKILL[_loc4_] = _loc3_.data.MAIN_HERO.SKILL[_loc4_];
   }
   delete _global.MAIN_HERO.ACTIVE_SKILLS;
   delete _global.MAIN_HERO.PASSIVE_SKILLS;
   delete _global.MAIN_HERO.AURA_SKILLS;
   _global.MAIN_HERO.ACTIVE_SKILLS = new Array();
   _global.MAIN_HERO.PASSIVE_SKILLS = new Array();
   _global.MAIN_HERO.AURA_SKILLS = new Array();
   for(_loc4_ in _loc3_.data.MAIN_HERO.ACTIVE_SKILLS)
   {
      _global.MAIN_HERO.ACTIVE_SKILLS[_loc4_] = new Array();
      for(_loc5_ in _loc3_.data.MAIN_HERO.ACTIVE_SKILLS[_loc4_])
      {
         _global.MAIN_HERO.ACTIVE_SKILLS[_loc4_][_loc5_] = _loc3_.data.MAIN_HERO.ACTIVE_SKILLS[_loc4_][_loc5_];
      }
   }
   for(_loc4_ in _loc3_.data.MAIN_HERO.PASSIVE_SKILLS)
   {
      _global.MAIN_HERO.PASSIVE_SKILLS[_loc4_] = new Array();
      for(_loc5_ in _loc3_.data.MAIN_HERO.PASSIVE_SKILLS[_loc4_])
      {
         _global.MAIN_HERO.PASSIVE_SKILLS[_loc4_][_loc5_] = _loc3_.data.MAIN_HERO.PASSIVE_SKILLS[_loc4_][_loc5_];
      }
   }
   for(_loc4_ in _loc3_.data.MAIN_HERO.AURA_SKILLS)
   {
      _global.MAIN_HERO.AURA_SKILLS[_loc4_] = new Array();
      for(_loc5_ in _loc3_.data.MAIN_HERO.AURA_SKILLS[_loc4_])
      {
         _global.MAIN_HERO.AURA_SKILLS[_loc4_][_loc5_] = _loc3_.data.MAIN_HERO.AURA_SKILLS[_loc4_][_loc5_];
      }
   }
   _global.MAIN_HERO.WEAPON_PRI = _loc3_.data.MAIN_HERO.WEAPON_PRI == null ? null : new WeaponClass(_loc3_.data.MAIN_HERO.WEAPON_PRI.TYPE,_loc3_.data.MAIN_HERO.WEAPON_PRI.NATION,_loc3_.data.MAIN_HERO.WEAPON_PRI.LEVEL,_loc3_.data.MAIN_HERO.WEAPON_PRI.ENCH_ID,_loc3_.data.MAIN_HERO.WEAPON_PRI.REFINE);
   _global.MAIN_HERO.WEAPON_SEC = _loc3_.data.MAIN_HERO.WEAPON_SEC == null ? null : new WeaponClass(_loc3_.data.MAIN_HERO.WEAPON_SEC.TYPE,_loc3_.data.MAIN_HERO.WEAPON_SEC.NATION,_loc3_.data.MAIN_HERO.WEAPON_SEC.LEVEL,_loc3_.data.MAIN_HERO.WEAPON_SEC.ENCH_ID,_loc3_.data.MAIN_HERO.WEAPON_SEC.REFINE);
   _global.MAIN_HERO.ARMOR = _loc3_.data.MAIN_HERO.ARMOR == null ? null : new Armor(_loc3_.data.MAIN_HERO.ARMOR.TYPE,_loc3_.data.MAIN_HERO.ARMOR.NATION,_loc3_.data.MAIN_HERO.ARMOR.LEVEL,_loc3_.data.MAIN_HERO.ARMOR.ENCH_ID,_loc3_.data.MAIN_HERO.ARMOR.REFINE);
   _global.MAIN_HERO.HELMET = _loc3_.data.MAIN_HERO.HELMET == null ? null : new Armor(_loc3_.data.MAIN_HERO.HELMET.TYPE,_loc3_.data.MAIN_HERO.HELMET.NATION,_loc3_.data.MAIN_HERO.HELMET.LEVEL,_loc3_.data.MAIN_HERO.HELMET.ENCH_ID,_loc3_.data.MAIN_HERO.HELMET.REFINE);
   _global.MAIN_HERO.HORSE = _loc3_.data.MAIN_HERO.HORSE == null ? null : new Horse(_loc3_.data.MAIN_HERO.HORSE.skin_color,_loc3_.data.MAIN_HERO.HORSE.bonus_HP,_loc3_.data.MAIN_HERO.HORSE.bonus_DEF,_loc3_.data.MAIN_HERO.HORSE.bonus_speed,_loc3_.data.MAIN_HERO.HORSE.price);
   delete _global.INVENTORY;
   _global.INVENTORY = new Array();
   _loc4_ = 0;
   while(_loc4_ < _loc3_.data.INVENTORY.length)
   {
      _global.INVENTORY[_loc4_] = new ItemInfo(_loc3_.data.INVENTORY[_loc4_].CATEGORY,_loc3_.data.INVENTORY[_loc4_].TYPE,_loc3_.data.INVENTORY[_loc4_].NATION,_loc3_.data.INVENTORY[_loc4_].LEVEL,_loc3_.data.INVENTORY[_loc4_].ENCH_ID,_loc3_.data.INVENTORY[_loc4_].REFINE);
      _global.INVENTORY[_loc4_].COUNT = _loc3_.data.INVENTORY[_loc4_].COUNT;
      _loc4_ = _loc4_ + 1;
   }
   delete _global.IS_CAPTURED;
   _global.IS_CAPTURED = _loc3_.data.IS_CAPTURED;
   delete _global.IS_HOSTILE;
   _global.IS_HOSTILE = _loc3_.data.IS_HOSTILE;
   if(_loc3_.data.EASY_MODE == undefined)
   {
      _global.EASY_MODE = false;
   }
   else
   {
      _global.EASY_MODE = _loc3_.data.EASY_MODE;
   }
   _global.SHIP_LOCATION = _loc3_.data.SHIP_LOCATION;
   _global.CURR_TOWN = _loc3_.data.CURR_TOWN;
   _global.SAILING_SHIP = _loc3_.data.SAILING_SHIP;
   _global.GOLD = _loc3_.data.GOLD;
   _global.POTION_HealSmall = _loc3_.data.POTION_HealSmall;
   _global.POTION_HealMedium = _loc3_.data.POTION_HealMedium;
   _global.POTION_HealBig = _loc3_.data.POTION_HealBig;
   _global.SCROLL_AllHealSmall = _loc3_.data.SCROLL_AllHealSmall;
   _global.SCROLL_AllHealBig = _loc3_.data.SCROLL_AllHealBig;
   _global.SCROLL_Rage = _loc3_.data.SCROLL_Rage;
   if(_loc3_.data.GAME_ENDED == undefined)
   {
      _global.GAME_ENDED = false;
   }
   else
   {
      _global.GAME_ENDED = _loc3_.data.GAME_ENDED;
   }
   _root.gotoAndStop("TOWN_SCREEN");
   _root.town_screen.init();
   return true;
}
_global.F_WIDTH = 20;
_global.F_HEIGHT = 8;
_global.SKY_HEIGHT = 300;
_global.CAGE_W = 40;
_global.CAGE_H = 25;
_global.SCREEN_W = 800;
_global.SCREEN_H = 600;
_global.DEPTH_DOWN = 1000;
_global.DEPTH_CORPSE = 2000;
_global.DEPTH_MAN = 3000;
_global.S_ANGLE = 3;
_global.DISAPEAR_TIME = 2;
_global.SELECTED = new Array();
_global.MAX_UNIT_AMOUNT = 10;
_global.times = 0;
_global.RAGE = new Array(2);
_global.SHIP_PRICE = 10000;
_global.BATTLE_MAP = 45;
NATION_NUMBER = new Array();
NATION_NUMBER.rog = 0;
NATION_NUMBER.viz = 1;
NATION_NUMBER.ger = 2;
NATION_NUMBER.rus = 3;
NATION_NUMBER.jap = 4;
NATION_NUMBER.mon = 5;
NATION_NUMBER.ara = 6;
_global.field = new Array(F_WIDTH);
var i = 0;
while(i < _global.field.length)
{
   _global.field[i] = new Array(F_HEIGHT);
   var j = 0;
   while(j < F_HEIGHT)
   {
      _global.field[i][j] = new Cage(i,j);
      j++;
   }
   i++;
}
percent = function(x)
{
   return d(100) <= x;
};
loadDefaults = function()
{
   var _loc2_ = SharedObject.getLocal("Feudalism");
   var _loc3_ = false;
   for(var _loc4_ in _loc2_.data)
   {
      _loc3_ = true;
      break;
   }
   if(_loc3_)
   {
      _global.SAVED_QUALITY = _loc2_.data.SAVED_QUALITY;
      _global.HIGHLIGHT_TROOPS = _loc2_.data.HIGHLIGHT_TROOPS;
      _global.SHOW_HELP = _loc2_.data.SHOW_HELP;
      _global.CO_UP_1 = _loc2_.data.CO_UP_1;
      _global.CO_UP_2 = _loc2_.data.CO_UP_2;
      _global.CO_DOWN_1 = _loc2_.data.CO_DOWN_1;
      _global.CO_DOWN_2 = _loc2_.data.CO_DOWN_2;
      _global.CO_LEFT_1 = _loc2_.data.CO_LEFT_1;
      _global.CO_LEFT_2 = _loc2_.data.CO_LEFT_2;
      _global.CO_RIGHT_1 = _loc2_.data.CO_RIGHT_1;
      _global.CO_RIGHT_2 = _loc2_.data.CO_RIGHT_2;
      _global.CO_ATTACK_1 = _loc2_.data.CO_ATTACK_1;
      _global.CO_ATTACK_2 = _loc2_.data.CO_ATTACK_2;
      _global.CO_SWITCH = _loc2_.data.CO_SWITCH;
   }
   else
   {
      _global.SAVED_QUALITY = "MEDIUM";
      _global.HIGHLIGHT_TROOPS = true;
      _global.SHOW_HELP = true;
      _global.CO_UP_1 = 38;
      _global.CO_UP_2 = 87;
      _global.CO_DOWN_1 = 40;
      _global.CO_DOWN_2 = 83;
      _global.CO_LEFT_1 = 37;
      _global.CO_LEFT_2 = 65;
      _global.CO_RIGHT_1 = 39;
      _global.CO_RIGHT_2 = 68;
      _global.CO_ATTACK_1 = 32;
      _global.CO_ATTACK_2 = 45;
      _global.CO_SWITCH = 16;
   }
};
saveDefaults = function()
{
   var _loc2_ = SharedObject.getLocal("Feudalism");
   _loc2_.data.SAVED_QUALITY = _global.SAVED_QUALITY;
   _loc2_.data.HIGHLIGHT_TROOPS = _global.HIGHLIGHT_TROOPS;
   _loc2_.data.SHOW_HELP = _global.SHOW_HELP;
   _loc2_.data.CO_UP_1 = _global.CO_UP_1;
   _loc2_.data.CO_UP_2 = _global.CO_UP_2;
   _loc2_.data.CO_DOWN_1 = _global.CO_DOWN_1;
   _loc2_.data.CO_DOWN_2 = _global.CO_DOWN_2;
   _loc2_.data.CO_LEFT_1 = _global.CO_LEFT_1;
   _loc2_.data.CO_LEFT_2 = _global.CO_LEFT_2;
   _loc2_.data.CO_RIGHT_1 = _global.CO_RIGHT_1;
   _loc2_.data.CO_RIGHT_2 = _global.CO_RIGHT_2;
   _loc2_.data.CO_ATTACK_1 = _global.CO_ATTACK_1;
   _loc2_.data.CO_ATTACK_2 = _global.CO_ATTACK_2;
   _loc2_.data.CO_SWITCH = _global.CO_SWITCH;
   _loc2_.flush();
};
loadMap = function(map)
{
   _root.WhatToLoad = map;
   _global.MAX_INFLICTED = 0;
   _global.MAX_RECEIVED = 0;
   _global.HERO = 1;
   delete _global.LOOT;
   _global.LOOT = new Array();
   _global.AURAS = new Array();
   _global.EXP_GOT = 0;
   _global.GOLD_GOT = 0;
   _root.attachMovie("BattleCursor","_cursor",7001,{_x:_xmouse,_y:_ymouse});
   _root.attachMovie("Screen","scr",6002,{_x:0,_y:0});
   _root.gotoAndStop(map + 4);
   var _loc4_ = 0;
   var _loc3_;
   while(_loc4_ < F_WIDTH)
   {
      _loc3_ = 0;
      while(_loc3_ < F_HEIGHT)
      {
         _global.field[_loc4_][_loc3_].empty = true;
         _global.field[_loc4_][_loc3_].free = true;
         _global.field[_loc4_][_loc3_].who = null;
         _loc3_ = _loc3_ + 1;
      }
      _loc4_ = _loc4_ + 1;
   }
   _root._quality = _global.SAVED_QUALITY;
   _root.onEnterFrame = _root.battleEnterFrame;
};
gameLoad = function(map)
{
   unloadMap();
   _root.WhatToLoad = map;
   _root.gotoAndStop("GAME_LOAD");
};
_root.battleEnterFrame = function()
{
   if(_global.times >= 30)
   {
      _global.times = 0;
      commandAI();
      operateStatuses();
      operateAuras();
   }
   else
   {
      _global.times = _global.times + 1;
   }
};
_root.tutorialEnterFrame = function()
{
   if(_global.times >= 30)
   {
      _global.times = 0;
      operateStatuses();
      operateAuras();
   }
   else
   {
      _global.times = _global.times + 1;
   }
};
var _mochiads_game_id = "688d29a336371bcc";
fscommand("trapallkeys",true);
_root.kongregateServices.connect();
MochiAd.showPreGameAd({id:"688d29a336371bcc",res:"800x600"});
