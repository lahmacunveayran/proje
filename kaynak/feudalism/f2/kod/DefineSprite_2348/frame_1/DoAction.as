if(sq == "Player")
{
   _root.addHero(this._x,this._y,_global.MAIN_HERO,0);
}
else
{
   _root.addUnit(this._x,this._y,_global.EVIL_HERO,1);
}
this.unloadMovie();
this.removeMovieClip();
