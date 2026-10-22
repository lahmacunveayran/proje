class ActiveSkillChooser extends SkillChooser
{
   var ID;
   var _parent;
   var curr_value;
   var type_mc;
   static var arr = ["shield","2H_sword","2H_axe","dual","spear","dagger","katana","staff","katar","bow","crossbow","throwing"];
   function ActiveSkillChooser()
   {
      super();
      var _loc3_ = 1;
      while(_loc3_ <= 3)
      {
         this["ico_" + _loc3_].shade.gotoAndStop(3);
         this["ico_" + _loc3_].amount_txt.text = "";
         _loc3_ = _loc3_ + 1;
      }
      this.showChosen();
   }
   function showChosen()
   {
      this.type_mc.gotoAndStop(this.curr_value);
      var _loc2_ = 1;
      while(_loc2_ <= 3)
      {
         this["ico_" + _loc2_].gotoAndStop(Skill.getActiveSkillFrame(this.curr_value,_loc2_));
         _loc2_ = _loc2_ + 1;
      }
   }
   function goRight()
   {
      var _loc2_ = Skill.getActiveSkillFrame(this.curr_value,3) / 3 - 1;
      _loc2_ = _loc2_ + 1;
      if(_loc2_ >= ActiveSkillChooser.arr.length)
      {
         _loc2_ = 0;
      }
      this.curr_value = ActiveSkillChooser.arr[_loc2_];
      if(this.same())
      {
         this.goRight();
      }
      else
      {
         this.showChosen();
      }
   }
   function goLeft()
   {
      var _loc2_ = Skill.getActiveSkillFrame(this.curr_value,3) / 3 - 1;
      _loc2_ = _loc2_ - 1;
      if(_loc2_ < 0)
      {
         _loc2_ = ActiveSkillChooser.arr.length - 1;
      }
      this.curr_value = ActiveSkillChooser.arr[_loc2_];
      if(this.same())
      {
         this.goLeft();
      }
      else
      {
         this.showChosen();
      }
   }
   function same()
   {
      var _loc2_ = 0;
      while(_loc2_ < 3)
      {
         if(_loc2_ != this.ID && this._parent["active_" + _loc2_].curr_value == this.curr_value)
         {
            return true;
         }
         _loc2_ = _loc2_ + 1;
      }
      return false;
   }
}
