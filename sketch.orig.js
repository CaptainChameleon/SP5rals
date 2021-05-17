let background;
let displacement = 0;

function preload(){
    background = loadImage("assets/background.jpg");
}

function setup() {
    createCanvas(640.5, 525, WEBGL);
}

function draw() {
    camera(0, -70, 190, 0, 0, 0);

    lightFalloff(0.05, 0, 0);
    spotLight(255,255,255, -200,-30,250,  200,0,60,  PI/2, 1);

    push();
        translate(-width/2, -height/2 +70 , -338);
        rotateX(atan(70/190));
        image(background, 0, 0, 640.5, 525);
    pop();
    
    translate(-8,-42,-25);
    rotateX(-0.35);
    rotateY(PI/4.7);
    //noStroke();
    for (let i = 0; i < 4; i++) {
        generateStripe(PI/4*i, displacement);
        displacement += 0.0001;          
    }
    
}

function generateStripe(gap, innerRotation) {
    let majorRadius = 100;
    let minusRadius;
    let elongation = 21;
    let center;
    let direction;
    let point;
    let angle = 0;
    let stripeSection;
    let vertex1;
    let vertex2;

    beginShape(TRIANGLE_STRIP);

    while(elongation*angle <= 1.44*TWO_PI) { // DESFASE
        point = [majorRadius,0,0];
        center = math.rotate([majorRadius, 0, 0], -elongation*angle,[0,1,0]);
        direction = math.rotate([0, 0, 1], -elongation*angle,[0,1,0]);
        
        //minorRadius =100*pow(angle, 1); // TIPO DE ESPIRAL
        minusRadius = 90*pow(angle, 1); // TIPO DE ESPIRAL

        point = math.dotMultiply(math.dotDivide(point, math.norm(point)), -minusRadius);
        point = math.rotate(point, 90*(angle + gap + innerRotation), [0,0,1]); // ROTACION
        point = math.rotate(point, -elongation*angle, [0,1,0]);
        point = math.add(center, point);

        stripeSection =  math.dotMultiply(math.dotDivide(direction, math.norm(direction)), minusRadius/PI);
        vertex1 = math.add(point, stripeSection);
        vertex2 = math.add(point, math.rotate(stripeSection, -PI, point));
        //let vertex2 = math.add(pointPos, math.dotMultiply(-1,stripeSection));

        point = math.rotate(point, pow(sin(angle),2)*pow(angle,1.01), [0,1,0]);
        point = math.add(center, point);
        angle = radians(degrees(angle) + 0.1);
        
        vertex(vertex2[0], vertex2[1], vertex2[2]);   
        if (elongation*angle <= 1.44*TWO_PI) vertex(vertex1[0], vertex1[1], vertex1[2]);   
    }

    endShape();
}