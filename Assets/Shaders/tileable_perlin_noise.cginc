// WARNING: THIS FILE IS ROUGH AND NEEDS CLEANING UP.
// source: https://www.ronja-tutorials.com/post/029-tiling-noise/#layered-tileable-noise
float Rand2dTo1d(float2 value, float2 dotDir = float2(12.9898, 78.233), float seed = 1){
	float2 smallValue = cos(value);
	float random = dot(smallValue, dotDir * seed);
	random = frac(sin(random) * 143758.5453);
	return random;
}

float2 Rand2dTo2d(float2 value, float seed = 1){
	return float2(
		Rand2dTo1d(value, float2(12.9898, 78.233), seed),
		Rand2dTo1d(value, float2(39.346, 11.135), seed)
	);
}

float EaseIn(float interpolator){
	return interpolator * interpolator;
}

float EaseOut(float interpolator){
	return 1 - EaseIn(1 - interpolator);
}

float EaseInOut(float interpolator){
	float EaseInValue = EaseIn(interpolator);
	float EaseOutValue = EaseOut(interpolator);
	return lerp(EaseInValue, EaseOutValue, interpolator);
}

float2 Modulo(float2 divident, float2 divisor){
	float2 positiveDivident = divident % divisor + divisor;
	return positiveDivident % divisor;
}

void PerlinNoise_float(float2 value, float2 period, float seed, out float noise){
	float2 cellsMinimum = floor(value);
	float2 cellsMaximum = ceil(value);

	cellsMinimum = Modulo(cellsMinimum, period);
	cellsMaximum = Modulo(cellsMaximum, period);

	//generate random directions
	float2 lowerLeftDirection = Rand2dTo2d(float2(cellsMinimum.x, cellsMinimum.y), seed) * 2 - 1;
	float2 lowerRightDirection = Rand2dTo2d(float2(cellsMaximum.x, cellsMinimum.y), seed) * 2 - 1;
	float2 upperLeftDirection = Rand2dTo2d(float2(cellsMinimum.x, cellsMaximum.y), seed) * 2 - 1;
	float2 upperRightDirection = Rand2dTo2d(float2(cellsMaximum.x, cellsMaximum.y), seed) * 2 - 1;

	float2 fraction = frac(value);

	//get values of cells based on fraction and cell directions
	float lowerLeftFunctionValue = dot(lowerLeftDirection, fraction - float2(0, 0));
	float lowerRightFunctionValue = dot(lowerRightDirection, fraction - float2(1, 0));
	float upperLeftFunctionValue = dot(upperLeftDirection, fraction - float2(0, 1));
	float upperRightFunctionValue = dot(upperRightDirection, fraction - float2(1, 1));

	float interpolatorX = EaseInOut(fraction.x);
	float interpolatorY = EaseInOut(fraction.y);

	//interpolate between values
	float lowerCells = lerp(lowerLeftFunctionValue, lowerRightFunctionValue, interpolatorX);
	float upperCells = lerp(upperLeftFunctionValue, upperRightFunctionValue, interpolatorX);

	noise = lerp(lowerCells, upperCells, interpolatorY);
	noise += 0.5;
}

// Signed distance to a regular heptagon, based on IQ's pentagon function.
float sdHeptagon(float2 p, float r){ 
    const float3 k = float3(.9009688679, .43388373911, .4815746188); // PI/7: cos, sin, tan.
    p.y = -p.y;
    p.x = abs(p.x);
    p -= 2.*min(dot(float2(-k.x, k.y), p), 0.)*float2(-k.x, k.y);
    p -= 2.*min(dot(float2(k.x, k.y), p), 0.)*float2(k.x, k.y);
    p -= 2.*min(dot(float2(-k.x, k.y), p), 0.)*float2(-k.x, k.y);
	p -= float2(clamp(p.x, -r*k.z, r*k.z), r);    
    return length(p)*sign(p.y); 
}

// This is horrifically in-efficient and doesn't embrace the fact that it's a shader.
// MOVE THIS TO IT'S OWN .CGINC.
void SpeckNoise_half(float2 value, float seed, out half noise){
	float pct = 0.0;

	noise = 0;

	float2 tempVal = value;

	[unroll(10)] for (int i=0; i<10; i++)
	{
		tempVal = value;
		float2 randDisplacement = Rand2dTo2d(float2(0.2, 0.4), i*seed) * 1 - 1;
		tempVal += randDisplacement; // translate

		float rad7 = 0.001;
		float apothem7 = (rad7*cos(PI/7.));
		float side7 = rad7*sin(PI/7.)*2.;
		float width7s = side7*cos(2.*PI/7.);
		float width7 = (side7*cos(PI/7.) + side7/2.);
		float h = sqrt(apothem7*apothem7*4. - (width7 + width7s)*(width7 + width7s));
		float2 s = float2(width7*2. + width7s*2., (apothem7 + apothem7 + h));
		float2 s2 = s*float2(1, 2);
		//value = Modulo(value, s2) - s2/2.;
		pct = 1-step(0.1*rad7, sdHeptagon(tempVal, apothem7));

		noise += pct;
	}
}

void SpeckNoise_float(float2 value, float seed, out float noise){
	float pct = 0.0;

	noise = 0;

	float2 tempVal = value;

	[unroll(10)] for (int i=0; i<10; i++)
	{
		tempVal = value;
		float2 randDisplacement = Rand2dTo2d(float2(0.2, 0.4), i*seed) * 1 - 1;
		tempVal += randDisplacement; // translate

		float rad7 = 0.001;
		float apothem7 = (rad7*cos(PI/7.));
		float side7 = rad7*sin(PI/7.)*2.;
		float width7s = side7*cos(2.*PI/7.);
		float width7 = (side7*cos(PI/7.) + side7/2.);
		float h = sqrt(apothem7*apothem7*4. - (width7 + width7s)*(width7 + width7s));
		float2 s = float2(width7*2. + width7s*2., (apothem7 + apothem7 + h));
		float2 s2 = s*float2(1, 2);
		//value = Modulo(value, s2) - s2/2.;
		pct = 1-step(0.1*rad7, sdHeptagon(tempVal, apothem7));

		noise += pct;
	}
}