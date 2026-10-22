if(_global.field[X][Y].who != null && _global.field[X][Y].free)
{
   var hit_chance = 100 - (_global.field[X][Y].who.FLEE + _global.field[X][Y].who.SHIELD_FLEE) * 0.8;
   if(_root.percent(hit_chance))
   {
      _global.field[X][Y].who.takeDamage(dmg[play_count],null,crit[play_count]);
   }
}
if(play_count > 0)
{
   play_count--;
   gotoAndPlay(1);
}
else
{
   this.removeMovieClip();
}
