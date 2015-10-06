#version 150

//Input position (coordinates within texture)
in vec2 pos;

//Texture maps for the image drawn on the screen, and the Z-buffer
uniform sampler2D tex;
uniform sampler2D depth;

//Final output colour
out vec4 outColour;

void main() {
	//Modify this code to read from the texture and add extra effects!
	//Read the colour from the texture and output it directly to the screen
	float blurRadius = 0.1;
	float blurVariation = 15;
	float blurBlackCancelThresh = 0.1;

	vec4 col=texture(tex,vec2(pos.x,pos.y));

    vec4 avgCol;

    // only blur the pixel if it is not blackish to prevent background blur
    if (((col.x + col.y + col.z)/3.0) < blurBlackCancelThresh){
        outColour=col;
    } else {
        // make the blur the average of 9 pixels spaced out by the blurRadius
        for(int i = -1; i<=1; i++){
            for(int j = -1; j<=1; j++){
                float pixelDepth = texture(depth, vec2(pos.x, pos.y)).x;
                float blurValue = blurRadius * pow(pixelDepth, blurVariation);
                avgCol += texture(tex, vec2(pos.x + (i*blurValue), pos.y + (j*blurValue)));
            }
        }
        outColour=avgCol/9;
    }
//	outColour=col;
}
