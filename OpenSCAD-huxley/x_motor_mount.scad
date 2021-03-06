
// X motor mount

// Adrian Bowyer 18 December 2010

include <parameters.scad>;
use<library.scad>

screw_hole_r=screwsize/2;

//*****************************************************************************************************************

module base()
{
	x_size = 2*hole_land + 2*bearing_x;
	y_size = bearing_y + hole_land;
	difference()
	{
		difference()
		{
			translate([-bearing_x - hole_land, 0, -thickness])
				cube([x_size, y_size, 2*thickness]);
			translate([-bar_clamp_x_gap - hole_land, 0, -bearing_x])
				rotate(a = 105, v = [0, 0, 1])
					cube([2*bearing_y ,2*bearing_y , 8*thickness]);
			translate([bar_clamp_x_gap+ hole_land, 0, -4*thickness])
				rotate(a = -15, v = [0, 0, 1])
					cube([2*bearing_y ,2*bearing_y , 8*thickness]);
		}
		difference()
		{
			translate([-x_size-1, -1, 0])
				cube([2+ 2*x_size, y_size+2, 6*thickness]);
			translate([0, motor_center_y, 0])
				rotate(a = 45, v = [0, 0, 1])
					translate([ - nema14_square*0.5,  - nema14_square*0.5, 0])
						cube([nema14_square, nema14_square, 2*thickness]);
		}
	}
}

module oriented_teardrop()
{
	translate([0, -2.5*thickness, 0])
		rotate(a = 90, v = [0, 0, 1])
			rotate(a = 90, v = [0, 1, 0])
				teardrop(r=screw_hole_r, h=4*thickness, truncateMM=-1);
}

module bearing_plate()
{

		difference()
		{
			union()
			{
			translate([-bearing_plate_width/2, bearing_plate_overlap - thickness, -thickness])
			{
				difference()
				{
					cube([bearing_plate_width, thickness + bearing_plate_support, 
						bearing_low_z + bearing_z_gap + hole_land + thickness]);
					translate([thickness, thickness, - 5])
						cube([bearing_plate_width - 2*thickness, 2*thickness + bearing_plate_support, 
							bearing_low_z + bearing_z_gap + hole_land + thickness + 10]);
				}
			}
		// Shim support ledges

		translate([-bearing_mount_centres/2, -0.8*thickness, bearing_low_z + bearing_z_gap-1.5*thickness-1.5])
			intersection()
			{
				rotate([35,0,0])
					cube([bearing_mount_centres, thickness, thickness]);
				translate([-thickness/5, -thickness*3/5, -thickness*6/5])
					cube([2*bearing_mount_centres, 2*thickness, 2*thickness]);
			}

		translate([-bearing_mount_centres/2, -0.8*thickness, bearing_low_z -1.5*thickness-1.5])
			intersection()
			{
				rotate([35,0,0])
					cube([bearing_mount_centres, thickness, thickness]);
				translate([-thickness/5, -thickness*3/5, -thickness*6/5])
					cube([2*bearing_mount_centres, 2*thickness, 2*thickness]);
			}
			}

			// Bearing mount holes
	
			for ( y = [0:1] )
			for ( x = [0:1] ) 
			{
				translate([(x-0.5)*bearing_mount_centres, 0, bearing_low_z + y*bearing_z_gap])
					oriented_teardrop();
			}
	
			// Limit switch mounting holes
	
			translate([-40,1,15])
				rotate([0,90,0])
				{
					teardrop(r=limit_switch_hole_diameter/2, h=40, truncateMM=-1);
					translate([0,0,27])
						teardrop(r=limit_switch_hole_diameter, h=18, truncateMM=-1);
				}
			translate([-40,1,15+limit_switch_centres])
				rotate([0,90,0])
				{
					teardrop(r=limit_switch_hole_diameter/2, h=40, truncateMM=-1);
					translate([0,0,27])
						teardrop(r=limit_switch_hole_diameter, h=18, truncateMM=-1);
				}
			}



}

module cylindrical_z_holes()
{
	union()
	{
		translate([-bar_clamp_x_gap, bar_clamp_y, 0])
			cylinder(r = screw_hole_r, h = 30, center = true, $fn=10);
		translate([bar_clamp_x_gap, bar_clamp_y, 0])
			cylinder(r = screw_hole_r, h = 30, center = true, $fn=10);
		translate([-bearing_x, bearing_y, 0])
			cylinder(r = screw_hole_r, h = 30, center = true, $fn=10);
		translate([bearing_x, bearing_y, 0])
			cylinder(r = screw_hole_r, h = 30, center = true, $fn=10);
		translate([0, motor_center_y, thickness])
			rotate(a = 45, v = [0, 0, 1])
				nema14(body=false, counterbore = -1);
	}
}

module x_motor_mount()
{
	union()
	{
		bearing_plate();
		difference()
		{
			base();
			cylindrical_z_holes();
		}
	}
}


x_motor_mount();

/*translate([0, motor_center_y, thickness])
	rotate(a = 45, v = [0, 0, 1])
		nema14(body=true, counterbore = -1);*/
