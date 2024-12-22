include <helper.scad>
r = 3;
s = 22;
side = s - 9*r/2 + r;
h = .4;

module knight(){
	at(-side/4, -side/2 + .7, r/2 - h) scale([.055, .055, 1]) linear_extrude($preview ? h + .1 : h) {
		import("/Users/andrewphung/Downloads/chess-game-knight-icon.svg");
	}
}

module tree(dots = 1){
	diff(){
		at(-5.25, -side/2 + .6, r/2 - h) scale([.05, .05, 1]) linear_extrude($preview ? h + .1 : h) {
			import("/Users/andrewphung/Downloads/tree-4-svgrepo-com.svg");
		}
		for (i = [1:dots]){
			echo(i, -side/2 + i*side/(dots + 1));
			at(0, -side/2 + i*side/(dots + 1), r/2 - h) cyl($preview ? h + .2 : h, 1);
		}
	}
}

module draw(){
	at(-6.75, -side/2 - 2.5, r/2 - h) scale([.065, .065, 1]) linear_extrude($preview ? h + .1 : h) {
		import("/Users/andrewphung/Downloads/card-draw-svgrepo-com.svg");
	}
}

module dice(){
	at(-5.25, -side/2 + .3, r/2 - h) scale([.05, .05, 1]) linear_extrude($preview ? h + .1 : h) {
		import("/Users/andrewphung/Downloads/dice-1-svgrepo-com.svg");
	}
}

module move(){
	at(-6.25, -side/2 - .4, r/2 - h) scale([.06, .06, 1]) linear_extrude($preview ? h + .1 : h) {
		import("/Users/andrewphung/Downloads/move-svgrepo-com.svg");
	}
}

module reroll(){
	at(-5, -side/2 + .8, r/2 - h) scale([.045, .045, 1]) linear_extrude($preview ? h + .1 : h) {
		import("/Users/andrewphung/Downloads/arrow-rotate-right-svgrepo-com.svg");
	}
}

module copy(){
	at(-5, -side/2 + .8, r/2 - h) scale([.045, .045, 1]) linear_extrude($preview ? h + .1 : h) {
		import("/Users/andrewphung/Downloads/dice-svgrepo-com.svg");
	}
}

module play(){
	at(-5, -side/2 + .8, r/2 - h) scale([.045, .045, 1]) linear_extrude($preview ? h + .1 : h) {
		import("/Users/andrewphung/Downloads/arrow-down-to-bracket-svgrepo-com.svg");
	}
}

module swap(){
	at(-5, -side/2 + .8, r/2 - h) scale([.045, .045, 1]) linear_extrude($preview ? h + .1 : h) {
		import("/Users/andrewphung/Downloads/swap-svgrepo-com.svg");
	}
}

module symbol(){
	rowCount = floor(sqrt($children));
	for (i = [0:$children - 1]){
		at((floor(i/rowCount))*(side + 1), (i%rowCount)*(side + 1)) color("brown") {
			keep(yMin = -side/2, yMax = side/2, xMin = -side/2, xMax = side/2) children(i);
		}
	}
	
}

module face(){
	rowCount = floor(sqrt($children));
	for (i = [0:$children - 1]){
		//echo((floor(i/rowCount))*(side + 1), (i%rowCount)*(side + 1));
		at((floor(i/rowCount))*(side + 1), (i%rowCount)*(side + 1)) color("green") diff()
		{
			union(){
				linear_extrude(r/2, scale = (side)/(s - 9*r/2)) square(s - 9*r/2, center = true);
				up(-r/2) cyl(r/2, r/2, .25, invert_top = true);
			}
			children(i);
		}
	}
}


//symbol_face() { 
//	tree(1); 
//	tree(2);
//	tree(3);
//	tree(1);
//	draw();
//	dice();
//	tree(2);
//	move();
//	move();
//	copy();
//	play();
//	move();
//	swap();
//	move();
//	tree();
//	move();
//}
symbol() { 
	tree(1); 
	tree(2);
	tree(3);
	tree(1);
	draw();
	dice();
	tree(2);
	move();
	move();
	copy();
	play();
	move();
	swap();
	move();
	tree();
	move();
}
face() { 
	tree(1); 
	tree(2);
	tree(3);
	tree(1);
	draw();
	dice();
	tree(2);
	move();
	move();
	copy();
	play();
	move();
	swap();
	move();
	tree();
	move();
}
