module rounded_box(width = 10, length = 20, height = 1, corner_radius = [1, 2, 3, 4]) {
    hull() {
        translate([corner_radius[0], corner_radius[0], 0]) {
            cylinder(r = corner_radius[0], h = height, $fn = 100);
        }
        translate([corner_radius[1], length - corner_radius[1], 0]) {
            cylinder(r = corner_radius[1], h = height, $fn = 100);
        }
        translate([width - corner_radius[2], length - corner_radius[2], 0]) {
            cylinder(r = corner_radius[2], h = height, $fn = 100);
        }
        translate([width - corner_radius[3], corner_radius[3], 0]) {
            cylinder(r = corner_radius[3], h = height, $fn = 100);
        }
    }
}

module teardrop(radius = 10, length = 20) {
    rotate([90, 0, 0]) {
        rotate([0, 0, 45]) {
            translate([0, 0, -length / 2]) {
                linear_extrude(height = length) {
                    union() {
                        circle(r = radius, $fn = 100);
                        square([radius, radius]);
                    }
                }
            }
        }
    }
}

module power_socket_box(
        width = 87,
        length = 147,
        height = 18 + 5 + 8,
        thickness = 4,
        corner_radius = 6,
        screw_diameter = 3.38,
        dist_between_screws = 120,
        cable_diameter = 7) {
    difference() {
        union() {
            difference() {
                rounded_box(width, length, height, [corner_radius, corner_radius, corner_radius, corner_radius]);
                translate([thickness, thickness, thickness]) {
                    //cube([width - 2 * thickness, length - 2 * thickness, height]);
                    rounded_box(width - 2 * thickness, length - 2 * thickness, height, [corner_radius, corner_radius, corner_radius, corner_radius]);
                }
            }
            translate([width / 2, (length - dist_between_screws) / 2, 0]) {
                        cylinder(d = screw_diameter + thickness * 2, h = height / 2, $fn = 100);
            }
            translate([width / 2, (length - dist_between_screws) / 2 + dist_between_screws, 0]) {
                        cylinder(d = screw_diameter + thickness * 2, h = height / 2, $fn = 100);
            }
        }
        translate([width / 2, (length - dist_between_screws) / 2, thickness]) {
                        cylinder(d = screw_diameter, h = height / 2, $fn = 100);
        }
        translate([width / 2, (length - dist_between_screws) / 2 + dist_between_screws, thickness]) {
                    cylinder(d = screw_diameter, h = height / 2, $fn = 100);
        }
        translate([thickness - 0.1, length / 2, height / 2]) {
            rotate([0, 0, 90]) {
                teardrop(cable_diameter / 2, thickness * 2);
            }
        }
    }
}

power_socket_box();
