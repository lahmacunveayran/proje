if(_global.BATTLE_TYPE != "CHALLENGE")
{
   _root.addUnit(this._x,this._y,_global[arr].shift(),tm);
}
this.unloadMovie();
this.removeMovieClip();
