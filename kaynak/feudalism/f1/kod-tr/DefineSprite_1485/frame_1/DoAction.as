this.VARIABLE = the_var;
this.is_waiting = false;
this.getBtnName = function(code)
{
   if(code == 8)
   {
      return "BcSpc";
   }
   if(code == 20)
   {
      return "Caps";
   }
   if(code == 17)
   {
      return "Ctrl";
   }
   if(code == 46)
   {
      return "Del";
   }
   if(code == 40)
   {
      return "Aşağı";
   }
   if(code == 35)
   {
      return "End";
   }
   if(code == 13)
   {
      return "Enter";
   }
   if(code == 27)
   {
      return "Esc";
   }
   if(code == 36)
   {
      return "Home";
   }
   if(code == 45)
   {
      return "Ins";
   }
   if(code == 37)
   {
      return "Sol";
   }
   if(code == 34)
   {
      return "PgDn";
   }
   if(code == 33)
   {
      return "PgUp";
   }
   if(code == 39)
   {
      return "Sağ";
   }
   if(code == 16)
   {
      return "Shift";
   }
   if(code == 32)
   {
      return "Boşluk";
   }
   if(code == 9)
   {
      return "Tab";
   }
   if(code == 38)
   {
      return "Yukarı";
   }
   return String.fromCharCode(code).toUpperCase();
};
this.onRelease = function()
{
   this.is_waiting = true;
   this.btn_name.text = "???";
   this.gotoAndStop(3);
};
this.btn_name.text = this.getBtnName(_global["CO_" + this.VARIABLE]);
this.gotoAndStop(2);
