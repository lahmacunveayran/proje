on(release){
   if(_root.cursor._currentframe == 3)
   {
      _root.cursor.gotoAndStop(1);
   }
   else if(is_ready)
   {
      _root.cursor.gotoAndStop(3);
   }
}
