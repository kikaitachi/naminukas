solar_cell_diameter = 125;
solar_cell_diameter_diagonal = 160;
solar_cell_to_frame_gap = 0.25;
solar_frame_diameter = 4;
solar_frame_thickness = 2;
solar_frame_length = solar_cell_diameter + (solar_cell_to_frame_gap + solar_frame_diameter) * 2;
solar_frame_length_diagonal = solar_cell_diameter_diagonal + (solar_cell_to_frame_gap + solar_frame_diameter) * 2;
solar_facet_diameter = solar_cell_diameter + (solar_cell_to_frame_gap + solar_frame_diameter + 3) * 2;
solar_staple_width = 9;
solar_staple_diameter = 0.8;

module solar_panel_frame_side(length) {
    linear_extrude(height = length, convexity = 10, center = false) {
        polygon(points = [
            [0, 0],
            [-solar_frame_thickness / 2, -solar_frame_thickness],
            [-solar_frame_diameter, -solar_frame_thickness],
            [-solar_frame_diameter + solar_frame_thickness / 2, -solar_frame_thickness / 2],
            [-solar_frame_diameter, 0]
        ]);
    }
}

module solar_panel_frame_corner(length) {
    union() {
        intersection() {
            solar_panel_frame_side(length / 2);
            translate([length / 2 - solar_frame_diameter, 0, solar_frame_diameter]) {
                rotate([0, -90, 0]) {
                    solar_panel_frame_side(length / 2);
                }
            }
        }
        translate([0, 0, solar_frame_diameter / 2]) {
            solar_panel_frame_side(length / 2 - solar_frame_diameter / 2);
        }
        translate([length / 2 - solar_frame_diameter, 0, solar_frame_diameter]) {
            rotate([0, -90, 0]) {
                solar_panel_frame_side(length / 2 - solar_frame_diameter / 2);
            }
        }
    }
}

module solar_panel_frame_sides(length) {
    for (i = [0 : 3]) {
        rotate([0, 0, i * 90]) {
            rotate([-90, 0, 0]) {
                translate([-length / 2 + solar_frame_diameter, 0, -length / 2]) {
                    solar_panel_frame_corner(length);
                }
            }
        }
    }
}

module solar_cell(
        main_diameter = 125,
        diagonal_diameter = 160,
        thickness = 2) {
    difference() {
        union() {
            solar_panel_frame_sides(solar_frame_length);
            /*rotate([0, 0, 45]) {
                solar_panel_frame_sides(solar_frame_length_diagonal);
            }*/
            translate([-solar_frame_diameter / 2, -solar_frame_length + solar_frame_diameter * 1.5, 0]) {
                cube([solar_frame_diameter, solar_cell_diameter / 2, solar_frame_thickness]);
            }
        }
        for (i = [-1 : 1]) {
            translate([0, i * 35, 0]) {
                translate([-(solar_frame_length - solar_frame_diameter) / 2, -solar_staple_width / 2, -0.1]) {
                    cylinder(h = solar_frame_thickness + 1, d = solar_staple_diameter, $fn = 25);
                }
                translate([-(solar_frame_length - solar_frame_diameter) / 2, solar_staple_width / 2, -0.1]) {
                    cylinder(h = solar_frame_thickness + 1, d = solar_staple_diameter, $fn = 25);
                }
                translate([(solar_frame_length - solar_frame_diameter) / 2, -solar_staple_width / 2, -0.1]) {
                    cylinder(h = solar_frame_thickness + 1, d = solar_staple_diameter, $fn = 25);
                }
                translate([(solar_frame_length - solar_frame_diameter) / 2, solar_staple_width / 2, -0.1]) {
                    cylinder(h = solar_frame_thickness + 1, d = solar_staple_diameter, $fn = 25);
                }
            }
        }
    }
}

//solar_cell();

for (i = [0 : 24]) {
    rotate([0, 0, i * (360 / 24)]) {
        translate([-solar_cell_diameter / 6, 159, 0])
        rotate([0, 0, 0])
        translate([solar_cell_diameter / 6, solar_cell_diameter / 2, 0]) {
            intersection() {
                cube([solar_cell_diameter / 3, solar_cell_diameter, solar_frame_thickness], center = true);
                rotate([0, 0, 45]) {
                    cube([solar_cell_diameter_diagonal, solar_cell_diameter_diagonal, solar_frame_thickness], center = true);
                }
            }
        }
    }
}
/*
#for (i = [0 : 24]) {
    rotate([0, 0, i * (360 / 24)]) {
        translate([-solar_cell_diameter / 6, 159, 0])
        rotate([0, 0, 0])
        translate([solar_cell_diameter / 6, solar_cell_diameter / 2, 0]) {
            intersection() {
                cube([solar_cell_diameter / 3, solar_cell_diameter, solar_frame_thickness], center = true);
                rotate([0, 0, 45]) {
                    cube([solar_cell_diameter_diagonal, solar_cell_diameter_diagonal, solar_frame_thickness], center = true);
                }
            }
        }
    }
}
*/