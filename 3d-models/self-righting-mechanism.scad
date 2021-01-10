track_length = 95.6;
track_width = 19;
track_height = 7;
track_thickness = 2;
track_pin_diameter = 3;
track_holder_length = 10;
track_holder_width = 17;
track_holder_dist_between_screws = 8;
track_holder_screw_diameter = 3;
wheel_diameter = 130;
wheel_side_ridge_length = track_width * 1.7;
gap = 0.15;
catch_pin_spacing = track_thickness * 3;
spring_diameter = 1;
tail_extension = 20;
tooth_diameter = 2;
ridge_length = 17.5;
tooth_factor = 0.75;

module tooth(diameter, height) {
    linear_extrude(height = height, center = false, convexity = 10, twist = 0) {
        polygon(points = [
            [0, 0],
            [diameter, 0],
            [0, diameter]
        ]);
    }
}

module tail_teeth(count) {
    for (i = [1 : 1 + count]) {
        translate([tooth_diameter * i, 0, 0]) {
            mirror([1, 1, 0]) {
                tooth(tooth_diameter * tooth_factor, track_height - track_thickness * 1.5 - gap * 2 - tooth_diameter);
            }
        }
    }
}

module ridge() {
    translate([0, -track_width / 2 + track_thickness, track_height]) {
        rotate([-90, 0, 0]) {
            rotate([0, -90, 0]) {
                translate([0, 0, -track_length / 2]) {
                    tooth(track_thickness / 2 + tooth_diameter, ridge_length);
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
            // Pin hole
            translate([0, tooth_diameter * 1.5, -0.1]) {
                cylinder(d = track_pin_diameter, h = track_thickness + 1, $fn = 50);
            }
            // Wheel hole                
            translate([0, -wheel_diameter / 2, -0.1]) {
                cylinder(d = wheel_diameter, h = track_height + 1, $fn = 200);
            }
        }
        // Ridge opposite to wheel
        translate([0, track_width / 2 - track_thickness, track_height]) {
            rotate([-90, 0, 0]) {
                rotate([0, 90, 0]) {
                    translate([0, 0, -track_length / 2]) {
                        tooth(track_thickness / 2, track_length);
                    }
                }
            }
        }
        // Ridges on wheel side
        ridge();
        mirror([1, 0, 0]) {
            ridge();
        }
        // Teeth
        translate([track_length / 2 - ridge_length, -track_width / 2 + track_thickness, track_thickness]) {
            mirror([0, 1, 0]) {
                tail_teeth(7);
            }
        }
        mirror([1, 0, 0]) {
            translate([track_length / 2 - ridge_length, -track_width / 2 + track_thickness, track_thickness]) {
                mirror([0, 1, 0]) {
                    tail_teeth(7);
                }
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
                                translate([track_holder_dist_between_screws * j / 2, track_holder_length / 2 - track_holder_screw_diameter / 2 - track_thickness / 2, 0]) {
                                    cylinder(d = track_holder_screw_diameter, h = track_thickness + 1, center = true, $fn = 50);
                                }
                            }
                        }
                    }
                }
            }
        }
        // Spring holder
        /*translate([0, track_width / 2 - track_thickness * 1.5 / 2, track_height + track_thickness / 2]) {
            difference() {
                cube([track_thickness * 4 + spring_diameter * 3, track_thickness * 1.5, track_thickness * 2 + spring_diameter], center = true);
                for (i = [-1 : 1]) {
                    translate([i * (track_thickness + spring_diameter), 0, 0]) {
                        rotate([90, 0, 0]) {
                            cylinder(d = spring_diameter, h = track_thickness * 2, center = true, $fn = 25);
                        }
                    }
                }
            }
        }*/
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

module catch_pin() {
    hull() {
        translate([0, 0, track_thickness / 2]) {
            sphere(d = track_thickness, $fn = 25);
        }
        translate([0, 0, track_height - track_thickness]) {
            sphere(d = track_thickness, $fn = 25);
        }
    }
}

module tail(
        tail_width = track_width - (track_thickness + gap) * 2 - tooth_diameter) {
    translate([0, tooth_diameter / 2, track_thickness + gap]) {
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
                        cylinder(d = track_pin_diameter + tooth_diameter + 2 * gap, h = track_height, $fn = 50);
                    }
                    translate([track_length / 2 + tail_extension, 0, -0.1]) {
                        cylinder(d = track_pin_diameter + tooth_diameter + 2 * gap, h = track_height, $fn = 50);
                    }
                }
            }
        }
        /*for (i = [-track_length / 2 - tail_extension : catch_pin_spacing : track_length / 2 + tail_extension + 1]) {
            translate([i, -track_width / 2 + track_thickness * 2 + gap, 0]) {
                catch_pin();
            }
        }*/
        translate([0, -tail_width / 2, 0]) {
            tail_teeth(25);
            mirror([1, 0, 0]) {
                tail_teeth(25);
            }
        }
    }
}

track();
tail();