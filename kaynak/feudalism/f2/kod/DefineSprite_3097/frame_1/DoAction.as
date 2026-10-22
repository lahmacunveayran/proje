hero.attachMovie(_global.MAIN_HERO.HORSE != null ? "Horseman" : "Human","anim",1,{_x:0,_y:0});
hero.anim._xscale = 70;
hero.anim._yscale = 70;
hero.anim._x = 0;
hero.anim._y = 0;
hero.anim.onEnterFrame = null;
hero.anim.initUnit(_global.MAIN_HERO);
hero.anim.die();
