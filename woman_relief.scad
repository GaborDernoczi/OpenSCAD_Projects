// Two-colour, print-in-place aligned relief for a 250 x 250 mm build plate.
// Export "black" and "gold" separately; import them as parts of one object in
// the slicer and preserve their coordinates so the relief stays at z = 4 mm.
part = "preview"; // [preview, black, gold]

panel_width = 160;
panel_height = 200;
base_thickness = 4;
gold_height = 1.2;
mounting_holes = true;

$fn = 48;

assert(panel_width >= 140 && panel_height >= 180,
    "Panel dimensions must leave room for the relief");
assert(base_thickness >= 2, "Base must be at least 2 mm thick");
assert(gold_height >= 0.8, "Relief must be at least 0.8 mm high");

module panel_base() {
    difference() {
        linear_extrude(height = base_thickness)
            offset(r = 3)
                square([panel_width - 6, panel_height - 6]);

        if (mounting_holes) {
            for (x = [12, panel_width - 12])
                translate([x, panel_height - 12, -0.01])
                    cylinder(h = base_thickness + 0.02, d = 4.2);
        }
    }
}

module stroke(points, radius) {
    for (i = [0 : len(points) - 2]) {
        hull() {
            translate(points[i]) circle(r = radius);
            translate(points[i + 1]) circle(r = radius);
        }
    }
}

module eye_detail() {
    stroke([[53, 128], [58, 134], [65, 136], [72, 133], [77, 128]], 1.5);
    stroke([[54, 127], [60, 124], [66, 124], [73, 127], [76, 128]], 1.1);
    translate([65, 129]) circle(r = 2.1);
    translate([65, 129]) circle(r = 0.9);
}

module artwork_2d() {
    union() {
        // Fine oval frame around the face.
        difference() {
            translate([80, 108]) scale([0.49, 0.67]) circle(r = 100);
            translate([80, 108]) scale([0.465, 0.645]) circle(r = 100);
        }

        // Eyes and brow lines.
        for (side = [-1, 1])
            translate([80, 0]) scale([side, 1]) translate([-80, 0]) {
                eye_detail();
                stroke([[53, 139], [59, 142], [66, 142], [73, 139]], 1.6);
            }

        // Nose bridge and nostril contours.
        stroke([[80, 126], [79, 116], [80, 106], [80, 98]], 1.8);
        stroke([[80, 99], [76, 95], [72, 94]], 1.4);
        stroke([[80, 99], [84, 95], [88, 94]], 1.4);

        // Paired hands fanning across the lower face.
        for (side = [-1, 1])
            translate([80, 0]) scale([side, 1]) translate([-80, 0]) {
                stroke([[64, 82], [68, 78], [73, 76], [76, 78]], 1.8);
                stroke([[62, 82], [57, 89], [53, 98], [49, 109]], 1.4);
                stroke([[66, 81], [63, 91], [60, 102], [58, 114]], 1.4);
                stroke([[70, 80], [69, 91], [68, 103], [68, 115]], 1.4);
                stroke([[74, 80], [75, 91], [77, 102], [78, 114]], 1.4);

                // Fingernail accents.
                stroke([[47, 108], [50, 110], [53, 108]], 0.8);
                stroke([[56, 113], [59, 115], [62, 113]], 0.8);
                stroke([[66, 114], [69, 116], [72, 114]], 0.8);
            }
    }
}

module gold_relief() {
    translate([panel_width / 2, panel_height / 2, base_thickness])
        scale([panel_width / 160, panel_height / 200, 1])
            translate([-80, -100, 0])
                linear_extrude(height = gold_height)
                    artwork_2d();
}

if (part == "black") {
    panel_base();
} else if (part == "gold") {
    gold_relief();
} else {
    color([0.035, 0.035, 0.04]) panel_base();
    color([0.83, 0.62, 0.25]) gold_relief();
}
