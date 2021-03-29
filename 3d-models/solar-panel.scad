use <MCAD/2Dshapes.scad>;

frame_width = 3;
frame_height = 4;
cell_width = 125;
cell_height = cell_width * 2;
shaft_diameter = 30;
shaft_thickness = 3;
shaft_gap = 0.1;
shaft_height_bottom = 10;
cable_diameter = 2;

module C60() {
    width = 125;
    width_diagonal = 160;
    height = 0.5;
    color([22 / 255, 33 / 255, 75 / 255]) {
        intersection() {
            cube([width, width, height], center = true);
            rotate([0, 0, 45]) {
                cube([width_diagonal, width_diagonal, height], center = true);
            }
        }
    }
    color([206 / 255, 198 / 255, 195 / 255]) {
        translate([0, 0, -height]) {
            intersection() {
                cube([width, width, height], center = true);
                rotate([0, 0, 45]) {
                    cube([width_diagonal, width_diagonal, height], center = true);
                }
            }
        }
    }
}

module shaft(diameter, height, thickness) {
    difference() {
        union() {
            cylinder(d = diameter, h = height, $fn = 100);
            linear_extrude(height, $fn = 100) {
                pieSlice(size = diameter / 2 + (shaft_thickness / 6), start_angle = 20, end_angle = 25);
            }
        }
        translate([0, 0, -0.1]) {
            cylinder(d = diameter - thickness * 2, h = height + 1, $fn = 100);            
            linear_extrude(height + 1, $fn = 100) {
                pieSlice(size = diameter / 2 - shaft_thickness * 5 / 6, start_angle = 20, end_angle = 115);
            }
            linear_extrude(height + 1, $fn = 100) {
                pieSlice(size = diameter / 2 - shaft_thickness * 3 / 6, start_angle = 350, end_angle = 370);
            }
        }
    }
}

module frame(index, height) {
    difference() {
        union() {
            translate([cell_width / 2 + frame_width, cell_width / 2 + frame_width, frame_height * 2 / 3]) {
                mirror([0, 0, index == 0 ? 0 : 1]) {
                    for (i = [0 : cell_height / cell_width - 1]) {
                        translate([0, i * cell_width, 0]) {
                            C60();
                        }
                    }
                }
            }
            difference() {
                cube([
                    cell_width + 2 * frame_width,
                    cell_height + 2 * frame_width,
                    frame_height
                ]);
                translate([frame_width, frame_width, -0.1]) {
                    cube([
                        cell_width,
                        cell_height,
                        frame_height + 1
                    ]);
                }
            }
            rotate([0, 0, 45]) {
                diameter = shaft_diameter - index * (shaft_thickness + shaft_gap) * 2;
                translate([- shaft_diameter / 2, 0, 0]) {
                    shaft(diameter, height, shaft_thickness);
                }
                translate([-(index + 1) * shaft_thickness + shaft_thickness / 2, - frame_width, 0]) {
                    cube([frame_width + (index + 1) * shaft_thickness - shaft_thickness / 2, frame_width * 2, frame_height]);
                }
            }
        }
        // Cable hole
        translate([-3, -3, frame_height / 2]) {
            rotate([0, 45, -45]) {
                cube([cable_diameter, shaft_diameter * 0.8, cable_diameter], center = true);
            }
        }
    }
}

delta = sqrt(pow(shaft_diameter / 2, 2) * 2) / 2;
translate([delta, delta, 0]) {
    union() {
        frame(0, frame_height);
        translate([cell_width + 2 * frame_width, cell_height + 2 * frame_width, 0]) {
            rotate([0, 0, 180]) {
                frame(0, frame_height);
            }
        }
    }
}
for (i = [1 : 3]) {
    translate([0, 0, frame_height * (i + 1)]) {
        rotate([0, 0, 90 * i * $t]) {
            translate([delta, delta, 0]) {
                mirror([0, 0, 1]) {
                    frame(i, frame_height * (i + 1) + (i == 3 ? shaft_height_bottom : 0));
                }
            }
        }
    }
    translate([cell_width + (delta + frame_width) * 2, cell_height + (delta + frame_width) * 2, frame_height * (i + 4)]) {
        rotate([0, 0, 90 * i * $t - 180]) {
            translate([delta, delta, 0]) {
                mirror([0, 0, 1]) {
                    frame(i, frame_height * (i + 4) + (i == 3 ? shaft_height_bottom : 0));
                }
            }
        }
    }
}
