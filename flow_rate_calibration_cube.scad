// Open-top, single-wall flow-rate calibration cube.
// Outer dimensions: 50 x 50 x 50 mm.
cube_size = 50;
wall_thickness = 0.45;
bottom_thickness = 0.8;
cylinder_diameter = 20;
cylinder_wall_thickness = wall_thickness;
cylinder_gap = 2;

assert(wall_thickness > 0, "wall_thickness must be greater than zero");
assert(bottom_thickness > 0, "bottom_thickness must be greater than zero");
assert(cube_size > 2 * wall_thickness, "Walls leave no interior");
assert(cube_size > bottom_thickness, "Bottom leaves no interior height");
assert(cylinder_wall_thickness > 0, "cylinder_wall_thickness must be greater than zero");
assert(cylinder_diameter > 2 * cylinder_wall_thickness, "Cylinder wall leaves no interior");

union() {
    difference() {
        translate([-cube_size / 2, -cube_size / 2, 0])
            cube([cube_size, cube_size, cube_size]);

        translate([
            -cube_size / 2 + wall_thickness,
            -cube_size / 2 + wall_thickness,
            bottom_thickness
        ])
            cube([
                cube_size - 2 * wall_thickness,
                cube_size - 2 * wall_thickness,
                cube_size - bottom_thickness + 0.02
            ]);
    }

    translate([
        cube_size / 2 + cylinder_gap + cylinder_diameter / 2,
        0,
        0
    ])
        difference() {
            cylinder(h = cube_size, d = cylinder_diameter);
            translate([0, 0, -0.01])
                cylinder(
                    h = cube_size + 0.02,
                    d = cylinder_diameter - 2 * cylinder_wall_thickness
                );
        }
}
