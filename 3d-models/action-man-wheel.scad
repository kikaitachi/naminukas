module action_man_wheel(
        wheel_thickness = 9.4,
        wheel_diameter = 95.5,
        wheel_screw_diameter = 2.4,
        wheel_screw_hole_dist = 30.5,
        wheel_spoke_thickness = 1.5,
        rim_thickness = 1.25,
        edge_height = 5.7,
        edge_width_base = 4.72,
        edge_width_top = 2.9) {
    difference() {
        union() {
            rotate_extrude($fn = 300) {
                translate([wheel_diameter / 2, 0]) {
                    polygon(points = [
                        [0, 0],
                        [edge_height, 0],
                        [edge_height, edge_width_top / 2],
                        [0, edge_width_base / 2],
                    ]);
                }
            }
            difference() {
                cylinder(d = wheel_diameter, h = wheel_thickness / 2, $fn = 300);
                cylinder(d = wheel_diameter - rim_thickness * 2, h = wheel_thickness + 1, center = true, $fn = 300);
            }
            // Wheel spokes
            for (i = [0:5]) {
                for (j = [-1:1]) {
                    hull() {
                        rotate([0, 0, 360 * i / 6]) {
                            translate([wheel_screw_hole_dist - 1, 0, 0]) {
                                cylinder(h = wheel_spoke_thickness, d = wheel_screw_diameter + 0.6, $fn = 32);
                            }
                        }
                        rotate([0, 0, 360 * i / 6 + j * 15]) {
                            translate([wheel_diameter / 2, 0, 0]) {
                                cylinder(h = wheel_spoke_thickness, d = wheel_screw_diameter / 2, $fn = 32);
                            }
                        }
                    }
                }
            }
        }
        // Screw holes
        for (i = [0:5]) {
            rotate([0, 0, 360 * i / 6]) {
                translate([wheel_screw_hole_dist, 0, -0.1]) {
                    cylinder(h = wheel_spoke_thickness + 1, d = wheel_screw_diameter, $fn = 32);
                }
            }
        }
    }
}

action_man_wheel();
