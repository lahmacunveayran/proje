_parent.attachMovie("DummyHuman","man_" + id,id);
_parent["man_" + id]._x = this._x;
_parent["man_" + id]._y = this._y;
_parent["man_" + id]._xscale = this._xscale;
_parent["man_" + id]._yscale = this._yscale;
if(!look_left)
{
   _parent["man_" + id]._xscale *= -1;
}
_parent["man_" + id].dress(nat,tp,lv);
this.unloadMovie();
this.removeMovieClip();
