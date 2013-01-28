radius = 6.75 / 2;
payload = [14, 5, 5.5];

module body() {
   translate([payload[0]/2, 0, 0])
      rotate(a=[0, 90, 0])
      cylinder( r1=radius, r2 = .5, h=36 );
   cube(size= payload, center = true);
   multmatrix( [
	   [0, 0, -1, -payload[0]/2],
		[0, 1, 0, 0],
		[1, 0, 0, 0],
		[0, 90, 0, 1]
	]
   ) cylinder( r=radius, h = 6 );
   multmatrix( [
		[0, 0, -1, -payload[0]/2 - 6 ],
		[0, 1, 0, 0],
		[1, 0, .1, 0],
		[0, 0, 0, 1]
	]
   )
     cylinder( r1=radius, r2 = .5, h=35 - 6);
}

module wing() {
   linear_extrude(height=.5)
   polygon(
      points = [[-7, 0], [7, 0], [2, 10], [-5, 10]],
      paths = [[0,1,2,3],[1,2,3,0]]
   ); 
}

module engine() {
   rotate(a=[0, 90, 0]) {
      cylinder( r=2, h=10, center = true );
      translate( [0,0,5] )
      cylinder( r1=1.5, r2=0, h=2.5 );
   }
}

module canard() {
    translate([38, 0, 0])
    linear_extrude(height=.1)
    polygon(
    points = [[0, 0], [3, 0], [-1.9, 4], [-2.1, 4]],
    paths = [[0,1,2,3],[1,2,3,0]]
);
}

module rudder() {
   translate([-38, 0, 1])
      rotate(a=[90, 0, 0])
      linear_extrude(height=.5)
      polygon(
	    points = [[0, 0], [8, 0], [0, 8], [-1, 8]], 
	    paths = [[0,1,2,3],[1,2,3,0]]
	    );
}

module fuselage() {
   body();
   translate([0, 3, -2]) wing();
   mirror([0, 1, 0]) translate([0, 3, -2]) wing();
   translate([-1, 12, -2] ) engine();
   translate([-1, -12, -2] ) engine();
   canard();
   mirror([0, 1, 0]) canard();
   rudder();
}

fuselage();
$fs = .5;
