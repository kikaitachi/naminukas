track_length = 95.6;
track_width = 17;
track_height = 7;
track_thickness = 2;
track_pin_diameter = 3;
track_holder_length = 10;
track_holder_width = 17;
track_holder_dist_between_screws = 8;
track_holder_screw_diameter = 3;
gap = 0.15;
catch_pin_spacing = track_thickness * 3;
spring_diameter = 1;
tail_hole_diameter = 4;
tail_extension = 20;
tooth_width = 2;
tooth_heigth = 1.5;

ridge_length = 17.5;
tooth_factor = 0.75;

module tooth(width, height, depth) {
    rotate([90, 0, 0]) {
        linear_extrude(height = depth, center = true, convexity = 10, twist = 0) {
            polygon(points = [
                [-width / 2, 0],
                [-width / 2, height],
                [0, height + width / 2],
                [width / 2, height],
                [width / 2, 0]
            ]);
        }
    }
}

module ridge_tooth(diameter, height) {
    linear_extrude(height = height, center = false, convexity = 10, twist = 0) {
        polygon(points = [
            [0, 0],
            [diameter, 0],
            [0, diameter]
        ]);
    }
}

module ridge() {
    translate([0, track_width / 2 - track_thickness, track_height]) {
        rotate([-90, 0, 0]) {
            rotate([0, 90, 0]) {
                translate([0, 0, -track_length / 2]) {
                    ridge_tooth(track_thickness / 2, track_length);
                }
            }
        }
    }
}

module track() {
    union() {
        difference() {
            translate([0, 0, track_height / 2]) {
                cube([track_length, track_width, track_height], center = true);
            }
            translate([0, 0, track_height / 2 + track_thickness]) {
                cube([track_length + 1, track_width - 2 * track_thickness, track_height], center = true);
            }
        }
        // Ridges
        ridge();
        mirror([0, 1, 0]) {
            ridge();
        }
        // Track holders
        for (i = [-1 : 2 : 1]) {
            translate([(track_length - track_holder_width) * i / 2, track_width / 2, 0]) {
                rotate([45, 0, 0]) {
                    translate([0, track_holder_length / 2, track_thickness / 2]) {
                        difference() {
                            cube([track_holder_width, track_holder_length, track_thickness], center = true);
                            for (j = [-1 : 2 : 1]) {
                                translate([track_holder_dist_between_screws * j / 2, track_holder_length / 2 - track_holder_screw_diameter / 2 - track_thickness / 2, 0]) {
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

module tail_end(tail_width) {
    union() {
        cylinder(d1 = tail_width - track_thickness, d2 = tail_width, h = track_thickness / 2, $fn = 100);
        translate([0, 0, track_thickness / 2]) {
            cylinder(d = tail_width, h = track_height - (track_thickness + gap) * 2, $fn = 100);
        }
        translate([0, 0, track_thickness / 2 + track_height - (track_thickness + gap) * 2]) {
            cylinder(d2 = tail_width - track_thickness, d1 = tail_width, h = track_thickness / 2, $fn = 100);
        }
    }
}

module tail(
        tail_width = track_width - (track_thickness + gap) * 2) {
    translate([0, 0, track_thickness + gap]) {
        union() {
            difference() {
                hull() {
                    translate([-track_length / 2 - tail_extension, 0, 0]) {
                        tail_end(tail_width);
                    }
                    translate([track_length / 2 + tail_extension, 0, 0]) {
                        tail_end(tail_width);
                    }
                }
                hull() {
                    translate([-track_length / 2 - tail_extension, 0, -0.1]) {
                        cylinder(d = tail_hole_diameter, h = track_height, $fn = 50);
                    }
                    translate([track_length / 2 + tail_extension, 0, -0.1]) {
                        cylinder(d = tail_hole_diameter, h = track_height, $fn = 50);
                    }
                }
                // Top teeth
                for (i = [0 : track_thickness : track_length / 2 + tail_extension - track_thickness]) {
                    translate([i + track_thickness / 2, 0, track_height - gap * 2 - track_thickness]) {
                        rotate([90, 0, 0]) {
                            cylinder(d = track_thickness, h = tail_width - track_thickness, center = true, $fn = 4);
                        }
                    }
                    translate([-i- track_thickness / 2, 0, track_height - gap * 2 - track_thickness]) {
                        rotate([90, 0, 0]) {
                            cylinder(d = track_thickness, h = tail_width - track_thickness, center = true, $fn = 4);
                        }
                    }
                }
                // Bottom teeth
                for (i = [0 : tooth_width * 2 : track_length / 2 + tail_extension]) {
                    translate([-i, 0, -0.01]) {
                        tooth(tooth_width + gap, tooth_heigth + gap, tail_width - track_thickness * 2);
                    }
                    translate([i, 0, -0.01]) {
                        tooth(tooth_width + gap, tooth_heigth + gap, tail_width - track_thickness * 2);
                    }
                }
            }
        }
    }
}

track();
tail();