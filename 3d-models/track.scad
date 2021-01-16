module shear_along_z(p) {
  multmatrix([
    [1, 0, p.x / p.z, 0],
    [0, 1, p.y / p.z, 0],
    [0, 0, 1, 0]
  ]) {
      children();
  }
}

module round_block(width, height, thickness) {
    difference() {
        hull() {
            cylinder(d = thickness, h = height, $fn = 100);
            translate([width, 0, 0]) {
                cylinder(d = thickness, h = height, $fn = 100);
            }
        }
        translate([-thickness / 2, 0, height / 2 - 0.25]) {
            cube([thickness, thickness, height + 1], center = true);
        }
        /*translate([0, 0, -0.5]) {
            cylinder(d = thickness + 0.1, h = height + 1, $fn = 100);
        }*/
    }
}

module pin(height, thickness) {
    union() {
        cylinder(d1 = thickness / 2, d2 = thickness / 3, h = height / 2 + 0.01, $fn = 100);
        translate([0, 0, height / 2]) {
            cylinder(d1 = thickness / 3, d2 = thickness / 2, h = height / 2, $fn = 100);
        }
    }
}

module track(
        track_thickness = 4,
        track_height = 12,
        link_width = 11,
        pin_diameter = 1,
        pin_clearance = 0.9) {
    for (i = [0 : 1]) {
        translate([i * (link_width - track_thickness / 4 - 0.25), 0, 0]) {
            difference() {
                union() {
                    shear_along_z([1, 0, 1]) {
                        round_block(link_width - track_thickness, track_thickness, track_thickness);
                    }
                    translate([track_thickness, 0, track_thickness]) {
                        round_block(link_width - track_thickness, track_height - track_thickness * 2, track_thickness);
                    }
                    translate([track_thickness, 0, track_height - track_thickness]) {
                        shear_along_z([-1, 0, 1]) {
                            round_block(link_width - track_thickness, track_thickness, track_thickness);
                        }
                    }
                    translate([track_thickness / 4 + 0.25, 0, 0]) {
                        pin(track_height, track_thickness);
                    }
                }
                translate([link_width, 0, -0.01]) {
                    pin(track_height + 0.02, track_thickness + pin_clearance);
                }
                hull() {
                    translate([link_width / 2 + track_thickness / 3, 0, track_thickness]) {
                        rotate([0, 45, 0]) {
                            cube([track_thickness / 2, track_thickness + 0.1, track_thickness / 2], center = true);
                        }
                    }
                    translate([link_width / 2 + track_thickness / 3, 0, track_height - track_thickness]) {
                        rotate([0, 45, 0]) {
                            cube([track_thickness / 2, track_thickness + 0.1, track_thickness / 2], center = true);
                        }
                    }
                }
            }
        }
    }
    /*track_length = (tooth_diameter + distance_between_teeth) * tooth_count;
    echo("Track length: ", track_length);
    track_diameter = track_length / PI;
    echo("Track diameter: ", track_diameter);
    union() {
        difference() {
            cylinder(d = track_diameter + track_thickness * 2, h = track_width, $fn = 200);
            translate([0, 0, -0.5]) {
                cylinder(d = track_diameter, h = track_width + 1, $fn = 200);
            }
        }
        for (i = [1 : tooth_count]) {
            rotate([0, 0, i * 360 / tooth_count]) {
                translate([track_diameter / 2, 0, 0]) {
                    cylinder(d = tooth_diameter, h = track_width, $fn = 100);
                }
            }
        }
    }*/
}

track();
