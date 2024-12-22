include <helper.scad>

r = 15/2;

module token(){
	random_index = floor(rands(0, 4, 1)[0]);
	tree_color = ["red", "yellow", "purple", "orange"][random_index];
	color("brown") cyl(3, r, 1);
	at(-r + 2) tree(tree_color);
	rotate(120*Z) at(-r + 2) tree(tree_color);
	rotate(240*Z) at(-r + 2) tree(tree_color);
}

for (i = [0:0]){
	for (j = [0:0]){
		if (rands(0, 360, 1)[0] > 36){
			at(19*i, 19*j, abs(10 - i) + abs(10 - j) < 4 ? 12 : 0) rotate(rands(0, 360, 1)[0]*Z)token();
		}
		//at(19*i, 19*j, abs(10 - i) + abs(10 - j) < 4 ? 6 : 0) at(-13/2, -13/2, -6) color("brown") box(13, 13, 6);
	}
}
//up(-6) color("green") box(400, 400, 5);


module tree(tree_color){
	$fa = 8;
	$fs = 0.01;
	//////////////////////////////////////
	// Start User Settings
	// All lengths in mm
	//////////////////////////////////////
	$height = 13 + floor(rands(0, 4, 1)[0]); // total height of the tree
	$layerHeight = 0.3; // the layer height you're going to set in your slicer
	$perimeterWidth = 0.6; // the perimeter width you're going to set in your slicer
	$firstLayer = 0.2; // height of the first layer set in slicer
	$trunkHeightWished = 7; // height of the lowest branch -- how tall is the trunk? -- cut later to match the layers.
	$tipHeight = 0; // how far will the "trunk" extend past the highest branch
	$baseRadius = 2; // Radius of the of the trunk at the ground
	// the radius of the tip of the tree is $tipRadius, which you can set below
	$bottomBranchRadius = 5; // length of the lowest branches
	$topBranchRadius = 4; // length of the top branches
	$branchSkip = 2; // branches will be drawn every N layers...
	$branchVariance = 0.15; // branch length will vary by this amount
	//////////////////////////////////////
	// End User Settings
	//////////////////////////////////////

	$trunkHeight = floor($trunkHeightWished/$layerHeight)*$layerHeight - $layerHeight + $firstLayer;
	$doublePerimeterWidth = 2*($perimeterWidth - $layerHeight * (1 - PI/4));
	// ONE MORE USER SETTING, if you want to change it.
	$tipRadius = $doublePerimeterWidth; // radius of the top of the trunk
	$branchSpacing = 0.5*$perimeterWidth; // spacing along the trunk between branches

	// draw the trunk
	color("brown") cylinder( $height, $baseRadius, $tipRadius);

	$osAngle = 0;
	// draw the branches - travel up the trunk in steps of "branchSkip" layers
	color(tree_color) for ($branchHeight = [$trunkHeight : $layerHeight*$branchSkip : $height - $tipHeight]) {
	  // calculate the radius of the trunk here
	  $radius = $baseRadius - ($branchHeight/$height * ($baseRadius - $tipRadius));
	  // and the radius of the branches
	  $branchRadius = $bottomBranchRadius - ($bottomBranchRadius - $topBranchRadius)
		*($branchHeight - $trunkHeight)/($height - $tipHeight - $trunkHeight);
	  // what angle does a branch alone cut on the trunk?
	  $branchAngle = acos((2*$radius^2 - $doublePerimeterWidth^2)/(2*$radius^2));
	  // how long is the arc of that angle? add the minimum spacing between branches!
	  $branchArc = $branchAngle * PI / 180 * $radius + $branchSpacing;
	  // what angle is a branch plus the spacing?
	  $branch = $branchArc * 180 / PI / $radius;
	  // how many branches will there be (round to an integer number!)
	  $branches = floor (360 / $branch);
	  // pop up to the right height
	  translate([0, 0, $branchHeight]){
		  $osAngle = rands(1,360,1)[0];
		  // draw the branches at this layer, offset the angle so the branches don't line up.
		  for($angle = [0: 360/$branches : 360]){
			rotate([0,0,$angle + $osAngle]){
			  translate([-$doublePerimeterWidth/2, 0, 0])
				cube([$doublePerimeterWidth, 
					  rands($branchRadius*(1-$branchVariance),$branchRadius,1)[0], 
					  $layerHeight]);
		  }
		}
	  }
	}
}
