_root.addProjectile(X,Y,_global.F_WIDTH - 1,Y,dmg[play_count],0,crit[play_count],1,141,-1);
if(play_count > 0)
{
   play_count--;
   gotoAndPlay(1);
}
else
{
   this.removeMovieClip();
}
