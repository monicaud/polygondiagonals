import java.text.DecimalFormat; 

class Polygon {
  
   ArrayList<Point> p     = new ArrayList<Point>();
   ArrayList<Edge>  bdry = new ArrayList<Edge>();
   boolean ccw; 
   boolean cw;
   Polygon( ){  }
   
   
   boolean isClosed(){ return p.size()>=3; }
   
   
   boolean isSimple(){
    //polygon is simple if non adjacent edges do not intercept
     ArrayList<Edge> bdry = getBoundary();
     for (int i = 0; i < bdry.size(); i++){
       for (int j = 0; j < bdry.size(); j++){
           if(bdry.get(i).p0 == bdry.get(j).p0 || bdry.get(i).p1 == bdry.get(j).p0 || bdry.get(i).p0 == bdry.get(j).p1 || bdry.get(i).p1 == bdry.get(j).p1){
             //adjacent vertices get ignored because they are supposed to have an intersection
             continue;
           }
           if(bdry.get(i).intersectionTest(bdry.get(j))){
             return false;
           }
       }
     }
     
     //polygon must be a triangle at least!
     if(isClosed()){
       return true;
     }
     
     return false;
   }
   
   
   boolean pointInPolygon( Point p ){
     //a random point, here is made outside the polygon and connected to the point p.
     //if there are an even number of intercepts to the bdry, it's outside, else inside
     ArrayList<Edge> bdry = getBoundary();
     
     Point point = new Point(0,0);
     Edge edge = new Edge(point, p);
     
     int intercepts = 0;
     
     for(int i = 0; i < bdry.size(); i++){
        if(bdry.get(i).intersectionTest(edge))
          intercepts++;
     }
     
     if(intercepts % 2 == 0)
       return false;
     
     return true;
   }
   
   
   ArrayList<Edge> getDiagonals(){
     
     ArrayList<Edge> bdry = getBoundary();
     ArrayList<Edge> diag = getPotentialDiagonals();
     ArrayList<Edge> ret  = new ArrayList<Edge>();
     DecimalFormat df = new DecimalFormat("###.00");
     boolean totallyOutside = false;
     boolean outside = false;
     boolean x = false;
     boolean y = false;
     
     for(int j = 0; j < diag.size(); j++){
          x = false;
          y = false;
          totallyOutside = false;
          outside = false;
        for(int i = 0; i < bdry.size(); i++){

          //diagonals shouldnt intersect the boundary
          if(diag.get(j).intersectionTest(bdry.get(i))){

            //check that it's not just one of the endpoints
            Point intersection = diag.get(j).intersectionPoint(bdry.get(i));
            
            if(intersection != null){
              
              String pointX = df.format(intersection.p.x);
              String pointY = df.format(intersection.p.y);
              
              String endPoint0x = df.format(diag.get(j).p0.p.x);
              String endPoint0y = df.format(diag.get(j).p0.p.y);
              
              String endPoint1x = df.format(diag.get(j).p1.p.x);
              String endPoint1y = df.format(diag.get(j).p1.p.y);
              
              if( pointX.equals(endPoint0x) || pointX.equals(endPoint1x)) 
                x = true;
                
              if(pointY.equals(endPoint0y) || pointY.equals(endPoint1y))
                y = true;
  
              //the intersection point did not match any of the endpoints of the diagonal
              if(!x || !y){ 
                outside = true;
              }
               
            }//end of if intersection ! null
    
          }//end of if intersection test

        }
        if(!pointInPolygon(diag.get(j).midpoint())){
            totallyOutside = true;
        }
        //if the current diagonal passed the tests, it can be returned
        if(!totallyOutside && !outside){ 
          //println(" - " + j ); 
          ret.add(diag.get(j));
        }
     }
     return ret;
   }
   
   
   boolean ccw(){

     if( !isClosed() ) return false;
     if( !isSimple() ) return false;
     area();
     
     return ccw;
   }
   
   
   boolean cw(){
     
     if( !isClosed() ) return false;
     if( !isSimple() ) return false;
     area();
     
     return cw;
   }
   
   float area(){
     ArrayList<Edge> bdry = getBoundary();
     float area = 0;
     
     for(int i = 0; i< bdry.size(); i++){
         area = area + (bdry.get(i).p1.x() - bdry.get(i).p0.x())*(bdry.get(i).p1.y() + bdry.get(i).p0.y())/2;
     }
     if(area > 0)
     { 
       ccw = false;
       cw = true;
     }
     else {
       area = area * -1;
       ccw = true;
       cw = false;
     }
     
     return area;  
   }


   ArrayList<Edge> getBoundary(){
     return bdry;
   }


   ArrayList<Edge> getPotentialDiagonals(){
     ArrayList<Edge> ret = new ArrayList<Edge>();
     int N = p.size();
     for(int i = 0; i < N; i++ ){
       int M = (i==0)?(N-1):(N);
       for(int j = i+2; j < M; j++ ){
         ret.add( new Edge( p.get(i), p.get(j) ) );
       }
     }
     return ret;
   }
   

   void draw(){
     //println( bdry.size() );
     for( Edge e : bdry ){
       e.draw();
     }
   }
   
   
   void addPoint( Point _p ){ 
     p.add( _p );
     if( p.size() == 2 ){
       bdry.add( new Edge( p.get(0), p.get(1) ) );
       bdry.add( new Edge( p.get(1), p.get(0) ) );
     }
     if( p.size() > 2 ){
       bdry.set( bdry.size()-1, new Edge( p.get(p.size()-2), p.get(p.size()-1) ) );
       bdry.add( new Edge( p.get(p.size()-1), p.get(0) ) );
     }
   }

}
