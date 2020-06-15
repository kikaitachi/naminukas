use <teardrop.scad>

module camera_holder(
        holder_height = 60,
        holder_width = 13,
        holder_length = 25,
        thickness = 3.5,
        camera_screw_diameter = 6.2,
        screw_diameter = 3.2) {
    difference() {
        union() {
            translate([0, -holder_width / 2, 0]) {
                cube([holder_height, holder_width, thickness]);
                cube([thickness, holder_width, holder_length]);
            }
            translate([0, 0, holder_length]) {
                rotate([0, 90, 0]) {
                    cylinder(d = holder_width, h = thickness, $fn = 100);
                }
            }
            hull() {
                translate([holder_height - screw_diameter / 2 - thickness / 2, -10, 0]) {
                    cylinder(d = screw_diameter + thickness, h = thickness, $fn = 50);
                }
                translate([holder_height - screw_diameter / 2 - thickness / 2, 10, 0]) {
                    cylinder(d = screw_diameter + thickness, h = thickness, $fn = 50);
                }
            }
        }
        translate([0, 0, holder_length]) {
            rotate([0, 0, 90]) {
                teardrop(radius = camera_screw_diameter / 2, length = 10);
            }
        }
        for (i = [-1:1]) {
            translate([holder_height - screw_diameter / 2 - thickness / 2, i * 10, -0.1]) {
                cylinder(d = screw_diameter, h = thickness + 1, $fn = 50);
            }
        }
    }
}

camera_holder();
