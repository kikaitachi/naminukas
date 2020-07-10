thickness = 2;
hub_width = 52.5;
hub_height = 14;
corner = 7;
delta = 7;
top_screw_diameter = 2;
bottom_screw_diameter = 3.2;
bottom_screw_count = 5;

module usb_hub_holder() {
    difference() {
        union() {
            difference() {
                union() {
                    cube([hub_width + thickness * 2, hub_width + thickness * 2, hub_height + thickness]);
                    cylinder(d = top_screw_diameter + thickness * 2, h = hub_height + thickness, $fn = 50);
                    translate([hub_width + thickness * 2, hub_width + thickness * 2, 0]) {
                        cylinder(d = top_screw_diameter + thickness * 2, h = hub_height + thickness, $fn = 50);
                    }
                }
                translate([thickness, thickness, thickness]) {
                    cube([hub_width, hub_width, hub_height + 1]);
                }
                translate([corner, -corner + thickness * 2, -0.1]) {
                    cube([hub_width, hub_width, hub_height + thickness * 2]);
                }
                translate([-corner + thickness * 2, corner, -0.1]) {
                    cube([hub_width, hub_width, hub_height + thickness * 2]);
                }
            }
            hull() {
                translate([hub_width + thickness * 2, hub_width + thickness * 2, 0]) {
                    cylinder(d = top_screw_diameter + thickness * 2, h = thickness, $fn = 50);
                }
                translate([-delta, -delta, 0]) {
                    cylinder(d = top_screw_diameter + thickness * 2, h = thickness, $fn = 50);
                }
            }
            translate([-delta, -delta, 0]) {
                rotate([0, 0, -45]) {
                    hull() {
                        translate([-10 * floor(bottom_screw_count  / 2), 0, 0]) {
                            cylinder(d = bottom_screw_diameter + thickness * 2, h = thickness, $fn = 50);
                        }
                        translate([10 * floor(bottom_screw_count  / 2), 0, 0]) {
                            cylinder(d = bottom_screw_diameter + thickness * 2, h = thickness, $fn = 50);
                        }
                    }
                }
            }
        }
        translate([0, 0, -0.1]) {
            cylinder(d = top_screw_diameter, h = hub_height + thickness + 1, $fn = 50);
            translate([hub_width + thickness * 2, hub_width + thickness * 2, 0]) {
                cylinder(d = top_screw_diameter, h = hub_height + thickness + 1, $fn = 50);
            }
        }
        translate([-delta, -delta, -0.1]) {
            rotate([0, 0, -45]) {
                for (i = [-floor(bottom_screw_count  / 2) : floor(bottom_screw_count  / 2)]) {
                    translate([-10 * i, 0, 0]) {
                        cylinder(d = bottom_screw_diameter, h = thickness + 1, $fn = 50);
                    }
                }
            }
        }
    }
}

module cover_plate() {
    difference() {
        hull() {
            translate([hub_width + thickness * 2, hub_width + thickness * 2, 0]) {
                cylinder(d = top_screw_diameter + thickness * 2, h = thickness, $fn = 50);
            }
            cylinder(d = top_screw_diameter + thickness * 2, h = thickness, $fn = 50);
        }
        translate([0, 0, -0.1]) {
            cylinder(d = top_screw_diameter + 0.5, h = hub_height + thickness + 1, $fn = 50);
            translate([hub_width + thickness * 2, hub_width + thickness * 2, 0]) {
                cylinder(d = top_screw_diameter + 0.5, h = hub_height + thickness + 1, $fn = 50);
            }
        }
    }
}

rotate([0, 0, -45]) {
    //usb_hub_holder();
    cover_plate();
}
