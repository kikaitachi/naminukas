include <dimensions.scad>
use <teardrop.scad>

module servo_bracket(
        bracket_length = 58.5 * 2,
        bracket_heigth = 38,
        bearing_center_to_servo_horn_center = 30.5 - 6, // center to center
        servo_horn_diameter = 19.5,
        servo_bracket_thickness = 4.2,
        bracket_thickness = 5.5,
        bearing_od = 27,
        bearing_thickness = 4,
        joining_screw_radius_left = 1.2,
        joining_screw_radius_right = 1.2,
        servo_screw_radius = 1.1,
        servo_screw_head_radius = 2) {
    difference() {
        union() {
            // Bearing plate
            translate([0, 0, bracket_heigth / 2]) {
                cube([bracket_length + servo_bracket_thickness * 2 - bracket_thickness, bracket_thickness, bracket_heigth], center = true);
            }
            // Left servo plate
            translate([-(bracket_length + servo_bracket_thickness) / 2, -(bearing_center_to_servo_horn_center + servo_horn_diameter / 2 + 1) / 2, bracket_heigth / 2]) {
                cube([servo_bracket_thickness, bearing_center_to_servo_horn_center + servo_horn_diameter / 2 + 1, bracket_heigth], center = true);
            }
            // Right servo plate
            translate([(bracket_length + servo_bracket_thickness) / 2, -(bearing_center_to_servo_horn_center + servo_horn_diameter / 2) / 2, bracket_heigth / 2]) {
                cube([servo_bracket_thickness, bearing_center_to_servo_horn_center + servo_horn_diameter / 2, bracket_heigth], center = true);
            }
            translate([-bracket_length / 2 - servo_bracket_thickness + bracket_thickness / 2, 0, 0]) {
                cylinder(h = bracket_heigth, d = bracket_thickness, center = false, $fn = 100);
            }
        }
        // Outher bearing hole
        translate([0, 0, bracket_heigth / 2]) {
            rotate([90, 0, 0]) {
                cylinder(h = bearing_thickness + 0.1, r = bearing_od / 2 + 0.2, center = true, $fn = 100);
            }
        }
        // Inner bearing hole
        translate([0, 0, bracket_heigth / 2]) {
            rotate([90, 0, 0]) {
                cylinder(h = bracket_thickness + 1, r = bearing_od / 2 - 0.75, center = true, $fn = 100);
            }
        }
        // Joining screw holes
        translate([-bearing_od / 2 - bracket_thickness, 0, 0.1]) {
            cylinder(h = bracket_heigth * 2, r = joining_screw_radius_left, center = true, $fn = 100);
        }
        translate([bearing_od / 2 + bracket_thickness, 0, 0.1]) {
            cylinder(h = bracket_heigth * 2, r = joining_screw_radius_right, center = true, $fn = 100);
        }
        translate([-bracket_length / 2 + 15, 0, 0.1]) {
            cylinder(h = bracket_heigth * 2, r = joining_screw_radius_left, center = true, $fn = 100);
        }
        translate([bracket_length / 2 - 15, 0, 0.1]) {
            cylinder(h = bracket_heigth * 2, r = joining_screw_radius_right, center = true, $fn = 100);
        }
        // Servo screw holes
        translate([0, -bearing_center_to_servo_horn_center, bracket_heigth / 2]) {
            for (i = [0:7]) {
                rotate([i * (360 / 8) + 360 / 16, 0, 0]) {
                    translate([0, 16 / 2, 0]) {
                        rotate([-(i * (360 / 8) + 360 / 16), 0, 0]) {
                            rotate([0, 0, 90]) {
                                teardrop(radius = servo_screw_radius, length = bracket_length * 2);
                            }
                        }
                    }
                }
            }
        }
        // Servo screw head holes
        translate([-bracket_length / 2 - servo_bracket_thickness / 2 - 1.5, -bearing_center_to_servo_horn_center, bracket_heigth / 2]) {
            for (i = [0:7]) {
                rotate([i * (360 / 8) + 360 / 16, 0, 0]) {
                    translate([0, 16 / 2, 0]) {
                        rotate([-(i * (360 / 8) + 360 / 16), 0, 0]) {
                            rotate([0, 0, 90]) {
                                teardrop(radius = servo_screw_head_radius, length = servo_bracket_thickness);
                            }
                        }
                    }
                }
            }
        }
        // Servo horn center hole
        translate([0, -bearing_center_to_servo_horn_center, bracket_heigth / 2]) {
            rotate([0, 0, 90]) {
                teardrop(radius = 9 / 2, length = bracket_length * 2);
            }
        }
        // Cut in half
        translate([0, 0, bracket_heigth / 2 - 0.1]) {
            rotate([0, 19, 0]) {
                translate([0, 0, bracket_length]) {
                    cube([bracket_length * 2, bracket_length * 2, bracket_length * 2], center = true);
                }
            }
        }
        // Cut servo side bottom
        translate([-bracket_length / 2, -bearing_center_to_servo_horn_center - servo_horn_diameter / 2 - 1, 0]) {
            rotate([45, 0, 0]) {
                cube([15, 15, 15], center = true);
            }
        }
        // Cut servo side top
        translate([-bracket_length / 2, -bearing_center_to_servo_horn_center - servo_horn_diameter / 2 - 1, bracket_heigth]) {
            rotate([45, 0, 0]) {
                cube([15, 15, 15], center = true);
            }
        }
        translate([-bracket_length / 2 - servo_bracket_thickness + bracket_thickness / 2, 0, 0.1]) {
            cylinder(h = bracket_heigth + 1, d = 2, center = false, $fn = 100);
        }
    }
}

servo_bracket();
