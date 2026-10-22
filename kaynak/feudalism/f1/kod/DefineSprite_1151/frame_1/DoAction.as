this.onRelease = function()
{
   _global[val] = !_global[val];
   if(_global[val])
   {
      gotoAndStop(3);
   }
   else
   {
      gotoAndStop(2);
   }
};
if(_global[val])
{
   gotoAndStop(3);
}
else
{
   gotoAndStop(2);
}
