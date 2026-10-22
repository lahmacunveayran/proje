class NationChooser extends SkillChooser
{
   var _parent;
   var curr_value;
   var sign;
   static var arr = ["Viz","Ger","Rus","Jap","Mon","Ara"];
   function NationChooser()
   {
      super();
      delete _global.MAIN_HERO;
      _global.MAIN_HERO = new Hero();
      _global.MAIN_HERO.GENDER = "m";
      this.curr_value = "Viz";
      this.showChosen();
   }
   function showChosen()
   {
      this.sign.gotoAndStop(this.curr_value);
      _global.MAIN_HERO.NATION = this.curr_value;
      this._parent.hero_ico.setUnitView(_global.MAIN_HERO,false);
   }
   function goRight()
   {
      if(this.sign._currentframe == 6)
      {
         this.sign.gotoAndStop(1);
      }
      else
      {
         this.sign.gotoAndStop(this.sign._currentframe + 1);
      }
      this.curr_value = NationChooser.arr[this.sign._currentframe - 1];
      this.showChosen();
   }
   function goLeft()
   {
      if(this.sign._currentframe == 1)
      {
         this.sign.gotoAndStop(6);
      }
      else
      {
         this.sign.gotoAndStop(this.sign._currentframe - 1);
      }
      this.curr_value = NationChooser.arr[this.sign._currentframe - 1];
      this.showChosen();
   }
}
