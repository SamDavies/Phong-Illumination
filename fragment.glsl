#version 150

//Vector to light source
in vec4 lightVec;
//Vector to eye
in vec4 eyeVec;
//Transformed normal vector
in vec4 normOut;

//A texture you might want to use (optional)
uniform sampler2D tex;

//Output colour
out vec4 outColour;

/* Standard operations work on vectors, e.g.
	light + eye
	light - eye
   Single components can be accessed (light.x, light.y, light.z, light.w)
   C style program flow, e.g. for loops, if statements
   Can define new variables, vec2, vec3, vec4, float
   No recursion
   Example function calls you might find useful:
	max(x,y) - maximum of x and y
	dot(u,v) - dot product of u and v
	normalize(x) - normalise a vector
	pow(a,b) - raise a to power b
	texture(t,p) - read texture t at coordinates p (vec2 between 0 and 1)
	mix(a,b,c) - linear interpolation between a and b, by c. (You do not need to use this to interpolate vertex attributes, OpenGL will take care of interpolation between vertices before calling the fragment shader)
   outColour is a vec4 containing the RGBA colour as floating point values between 0 and 1. outColour.r, outColour.g, outColour.b and outColour.a can be used to access the components of a vec4 (as well as .x .y .z .w)
*/

void main() {
	float lightIntensity = 1.0;
	float diffRelectivity = 0.5;
	float specRelectivity = 0.5;
	float specIntensity = 4.0;
	float ambient=0.1;
	float texRatio = 0.2;

	//Modify this code to calculate Phong illumination based on the inputs
	float diff = lightIntensity * diffRelectivity * max(0, dot(lightVec, normOut));
//    diff = 0.0;

    float cosA = max(0.0, dot(2*normOut * dot(lightVec, normOut ) - lightVec, eyeVec));
	float spec = lightIntensity * specRelectivity * pow(cosA, specIntensity);


    vec4 eyeRelfection = 2*normOut * dot(eyeVec, normOut ) - eyeVec;
    vec4 texVec = texture(tex, normalize(vec2(eyeRelfection.x, eyeRelfection.y)));


	vec4 phong = vec4(spec+ambient, spec+diff+ambient, spec+ambient, 1.0);
	outColour = (texRatio * texVec) + ((1-texRatio) * phong);
}
