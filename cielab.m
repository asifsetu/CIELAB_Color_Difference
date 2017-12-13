function[coord]=cielab(data)

%Input data is a Minolta measurement

%Tristimulusvalue for the measurement
XYZ=tristimulus(data);
%Let's separate variables
X=XYZ(1);
Y=XYZ(2);
Z=XYZ(3);

%Then we need tristimulusvalues of neutral point
%Lets generate a "measurement"
lam=linspace(400,700,31);
ref=ones(1,31)*100;
neut=[lam;ref];
%Now variable "neut" is similar to actual Minolta measurement, but
%refletance is 100 at all wavelengths.

%And then tristimulus values
NXYZ=tristimulus(neut);
%pause
%(for D65 illuminant they are about 95, 100, 109)
%new variables
Xn=NXYZ(1);
Yn=NXYZ(2);
Zn=NXYZ(3);

%Coordinates
%We ignore now special case for very dark colors
%would just require some if - else conditions 
%Lightness scale
L=116*(Y/Yn)^(1/3)-16;
%Red-Green scale
a=500*((X/Xn)^(1/3)-(Y/Yn)^(1/3));
%Yellow-Blue scale
b=200*((Y/Yn)^(1/3)-(Z/Zn)^(1/3));
%Chroma
C=sqrt(a^2+b^2);
%hue-angle
%Note! basic Matlab function "atan" would not give correct angle
%for all samples!
h=atan2(b,a);
%Now h is in radians, not degrees.
%Collecting results to a single variable.
coord=[L,a,b,C,h];