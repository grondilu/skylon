L = 85;
R = 6.75 / 2;
payload = [14, 5, 5.5];

function sears_hack(x) = R * pow(4 * x/L * (L-x)/L, 3/4);

module body() {
   dx = 1;
   for(x=[0:dx:L-dx]) {
	    assign(r1 = sears_hack(x), r2 = sears_hack(x+dx)) {
      multmatrix( [
         [ 0, 0,     1,           x-L/2 ],
         [ 0, 1,     0,               0 ],
         [-1, 0, x > L/2 ? 0 : (r1-r2)/dx, x>L/2 ? 0 : R-r1],
         [ 0, 0,     0,               1 ]
      ] ) cylinder(r1 = r1, r2=r2, h = dx);
	   }
	}
}

module wing() {
   linear_extrude(height=.5)
   polygon(
      points = [[-7, -2], [7, -2], [2, 10], [-5, 10]],
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
   width = .5;
   height = 5;
   translate([-40, width/2, R])
      rotate(a=[90, 0, 0])
      linear_extrude(height=width)
      polygon(
	    points = [[0, 0], [6, 0], [-2, height], [-3, height]], 
	    paths = [[0,1,2,3],[1,2,3,0]]
	    );
}

module payload_mask() {
   translate([-payload[0]/2, payload[1]/2, -R])
   cube([payload[0],R,2*R]);
}

module fuselage() {
   difference() {
      body();
      union() {
         payload_mask();
         mirror([0,1,0]) payload_mask();
      }
   }
   translate([0, 3, -2]) wing();
   mirror([0, 1, 0]) translate([0, 3, -2]) wing();
   translate([-1, 12, -2] ) engine();
   translate([-1, -12, -2] ) engine();
   canard();
   mirror([0, 1, 0]) canard();
   rudder();
}

color([0.25,0.25,0.25])
fuselage();
$fs = .1;
