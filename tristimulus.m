function[XYZ]=tristimulus(data)

%1st row of data: wavelengths
measlam=data(1,:);
%2nd row of data: reflectance in percents (0 - 100)
%Reflectance has to be scaled from 0 to 1
refl=data(2,:)/100;

%Color matching functions
%Defined from 360 to 830 nm
load cie1931.txt
lamxyz=cie1931(:,1);    %Wavelengths
xb=cie1931(:,2);         %x-,y-,z-bar color matching functions
yb=cie1931(:,3);
zb=cie1931(:,4);

%D65 illuminant
%Defined from 300 to 830 nm with an interval of 1 nm
load d65ill.txt
%1st column wavelengths
%2nd column relative power

%However, we are only interested in values 360 - 830 nm
%i.e. elements 61 - 531
%Values 300 - 359 nm are important only if we simulate fluorescence
illpower=d65ill(61:531,2);

%Then we need to constuct reflectance vector
%Lets start by making an empty vector of correct size
%Size of "illpower", x, y and z is 471 x 1
R=zeros(471,1);

%We don't have measured data for values 360 - 399 nm (elements 1 - 40)
%Therefore we extrapolate by using the first measured value (400 nm)
R(1:40)=refl(1);

%For wavelengths 400 - 700 nm (elements 41 - 341) we have information, but only with an
%interval of 10 nm. So we need to interpolate
R(41:341)=interp1(measlam,refl,400:1:700);

%And then we again extrapolate for wavelenghts 701 - 830 nm
%(elements 342 - 471). Original measurement has 31 values so element number
%31 refers to wavelength 700 nm.
R(342:471)=refl(31);

%And the rest is easy
%Normalization coefficient k
k=100/sum(yb.*illpower*10^-9);

%Tristimulus values
X=k*sum(xb.*illpower.*R*10^-9);
Y=k*sum(yb.*illpower.*R*10^-9);
Z=k*sum(zb.*illpower.*R*10^-9);

%All three are collected to the same variable
XYZ=[X,Y,Z];

%Of course we could have three separate output variables as well
%Then the first lines should be "function[X,Y,Z]=tristimulus(data)"







