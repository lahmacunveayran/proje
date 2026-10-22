on(press){
   if(_global.FRIENDS.length - 9 > _parent.scrollUser + 8)
   {
      _parent.scrollUser = _parent.scrollUser + 1;
      _parent.barracksShowUser();
   }
}
