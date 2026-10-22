on(release){
   if(_global.QUEST.avatar_id < 0)
   {
      _global.QUEST.aproveDeliver();
   }
   _parent.enableAll();
   gotoAndStop(1);
}
