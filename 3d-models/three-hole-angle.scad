include <dimensions.scad>

module plate(
        width = 30,
        length = 20) {
    translate([length / 2 - tool_connecting_plate_thickness / 2, 0, tool_connecting_plate_thickness / 2]) {
        difference() {
            cube([length, width, tool_connecting_plate_thickness], center = true);
            for (i = [-1:1]) {
                hull() {
                    translate([-length / 2 + tool_connecting_plate_thickness * 2, i * 10, 0]) {
                        cylinder(h = tool_connecting_plate_thickness + 1, d = tool_connecting_plate_screw_diameter, center = true, $fn = 25);
                    }
                    translate([length / 2 - tool_connecting_plate_thickness, i * 10, 0]) {
                        cylinder(h = tool_connecting_plate_thickness + 1, d = tool_connecting_plate_screw_diameter, center = true, $fn = 25);
                    }
                }
            }
        }
    }
}

module three_hole_angle() {
    plate();
    translate([0, 0, tool_connecting_plate_thickness / 2]) {
        rotate([0, -90, 0]) {
            translate([0, 0, -tool_connecting_plate_thickness / 2]) {
                plate();
            }
        }
    }
}

three_hole_angle();
