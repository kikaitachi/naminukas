track_length = 95.6;
track_width = 15;
track_height = 8;
track_thickness = 2;
track_pin_diameter = 3;
track_holder_length = 10;
track_holder_width = 18;
track_holder_dist_between_screws = 8;
track_holder_screw_diameter = 3;
wheel_diameter = 120;
wheel_side_ridge_length = track_width * 1.7;
gap = 0.25;

module track() {
    union() {
        difference() {
            translate([0, 0, track_height / 2]) {
                cube([track_length, track_width, track_height], center = true);
            }
            translate([0, 0, track_height / 2 + track_thickness]) {
                cube([track_length + 1, track_width - 2 * track_thickness, track_height], center = true);
            }
            // Pin hole
            translate([0, 0, -0.1]) {
                cylinder(d = track_pin_diameter, h = track_thickness + 1, $fn = 50);
            }
            // Wheel hole                
            translate([0, -wheel_diameter / 2 - track_pin_diameter / 2 - track_thickness, -0.1]) {
                cylinder(d = wheel_diameter, h = track_height + 1, $fn = 200);
            }
        }
        // Ridge opposite to wheel
        translate([0, track_width / 2 - track_thickness, track_height - track_thickness / 2]) {
            rotate([0, 90, 0]) {
                cylinder(d = track_thickness, h = track_length, center = true, $fn = 4);
            }
        }
        // Ridges on wheel side
        translate([(track_length - wheel_side_ridge_length) / 2, -track_width / 2 + track_thickness, track_height - track_thickness / 2]) {
            rotate([0, 90, 0]) {
                cylinder(d = track_thickness, h = wheel_side_ridge_length, center = true, $fn = 4);
            }
        }
        translate([-(track_length - wheel_side_ridge_length) / 2, -track_width / 2 + track_thickness, track_height - track_thickness / 2]) {
            rotate([0, 90, 0]) {
                cylinder(d = track_thickness, h = wheel_side_ridge_length, center = true, $fn = 4);
            }
        }
        // Track holders
        for (i = [-1 : 2 : 1]) {
            translate([(track_length - track_holder_width) * i / 2, track_width / 2, 0]) {
                rotate([45, 0, 0]) {
                    translate([0, track_holder_length / 2, track_thickness / 2]) {
                        difference() {
                            cube([track_holder_width, track_holder_length, track_thickness], center = true);
                            for (j = [-1 : 2 : 1]) {
                                translate([track_holder_dist_between_screws * j / 2, track_holder_length / 2 - track_holder_screw_diameter / 2 - track_thickness, 0]) {
                                    cylinder(d = track_holder_screw_diameter, h = track_thickness + 1, center = true, $fn = 50);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

module tail_end() {
    union() {
        cylinder(d1 = track_width - (track_thickness + gap) * 2 - track_thickness / 2, d2 = track_width - (track_thickness + gap) * 2, h = track_thickness / 2, $fn = 100);
        translate([0, 0, track_thickness / 2]) {
            cylinder(d = track_width - (track_thickness + gap) * 2, h = track_height - (track_thickness + gap) * 2 - track_thickness / 2, $fn = 100);
        }
        translate([0, 0, track_thickness / 2 + track_height - (track_thickness + gap) * 2 - track_thickness / 2]) {
            cylinder(d2 = track_width - (track_thickness + gap) * 2 - track_thickness / 2, d1 = track_width - (track_thickness + gap) * 2, h = track_thickness / 2, $fn = 100);
        }
    }
}

module tail() {
    translate([0, 0, track_thickness + gap]) {
        difference() {
            hull() {
                translate([-track_length / 2, 0, 0]) {
                    tail_end();
                }
                translate([track_length / 2, 0, 0]) {
                    tail_end();
                }
            }
            hull() {
                translate([-track_length / 2, 0, -0.1]) {
                    cylinder(d = track_pin_diameter + 2 * gap, h = track_height, $fn = 50);
                }
                translate([track_length / 2, 0, -0.1]) {
                    cylinder(d = track_pin_diameter + 2 * gap, h = track_height, $fn = 50);
                }
            }
        }
    }
}

track();
tail();