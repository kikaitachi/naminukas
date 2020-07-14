use <teardrop.scad>

module camera_holder(
        holder_height = 60,
        holder_width = 13,
        holder_length = 25,
        thickness = 3,
        camera_screw_diameter = 3.2,
        dist_between_camera_screws = 45,
        screw_diameter = 3.2,
        nut_diameter = 6.3) {
    difference() {
        union() {
            hull() {
                translate([0, -dist_between_camera_screws / 2, 0]) {
                    cylinder(d = camera_screw_diameter + thickness, h = thickness, $fn = 50);
                }
                translate([0, dist_between_camera_screws / 2, 0]) {
                    cylinder(d = camera_screw_diameter + thickness, h = thickness, $fn = 50);
                }
            }
            translate([0, -holder_width / 2, 0]) {
                cube([holder_height, holder_width, thickness]);
            }
            hull() {
                translate([holder_height - screw_diameter / 2 - thickness / 2, -10, 0]) {
                    cylinder(d = nut_diameter + thickness, h = thickness, $fn = 50);
                }
                translate([holder_height - screw_diameter / 2 - thickness / 2, 10, 0]) {
                    cylinder(d = nut_diameter + thickness, h = thickness, $fn = 50);
                }
            }
        }
        for (i = [-1:1]) {
            translate([holder_height - screw_diameter / 2 - thickness / 2, i * 10, -0.1]) {
                cylinder(d = screw_diameter, h = thickness + 1, $fn = 50);
            }
            translate([holder_height - screw_diameter / 2 - thickness / 2, i * 10, thickness / 2]) {
                cylinder(d = nut_diameter, h = thickness, $fn = 6);
            }
        }
        translate([0, -dist_between_camera_screws / 2, -0.1]) {
            cylinder(d = camera_screw_diameter, h = thickness + 1, $fn = 50);
        }
        translate([0, dist_between_camera_screws / 2, -0.1]) {
            cylinder(d = camera_screw_diameter, h = thickness + 1, $fn = 50);
        }
    }
}

camera_holder();
