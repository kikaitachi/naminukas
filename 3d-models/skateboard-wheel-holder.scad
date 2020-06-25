use <teardrop.scad>

module skateboard_wheel_holder(
        board_holder_thickness = 2,
        board_holder_length = 15,
        board_holder_screw_radius = 4.3 / 2,
        wheel_holder_thickness = 4,
        wheel_holder_length = 15,
        whell_holder_screw_radius = 6.3 / 2,
        board_height = 8.7,
        board_width = 124) {
    difference() {
        union() {
            cube([
                board_height + 2 * board_holder_thickness,
                board_width + 2 * board_holder_thickness,
                board_holder_length + board_holder_thickness],
                center = true);
            translate([
                    wheel_holder_length / 2 + board_height / 2 + board_holder_thickness,
                    -board_width / 2 + wheel_holder_thickness / 2 - board_holder_thickness,
                0]) {
                cube([
                    wheel_holder_length,
                    wheel_holder_thickness,
                    board_holder_length + board_holder_thickness],
                    center = true);
            }
            translate([
                    wheel_holder_length / 2 + board_height / 2 + board_holder_thickness,
                    board_width / 2 - wheel_holder_thickness / 2 + board_holder_thickness,
                    0]) {
                cube([
                    wheel_holder_length,
                    wheel_holder_thickness,
                    board_holder_length + board_holder_thickness],
                    center = true);
            }
        }
        translate([0, 0, board_holder_thickness]) {
            cube([
                    board_height,
                    board_width,
                    board_holder_length + board_holder_thickness],
                center = true);
        }
        for (i = [-board_width / 20 + 1:board_width / 20 - 1]) {
            translate([0, i * 10 + board_holder_screw_radius, board_holder_screw_radius]) {
                rotate([0, 0, 90]) {
                    teardrop(radius = board_holder_screw_radius, length = board_height * 2);
                }
            }
        }
        translate([wheel_holder_length / 2 + board_height / 2 + board_holder_thickness, -board_width / 2 + wheel_holder_thickness / 2 - board_holder_thickness, 0]) {
            teardrop(radius = whell_holder_screw_radius, length = wheel_holder_thickness * 2);
        }
        translate([wheel_holder_length / 2 + board_height / 2 + board_holder_thickness, board_width / 2, 0]) {
            teardrop(radius = whell_holder_screw_radius, length = wheel_holder_thickness * 2);
        }
    }
}

skateboard_wheel_holder();
