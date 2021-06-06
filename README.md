# SP5rals
A P5.js representation of M.C. Escher's artwork "Spirals"

## About 
This project started as a class asignment. Initially, the objetive was to create a visual effect using P5.js library, with the limitation of a maximum of 1024 characters for the main and only script. I chose the goal of recreating M.C. Escher artwork "Spirals", as it posed a decent challenge and was suitable for being animated into a mesmerizing effect.

### Original work by M.C. Escher
![Spirals artwork by M.C. Escher](https://github.com/CaptainChameleon/sp5rals/blob/39a40f17abfff7e511307364ab20c601e5ea3aea/Spirals%20-%20M.C.%20Escher.jpg)

## Implementing the copycat
### The Spirals
The first part of the project consisted in analysing the artwork itself. It clearly involves some spirals... but which ones? 

It can be easily apreciated how the stripes that form the structure follow a circular path in space, but also twist around this path at an ever increasing distance, resulting in the effect of the convoluted stripes "eating" their tails. This is somehow similar to a torus whose minor radius grows exponentially, the key being the rate of that growth. 

A torus can be described as a circle rotating at a certain distance over an axis. We could reconstruct the structure by rotating a spiral instead of a circle. To achieve this, because we're working with a 3D graphics library, polar coordinates work best in this scenario, we can use them to describe the spiral's travel with points. We'll use 2 vectors to describe each point position: one for the position of the center of the spiral, and one for the position of the point itself: 

The center will be computed using the circular path radius (the major radius) and the current value of the rotation angle. 

The position of the point is computed starting from the x-axis, it is first rotated over the z-axis, to account for the rotation around the circular path,  and then over the y-axis, to follow such path. Lastly, its module is set to the value of the minor radius and the center position is added to the vector.

The value of the minor radius is calculated with the equation of the corresponding spiral. The first spiral that comes to mind is the most basic of all spirals: the arithmetic spiral. The general equation of the arithmetic spiral in polar coordinates is the following: 

`r = a + b * theta ^ (1/c)`

Where `r` is the radius and `theta` the angle. This equation also describes the family of hyperbolic `c = -1`, lituus `c = -2`, and Fermat's spirals `c = 2`; while the regular arithmetic spiral appears when `c = 1`. The other parameters meassure the center's distance to the origin `a`, and the distance between each loop `b`. 

After serveral tries, the following equation appeared to be the closest to resemble the ones used in the artwork: 

`r = 90 * theta`

### A 3D Stripe
Once we have a better idea of the type of spiral, and how it travels through the space, we need to generate a 3D mesh so we can reproduce the twisted stripes of the artwork. In order to achieve it, we need more points. Each point we calculated in the previous step was in fact in the middle of such stripe, for creating a 3D mesh we need to add them 2 by 2. For this, we'll introduce an additional vector: the direction. This vector represents the direction the spiral is following at each point.

By computing the cross product between this vector and the position we obtain a new vector whose key characteristic is that it's ortogonal to both the direction and the point position. This new vector represents the position of one of those vertex that would conform the stripe section, and by rotating it using the point position as a rotation axis, we can generate the second needed vertex. We can also customize the stripe width via the module of this vector and the rotation angle over the point position.

![First Stripe](https://github.com/CaptainChameleon/SP5rals/blob/5ddce9e2762e2a467cad511c13d53a6088ce6dc4/First%20stripe.jpg)

### Multiple Stripes & Animation
Now that we have our first stripe, generating the rest shoud be a piece of cake. If we observe the artwork further, we can notice that there are 4 stripes in total, and they all finish their rotation at the same point in the path. The only difference between them is that they are out of phase. We can reproduce this by adding a new parameter: the gap. This parameter will be used when we rotate each point position over the z-axis, by adding it to the rotation angle we can produce the out of phase effect.

This is also the way we can animate the stripes, by creating another parameter that will be added alongside the gap. If we link this new parameter to the scene drawing iterations, we can make it look like the stripes are continuously being generated and revolving around themselves.

### The result
Finally, after playing with the camera angles, the lightning, creating a similar background with GIMP, and [cheating a bit](https://codebeautify.org/minify-js) with the total characters used, here's the result:

![P5.js representation](https://github.com/CaptainChameleon/SP5rals/blob/5ddce9e2762e2a467cad511c13d53a6088ce6dc4/SP5rals.gif)

## Getting real
Now that we have something remotely close to the original work, let's try and see if we can improve it.

### Shaders
