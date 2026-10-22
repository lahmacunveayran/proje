var i = 0;
while(i < 5)
{
   if(_global.FRIENDS[i])
   {
      this["fr_" + i].setHero(_global.FRIENDS[i]);
      this["fr_" + i].anim._xscale = 65;
      this["fr_" + i].anim._yscale = 65;
      this["fr_" + i].anim._xscale *= -1;
      this["fr_" + i]._visible = true;
   }
   else
   {
      this["fr_" + i]._visible = false;
   }
   i++;
}
var i = 0;
while(i < 5)
{
   if(_global.ENEMIES[i])
   {
      this["en_" + i].setHero(_global.ENEMIES[i]);
      this["en_" + i].anim._xscale = 65;
      this["en_" + i].anim._yscale = 65;
      this["en_" + i].anim._xscale *= -1;
      this["en_" + i]._visible = true;
   }
   else
   {
      this["en_" + i]._visible = false;
   }
   i++;
}
this.hr_0.setHero(_global.MAIN_HERO);
this.hr_0.anim._xscale = 65;
this.hr_0.anim._yscale = 65;
this.hr_0.anim._xscale *= -1;
this.hp_txt.text = this.hr_0.anim.HP + "/" + this.hr_0.anim.MAX_HP;
this.backgr.gotoAndStop(_global.BATTLE_MAP);
stop();
