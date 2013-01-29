pi=355/113;
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
   translate([0, 2.5, -2])
      linear_extrude(height=.5)
      polygon(
	    points = [[-8, -2], [7, -2], [2, 9], [-5, 9]],
	    paths = [[0,1,2,3],[1,2,3,0]]
	    ); 
}

module engine() {
   r1 = 2.4; r2 = 1.75;
   angle = 30; delta_angle = 2;
   curvature_radius = 20;
   for(ratio = [0:delta_angle/angle:1-delta_angle/angle])
   assign(
      a = -angle/2 + ratio*angle,
      r2 = r1+ (r2-r1)*ratio,
      r1 = r1+ (r2-r1)*(ratio + delta_angle/angle)   
   )
   multmatrix([
   [sin(a), 0, -cos(a), curvature_radius*sin(a)],
   [0, 1, 0, 0],
   [cos(a), 0, sin(a), curvature_radius*(-1+cos(a))],
   [0, 0, 0, 1]
   ])
   cylinder( h = delta_angle*pi/180*(curvature_radius + r1), r1 = r1, r2 = r2 );
   assign(a = angle/2-delta_angle)
   multmatrix([
   [sin(a), 0, -cos(a), curvature_radius*sin(a)],
   [0, 1, 0, 0],
   [cos(a), 0, sin(a), curvature_radius*(-1+cos(a))],
   [0, 0, 0, 1]
   ]) mirror([0,0,1])
	  cylinder( r1=r2, r2=0, h=4 );
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
   smoothing_radius = 1;
   translate([-payload[0]/2, payload[1]/2+smoothing_radius, -R])
      minkowski() {
         cube([payload[0]-smoothing_radius,R,2*R]);
         cylinder(r=smoothing_radius, 2*R);
      }
}

module fuselage() {
   difference() {
      body();
      union() {
	 payload_mask();
	 mirror([0,1,0]) payload_mask();
      }
   }
   wing();
   mirror([0, 1, 0]) wing();
   translate([-2, 10, -1] ) engine();
   translate([-2, -10, -1] ) engine();
   canard();
   mirror([0, 1, 0]) canard();
   rudder();
}

color([0.2,0.2,0.2])
   fuselage();
$fs = .1;
