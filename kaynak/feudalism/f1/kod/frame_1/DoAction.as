function getNationNumber(nation)
{
   return NATION_NUMBER[nation.toLowerCase()];
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
function d(dice)
{
   return Math.floor(Math.random() * dice) + 1;
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
function addProjectile(fx, fy, tx, ty, dm, rn, cr, xscl_mod, wpn_frame, tm)
{
   var _loc7_ = wpn_frame == 134 || wpn_frame == 135;
   var _loc6_ = wpn_frame >= 126 && wpn_frame <= 140;
   var _loc2_ = getDepthMan(fx,fy);
   _root.attachMovie(!_loc7_ ? "Arrow" : "Grenade","gr_" + _loc2_,_loc2_ + 2,{_x:stgX(fx),_y:stgY(fy),X:fx,Y:fy,dstX:tx,dstY:ty,dmg:dm,rnd:rn,crit:cr});
   if(_loc6_)
   {
      _root["gr_" + _loc2_].gren.gotoAndStop(wpn_frame);
      _root["gr_" + _loc2_].play();
   }
   else
   {
      _root["gr_" + _loc2_].gotoAndStop(10);
   }
   _root["gr_" + _loc2_].team = tm;
   _root["gr_" + _loc2_]._xscale *= xscl_mod;
}
function addArrowShower(fx, fy, dm, cr)
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
   _root["as_" + _loc2_].addDamage(dm,cr);
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
   if(!item)
   {
      return undefined;
   }
   var _loc4_;
   if(item instanceof WeaponClass)
   {
      _loc4_ = "WeaponClass";
   }
   else if(item instanceof Armor)
   {
      _loc4_ = "Armor";
   }
   var _loc1_ = 0;
   while(_loc1_ < array.length)
   {
      if(item.ENCH_ID == array[_loc1_].ENCH_ID && array[_loc1_].CATEGORY == _loc4_ && array[_loc1_].NATION == item.NATION && array[_loc1_].TYPE == item.TYPE && array[_loc1_].LEVEL == item.LEVEL)
      {
         array[_loc1_].COUNT = array[_loc1_].COUNT + 1;
         return undefined;
      }
      _loc1_ = _loc1_ + 1;
   }
   array.push(new ItemInfo(_loc4_,item.TYPE,item.NATION,item.LEVEL,item.ENCH_ID));
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
      if(array[_loc1_].CATEGORY == item.CATEGORY && array[_loc1_].NATION == item.NATION && array[_loc1_].TYPE == item.TYPE && array[_loc1_].LEVEL == item.LEVEL && array[_loc1_].ENCH_ID == item.ENCH_ID)
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
   var _loc6_ = _global.HERO - 1;
   while(_loc6_ > 0)
   {
      if(_root["hero" + _loc6_].HP > 0 && _root["hero" + _loc6_].team == 0)
      {
         if(_root["hero" + _loc6_].unit_ref != undefined)
         {
            _global.FRIENDS.unshift(_root["hero" + _loc6_].unit_ref);
         }
      }
      _root["hero" + _loc6_].removeMovieClip();
      _loc6_ = _loc6_ - 1;
   }
   _root.hero0.removeMovieClip();
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
   _root.scr.removeMovieClip();
   _root.attachMovie("ArrowCursor","_cursor",7001,{_x:_xmouse,_y:_ymouse});
   _root._quality = "HIGH";
}
function commandAI()
{
   var _loc2_ = getTeamCount(0);
   if(MAX_UNIT_AMOUNT > _loc2_)
   {
      if(FRIENDS.length > 0)
      {
         reinforceUnit(FRIENDS.shift(),0);
         _root.scr.reinitArrowStorm();
      }
   }
   _loc2_ = getTeamCount(1);
   if(MAX_UNIT_AMOUNT > _loc2_)
   {
      if(ENEMIES.length > 0)
      {
         reinforceUnit(ENEMIES.shift(),1);
      }
      else if(_loc2_ == 0)
      {
         unloadMap();
         _root.gotoAndStop("VICTORY");
         return undefined;
      }
   }
}
function reinforceUnit(un, sd)
{
   mana[sd] -= PRICES[un];
   var _loc1_ = (F_WIDTH - 1) * sd;
   var _loc3_ = getFreeY(_loc1_);
   addUnit(stgX(_loc1_),stgY(_loc3_),un,sd);
}
function buyUnitXY(un, xx, yy)
{
   if(un == "ScottishLightChivalery" || un == "ScottishHussar" || un == "ScottishMountedGrenader" || un == "EnglishHussar" || un == "EnglishDragoon" || un == "EnglishHeavyChivalery")
   {
      addHorseman(stgX(xx),stgY(yy),un,1);
   }
   else
   {
      addSoldier(stgX(xx),stgY(yy),un,1);
   }
}
function saveGame(slot)
{
   var _loc3_ = SharedObject.getLocal("Feudalism_Save_" + slot);
   _loc3_.data.FRIENDS = new Array();
   var _loc4_ = 0;
   while(_loc4_ < _global.FRIENDS.length)
   {
      if(_global.FRIENDS[_loc4_])
      {
         _loc3_.data.FRIENDS[_loc4_] = _global.FRIENDS[_loc4_].getUnitInfo();
      }
      _loc4_ = _loc4_ + 1;
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
   _loc3_.data.MAIN_HERO.INT = _global.MAIN_HERO.INT;
   _loc3_.data.MAIN_HERO.free_points = _global.MAIN_HERO.free_points;
   _loc3_.data.MAIN_HERO.SKILL = new Array();
   for(_loc4_ in _global.MAIN_HERO.SKILL)
   {
      _loc3_.data.MAIN_HERO.SKILL[_loc4_] = _global.MAIN_HERO.SKILL[_loc4_];
   }
   _loc3_.data.MAIN_HERO.WEAPON_PRI = _global.MAIN_HERO.WEAPON_PRI == null ? null : _global.MAIN_HERO.WEAPON_PRI.getItemInfo();
   _loc3_.data.MAIN_HERO.WEAPON_SEC = _global.MAIN_HERO.WEAPON_SEC == null ? null : _global.MAIN_HERO.WEAPON_SEC.getItemInfo();
   _loc3_.data.MAIN_HERO.ARMOR = _global.MAIN_HERO.ARMOR == null ? null : _global.MAIN_HERO.ARMOR.getItemInfo();
   _loc3_.data.MAIN_HERO.HELMET = _global.MAIN_HERO.HELMET == null ? null : _global.MAIN_HERO.HELMET.getItemInfo();
   _loc3_.data.MAIN_HERO.HORSE = _global.MAIN_HERO.HORSE == null ? null : _global.MAIN_HERO.HORSE;
   _loc3_.data.INVENTORY = new Array();
   _loc4_ = 0;
   while(_loc4_ < _global.INVENTORY.length)
   {
      _loc3_.data.INVENTORY[_loc4_] = _global.INVENTORY[_loc4_];
      _loc4_ = _loc4_ + 1;
   }
   _loc3_.data.IS_CAPTURED = new Array();
   for(var _loc5_ in _global.IS_CAPTURED)
   {
      _loc3_.data.IS_CAPTURED[_loc5_] = _global.IS_CAPTURED[_loc5_];
   }
   _loc3_.data.IS_HOSTILE = new Array();
   for(_loc5_ in _global.IS_HOSTILE)
   {
      _loc3_.data.IS_HOSTILE[_loc5_] = _global.IS_HOSTILE[_loc5_];
   }
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
         _global.FRIENDS[_loc4_] = new Unit(_loc3_.data.FRIENDS[_loc4_].TYPE,_loc3_.data.FRIENDS[_loc4_].NATION,_loc3_.data.FRIENDS[_loc4_].ID);
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
   _global.MAIN_HERO.EXP = _loc3_.data.MAIN_HERO.EXP;
   _global.MAIN_HERO.LEVEL = _loc3_.data.MAIN_HERO.LEVEL;
   _global.MAIN_HERO.NAME = _loc3_.data.MAIN_HERO.NAME;
   _global.MAIN_HERO.NATION = _loc3_.data.MAIN_HERO.NATION;
   _global.MAIN_HERO.GENDER = _loc3_.data.MAIN_HERO.GENDER;
   _global.MAIN_HERO.STR = _loc3_.data.MAIN_HERO.STR;
   _global.MAIN_HERO.DEX = _loc3_.data.MAIN_HERO.DEX;
   _global.MAIN_HERO.CON = _loc3_.data.MAIN_HERO.CON;
   _global.MAIN_HERO.INT = _loc3_.data.MAIN_HERO.INT;
   _global.MAIN_HERO.free_points = _loc3_.data.MAIN_HERO.free_points;
   for(_loc4_ in _loc3_.data.MAIN_HERO.SKILL)
   {
      _global.MAIN_HERO.SKILL[_loc4_] = _loc3_.data.MAIN_HERO.SKILL[_loc4_];
   }
   _global.MAIN_HERO.WEAPON_PRI = _loc3_.data.MAIN_HERO.WEAPON_PRI == null ? null : new WeaponClass(_loc3_.data.MAIN_HERO.WEAPON_PRI.TYPE,_loc3_.data.MAIN_HERO.WEAPON_PRI.NATION,_loc3_.data.MAIN_HERO.WEAPON_PRI.LEVEL,_loc3_.data.MAIN_HERO.WEAPON_PRI.ENCH_ID);
   _global.MAIN_HERO.WEAPON_SEC = _loc3_.data.MAIN_HERO.WEAPON_SEC == null ? null : new WeaponClass(_loc3_.data.MAIN_HERO.WEAPON_SEC.TYPE,_loc3_.data.MAIN_HERO.WEAPON_SEC.NATION,_loc3_.data.MAIN_HERO.WEAPON_SEC.LEVEL,_loc3_.data.MAIN_HERO.WEAPON_SEC.ENCH_ID);
   _global.MAIN_HERO.ARMOR = _loc3_.data.MAIN_HERO.ARMOR == null ? null : new Armor(_loc3_.data.MAIN_HERO.ARMOR.TYPE,_loc3_.data.MAIN_HERO.ARMOR.NATION,_loc3_.data.MAIN_HERO.ARMOR.LEVEL,_loc3_.data.MAIN_HERO.ARMOR.ENCH_ID);
   _global.MAIN_HERO.HELMET = _loc3_.data.MAIN_HERO.HELMET == null ? null : new Armor(_loc3_.data.MAIN_HERO.HELMET.TYPE,_loc3_.data.MAIN_HERO.HELMET.NATION,_loc3_.data.MAIN_HERO.HELMET.LEVEL,_loc3_.data.MAIN_HERO.HELMET.ENCH_ID);
   _global.MAIN_HERO.HORSE = _loc3_.data.MAIN_HERO.HORSE == null ? null : new Horse(_loc3_.data.MAIN_HERO.HORSE.skin_color,_loc3_.data.MAIN_HERO.HORSE.bonus_HP,_loc3_.data.MAIN_HERO.HORSE.bonus_DEF,_loc3_.data.MAIN_HERO.HORSE.bonus_speed,_loc3_.data.MAIN_HERO.HORSE.price);
   delete _global.INVENTORY;
   _global.INVENTORY = new Array();
   _loc4_ = 0;
   while(_loc4_ < _loc3_.data.INVENTORY.length)
   {
      _global.INVENTORY[_loc4_] = new ItemInfo(_loc3_.data.INVENTORY[_loc4_].CATEGORY,_loc3_.data.INVENTORY[_loc4_].TYPE,_loc3_.data.INVENTORY[_loc4_].NATION,_loc3_.data.INVENTORY[_loc4_].LEVEL,_loc3_.data.INVENTORY[_loc4_].ENCH_ID);
      _global.INVENTORY[_loc4_].COUNT = _loc3_.data.INVENTORY[_loc4_].COUNT;
      _loc4_ = _loc4_ + 1;
   }
   _global.IS_CAPTURED = new Array();
   for(var _loc5_ in _loc3_.data.IS_CAPTURED)
   {
      _global.IS_CAPTURED[_loc5_] = _loc3_.data.IS_CAPTURED[_loc5_];
   }
   _global.IS_HOSTILE = new Array();
   for(_loc5_ in _loc3_.data.IS_HOSTILE)
   {
      _global.IS_HOSTILE[_loc5_] = _loc3_.data.IS_HOSTILE[_loc5_];
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
_global.SHIP_PRICE = 4000;
_global.BATTLE_MAP = 45;
_global.MIN_ATTACK_TIME = new Array();
_global.MIN_ATTACK_TIME.sword = 30;
_global.MIN_ATTACK_TIME.twohanded_sword = 40;
_global.MIN_ATTACK_TIME.twohanded_axe = 40;
_global.MIN_ATTACK_TIME.double = 30;
_global.MIN_ATTACK_TIME.spear = 30;
_global.MIN_ATTACK_TIME.bow = 40;
_global.MIN_ATTACK_TIME.crossbow = 60;
_global.MIN_ATTACK_TIME.dagger = 20;
_global.MIN_ATTACK_TIME.katana = 25;
_global.MIN_ATTACK_TIME.staff = 35;
_global.MIN_ATTACK_TIME.fists = 35;
_global.MIN_ATTACK_TIME.suriken = 30;
NATION_NUMBER = new Array();
NATION_NUMBER.rog = 0;
NATION_NUMBER.viz = 1;
NATION_NUMBER.ger = 2;
NATION_NUMBER.rus = 3;
NATION_NUMBER.jap = 4;
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
   _global.HERO = 1;
   delete _global.LOOT;
   _global.LOOT = new Array();
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
   delete _global.DISABLED_UNITS;
   _global.DISABLED_UNITS = new Array();
};
gameLoad = function(map)
{
   unloadMap();
   _root.WhatToLoad = map;
};
_root.onEnterFrame = function()
{
   if(_global.times >= 30)
   {
      _global.times = 0;
      if(_root.hero0 != undefined)
      {
         commandAI();
      }
   }
   else
   {
      _global.times = _global.times + 1;
   }
};
fscommand("trapallkeys",true);
fscommand("showmenu",false);
_root.kongregateServices.connect();
