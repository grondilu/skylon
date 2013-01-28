L = 85;
R = 6.75 / 2;
payload = [14, 5, 5.5];

function sears_hack(x) = R * pow(4 * x/L * (L-x)/L, 3/4);

module body() {
   translate([-L/2,0,0])
   rotate([0,90,0])
	for(z=[0:L-1]) {
	    assign(r1 = sears_hack(z), r2 = sears_hack(z+1)) {
		translate([0,0,z])
		    cylinder(r1 = r1, r2=r2, h = 1);
	    }
	}
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
      cylinder( r1=2.4, r2=1.75, h=10, center = true );
      translate( [0,0,5] )
      cylinder( r1=1.75, r2=0, h=4 );
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
