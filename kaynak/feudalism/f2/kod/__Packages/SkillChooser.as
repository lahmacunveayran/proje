class SkillChooser extends MovieClip
{
   var curr_value;
   function SkillChooser()
   {
      super();
   }
   function showSkillInfo(id)
   {
      this._parent.attachMovie("MouseHint","mouse_hint",90,{_x:this._parent._xmouse,_y:this._parent._ymouse});
      this._parent.mouse_hint.showSkillInfo(this.curr_value,id);
   }
   function removeSkillInfo()
   {
      this._parent.mouse_hint.removeMovieClip();
   }
}
