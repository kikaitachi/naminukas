module rounded_box(
        width = 10,
        height = 10,
        tickness = 1,
        corner_radius = [1, 2, 3, 4]) {
    hull() {
        translate([corner_radius[0], corner_radius[0], 0]) {
            cylinder(r = corner_radius[0], h = tickness, $fn = 50);
        }
        translate([corner_radius[1], height - corner_radius[1], 0]) {
            cylinder(r = corner_radius[1], h = tickness, $fn = 50);
        }
        translate([width - corner_radius[2], height - corner_radius[2], 0]) {
            cylinder(r = corner_radius[2], h = tickness, $fn = 50);
        }
        translate([width - corner_radius[3], corner_radius[3], 0]) {
            cylinder(r = corner_radius[3], h = tickness, $fn = 50);
        }
    }
}

module power_and_control_bracket(
        tickness = 2,
        corner_radius = 2,
        main_plate_width = 85,
        main_plate_height = 95,
        connect_plate_width = 30,
        connect_plate_height = 10,
        connect_screw_diameter = 3.1,
        power_screw_length = 5,
        power_screw_diameter = 2.1,
        dist_between_power_screws_horizontal = 35.5,
        dist_between_power_screws_vertical = 58,
        fpga_height = 18,
        rubber_hole_diameter = 5) {
    union() {
        // Main plate
        difference() {
            union() {
                rounded_box(main_plate_width, main_plate_height, tickness, [corner_radius, corner_radius, corner_radius, corner_radius]);
                translate([main_plate_width - corner_radius, main_plate_height - corner_radius, 0]) {
                    cylinder(r = corner_radius, h = power_screw_length, $fn = 50);
                }
                translate([main_plate_width - corner_radius - dist_between_power_screws_horizontal, main_plate_height - corner_radius, 0]) {
                    cylinder(r = corner_radius, h = power_screw_length, $fn = 50);
                }
                translate([main_plate_width - corner_radius, main_plate_height - corner_radius - dist_between_power_screws_vertical, 0]) {
                    cylinder(r = corner_radius, h = power_screw_length, $fn = 50);
                }
                translate([main_plate_width - corner_radius - dist_between_power_screws_horizontal, main_plate_height - corner_radius - dist_between_power_screws_vertical, 0]) {
                    cylinder(r = corner_radius, h = power_screw_length, $fn = 50);
                }
            }
            // Power board screw holes
            translate([main_plate_width - corner_radius, main_plate_height - corner_radius, -0.5]) {
                cylinder(d = power_screw_diameter, h = power_screw_length + 1, $fn = 50);
            }
            translate([main_plate_width - corner_radius - dist_between_power_screws_horizontal, main_plate_height - corner_radius, -0.5]) {
                cylinder(d = power_screw_diameter, h = power_screw_length + 1, $fn = 50);
            }
            translate([main_plate_width - corner_radius, main_plate_height - corner_radius - dist_between_power_screws_vertical, -0.5]) {
                cylinder(d = power_screw_diameter, h = power_screw_length + 1, $fn = 50);
            }
            translate([main_plate_width - corner_radius - dist_between_power_screws_horizontal, main_plate_height - corner_radius - dist_between_power_screws_vertical, -0.5]) {
                cylinder(d = power_screw_diameter, h = power_screw_length + 1, $fn = 50);
            }
            // Cuts to hold FPGA board by rubber band
            translate([0.25 * rubber_hole_diameter, corner_radius + rubber_hole_diameter / 2, -0.5]) {
                cylinder(d = rubber_hole_diameter, h = tickness + 1, $fn = 50);
            }
            translate([0.25 * rubber_hole_diameter, corner_radius + rubber_hole_diameter / 2 + fpga_height, -0.5]) {
                cylinder(d = rubber_hole_diameter, h = tickness + 1, $fn = 50);
            }
            translate([main_plate_width - 0.25 * rubber_hole_diameter, corner_radius + rubber_hole_diameter / 2, -0.5]) {
                cylinder(d = rubber_hole_diameter, h = tickness + 1, $fn = 50);
            }
            translate([main_plate_width - 0.25 * rubber_hole_diameter, corner_radius + rubber_hole_diameter / 2 + fpga_height, -0.5]) {
                cylinder(d = rubber_hole_diameter, h = tickness + 1, $fn = 50);
            }
        }
        // Connect plate
        translate([(main_plate_width - connect_plate_width) / 2, -connect_plate_height + 0.01, 0]) {
            difference() {
                rounded_box(connect_plate_width, connect_plate_height, tickness, [corner_radius, 0.001, 0.001, corner_radius]);
                for (i = [-1:1]) {
                    translate([i * 10 + connect_plate_width / 2, connect_plate_height / 2, -0.5]) {
                        cylinder(d = connect_screw_diameter, h = tickness + 1, $fn = 50);
                    }
                }
            }
        }
    }
}

power_and_control_bracket();
