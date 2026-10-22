onClipEvent(keyDown){
   if(this.is_waiting)
   {
      this.is_waiting = false;
      var code = Key.getCode();
      _global["CO_" + this.VARIABLE] = code;
      this.btn_name.text = this.getBtnName(code);
      this.gotoAndStop(2);
   }
}
