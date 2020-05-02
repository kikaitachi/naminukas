module rounded_box(width = 10, length = 20, height = 1, corner_radius = [1, 2, 3, 4]) {
    hull() {
        translate([corner_radius[0], corner_radius[0], 0]) {
            cylinder(r = corner_radius[0], h = height, $fn = 50);
        }
        translate([corner_radius[1], length - corner_radius[1], 0]) {
            cylinder(r = corner_radius[1], h = height, $fn = 50);
        }
        translate([width - corner_radius[2], length - corner_radius[2], 0]) {
            cylinder(r = corner_radius[2], h = height, $fn = 50);
        }
        translate([width - corner_radius[3], corner_radius[3], 0]) {
            cylinder(r = corner_radius[3], h = height, $fn = 50);
        }
    }
}
