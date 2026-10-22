class Cage extends Object
{
   var X;
   var Y;
   var empty;
   var free;
   function Cage(xx, yy)
   {
      super();
      this.X = xx;
      this.Y = yy;
      this.free = true;
      this.empty = true;
   }
}
