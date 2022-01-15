module servo_joining_plate(
        width = 24.5, //28.5,
        length = 45 + 2 * 34 - 7 * 2,
        thickness = 4,
        screw_diameter = 2.6,
        servo_screw_head_diameter = 5,
        plate_radius = 5,
        general_purpose_screw_diameter = 3.2,
        general_purpose_nut_diameter = 6.5) {
    difference() {
        union() {
            hull() {
                translate([width / 2 - plate_radius, length / 2 - plate_radius, 0]) {
                    cylinder(h = thickness, r = plate_radius, center = true, $fn = 50);
                }
                translate([-width / 2 + plate_radius, length / 2 - plate_radius, 0]) {
                    cylinder(h = thickness, r = plate_radius, center = true, $fn = 50);
                }
                translate([width / 2 - plate_radius, -length / 2 + plate_radius, 0]) {
                    cylinder(h = thickness, r = plate_radius, center = true, $fn = 50);
                }
                translate([-width / 2 + plate_radius, -length / 2 + plate_radius, 0]) {
                    cylinder(h = thickness, r = plate_radius, center = true, $fn = 50);
                }
            }
            translate([width / 2, 0, 0]) {
                rotate([0, -45, 0]) {
                    difference() {
                        hull() {
                            rotate([0, 45, 0]) {
                                cube([0.01, 70, thickness], center = true);
                            }
                            translate([10, -35 + thickness / 2, 0]) {
                                cylinder(h = sqrt(thickness * thickness / 2), d = thickness, center = true, $fn = 50);
                            }
                            translate([10, 35 - thickness / 2, 0]) {
                                cylinder(h = sqrt(thickness * thickness / 2), d = thickness, center = true, $fn = 50);
                            }
                        }
                        for (i = [-3:3]) {
                            translate([7, i * 10, -thickness / 2]) {
                                cylinder(h = thickness + 0.1, d = general_purpose_screw_diameter, center = true, $fn = 30);
                            }
                            translate([7, i * 10, thickness / 2]) {
                                cylinder(h = thickness + 0.1, d = general_purpose_nut_diameter, center = true, $fn = 6);
                            }
                        }
                    }
                }
            }
        }
        // Servo screw holes
        for (i = [-1:2:2]) {
            for (j = [-1:2:1]) {
                translate([j * 16 / 2, i * (45 / 2 + (34 - 12) / 2), -0.01 - thickness / 2]) {
                    cylinder(h = thickness + 0.1, r = screw_diameter / 2, center = true, $fn = 30);
                }
                translate([j * 16 / 2, i * (45 / 2 + (34 - 12) / 2 + 12), -0.01 - thickness / 2]) {
                    cylinder(h = thickness + 0.1, r = screw_diameter / 2, center = true, $fn = 30);
                }
                translate([j * 16 / 2, i * (45 / 2 + (34 - 12) / 2), thickness / 2]) {
                    cylinder(h = thickness + 0.1, r = servo_screw_head_diameter / 2, center = true, $fn = 30);
                }
                translate([j * 16 / 2, i * (45 / 2 + (34 - 12) / 2 + 12), thickness / 2]) {
                    cylinder(h = thickness + 0.1, r = servo_screw_head_diameter / 2, center = true, $fn = 30);
                }
            }
        }
        // General purpose holes
        for (i = [-2:2]) {
            for (j = [-1:1]) {
                translate([j * 8, i * 10, -0.01]) {
                    cylinder(h = thickness + 0.1, d = general_purpose_screw_diameter, center = true, $fn = 30);
                }
            }
        }
    }
}

servo_joining_plate();
